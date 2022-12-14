USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngMwoAssesment_ResponseTime_Get]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngMwoAssesment_ResponseTime_Get
Description			: Calculate the Response datetime for Assessment tab in WO.
Authors				: DHILIP V
Date				: 03-August-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_EngMwoAssesment_ResponseTime_Get] @pWorkOrderId=1,@pResponseDateTime='2018-04-05 18:53:32.150'

SELECT MaintenanceWorkDateTime FROM EngMaintenanceWorkOrderTxn WHERE WorkOrderId=1
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/


CREATE PROCEDURE  [dbo].[uspFM_EngMwoAssesment_ResponseTime_Get]
		
			@pWorkOrderId			INT,
			@pResponseDateTime		DATETIME
AS                                              

BEGIN TRY


-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)

-- Default Values


-- Execution



	SELECT DATEDIFF(MINUTE,MaintenanceWorkDateTime,@pResponseDateTime) AS ResponseDurationInMinute
	FROM EngMaintenanceWorkOrderTxn
	WHERE	WorkOrderId	= @pWorkOrderId



END TRY

BEGIN CATCH


	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   );
		   THROW;

END CATCH
GO
