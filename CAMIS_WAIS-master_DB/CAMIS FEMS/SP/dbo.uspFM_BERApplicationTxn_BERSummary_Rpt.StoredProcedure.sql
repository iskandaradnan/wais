USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_BERApplicationTxn_BERSummary_Rpt]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*========================================================================================================

Application Name	: UETrack-BEMS              

Version				: 1.0

Procedure Name		: [uspFM_BERApplicationTxn_BERSummary_Rpt] 

Description			: Get the BER Summary Report

Authors				: Ganesan S

Date				: 06-June-2018

-----------------------------------------------------------------------------------------------------------
Unit Test:

exec [uspFM_BERApplicationTxn_BERSummary_Rpt] @Facility_Id = 1,@From_Month=6,@From_Year= '2018',

@To_Month= 7,@To_Year='2018' ,@MenuName = ''

-----------------------------------------------------------------------------------------------------------

Version History 

exec [uspFM_BERApplicationTxn_BERSummary_Rpt] @Facility_Id = 1,@From_Month='01',@From_Year= 2018,
@To_Month= '12',@To_Year=2018 
--,@MenuName = ''

-----:------------:---------------------------------------------------------------------------------------

Init : Date       : Details

========================================================================================================*/
CREATE PROCEDURE [dbo].[uspFM_BERApplicationTxn_BERSummary_Rpt](                                                  
		 @From_Date		VARCHAR(100) = '',    
          @To_Date			VARCHAR(100) = ''  , 
          @FacilityId    int 
 ) 
as                                                  
BEGIN                                    

SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

BEGIN TRY
 DECLARE @mydate DATETIME
SELECT @mydate = GETDATE()

Declare @CMFirstDay Datetime, @CMLastDay Datetime , @LMFirstDay Datetime, @LMlastDay Datetime

set @CMFirstDay=(SELECT CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(@mydate)-1),@mydate),101))
set @CMLastDay = (SELECT CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,@mydate))),DATEADD(mm,1,@mydate)),101))
set @LMFirstDay=(SELECT CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,@mydate))-1),DATEADD(mm,1,@mydate)),101))
set @LMlastDay= (SELECT CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(@mydate)),@mydate),101))



DECLARE @@BERTable TABLE(    
ID    INT IDENTITY(1,1),  
FacilityName NVARCHAR(512),  
CustomerName NVARCHAR(512),  
TotalApplied  INT,  
TotalCompleted INT,   
TotalPending INT 
)  

Insert into @@BERTable(FacilityName,CustomerName,TotalApplied,TotalCompleted,TotalPending)
select  distinct fac.FacilityName , cust.CustomerName
, (select count(1) from BERApplicationTxn a where FacilityId=@FacilityId and  (CAST(a.ApplicationDate AS DATE) BETWEEN CAST(@From_Date  AS DATE) AND CAST(@To_Date AS DATE))   ) 
, (select count(1) from BERApplicationTxn b where FacilityId=@FacilityId and b.BERStatus=206 and (CAST(b.ApplicationDate AS DATE) BETWEEN CAST(@From_Date  AS DATE) AND CAST(@To_Date AS DATE))) 
, (select count(1) from BERApplicationTxn c where FacilityId=@FacilityId and c.BERStatus not in (206,210 ) and (CAST(c.ApplicationDate AS DATE) BETWEEN CAST(@From_Date  AS DATE) AND CAST(@To_Date AS DATE))   ) 
 from 
BERApplicationTxn ber 

inner join MstCustomer cust on cust.CustomerId= ber.CustomerId
inner join MstLocationFacility fac on fac.FacilityId= ber.FacilityId

where 
 ((ber.FacilityId = @FacilityId) OR (@FacilityId IS NULL) OR (@FacilityId = ''))   AND
  (CAST(ber.ApplicationDate AS DATE) BETWEEN CAST(@From_Date  AS DATE) AND CAST(@To_Date AS DATE))  
--group by cust.CustomerName, fac.FacilityName 


SELECT *
, ISNULL(@From_Date,'') AS FromDateParam  
, ISNULL(@To_Date,'') AS ToDateParam  
     
From @@BERTable







END TRY
BEGIN CATCH

INSERT INTO ERRORLOG(Spname,ErrorMessage,createddate)
values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())

END CATCH

SET NOCOUNT OFF                                             

END
GO
