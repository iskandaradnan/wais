USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_FEGPSPositionLastHistory_Mobile_GetById]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_EngMwoAssesmentTxn_GetById
Description			: To Get the data from table EngMwoAssesmentTxn using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
--EXEC [UspFM_FEGPSPositionLastHistory_Mobile_GetById] @pStartDate='2018-07-01 07:22:18.943',@pEndDate='2018-07-16 16:56:31.813',
--@pCustomerid=1,@pFacilityid=1,@pStaffId='f',@pUsername=''
EXEC [UspFM_FEGPSPositionLastHistory_Mobile_GetById] @pStartDate='2018-07-06 07:22:18.943',@pEndDate='2018-07-06 16:58:19.870',
@pCustomerid=1,@pFacilityid=1,@pStaffId='10'
SELECT GETDATE()
select * from UMUserRegistration
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[UspFM_FEGPSPositionLastHistory_Mobile_GetById]                           


@pStartDate date,
@pEndDate date,
@pCustomerid int null,
@pFacilityid int null,
@pStaffId INT null--,
--@pUsername nvarchar(75) null



AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;



	with cte
	AS
	(
	SELECT A.UserRegistrationId,B.StaffName,A.DateTime,A.Latitude,A.Longitude,ROW_NUMBER() OVER(PARTITION BY A.UserRegistrationId ORDER BY A.DateTime DESC) AS ROWNUMBER
	FROM FEGPSPositionHistory A INNER JOIN UMUserRegistration B ON A.UserRegistrationId = B.UserRegistrationId
	WHERE ((@pCustomerid is null and 1=1) OR (@pCustomerid is not null and B.CustomerId=@pCustomerid)) 
	and ((@pFacilityid is null and 1=1) OR (@pFacilityid is not null and B.FacilityId=@pFacilityid))
	and ((@pStaffId is null and 1=1) OR (@pStaffId is not null and B.UserRegistrationId =@pStaffId))
	--and ((@pUsername is null and 1=1) OR (@pUsername is not null and B.UserName like '%'+@pUsername+'%') )
	and	 cast(A.DateTime as date) BETWEEN cast(@pStartDate as date) AND cast(@pEndDate as date)
	)SELECT * FROM cte WHERE ROWNUMBER=1


	END TRY

BEGIN CATCH

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   )

END CATCH
GO
