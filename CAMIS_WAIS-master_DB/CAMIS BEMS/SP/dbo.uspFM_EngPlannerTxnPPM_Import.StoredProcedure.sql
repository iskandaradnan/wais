USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngPlannerTxnPPM_Import]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngPlannerTxnPPM_Import
Description			: If Stock Update already exists then update else insert.
Authors				: Balaji M S
Date				: 05-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

EXEC uspFM_EngPlannerTxnPPM_Import @pStockUpdateId=NULL,@pCustomerId=1,@pFacilityId=1,@pStockUpdateNo='BEMS/PAN101/201807/000020',@pDate='',@pStockExpiryDate='',@pPartNo='prt21',
@pPartDescription='',@pItemCode='P0003',@pItemDescription='',@pFacilityCode='PAN101'

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE  PROCEDURE  [dbo].[uspFM_EngPlannerTxnPPM_Import]
	
			@pStockUpdateId					INT = null,
			@pCustomerId					INT = null,
			@pFacilityId					INT = null,
			@pStockUpdateNo					NVARCHAR(100) = null,
			@pDate							DATETIME = null,
			@pStockExpiryDate				DATETIME = null,
			@pPartNo						NVARCHAR(100) = null,
			@pPartDescription				NVARCHAR(200) = null,
			@pItemCode						NVARCHAR(100) = null,
			@pItemDescription				NVARCHAR(200) = null,
			@pFacilityCode					NVARCHAR(200) = null


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
			@mErrorMessage	NVARCHAR(500)
			
-- Default Values


-- Execution
	IF(LEN(@pStockUpdateNo)=0)
		BEGIN
			SET @mStockUpdateId=0
		END

	ELSE IF((SELECT COUNT(1) FROM EngStockUpdateRegisterTxn WHERE LTRIM(RTRIM(StockUpdateNo))	=	LTRIM(RTRIM(@pStockUpdateNo)))=0)
		BEGIN
			SET @mErrorMessage =(SELECT 'Invalid DocumentNo' ErrorMessage)
		END
				


	SET @mItemId = (SELECT ItemId FROM FMItemMaster WHERE LTRIM(RTRIM(ItemNo))	=	LTRIM(RTRIM(@pItemCode)))
	SET @mSparePartsId = (SELECT SparePartsId FROM EngSpareParts WHERE LTRIM(RTRIM(PartNo))	=	LTRIM(RTRIM(@pPartNo)))
	SET @mFacilityId = (SELECT FacilityId FROM MstLocationFacility WHERE LTRIM(RTRIM(FacilityCode))	=	LTRIM(RTRIM(@pFacilityCode)))
	SET @mStockUpdateId = (SELECT StockUpdateId FROM EngStockUpdateRegisterTxn WHERE LTRIM(RTRIM(StockUpdateNo))	=	LTRIM(RTRIM(@pStockUpdateNo)))



	IF (ISNULL(@mItemId,0)=0 OR ISNULL(@mSparePartsId,0)=0 OR ISNULL(@mFacilityId,0)=0 )
		BEGIN
			SET @mErrorMessage = @mErrorMessage + ' , ' + (SELECT 'Please enter vaild Part No, ItemCode and FacilityCode' ErrorMessage)

		END

	IF (CONVERT(date,@pDate) > CONVERT(date,@pStockExpiryDate))
		BEGIN
			SET @mErrorMessage = @mErrorMessage  + ' , ' + (SELECT 'Stock Expiry Date should be greater than or equal to Stock update Register Date' ErrorMessage)
		END

			SELECT	@mStockUpdateId	AS	StockUpdateId,
					@mSparePartsId	AS	SparePartsId,
					@mFacilityId	AS	FacilityId,
					@mItemId		AS	ItemId,
					@mErrorMessage	AS	ErrorMessage


	
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
