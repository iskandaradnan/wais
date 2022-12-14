USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngStockUpdateRegisterTxn_Save]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngStockUpdateRegisterTxn_Save
Description			: If Stock Update already exists then update else insert.
Authors				: Balaji M S
Date				: 05-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
DECLARE @EngStockUpdateRegisterTxnDet AS [dbo].[udt_EngStockUpdateRegisterTxnDet]
 insert into  @EngStockUpdateRegisterTxnDet([StockUpdateDetId],CustomerId,FacilityId,ServiceId,StockUpdateId,SparePartsId,StockExpiryDate,StockExpiryDateUTC,	
Quantity,Cost,PurchaseCost,InvoiceNo,Remarks,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC)VALUES
(0,'1','1','2','9','1','2018-02-06 12:36:20.410','2018-04-06 07:06:36.340','10','10','10','200006','',2,'2018-04-06 12:37:18.333','2018-04-06 07:07:18.333',2,'2018-04-06 12:37:18.333','2018-04-06 07:07:18.333')


EXEC uspFM_EngStockUpdateRegisterTxn_Save @EngStockUpdateRegisterTxnDet,
@pUserId='1',@pStockUpdateId='0',@CustomerId='1',@FacilityId='2',@ServiceId='2',@StockUpdateNo=NULL,@Date='2018-03-06 12:37:18.333',@DateUTC='2018-04-06 07:07:18.333',
@TotalCost='100'

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE  PROCEDURE  [dbo].[uspFM_EngStockUpdateRegisterTxn_Save]

			@EngStockUpdateRegisterTxnDet AS [dbo].[udt_EngStockUpdateRegisterTxnDet] READONLY,			
			@pUserId						INT = null,
			@pStockUpdateId					INT = null,
			@CustomerId						INT = null,
			@FacilityId						INT = null,
			@ServiceId						INT = null,
			@StockUpdateNo					NVARCHAR(100) = null,
			@Date							DATETIME = null,
			@DateUTC						DATETIME = null,
			@TotalCost						NUMERIC(24,2)=null
			--@CreatedBy						INT,
			--@ModifiedBy						INT

AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)
	DECLARE @DuplicateCount INT
	DECLARE @DuplicateCount1 INT
	DECLARE @DuplicateCounts INT
	--DECLARE @DatetimeCheck DATETIME
-- Default Values

	--SET @DatetimeCheck= (SELECT MIN(StockExpiryDate) FROM @EngStockUpdateRegisterTxnDet)

