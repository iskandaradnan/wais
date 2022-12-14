USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngStockUpdateRegisterTxn_Import]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngStockUpdateRegisterTxn_Import
Description			: If Stock Update already exists then update else insert.
Authors				: Balaji M S
Date				: 05-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

EXEC [uspFM_EngAsset_Import] @pAssetId=null,@pFacilityId=1,@pAssetClassification='asdasd',@pAssetPreRegistrationNo='BEMS/TC/210',@pTypeCode='typecode12',
@pModel='Splendor2',@pManufacturer= 'New Manufacturer 1 Biju',@pCurrentLocationName='asdsadadsd',@pAppliedPartType='B'
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE  PROCEDURE  [dbo].[uspFM_EngStockUpdateRegisterTxn_Import]
			
			@pStockUpdateId					INT = null,
			@pCustomerId					INT = null,
			@pFacilityId					INT = null,
			@pStockUpdateNo					NVARCHAR(100) = null,
		---	@pDate							DATETIME = null,
			@pStockExpiryDate				DATETIME = null,
			@pPartNo						NVARCHAR(100) = null,
			@pPartDescription				NVARCHAR(200) = null,
			@pItemCode						NVARCHAR(100) = null,
			@pItemDescription				NVARCHAR(200) = null,
			@pFacilityCode					NVARCHAR(200) = null,
			@pBinNo							NVARCHAR(125)  = null,
			@pLocation						NVARCHAR(150)  = null,
			@pSparePartTypeName				NVARCHAR(150)  = null
AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)
	DECLARE @mSparePartsId	INT,
			@mFacilityId	INT,
			@mItemId		INT,
			@mStockUpdateId INT,
			@mSparePartTypeId INT,
			@mErrorMessage	NVARCHAR(500),
			@mLenErrorMsg		      		INT
-- Default Values


-- Execution

     IF(LEN(@pStockUpdateNo)=0)
		BEGIN
			SET @mStockUpdateId=0
		END

    SET @mSparePartsId = (SELECT SparePartsId FROM EngSpareParts WHERE LTRIM(RTRIM(PartNo))	=	LTRIM(RTRIM(@pPartNo)))
	SET @mItemId = (SELECT ItemId FROM FMItemMaster WHERE LTRIM(RTRIM(ItemNo))	=	LTRIM(RTRIM(@pItemCode)))
	SET @mSparePartTypeId = (SELECT top 1 Lovid FROM FMLovMst WHERE LTRIM(RTRIM(FieldValue))	=	LTRIM(RTRIM(@pSparePartTypeName)) and lovkey='StockTypeValue')
	
	
	SET @mFacilityId = (SELECT FacilityId FROM MstLocationFacility WHERE LTRIM(RTRIM(FacilityCode))	=	LTRIM(RTRIM(@pFacilityCode)))
	SET @mStockUpdateId = (SELECT StockUpdateId FROM EngStockUpdateRegisterTxn WHERE LTRIM(RTRIM(StockUpdateNo))	=	LTRIM(RTRIM(@pStockUpdateNo)))

	
	IF (ISNULL(@mSparePartTypeId,0)=0)
		BEGIN
			SET @mErrorMessage = @mErrorMessage + ' , ' + (SELECT 'Please enter vaild Spare Part Type' ErrorMessage)

		END
	 IF (ISNULL(@mSparePartsId,0)=0)
		BEGIN
			SET @mErrorMessage = @mErrorMessage + ' , ' + (SELECT 'Please enter vaild Part No.' ErrorMessage)

		END
		 IF (ISNULL(@mItemId,0)=0)
		BEGIN
			SET @mErrorMessage = @mErrorMessage + ' , ' + (SELECT 'Please enter vaild Item Code' ErrorMessage)

	    END
	

	


	      SET @mLenErrorMsg = LEN(@mErrorMessage)

			SELECT	 
		
			@mStockUpdateId								  AS StockUpdateId,
			@mSparePartTypeId							 AS SparePartTypeId,
			@mSparePartsId								 AS SparePartsId,
			@mItemId									 AS ItemId,
			@mFacilityId								 AS FacilityId, 
			SUBSTRING(@mErrorMessage,3,@mLenErrorMsg)	 AS ErrorMessage


	
		IF @mTRANSCOUNT = 0
	        BEGIN
	            COMMIT TRANSACTION
	        END   
	

END TRY

BEGIN CATCH

	IF @mTRANSCOUNT = 0
        BEGIN
            ROLLBACK TRAN
        END

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
