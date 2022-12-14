USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetMaintenanceHistory_Export]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngAssetMaintenanceHistory_Export
Description			: To export the Maintenance History for particular asset
Authors				: Dhilip V
Date				: 18-July-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngAssetMaintenanceHistory_Export  @StrCondition='',@StrSorting=null,@pAssetId=90

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE [dbo].[uspFM_EngAssetMaintenanceHistory_Export]

	@StrCondition	NVARCHAR(MAX) = NULL,
	@StrSorting		NVARCHAR(MAX) = NULL,
	@pAssetId		INT

AS 

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	DECLARE @countQry	NVARCHAR(MAX);
	DECLARE @qry		NVARCHAR(MAX);
	DECLARE @condition	VARCHAR(MAX);
	DECLARE @TotalRecords INT;

-- Default Values
    SELECT	MaintenanceWO.WorkOrderId,
			MaintenanceWO.MaintenanceWorkNo						AS	MaintenaceWorkNo,
			CAST(MaintenanceWO.MaintenanceWorkDateTime AS DATE)	AS	WorkOrderDate,
			LovMWOCategory.FieldValue							AS	WorkCategory ,
			LovMWOType.FieldValue								AS	Type,
			ISNULL(MAX(CAST(DATEDIFF(HOUR,MWOCompletionInfo.StartDateTime,MWOCompletionInfo.EndDateTime) AS NUMERIC(24,2))),0)	AS	TotalDownTime,
			SUM(ISNULL(MwoPartRep.TotalPartsCost,0.00))			AS	SparepartsCost,
			SUM(ISNULL(MwoPartRep.LabourCost,0.00))				AS	LabourCost,
			SUM(ISNULL(MwoPartRep.TotalCost,0.00))					AS	TotalCost
	INTO	#TempMWOGroup
 	FROM	EngMaintenanceWorkOrderTxn				AS	MaintenanceWO		WITH(NOLOCK)
			INNER JOIN	EngAsset					AS	Asset				WITH(NOLOCK)	ON Asset.AssetId							=	MaintenanceWO.AssetId
			LEFT JOIN	EngMwoCompletionInfoTxn		AS	MWOCompletionInfo	WITH(NOLOCK)	ON MaintenanceWO.WorkOrderId				=	MWOCompletionInfo.WorkOrderId
			LEFT JOIN	EngMwoPartReplacementTxn	AS	MwoPartRep			WITH(NOLOCK)	ON MaintenanceWO.WorkOrderId				=	MwoPartRep.WorkOrderId
			INNER JOIN	FMLovMst					AS	LovMWOCategory		WITH(NOLOCK)	ON MaintenanceWO.MaintenanceWorkCategory	=	LovMWOCategory.LovId
			INNER JOIN	FMLovMst					AS	LovMWOType			WITH(NOLOCK)	ON MaintenanceWO.TypeOfWorkOrder			=	LovMWOType.LovId
	WHERE	MaintenanceWO.AssetId	=	@pAssetId
	GROUP BY MaintenanceWO.WorkOrderId, 
			MaintenanceWO.MaintenanceWorkNo,
			MaintenanceWO.MaintenanceWorkDateTime,
			MaintenanceWO.MaintenanceWorkCategory,
			LovMWOCategory.FieldValue,
			MaintenanceWO.TypeOfWorkOrder,
			LovMWOType.FieldValue				
	ORDER BY	MaintenanceWO.MaintenanceWorkDateTime ASC
	--OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 


	
	SELECT	DISTINCT MaintenanceWO.WorkOrderId ,
			SpareParts.PartNo ,
			SpareParts.PartDescription ,
			ItemMst.ItemNo ,
			ItemMst.ItemDescription ,
			SpareParts.MinPrice		AS	MinCost ,
			SpareParts.MaxPrice		AS	MaxCost ,
			MwoPartRep.Quantity ,
			MwoPartRep.Cost			AS	CostPerUnit ,
			ISNULL(StockType.FieldValue, '')	AS	StockType ,
			MaintenanceWO.ModifiedDate
	INTO	#TempMWO
 	FROM	EngMaintenanceWorkOrderTxn					AS	MaintenanceWO		WITH(NOLOCK)
			INNER JOIN	EngAsset						AS	Asset				WITH(NOLOCK)	ON Asset.AssetId							=	MaintenanceWO.AssetId
			--INNER JOIN	EngMwoCompletionInfoTxn			AS	MWOCompletionInfo	WITH(NOLOCK)	ON MaintenanceWO.WorkOrderId				=	MWOCompletionInfo.WorkOrderId
			left JOIN	EngMwoPartReplacementTxn		AS	MwoPartRep			WITH(NOLOCK)	ON MaintenanceWO.WorkOrderId				=	MwoPartRep.WorkOrderId
			left JOIN	EngSpareParts					AS	SpareParts			WITH(NOLOCK)	ON MwoPartRep.SparePartStockRegisterId		=	SpareParts.SparePartsId
			left  JOIN	EngStockUpdateRegisterTxnDet	AS	StockUpdateReg		WITH(NOLOCK)	ON MwoPartRep.StockUpdateDetId				=	StockUpdateReg.StockUpdateDetId
			left JOIN	FMItemMaster					AS	ItemMst				WITH(NOLOCK)	ON SpareParts.ItemId						=	ItemMst.ItemId
			--left JOIN	FMLovMst						AS	SparePartsType		WITH(NOLOCK)	ON SpareParts.SparePartType					=	SparePartsType.LovId
			left JOIN	FMLovMst						AS	StockType			WITH(NOLOCK)	ON MwoPartRep.StockType					=	StockType.LovId
	WHERE	MaintenanceWO.AssetId	=	@pAssetId
	and     SpareParts.SparePartsId  is not null
	ORDER BY MaintenanceWO.WorkOrderId



	--SELECT	MaintenanceWO.WorkOrderId ,
	--		SpareParts.PartNo ,
	--		SpareParts.PartDescription ,
	--		ItemMst.ItemNo ,
	--		ItemMst.ItemDescription ,
	--		SpareParts.MinPrice		AS	MinCost ,
	--		SpareParts.MaxPrice		AS	MaxCost ,
	--		MwoPartRep.Quantity ,
	--		MwoPartRep.Cost			AS	CostPerUnit ,
	--		SparePartsType.FieldValue	AS	StockType,
	--		MaintenanceWO.ModifiedDate
	--INTO	#TempMWO
 --	FROM	EngMaintenanceWorkOrderTxn					AS	MaintenanceWO		WITH(NOLOCK)
	--		INNER JOIN	EngAsset						AS	Asset				WITH(NOLOCK)	ON Asset.AssetId							=	MaintenanceWO.AssetId
	--		INNER JOIN	EngMwoCompletionInfoTxn			AS	MWOCompletionInfo	WITH(NOLOCK)	ON MaintenanceWO.WorkOrderId				=	MWOCompletionInfo.WorkOrderId
	--		INNER JOIN	EngMwoPartReplacementTxn		AS	MwoPartRep			WITH(NOLOCK)	ON MaintenanceWO.WorkOrderId				=	MwoPartRep.WorkOrderId
	--		INNER JOIN	EngStockUpdateRegisterTxnDet	AS	StockUpdateReg		WITH(NOLOCK)	ON MwoPartRep.StockUpdateDetId				=	StockUpdateReg.StockUpdateDetId
	--		INNER JOIN	EngSpareParts					AS	SpareParts			WITH(NOLOCK)	ON StockUpdateReg.SparePartsId				=	SpareParts.SparePartsId
	--		INNER JOIN	FMItemMaster					AS	ItemMst				WITH(NOLOCK)	ON SpareParts.ItemId						=	ItemMst.ItemId
	--		INNER JOIN	FMLovMst						AS	SparePartsType		WITH(NOLOCK)	ON SpareParts.SparePartType					=	SparePartsType.LovId
	--WHERE	MaintenanceWO.AssetId	=	@pAssetId
	--ORDER BY MaintenanceWO.WorkOrderId



	SELECT	DISTINCT A.WorkOrderId,
			B.MaintenaceWorkNo,
			B.WorkOrderDate,
			B.WorkCategory,
			B.Type,
			A.PartNo,
			A.PartDescription,
			A.ItemNo,
			A.ItemDescription,
			A.MinCost,
			A.MaxCost,
			A.Quantity,
			A.CostPerUnit,
			A.StockType,
			B.TotalDownTime,
			B.SparepartsCost,
			B.LabourCost,
			B.TotalCost,
			a.ModifiedDate
	INTO	#ResultSet
	FROM	#TempMWOGroup B 
			LEFT JOIN #TempMWO A ON A.WorkOrderId	=	B.WorkOrderId

-- Execution


SET @qry = 'SELECT	MaintenaceWorkNo,
					WorkOrderDate,
					WorkCategory,
					Type,
					PartNo,
					PartDescription,
					ItemNo,
					ItemDescription,
					MinCost,
					MaxCost,
					Quantity,
					CostPerUnit,
					StockType,
					TotalDownTime,
					SparepartsCost,
					LabourCost,
					TotalCost
			FROM [#ResultSet]
			WHERE 1 = 1 ' 
			+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
			+ ' ' + ' ORDER BY ' +  ISNULL(@strSorting,'[#ResultSet].ModifiedDate DESC')

PRINT @qry;

EXECUTE sp_executesql @qry, N' @TotalRecords INT', @TotalRecords = @TotalRecords
	
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
