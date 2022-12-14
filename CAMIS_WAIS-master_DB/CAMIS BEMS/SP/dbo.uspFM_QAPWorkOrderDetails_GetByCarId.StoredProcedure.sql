USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_QAPWorkOrderDetails_GetByCarId]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_QAPWorkOrderDetails_GetByCarId
Description			: Get the Work Order details for QAP
Authors				: Dhilip V
Date				: 20-July-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_QAPWorkOrderDetails_GetByCarId  @pCarId=65
select * from QapB1AdditionalInformationTxn
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_QAPWorkOrderDetails_GetByCarId]   
                       
  @pCarId			INT

AS                                                     

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration


-- Default Values


-- Execution


	IF(ISNULL(@pCarId,0) = 0) RETURN

	DECLARE @CauseCodeId INT;
	DECLARE @QCCodeId INT;

		SELECT	DISTINCT MaintenanceWO.WorkOrderId ,
			QapB1AddInfo.AdditionalInfoId,
			MaintenanceWO.MaintenanceWorkNo ,
			MaintenanceWO.MaintenanceWorkDateTime,
			Asset.AssetNo,
			MaintenanceWO.MaintenanceWorkCategory		AS MaintenanceWorkCategory,
			CASE WHEN QapB1AddInfo.CauseCodeId IS NULL THEN MwoCompletion.CauseCode
			ELSE QapB1AddInfo.CauseCodeId END AS CauseCodeId,
			CASE WHEN QapB1AddInfo.QcCodeId IS NULL THEN MwoCompletion.QCCode
			ELSE QapB1AddInfo.QcCodeId END AS QCCodeId
 	FROM	EngMaintenanceWorkOrderTxn					AS	MaintenanceWO		WITH(NOLOCK)
			INNER JOIN	EngAsset						AS	Asset				WITH(NOLOCK)	ON Asset.AssetId							=	MaintenanceWO.AssetId
			INNER JOIN	QapB1AdditionalInformationTxn	AS	QapB1AddInfo		WITH(NOLOCK)	ON MaintenanceWO.WorkOrderId				=	QapB1AddInfo.WorkOrderId
			LEFT JOIN	EngMwoCompletionInfoTxn			AS	MWOCompletionInfo	WITH(NOLOCK)	ON MaintenanceWO.WorkOrderId				=	MWOCompletionInfo.WorkOrderId
			LEFT JOIN	MstQAPQualityCause				AS	QualityCause		WITH(NOLOCK)	ON MWOCompletionInfo.QCCode					=	QualityCause.QualityCauseId
			LEFT  JOIN  FMLovMst						AS  WorkCategory		WITH(NOLOCK)	ON MaintenanceWO.MaintenanceWorkCategory	=	WorkCategory.LovId
			LEFT  JOIN  EngMwoCompletionInfoTxn			AS  MwoCompletion		WITH(NOLOCK)	ON MaintenanceWO.WorkOrderId				=	MwoCompletion.WorkOrderId
	WHERE	QapB1AddInfo.CarId = @pCarId
	ORDER BY MaintenanceWO.WorkOrderId
	
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
