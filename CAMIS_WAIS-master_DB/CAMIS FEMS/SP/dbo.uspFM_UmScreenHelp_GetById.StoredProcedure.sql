USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_UmScreenHelp_GetById]    Script Date: 20-09-2021 16:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_SparePartsAttachment_GetById
Description			: Attachment Get
Authors				: Dhilip V
Date				: 14-July-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_UmScreenHelp_GetById] @pScreenURL='gm/lovmaster'

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_UmScreenHelp_GetById]                           

	@pScreenURL	NVARCHAR(500)

AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


    SELECT	ScreenHelp.ScreenHelpId			AS  ScreenHelpId,
			ScreenHelp.ScreenId				AS  ScreenId,
			ScreenHelp.HelpDescription		AS  HelpDescription,
			ScreenHelp.GuId					AS  GuId
 	FROM	[UmScreenHelp]					AS	ScreenHelp		WITH(NOLOCK)
	INNER JOIN UMScreen						AS	Screen			WITH(NOLOCK)	ON ScreenHelp.ScreenId		=	Screen.ScreenId
	WHERE	Screen.PageURL = @pScreenURL


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
