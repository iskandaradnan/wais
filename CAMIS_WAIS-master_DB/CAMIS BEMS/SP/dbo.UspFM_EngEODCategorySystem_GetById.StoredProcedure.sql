USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngEODCategorySystem_GetById]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_EngEODCategorySystem_GetById
Description			: To Get the data from table EngEODCategorySystem using the Primary Key id
Authors				: Balaji M S
Date				: 11-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_EngEODCategorySystem_GetById] @pCategorySystemId=1,@pUserId=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_EngEODCategorySystem_GetById]                           
  @pUserId			INT	=	NULL,
  @pCategorySystemId	INT

AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

    SELECT	
			CategorySystem.CategorySystemId						AS CategorySystemId,
			CategorySystem.ServiceId							AS ServiceId,
			ServiceKey.ServiceKey								AS ServiceKey,
			CategorySystem.CategorySystemName					AS CategorySystemName,
			CategorySystem.Remarks								AS Remarks,
			CategorySystem.Timestamp							AS Timestamp
	FROM	EngEODCategorySystem								AS CategorySystem		WITH(NOLOCK)
			INNER JOIN MstService								AS ServiceKey			WITH(NOLOCK)		ON CategorySystem.ServiceId = ServiceKey.ServiceId
	WHERE	CategorySystem.CategorySystemId = @pCategorySystemId 
	




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
