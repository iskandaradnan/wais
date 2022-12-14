USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_MstCustomerReport_GetById]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_FMAddFieldConfig_GetById
Description			: To Get config fields for the screen
Authors				: Dhilip V
Date				: 11-July-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_MstCustomerReport_GetById] @pCustomerId=1

SELECT * FROM FMAddFieldConfig
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_MstCustomerReport_GetById]                           

  @pCustomerId			INT

AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


    SELECT	Customer.CustomerId								AS CustomerId,
			Customer.CustomerCode							AS CustomerCode,
			Customer.CustomerName							AS CustomerName,
			CustomerReport.CustomerReportId					AS CustomerReportId,
			CustomerReport.ReportName						AS ReportName
	FROM	MstCustomer										AS Customer			WITH(NOLOCK)
			INNER JOIN	MstCustomerReport					AS CustomerReport	WITH(NOLOCK)	ON Customer.CustomerId		= CustomerReport.CustomerId

	WHERE	Customer.CustomerId = @pCustomerId 


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
