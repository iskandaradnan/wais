USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetPPMCheckListQuantasks_Print]    Script Date: 20-09-2021 16:43:00 ******/
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
EXEC [uspFM_EngAssetPPMCheckListQuantasks_Print]  @pPPMCheckListId= 64,@pWorkOrderId=170
SELECT * FROM EngAssetPPMCheckList
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_EngAssetPPMCheckListQuantasks_Print]                           


  @pPPMCheckListId		NVARCHAR(200)  = null,
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
	
		--	5	EngAssetPPMCheckListMaintTasksMstDet
		--SELECT	PPMCheckListQNId,
		--		PPMCheckListId,
		--		QuantitativeTasks,
		--		UOM,
		--		SetValues,
		--		LimitTolerance,
		--		Active
		--FROM	EngAssetPPMCheckListQuantasksMstDet	AS	Quantasks	WITH(NOLOCK)
		--WHERE	PPMCheckListId	=	@pPPMCheckListId

		
		DECLARE @pWOPPMCheckListId	INT

		SET @pWOPPMCheckListId = (SELECT WOPPMCheckListId FROM EngAssetPPMCheckListWorkOrder WHERE PPMCheckListId	=	@pPPMCheckListId AND WorkOrderId = @pWorkOrderId)


		set @pWOPPMCheckListId = isnull(@pWOPPMCheckListId,0)

		--	5	EngAssetPPMCheckListMaintTasksMstDet
		SELECT	QuantasksWO.WOPPMCheckListQNId,
				QuantasksWO.WOPPMCheckListId,
				QuantasksWO.PPMCheckListQNId,
				QuantasksWO.Value,
				QuantasksWO.[Status],
				StatusId.FieldValue		AS StatusValue,
				QuantasksWO.Remarks,
				Quantasks.QuantitativeTasks,
				Quantasks.UOM,
				UOM.UnitOfMeasurement,
				Quantasks.SetValues,
				Quantasks.LimitTolerance
		FROM [EngAssetPPMCheckListQuantasksMstDet]		as Quantasks
		INNER JOIN FMUOM										AS	UOM			 WITH(NOLOCK) ON Quantasks.UOM				=	UOM.UOMId		
		left join [EngAssetPPMCheckListQuantasksWorkOrderMstDet]	AS	QuantasksWO	WITH(NOLOCK)   ON Quantasks.PPMCheckListQNId	=	QuantasksWO.PPMCheckListQNId  and QuantasksWO.WOPPMCheckListId	=	@pWOPPMCheckListId
		left JOIN FMLovMst										AS	StatusId		 WITH(NOLOCK) ON QuantasksWO.Status		=	StatusId.LovId
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
