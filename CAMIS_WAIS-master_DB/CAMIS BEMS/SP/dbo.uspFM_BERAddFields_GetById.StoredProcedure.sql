USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_BERAddFields_GetById]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_BERAddFields_GetById
Description			: To Get the data from table BER using the Primary Key id
Authors				: Dhilip V
Date				: 13-July-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_BERAddFields_GetById]  @pApplicationId=90
SELECT * FROM BERApplicationTxn
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_BERAddFields_GetById]                           

  @pApplicationId				INT 
AS                                              

BEGIN TRY


	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	IF(ISNULL(@pApplicationId,0) = 0) RETURN



    SELECT	ApplicationId		AS ApplicationId,
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
	FROM	BERApplicationTxn	AS BER				WITH(NOLOCK)			
	WHERE	BER.ApplicationId = @pApplicationId 


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
