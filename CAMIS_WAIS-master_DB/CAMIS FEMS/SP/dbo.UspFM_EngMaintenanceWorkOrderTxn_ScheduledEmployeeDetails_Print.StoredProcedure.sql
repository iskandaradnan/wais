USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngMaintenanceWorkOrderTxn_ScheduledEmployeeDetails_Print]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_EngMaintenanceWorkOrderTxn_GetById
Description			: To Get the data from table EngMaintenanceWorkOrderTxn using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_EngMaintenanceWorkOrderTxn_ScheduledEmployeeDetails_Print] @pWorkOrderId=167

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[UspFM_EngMaintenanceWorkOrderTxn_ScheduledEmployeeDetails_Print]   
                        

  @pWorkOrderId		INT


AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;



	IF(ISNULL(@pWorkOrderId,0) = 0) RETURN

   
    SELECT	MwoCompletion.CompletionInfoId						AS CompletionInfoId,	
			UserReg.UserName as staffID,
			UserReg.StaffName  EmployeeName,
			MwoCompletionDet.StartDateTime						AS EmployeeStartDateTime,		
			MwoCompletionDet.EndDateTime						AS EmployeeEndDateTime,
			MwoCompletionDet.StartDateTimeUTC					AS UdtStartDateTimeUTC,
			MwoCompletionDet.EndDateTimeUTC						AS UdtEndDateTimeUTC
		
	FROM	EngMwoCompletionInfoTxn						AS MwoCompletion
			INNER JOIN	EngMwoCompletionInfoTxnDet		AS MwoCompletionDet			WITH(NOLOCK)	ON MwoCompletion.CompletionInfoId		= MwoCompletionDet.CompletionInfoId
			LEFT  JOIN  UMUserRegistration				AS UserReg					WITH(NOLOCK)	ON MwoCompletionDet.UserId				= UserReg.UserRegistrationId
			
			where MwoCompletion.WorkOrderId  = @pWorkOrderId



			

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
