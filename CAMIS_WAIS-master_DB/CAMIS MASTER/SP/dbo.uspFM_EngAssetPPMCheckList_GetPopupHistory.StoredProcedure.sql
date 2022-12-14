USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetPPMCheckList_GetPopupHistory]    Script Date: 20-09-2021 16:43:00 ******/
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
EXEC uspFM_EngAssetPPMCheckList_GetById  @pPPMCheckListId=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_EngAssetPPMCheckList_GetPopupHistory]                           
  @pPPMCheckListId		INT , 
  @pVersion		INT , 
   @pGridId		INT 
AS                                               

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration


-- Default Values


-- Execution




	IF(@pGridId = 1 OR @pGridId = '1')
	BEGIN 
	    Select -- PPmCategoryDetId,
		       b.FieldValue PPmCategory
		       ,PPMCheckListCategoryId
			   ,Number
			   ,Description
		
        from  EngAssetPPMCheckListCategoryHistory a 
		inner join     FMLovMst b  on a.PPMCheckListCategoryId=b.LovId
		where PPMCheckListId	=	@pPPMCheckListId  AND VersionNo=@pVersion

 --   END

	--ELSE 
	--BEGIN
	SELECT	PPMCheckListQNId,
				PPMCheckListId,
				QuantitativeTasks,
				b.UnitOfMeasurement as UOM,
				SetValues,
				LimitTolerance,
				Quantasks.Active
		FROM	EngAssetPPMCheckListQuantasksMstDetHistory 	AS	Quantasks	WITH(NOLOCK)

		         inner join FMUOM b on Quantasks.UOM = b.UOMId
		WHERE	PPMCheckListId	=	@pPPMCheckListId AND VersionNo=@pVersion
	END 

	

		--	5	EngAssetPPMCheckListMaintTasksMstDet
		


		
	



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