-- Execution



	--SET @mItemId = (SELECT ItemId FROM FMItemMaster WHERE LTRIM(RTRIM(ItemNo))	=	LTRIM(RTRIM(@pItemCode)))
	--SET @mSparePartsId = (SELECT SparePartsId FROM EngSpareParts WHERE LTRIM(RTRIM(PartNo))	=	LTRIM(RTRIM(@pPartNo)))
	--SET @mFacilityId = (SELECT FacilityId FROM MstLocationFacility WHERE LTRIM(RTRIM(FacilityCode))	=	LTRIM(RTRIM(@pFacilityCode)))
	--SET @mStockUpdateId = (SELECT StockUpdateId FROM EngStockUpdateRegisterTxn WHERE LTRIM(RTRIM(StockUpdateNo))	=	LTRIM(RTRIM(@pStockUpdateNo)))
		
 
	select * into #EngStockUpdateRegisterTxnDet from @EngStockUpdateRegisterTxnDet

	update a  set SparePartsId = b.SparePartsId
	from #EngStockUpdateRegisterTxnDet a join  EngSpareParts b  on LTRIM(RTRIM(a.PartNo))	=	LTRIM(RTRIM(b.PartNo))

	
	 IF EXISTS ((SELECT 1 FROM #EngStockUpdateRegisterTxnDet WHERE StockExpiryDate<@Date AND StockExpiryDate IS NOT NULL))
			BEGIN

			SELECT 0 As StockUpdateId,
			CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS  [timestamp],
			'Stock Expiry Date should be greater than the Stock Update Date for Part No - ' + (SELECT top 1 PartNo +' and Invoice No - '+ InvoiceNo FROM #EngStockUpdateRegisterTxnDet WHERE StockExpiryDate<@Date) AS ErrorMessage
			END
	ELSE
	BEGIN
	IF(@pStockUpdateId = NULL OR @pStockUpdateId =0)

	  BEGIN
	DECLARE @pOutParam NVARCHAR(50),@mMonth INT,@mYear INT
	SET @mMonth	=	MONTH(@Date)
	SET @mYear	=	YEAR(@Date)
	EXEC [uspFM_GenerateDocumentNumber] @pFlag='EngStockUpdateRegisterTxn',@pCustomerId=@CustomerId,@pFacilityId=@FacilityId,@Defaultkey='BEMS',@pModuleName=NULL,@pMonth=@mMonth,@pYear=@mYear,@pOutParam=@pOutParam OUTPUT
	SELECT @StockUpdateNo=@pOutParam
	          INSERT INTO EngStockUpdateRegisterTxn(
													CustomerId,
													FacilityId,
													ServiceId,
													StockUpdateNo,
													Date,
													DateUTC,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC             
                                                                                                           
                           )OUTPUT INSERTED.StockUpdateId INTO @Table
			  VALUES								(
													@CustomerId,
													@FacilityId,
													@ServiceId,
													@StockUpdateNo,
													@Date,
													@DateUTC,
													@pUserId,													
													GETDATE(), 
													GETUTCDATE(),
													@pUserId,													
													GETDATE(), 
													GETUTCDATE()
													)
			Declare @mPrimaryId int= (select StockUpdateId from EngStockUpdateRegisterTxn WHERE	StockUpdateId IN (SELECT ID FROM @Table))

			SET	@DuplicateCount=(SELECT top 1  COUNT(*) FROM #EngStockUpdateRegisterTxnDet GROUP BY StockUpdateId,SparePartsId,InvoiceNo HAVING COUNT(*) > 1 )
			SET	@DuplicateCount1= (SELECT top 1 COUNT(*) FROM #EngStockUpdateRegisterTxnDet a  inner join EngStockUpdateRegisterTxnDet b on a.SparePartsId = b.SparePartsId and a.InvoiceNo = b.InvoiceNo AND a.StockUpdateId = b.StockUpdateId)

			IF (@DuplicateCount>0 OR @DuplicateCount1>1)
			BEGIN

			SELECT 0 As StockUpdateId,
			CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS  [timestamp],
			'Part No and Invoice No should be unique' AS ErrorMessage

			END

			ELSE IF EXISTS (SELECT 1 FROM #EngStockUpdateRegisterTxnDet WHERE SparePartsId =0)
			BEGIN

			SELECT 0 As StockUpdateId,
			CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS  [timestamp],
			'Please Enter Valid Part No - ' +(SELECT top 1 A.PartNo FROM #EngStockUpdateRegisterTxnDet A WHERE A.SparePartsId =0) AS ErrorMessage

			END

			ELSE

			BEGIN



			  INSERT INTO EngStockUpdateRegisterTxnDet(													
													CustomerId,
													FacilityId,
													ServiceId,
													StockUpdateId,
													SparePartsId,
													StockExpiryDate,
													StockExpiryDateUTC,
													Quantity,
													Cost,
													PurchaseCost,
													InvoiceNo,
													Remarks,
													VendorName,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC,
													EstimatedLifeSpan,
													EstimatedLifeSpanId,
													BinNo,
													SparePartType,
													LocationId															
                                                    )
				   SELECT							CustomerId,
													FacilityId,
													ServiceId,
													@mPrimaryId,
													SparePartsId,
													StockExpiryDate,
													StockExpiryDateUTC,
													Quantity,
													Cost,
													PurchaseCost,
													InvoiceNo,
													Remarks,
													VendorName,
													CreatedBy,
													GETDATE(),
													GETUTCDATE(),
													ModifiedBy,
													GETDATE(),
													GETUTCDATE(),
													EstimatedLifeSpan,
													EstimatedLifeSpanId,
													BinNo,
													SparePartType,
													LocationId		
				   FROM #EngStockUpdateRegisterTxnDet	AS StockUpdateRegisterType
				   WHERE	ISNULL(StockUpdateRegisterType.StockUpdateDetId,0)=0




				END



				   SELECT				StockUpdateId,
										[Timestamp],
										'' AS ErrorMessage
				   FROM					EngStockUpdateRegisterTxn
				   WHERE				StockUpdateId IN (SELECT ID FROM @Table)
	
		END
  ELSE
	  BEGIN

	  		SET	@DuplicateCount=(SELECT  COUNT(*) FROM #EngStockUpdateRegisterTxnDet GROUP BY stockupdateid,SparePartsId,InvoiceNo HAVING COUNT(*) > 1)
			SET	@DuplicateCount1= (SELECT  COUNT(*) FROM #EngStockUpdateRegisterTxnDet a  inner join EngStockUpdateRegisterTxnDet b on a.SparePartsId = b.SparePartsId and a.InvoiceNo = b.InvoiceNo AND a.StockUpdateId = b.StockUpdateId)

			IF (@DuplicateCount>0)
			BEGIN

			SELECT 0 As StockUpdateId,
			CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS  [timestamp],
			'Part No and Invoice No should be unique' AS ErrorMessage


			END

			ELSE IF EXISTS (SELECT 1 FROM #EngStockUpdateRegisterTxnDet WHERE SparePartsId =0)
			BEGIN

			SELECT 0 As StockUpdateId,
			CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS  [timestamp],
			'Please Enter Valid Part No - ' +(SELECT top 1 A.PartNo FROM #EngStockUpdateRegisterTxnDet A WHERE A.SparePartsId =0) AS ErrorMessage
			END

			ELSE

			BEGIN
	  		
			 UPDATE EngStockUpdateRegisterTxn SET 
									CustomerId									= @CustomerId,
									FacilityId									= @FacilityId,
									ServiceId									= @ServiceId,
									StockUpdateNo								= @StockUpdateNo,
									Date										= @Date,
									DateUTC										= @DateUTC,									
									ModifiedBy									= @pUserId,
									ModifiedDate								= GETDATE(),
									ModifiedDateUTC								= GETUTCDATE()
									OUTPUT INSERTED.StockUpdateId INTO @Table
			   WHERE StockUpdateId=@pStockUpdateId


			   		SELECT				StockUpdateId,
										[Timestamp],
										'' AS ErrorMessage
					FROM					EngStockUpdateRegisterTxn
				    WHERE				StockUpdateId IN (SELECT ID FROM @Table)


			    UPDATE StockUpdateRegister SET										
									--StockUpdateRegister.CustomerId				= StockUpdateRegisterType.CustomerId,			
									--StockUpdateRegister.FacilityId				= StockUpdateRegisterType.FacilityId,			
									--StockUpdateRegister.ServiceId				= StockUpdateRegisterType.ServiceId,		
									--StockUpdateRegister.StockUpdateId			= StockUpdateRegisterType.StockUpdateId,		
									StockUpdateRegister.SparePartsId			= StockUpdateRegisterType.SparePartsId,		
									StockUpdateRegister.StockExpiryDate			= StockUpdateRegisterType.StockExpiryDate,		
									StockUpdateRegister.StockExpiryDateUTC		= StockUpdateRegisterType.StockExpiryDateUTC,	
									StockUpdateRegister.Quantity				= StockUpdateRegisterType.Quantity,			
									StockUpdateRegister.Cost					= StockUpdateRegisterType.Cost,				
									StockUpdateRegister.PurchaseCost			= StockUpdateRegisterType.PurchaseCost,		
									StockUpdateRegister.InvoiceNo				= StockUpdateRegisterType.InvoiceNo,			
									StockUpdateRegister.Remarks					= StockUpdateRegisterType.Remarks,
									StockUpdateRegister.VendorName				= StockUpdateRegisterType.VendorName,
									StockUpdateRegister.CreatedBy				= StockUpdateRegisterType.CreatedBy,			
									StockUpdateRegister.CreatedDate				= StockUpdateRegisterType.CreatedDate,			
									StockUpdateRegister.CreatedDateUTC			= StockUpdateRegisterType.CreatedDateUTC,		
									StockUpdateRegister.ModifiedBy				= StockUpdateRegisterType.ModifiedBy,			
									StockUpdateRegister.ModifiedDate			= GETDATE(),		
									StockUpdateRegister.ModifiedDateUTC			= GETUTCDATE(),
									StockUpdateRegister.EstimatedLifeSpan		= StockUpdateRegisterType.EstimatedLifeSpan	,
									StockUpdateRegister.EstimatedLifeSpanId		= StockUpdateRegisterType.EstimatedLifeSpanId,
									StockUpdateRegister.BinNo					= StockUpdateRegisterType.BinNo,
									StockUpdateRegister.SparePartType			= StockUpdateRegisterType.SparePartType,
									StockUpdateRegister.LocationId				= StockUpdateRegisterType.LocationId
									--OUTPUT INSERTED.StockUpdateDetId INTO @Table
					FROM	EngStockUpdateRegisterTxnDet AS StockUpdateRegister 
							INNER JOIN #EngStockUpdateRegisterTxnDet AS StockUpdateRegisterType ON StockUpdateRegister.StockUpdateDetId	=	StockUpdateRegisterType.StockUpdateDetId
					WHERE ISNULL(StockUpdateRegisterType.StockUpdateDetId,0)>0
			
			--SET	@DuplicateCount=(SELECT  COUNT(*) FROM @EngStockUpdateRegisterTxnDet GROUP BY stockupdateid,SparePartsId,InvoiceNo HAVING COUNT(*) > 1)
			--SET	@DuplicateCount1= (SELECT  COUNT(*) FROM @EngStockUpdateRegisterTxnDet a  inner join EngStockUpdateRegisterTxnDet b on a.SparePartsId = b.SparePartsId and a.InvoiceNo = b.InvoiceNo AND a.StockUpdateId = b.StockUpdateId)

			--IF (@DuplicateCount>0 OR @DuplicateCount1>1)
			--BEGIN

			--SELECT 0 As StockUpdateId,
			--CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS  [timestamp],
			--'Part No and Invoice No should be unique' AS ErrorMessage

			--END

			--ELSE

			--BEGIN

        
			   INSERT INTO EngStockUpdateRegisterTxnDet(													
													CustomerId,
													FacilityId,
													ServiceId,
													StockUpdateId,
													SparePartsId,
													StockExpiryDate,
													StockExpiryDateUTC,
													Quantity,
													Cost,
													PurchaseCost,
													InvoiceNo,
													Remarks,
													VendorName,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC,
													EstimatedLifeSpan,
													EstimatedLifeSpanId,												
													BinNo,
													SparePartType,
													LocationId																			
                                                    )
				   SELECT							CustomerId,
													FacilityId,
													ServiceId,
													StockUpdateId,
													SparePartsId,
													StockExpiryDate,
													StockExpiryDateUTC,
													Quantity,
													Cost,
													PurchaseCost,
													InvoiceNo,
													Remarks,
													VendorName,
													CreatedBy,
													GETDATE(),
													GETUTCDATE(),
													ModifiedBy,
													GETDATE(),
													GETUTCDATE(),
													EstimatedLifeSpan,
													EstimatedLifeSpanId,
													BinNo,
													SparePartType,
													LocationId		
				   FROM #EngStockUpdateRegisterTxnDet	AS StockUpdateRegisterType
				   WHERE	ISNULL(StockUpdateRegisterType.StockUpdateDetId,0)=0


				   --END

				
				END

END


			


				

	  

			   
END

			  


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
