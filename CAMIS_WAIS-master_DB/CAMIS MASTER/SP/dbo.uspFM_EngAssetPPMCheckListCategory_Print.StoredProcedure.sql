USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetPPMCheckListCategory_Print]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngAssetPPMCheckList_GetById
Description			: Get the staff details by passing the staffId.
Authors				: Dhilip V
Date				: 02-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_EngAssetPPMCheckListCategory_Print] @pPPMCheckListId= 64,@pWorkOrderId=167
SELECT * FROM EngAssetPPMCheckList
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_EngAssetPPMCheckListCategory_Print]                           
  @pPPMCheckListId		NVARCHAR(200),
  @pWorkOrderId			NVARCHAR(200)  = null
AS                                               

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration




-- Default Values


-- Execution


	IF(ISNULL(@pPPMCheckListId,0) = 0) RETURN

	--	1	EngAssetPPMCheckList
	

		--Select  CategoryList.CategoryId,
		--		CategoryId.FieldValue as CategoryIdValue
		--       ,Category.PPMCheckListCategoryId
		--	   ,Category.Number
		--	   ,Category.Description
		--	   ,Category.Active
  --      from  EngAssetPPMCheckListCategory as CategoryList
		--INNER JOIN EngAssetPPMCheckListCategory					AS	Category		 WITH(NOLOCK) ON CategoryList.CategoryId					=	Category.CategoryId
		--INNER JOIN FMLovMst										AS	CategoryId		 WITH(NOLOCK) ON Category.PPMCheckListCategoryId		=	CategoryId.LovId
		--where CategoryList.PPMCheckListId	=	@pPPMCheckListId

		DECLARE @pWOPPMCheckListId	INT
		SET @pWOPPMCheckListId = (SELECT WOPPMCheckListId FROM EngAssetPPMCheckListWorkOrder WHERE PPMCheckListId	=	@pPPMCheckListId AND WorkOrderId = @pWorkOrderId)
		
		set @pWOPPMCheckListId = isnull(@pWOPPMCheckListId,0)


		Select  CategoryWO.WOCategoryId,
				CategoryWO.WOPPMCheckListId,
				CategoryWO.CategoryId,
				CategoryId.FieldValue as CategoryIdValue,
				CategoryWO.[Status],
				StatusId.FieldValue		AS StatusValue,
				CategoryWO.Remarks,
				Category.PPMCheckListCategoryId,
				Category.Number,
				Category.Description
        from EngAssetPPMCheckListCategory						AS	Category		
		INNER JOIN FMLovMst										AS	CategoryId		 WITH(NOLOCK) ON Category.PPMCheckListCategoryId		=	CategoryId.LovId			
		left join  [EngAssetPPMCheckListCategoryWorkOrder]			AS  CategoryWO 		 WITH(NOLOCK) ON CategoryWO.CategoryId					=	Category.CategoryId and CategoryWO.WOPPMCheckListId	=	@pWOPPMCheckListId
		left JOIN FMLovMst										AS	StatusId		 WITH(NOLOCK) ON CategoryWO.Status		=	StatusId.LovId
		WHERE	PPMCheckListId	=	@pPPMCheckListId 


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
