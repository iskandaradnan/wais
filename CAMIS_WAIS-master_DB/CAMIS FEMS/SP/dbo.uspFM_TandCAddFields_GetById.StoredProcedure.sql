USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_TandCAddFields_GetById]    Script Date: 20-09-2021 16:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_TandCAddFields_GetById
Description			: To Get the additional fields from TestingandCommissioning
Authors				: Dhilip V
Date				: 13-July-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_TandCAddFields_GetById]  @pTestingandCommissioningId=90
SELECT * FROM EngTestingandCommissioningTxn
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_TandCAddFields_GetById]                           

  @pTestingandCommissioningId				INT 
AS                                              

BEGIN TRY


	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	IF(ISNULL(@pTestingandCommissioningId,0) = 0) RETURN



    SELECT	TestingandCommissioningId,
			Field1,
			Field2,
			Field3,
			Field4,
			Field5,
			Field6,
			Field7,
			Field8,
			Field9,
			Field10
	FROM	EngTestingandCommissioningTxn				WITH(NOLOCK)			
	WHERE	TestingandCommissioningId = @pTestingandCommissioningId 


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
