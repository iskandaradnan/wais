USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_SparePartNo_Fetch]    Script Date: 20-09-2021 16:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_CRMRequest_GetById
Description			: To Get the data from table CRMRequest using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_SparePartNo_Fetch] @pSparePartNo='P101'

SELECT * FROM EngSpareParts
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE  PROCEDURE  [dbo].[uspFM_SparePartNo_Fetch]                           
@pSparePartNo            NVARCHAR (20)

AS                                              

BEGIN TRY




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
			where SpareParts.PartNo = @pSparePartNo
	ORDER BY (SpareParts.PartNo) ASC

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
