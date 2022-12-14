USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngMwoPartReplacementTxnPartNo_Mobile_GetById]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_EngMwoPartReplacementTxn_GetById
Description			: To Get the data from table EngMaintenanceWorkOrderTxn using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_EngMwoPartReplacementTxnPartNo_Mobile_GetById] @pPartNo='P101'

SELECT * FROM EngSpareParts
SELECT * FROM EngStockUpdateRegisterTxnDet
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_EngMwoPartReplacementTxnPartNo_Mobile_GetById]                           
  @pUserId			INT	=	NULL,
  @pPartNo		NVARCHAR(500)

AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


	IF(ISNULL(@pPartNo,0) = '') RETURN



	

	SELECT	StockUpdateRegister.StockUpdateDetId				AS StockUpdateDetId,
			SpareParts.SparePartsId								AS SparePartsId,
			SpareParts.PartNo									AS PartNo,
			SpareParts.PartDescription							AS PartDescription,
			ItemMaster.ItemId									AS ItemId,
			ItemMaster.ItemNo									AS ItemNo,
			ItemMaster.ItemDescription							AS ItemDescription,
			SpareParts.SparePartType							AS StockTypeId,
			StockType.FieldValue								AS StockTypeValue,
			StockUpdateRegister.InVoiceNo						AS InVoiceNo,
			StockUpdateRegister.VendorName						AS VendorName
	FROM	EngSpareParts										AS SpareParts						WITH(NOLOCK)
			INNER JOIN  EngStockUpdateRegisterTxnDet			AS StockUpdateRegister				WITH(NOLOCK)			on StockUpdateRegister.SparePartsId					= SpareParts.SparePartsId
			INNER JOIN  FMItemMaster							AS ItemMaster						WITH(NOLOCK)			on SpareParts.ItemId								= ItemMaster.ItemId
			INNER  JOIN  FMLovMst								AS StockType						WITH(NOLOCK)			on SpareParts.SparePartType							= StockType.LovId
	WHERE	SpareParts.PartNo = @pPartNo 
	ORDER BY (SpareParts.PartNo) ASC




END TRY

BEGIN CATCH
throw
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
