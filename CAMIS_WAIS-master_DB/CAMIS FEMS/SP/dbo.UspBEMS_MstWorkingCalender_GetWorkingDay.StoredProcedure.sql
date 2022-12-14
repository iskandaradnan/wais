USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspBEMS_MstWorkingCalender_GetWorkingDay]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[UspBEMS_MstWorkingCalender_GetWorkingDay]
(

@Id int = null,
@Year int = null 


)
AS 

-- Exec [GetUserRoleLovs] 

--/*=====================================================================================================================
--APPLICATION		: UETrack
--NAME				: UspBEMS_EngAssetClassification_GetLovs
--DESCRIPTION		: GET LOV VALUES FOR USERROLE 
--AUTHORS			: BIJU NB
--DATE				: 12-March-2018
-------------------------------------------------------------------------------------------------------------------------
--VERSION HISTORY 
--------------------:---------------:---------------------------------------------------------------------------------------
--Init				: Date          : Details
--------------------:---------------:---------------------------------------------------------------------------------------
--BIJU NB           : 15-March-2018 : 
-------:------------:----------------------------------------------------------------------------------------------------*/
BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY
	
	--SELECT LovId, FieldValue FROM FmLovMst WHERE LovKey = 'StatusValue' ORDER BY FieldValue
--	SELECT   ServiceId LovId, ServiceKey FieldValue FROM MstService  ORDER BY ServiceKey

declare @weeklyholdy varchar(max) = (select WeeklyHoliday from MstLocationFacility where FacilityId=@Id)

if(@weeklyholdy is null  )
begin
select 1 Lovid, 'Sunday' WeekDay from FMTimeWeekDay
union

select 3 Lovid, 'Saturday' WeekDay from FMTimeWeekDay
end 
else 
begin 

select b.WeekDayId as Lovid, b.WeekDay from SplitString(@weeklyholdy  ,',') a
inner join FMTimeWeekDay b on a.Item=b.WeekDayId
end 







select
 a.CalenderId
,a.CustomerId
,a.FacilityId
,a.Year
,b.CalenderDetId
,b.CalenderId
,b.Month
,b.Day
,b.IsWorking
,b.Remarks
 from MstWorkingCalender a
inner join MstWorkingCalenderDet b on a.CalenderId=b.CalenderId and a.FacilityId =@Id and a.[Year]=@Year
	
END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
