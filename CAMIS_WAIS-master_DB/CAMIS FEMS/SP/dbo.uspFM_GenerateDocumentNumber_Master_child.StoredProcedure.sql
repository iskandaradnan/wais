USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_GenerateDocumentNumber_Master_child]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_GenerateDocumentNumber
Description			: If Testing and Commissioning already exists then update else insert.
Authors				: Sri 
Date				: 26-sep-2019
-----------------------------------------------------------------------------------------------------------

Unit Test:

DECLARE @pOutParam NVARCHAR(50)  

EXEC [uspFM_GenerateDocumentNumber] @pFlag='QAPCarTxn',@pCustomerId=1,@pFacilityId=2,@Defaultkey='CAR',@pModuleName=NULL,@pMonth=04,@pYear=2018,@pOutParam=@pOutParam OUTPUT
SELECT @pOutParam

SELECT * FROM FMDocumentNoGeneration
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

Create Procedure [dbo].[uspFM_GenerateDocumentNumber_Master_child]

	@pFlag nvarchar(50),
	@pCustomerId int,
	@pFacilityId int,
	@Defaultkey nvarchar(50),
	@pModuleName nvarchar(50)	=NULL,
	@pService nvarchar(50)		=NULL,
	@pMonth int,
	@pYear int ,
	@DocumentNumber_master VARCHAR(200)   = NULL  ,
	@pOutParam NVARCHAR(50) OUTPUT                                          

AS
BEGIN TRY

	--DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	--BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
			DECLARE @DocumentNumber NVARCHAR(100)
			DECLARE @DocumentCount int
			DECLARE @CodeNumber int
			DECLARE @MonthName nvarchar(20)
			DECLARE @pFacility nvarchar(50)
			SELECT @pFacility = FacilityCode FROM MstLocationFacility WHERE FacilityId=@pFacilityId
			
			
	DECLARE @Table TABLE (ID INT)

-- Default Values

	SET @MonthName=UPPER(SUBSTRING (DATENAME(MONTH,DATEFROMPARTS(@pYear, @pMonth, 1 )),1,3))

-- Execution


----------------------------------------------------------	1) TestingandCommissioning ---------------------------------------------------------------

		 IF(@pFlag='TestingandCommissioning')

			BEGIN
				--SET @DocumentNumber=@Defaultkey+'/'+@pFacility+'/'--+right(cast(@pYear as varchar(10)),4)+right('0'+cast(@pMonth as varchar(10)),2)+'/'
				SET @DocumentNumber=@DocumentNumber_master
				SET @DocumentCount=isnull((select COUNT(*) from FMDocumentNoGeneration where DocumentNumber=@DocumentNumber and ScreenName='TestingandCommissioning'),0)

				IF(@DocumentCount=0)
				begin
				INSERT INTO FMDocumentNoGeneration(	CustomerId,
													FacilityId,
													ScreenName,
													DocumentNumber,
													CodeNumber,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC) 
						VALUES (	@pCustomerId,
									@pFacilityId,
									'TestingandCommissioning',
									@DocumentNumber,
									1,
									1,
									GETDATE(),
									GETUTCDATE(),
									1,
									GETDATE(),
									GETUTCDATE()
								) 
				SET @DocumentNumber=@DocumentNumber+'00000'+cast (1 as varchar(10))
			END
			ELSE
				BEGIN
					SELECT	@CodeNumber=CodeNumber+1 
					FROM	FMDocumentNoGeneration 
					WHERE	DocumentNumber = @DocumentNumber 
							AND ScreenName='TestingandCommissioning'
					
					UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber	WHERE    DocumentNumber=@DocumentNumber AND ScreenName='TestingandCommissioning'

 					SET @DocumentNumber=@DocumentNumber+RIGHT('000000'+CAST (@CodeNumber AS VARCHAR(20)),6)
				END

				SET @pOutParam = @DocumentNumber; 
				--SELECT @DocumentNumber
			END



----------------------------------------------------------	1.1) TestingandCommissioningDet ---------------------------------------------------------------

		 IF(@pFlag='TestingandCommissioningDet')

			BEGIN
				--SET @DocumentNumber=@Defaultkey+'/'+@pFacility+'/'--+right(cast(@pYear as varchar(10)),4)+right('0'+cast(@pMonth as varchar(10)),2)+'/'
				SET @DocumentNumber=@DocumentNumber_master
				SET @DocumentCount=isnull((select COUNT(*) from FMDocumentNoGeneration where DocumentNumber=@DocumentNumber and ScreenName='TestingandCommissioningDet'),0)

				IF(@DocumentCount=0)
				begin
				INSERT INTO FMDocumentNoGeneration(	CustomerId,
													FacilityId,
													ScreenName,
													DocumentNumber,
													CodeNumber,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC) 
						VALUES (	@pCustomerId,
									@pFacilityId,
									'TestingandCommissioningDet',
									@DocumentNumber,
									1,
									1,
									GETDATE(),
									GETUTCDATE(),
									1,
									GETDATE(),
									GETUTCDATE()
								) 
				SET @DocumentNumber=@DocumentNumber+'00000'+cast (1 as varchar(10))
			END
			ELSE
				BEGIN
					SELECT	@CodeNumber=CodeNumber+1 
					FROM	FMDocumentNoGeneration 
					WHERE	DocumentNumber = @DocumentNumber 
							AND ScreenName='TestingandCommissioningDet'
					
					UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber	WHERE    DocumentNumber=@DocumentNumber AND ScreenName='TestingandCommissioningDet'

 					SET @DocumentNumber=@DocumentNumber+RIGHT('000000'+CAST (@CodeNumber AS VARCHAR(20)),6)
				END

				SET @pOutParam = @DocumentNumber; 
				--SELECT @DocumentNumber
			END

----------------------------------------------------------	2) EngEODCaptureTxn ---------------------------------------------------------------

		ELSE IF(@pFlag='EngEODCaptureTxn')

			BEGIN
				--SET @DocumentNumber=@Defaultkey+'/'+@pFacility+'/'--+right(cast(@pYear as varchar(10)),4)+right('0'+cast(@pMonth as varchar(10)),2)+'/'
				SET @DocumentNumber=@DocumentNumber_master
				SET @DocumentCount=isnull((select COUNT(*) from FMDocumentNoGeneration where DocumentNumber=@DocumentNumber and ScreenName='EngEODCaptureTxn'),0)

				IF(@DocumentCount=0)
				begin
				INSERT INTO FMDocumentNoGeneration(	CustomerId,
													FacilityId,
													ScreenName,
													DocumentNumber,
													CodeNumber,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC) 
						VALUES (	@pCustomerId,
									@pFacilityId,
									'EngEODCaptureTxn',
									@DocumentNumber,
									1,
									1,
									GETDATE(),
									GETUTCDATE(),
									1,
									GETDATE(),
									GETUTCDATE()
								) 
				SET @DocumentNumber=@DocumentNumber+'00000'+cast (1 as varchar(10))
			END
			ELSE
				BEGIN
					SELECT	@CodeNumber=CodeNumber+1 
					FROM	FMDocumentNoGeneration 
					WHERE	DocumentNumber = @DocumentNumber 
							AND ScreenName='EngEODCaptureTxn'
					
					UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber	WHERE    DocumentNumber=@DocumentNumber AND ScreenName='EngEODCaptureTxn'

 					SET @DocumentNumber=@DocumentNumber+RIGHT('000000'+CAST (@CodeNumber AS VARCHAR(20)),6)
				END
				SET @pOutParam = @DocumentNumber; 
			END


----------------------------------------------------------	3) BERApplicationTxn ---------------------------------------------------------------

		ELSE IF(@pFlag='BERApplicationTxn')

			BEGIN
				--SET @DocumentNumber=@Defaultkey+'/'+@pFacility+'/'--+right(cast(@pYear as varchar(10)),4)+right('0'+cast(@pMonth as varchar(10)),2)+'/'
				SET @DocumentNumber=@DocumentNumber_master
				SET @DocumentCount=isnull((select COUNT(*) from FMDocumentNoGeneration where DocumentNumber=@DocumentNumber and ScreenName='BERApplicationTxn'),0)

				IF(@DocumentCount=0)
				begin
				INSERT INTO FMDocumentNoGeneration(	CustomerId,
													FacilityId,
													ScreenName,
													DocumentNumber,
													CodeNumber,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC) 
						VALUES (	@pCustomerId,
									@pFacilityId,
									'BERApplicationTxn',
									@DocumentNumber,
									1,
									1,
									GETDATE(),
									GETUTCDATE(),
									1,
									GETDATE(),
									GETUTCDATE()
								) 
				SET @DocumentNumber=@DocumentNumber+'00000'+cast (1 as varchar(10))
			END
			ELSE
				BEGIN
					SELECT	@CodeNumber=CodeNumber+1 
					FROM	FMDocumentNoGeneration 
					WHERE	DocumentNumber = @DocumentNumber 
							AND ScreenName='BERApplicationTxn'
					
					UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber	WHERE    DocumentNumber=@DocumentNumber AND ScreenName='BERApplicationTxn'
 					SET @DocumentNumber=@DocumentNumber+RIGHT('000000'+CAST (@CodeNumber AS VARCHAR(20)),6)
				END

				SET @pOutParam = @DocumentNumber; 
			END


----------------------------------------------------------	3) EngMaintenanceWorkOrderTxn (Only for UnScheduled) ---------------------------------------------------------------

		ELSE IF(@pFlag='EngMaintenanceWorkOrderTxn')

			BEGIN
				--SET @DocumentNumber=@Defaultkey+'/'+@pFacility+'/'--+right(cast(@pYear as varchar(10)),4)+right('0'+cast(@pMonth as varchar(10)),2)+'/'
				SET @DocumentNumber=@DocumentNumber_master
				SET @DocumentCount=isnull((select COUNT(*) from FMDocumentNoGeneration where DocumentNumber=@DocumentNumber and ScreenName='EngMaintenanceWorkOrderTxn'),0)

				IF(@DocumentCount=0)
				begin
				INSERT INTO FMDocumentNoGeneration(	CustomerId,
													FacilityId,
													ScreenName,
													DocumentNumber,
													CodeNumber,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC) 
						VALUES (	@pCustomerId,
									@pFacilityId,
									'EngMaintenanceWorkOrderTxn',
									@DocumentNumber,
									1,
									1,
									GETDATE(),
									GETUTCDATE(),
									1,
									GETDATE(),
									GETUTCDATE()
								) 
				SET @DocumentNumber=@DocumentNumber+'00000'+cast (1 as varchar(10))
			END
			ELSE
				BEGIN
					SELECT	@CodeNumber=CodeNumber+1 
					FROM	FMDocumentNoGeneration 
					WHERE	DocumentNumber = @DocumentNumber 
							AND ScreenName='EngMaintenanceWorkOrderTxn'
					
					UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber	WHERE    DocumentNumber=@DocumentNumber AND ScreenName='EngMaintenanceWorkOrderTxn'
 					SET @DocumentNumber=@DocumentNumber+RIGHT('000000'+CAST (@CodeNumber AS VARCHAR(20)),6)
				END

				SET @pOutParam = @DocumentNumber; 
			END

----------------------------------------------------------	4)EngStockUpdateRegisterTxn  ---------------------------------------------------------------
ELSE IF(@pFlag='EngStockUpdateRegisterTxn')

			BEGIN
				--SET @DocumentNumber=@Defaultkey+'/'+@pFacility+'/'--+right(cast(@pYear as varchar(10)),4)+right('0'+cast(@pMonth as varchar(10)),2)+'/'
				SET @DocumentNumber=@DocumentNumber_master
				SET @DocumentCount=isnull((select COUNT(*) from FMDocumentNoGeneration where DocumentNumber=@DocumentNumber and ScreenName='EngStockUpdateRegisterTxn'),0)

				IF(@DocumentCount=0)
				begin
				INSERT INTO FMDocumentNoGeneration(	CustomerId,
													FacilityId,
													ScreenName,
													DocumentNumber,
													CodeNumber,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC) 
						VALUES (	@pCustomerId,
									@pFacilityId,
									'EngStockUpdateRegisterTxn',
									@DocumentNumber,
									1,
									1,
									GETDATE(),
									GETUTCDATE(),
									1,
									GETDATE(),
									GETUTCDATE()
								) 
				SET @DocumentNumber=@DocumentNumber+'00000'+cast (1 as varchar(10))
			END
			ELSE
				BEGIN
					SELECT	@CodeNumber=CodeNumber+1 
					FROM	FMDocumentNoGeneration 
					WHERE	DocumentNumber = @DocumentNumber 
							AND ScreenName='EngStockUpdateRegisterTxn'
					
					UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber	WHERE    DocumentNumber=@DocumentNumber AND ScreenName='EngStockUpdateRegisterTxn'
 					SET @DocumentNumber=@DocumentNumber+RIGHT('000000'+CAST (@CodeNumber AS VARCHAR(20)),6)
				END

				SET @pOutParam = @DocumentNumber; 
			END

--------------------------------------------------------6) EngStockAdjustmentTxn--------------------------------------------------------------------------------------

ELSE IF(@pFlag='EngStockAdjustmentTxn')

			BEGIN
				--SET @DocumentNumber=@Defaultkey+'/'+@pFacility+'/'--+right(cast(@pYear as varchar(10)),4)+right('0'+cast(@pMonth as varchar(10)),2)+'/'
				SET @DocumentNumber=@DocumentNumber_master
				SET @DocumentCount=isnull((select COUNT(*) from FMDocumentNoGeneration where DocumentNumber=@DocumentNumber and ScreenName='EngStockAdjustmentTxn'),0)

				IF(@DocumentCount=0)
				begin
				INSERT INTO FMDocumentNoGeneration(	CustomerId,
													FacilityId,
													ScreenName,
													DocumentNumber,
													CodeNumber,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC) 
						VALUES (	@pCustomerId,
									@pFacilityId,
									'EngStockAdjustmentTxn',
									@DocumentNumber,
									1,
									1,
									GETDATE(),
									GETUTCDATE(),
									1,
									GETDATE(),
									GETUTCDATE()
								) 
				SET @DocumentNumber=@DocumentNumber+'00000'+cast (1 as varchar(10))
			END
			ELSE
				BEGIN
					SELECT	@CodeNumber=CodeNumber+1 
					FROM	FMDocumentNoGeneration 
					WHERE	DocumentNumber = @DocumentNumber 
							AND ScreenName='EngStockAdjustmentTxn'
					
					UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber	WHERE    DocumentNumber=@DocumentNumber AND ScreenName='EngStockAdjustmentTxn'
 					SET @DocumentNumber=@DocumentNumber+RIGHT('000000'+CAST (@CodeNumber AS VARCHAR(20)),6)
				END

				SET @pOutParam = @DocumentNumber; 
			END


--------------------------------------------------------7) CRMRequest--------------------------------------------------------------------------------------

ELSE IF(@pFlag='CRMRequest')

			BEGIN
				--SET @DocumentNumber=@Defaultkey+'/'+@pFacility+'/'--+right(cast(@pYear as varchar(10)),4)+right('0'+cast(@pMonth as varchar(10)),2)+'/'
				SET @DocumentNumber=@DocumentNumber_master
				SET @DocumentCount=ISNULL((SELECT COUNT(*) FROM FMDocumentNoGeneration WHERE DocumentNumber=@DocumentNumber and ScreenName='CRMRequest'),0)

				IF(@DocumentCount=0)
				BEGIN
				INSERT INTO FMDocumentNoGeneration(	CustomerId,
													FacilityId,
													ScreenName,
													DocumentNumber,
													CodeNumber,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC) 
						VALUES (	@pCustomerId,
									@pFacilityId,
									'CRMRequest',
									@DocumentNumber,
									1,
									1,
									GETDATE(),
									GETUTCDATE(),
									1,
									GETDATE(),
									GETUTCDATE()
								) 
				SET @DocumentNumber=@DocumentNumber+'00000'+cast (1 as varchar(10))
			END
			ELSE
				BEGIN
					SELECT	@CodeNumber=CodeNumber+1 
					FROM	FMDocumentNoGeneration 
					WHERE	DocumentNumber = @DocumentNumber 
							AND ScreenName='CRMRequest'
					
					UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber	WHERE    DocumentNumber=@DocumentNumber AND ScreenName='CRMRequest'
 					SET @DocumentNumber=@DocumentNumber+RIGHT('000000'+CAST (@CodeNumber AS VARCHAR(20)),6)
				END

				SET @pOutParam = @DocumentNumber; 
			END

--------------------------------------------------------7) CRMRequestWorkOrderTxn--------------------------------------------------------------------------------------

ELSE IF(@pFlag='CRMRequestWorkOrderTxn')

			BEGIN
				--SET @DocumentNumber=@Defaultkey+'/'+@pFacility+'/'--+right(cast(@pYear as varchar(10)),4)+right('0'+cast(@pMonth as varchar(10)),2)+'/'
				SET @DocumentNumber=@DocumentNumber_master
				SET @DocumentCount=ISNULL((SELECT COUNT(*) FROM FMDocumentNoGeneration WHERE DocumentNumber=@DocumentNumber and ScreenName='CRMRequestWorkOrderTxn'),0)

				IF(@DocumentCount=0)
				BEGIN
				INSERT INTO FMDocumentNoGeneration(	CustomerId,
													FacilityId,
													ScreenName,
													DocumentNumber,
													CodeNumber,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC) 
						VALUES (	@pCustomerId,
									@pFacilityId,
									'CRMRequestWorkOrderTxn',
									@DocumentNumber,
									1,
									1,
									GETDATE(),
									GETUTCDATE(),
									1,
									GETDATE(),
									GETUTCDATE()
								) 
				SET @DocumentNumber=@DocumentNumber+'00000'+cast (1 as varchar(10))
			END
			ELSE
				BEGIN
					SELECT	@CodeNumber=CodeNumber+1 
					FROM	FMDocumentNoGeneration 
					WHERE	DocumentNumber = @DocumentNumber 
							AND ScreenName='CRMRequestWorkOrderTxn'
					
					UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber	WHERE    DocumentNumber=@DocumentNumber AND ScreenName='CRMRequestWorkOrderTxn'
 					SET @DocumentNumber=@DocumentNumber+RIGHT('000000'+CAST (@CodeNumber AS VARCHAR(20)),6)
				END

				SET @pOutParam = @DocumentNumber; 
			END


--------------------------------------------------------8) QAPCarTxn--------------------------------------------------------------------------------------

ELSE IF(@pFlag='QAPCarTxn')

			BEGIN
				--SET @DocumentNumber=@Defaultkey+'/'+@pFacility+'/'--+right(cast(@pYear as varchar(10)),4)+right('0'+cast(@pMonth as varchar(10)),2)+'/'
				SET @DocumentNumber=@DocumentNumber_master
				SET @DocumentCount=ISNULL((SELECT COUNT(*) FROM FMDocumentNoGeneration WHERE DocumentNumber=@DocumentNumber and ScreenName='QAPCarTxn'),0)

				IF(@DocumentCount=0)
				BEGIN
				INSERT INTO FMDocumentNoGeneration(	CustomerId,
													FacilityId,
													ScreenName,
													DocumentNumber,
													CodeNumber,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC) 
						VALUES (	@pCustomerId,
									@pFacilityId,
									'QAPCarTxn',
									@DocumentNumber,
									1,
									1,
									GETDATE(),
									GETUTCDATE(),
									1,
									GETDATE(),
									GETUTCDATE()
								) 
				SET @DocumentNumber=@DocumentNumber+'00000'+cast (1 as varchar(10))
			END
			ELSE
				BEGIN
					SELECT	@CodeNumber=CodeNumber+1 
					FROM	FMDocumentNoGeneration 
					WHERE	DocumentNumber = @DocumentNumber 
							AND ScreenName='QAPCarTxn'
					
					UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber	WHERE    DocumentNumber=@DocumentNumber AND ScreenName='QAPCarTxn'
 					SET @DocumentNumber=@DocumentNumber+RIGHT('000000'+CAST (@CodeNumber AS VARCHAR(20)),6)
				END

				SET @pOutParam = @DocumentNumber; 
			END

--------------------------------------------------------9) PorteringTransaction--------------------------------------------------------------------------------------

ELSE IF(@pFlag='PorteringTransaction')

			BEGIN
				--SET @DocumentNumber=@Defaultkey+'/'+@pFacility+'/'--+right(cast(@pYear as varchar(10)),4)+right('0'+cast(@pMonth as varchar(10)),2)+'/'
				SET @DocumentNumber=@DocumentNumber_master
				SET @DocumentCount=ISNULL((SELECT COUNT(*) FROM FMDocumentNoGeneration WHERE DocumentNumber=@DocumentNumber and ScreenName='PorteringTransaction'),0)

				IF(@DocumentCount=0)
				BEGIN
				INSERT INTO FMDocumentNoGeneration(	CustomerId,
													FacilityId,
													ScreenName,
													DocumentNumber,
													CodeNumber,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC) 
						VALUES (	@pCustomerId,
									@pFacilityId,
									'PorteringTransaction',
									@DocumentNumber,
									1,
									1,
									GETDATE(),
									GETUTCDATE(),
									1,
									GETDATE(),
									GETUTCDATE()
								) 
				SET @DocumentNumber=@DocumentNumber+'00000'+cast (1 as varchar(10))
			END
			ELSE
				BEGIN
					SELECT	@CodeNumber=CodeNumber+1 
					FROM	FMDocumentNoGeneration 
					WHERE	DocumentNumber = @DocumentNumber 
							AND ScreenName='PorteringTransaction'
					
					UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber	WHERE    DocumentNumber=@DocumentNumber AND ScreenName='PorteringTransaction'
 					SET @DocumentNumber=@DocumentNumber+RIGHT('000000'+CAST (@CodeNumber AS VARCHAR(20)),6)
				END

				SET @pOutParam = @DocumentNumber; 
			END
--------------------------------------------------------10) DeductionGeneration--------------------------------------------------------------------------------------

ELSE IF(@pFlag='DedGenerationTxn')

			BEGIN
				--SET @DocumentNumber=@Defaultkey+'/'+@pFacility+'/'--+right(cast(@pYear as varchar(10)),4)+right('0'+cast(@pMonth as varchar(10)),2)+'/'
				SET @DocumentNumber=@DocumentNumber_master
				SET @DocumentCount=ISNULL((SELECT COUNT(*) FROM FMDocumentNoGeneration WHERE DocumentNumber=@DocumentNumber and ScreenName='DedGenerationTxn'),0)

				IF(@DocumentCount=0)
				BEGIN
				INSERT INTO FMDocumentNoGeneration(	CustomerId,
													FacilityId,
													ScreenName,
													DocumentNumber,
													CodeNumber,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC) 
						VALUES (	@pCustomerId,
									@pFacilityId,
									'DedGenerationTxn',
									@DocumentNumber,
									1,
									1,
									GETDATE(),
									GETUTCDATE(),
									1,
									GETDATE(),
									GETUTCDATE()
								) 
				SET @DocumentNumber=@DocumentNumber+'00000'+cast (1 as varchar(10))
			END
			ELSE
				BEGIN
					SELECT	@CodeNumber=CodeNumber+1 
					FROM	FMDocumentNoGeneration 
					WHERE	DocumentNumber = @DocumentNumber 
							AND ScreenName='DedGenerationTxn'
					
					UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber	WHERE    DocumentNumber=@DocumentNumber AND ScreenName='DedGenerationTxn'
 					SET @DocumentNumber=@DocumentNumber+RIGHT('000000'+CAST (@CodeNumber AS VARCHAR(20)),6)
				END

				SET @pOutParam = @DocumentNumber; 
			END
--------------------------------------------------------11) EngTrainingScheduleTxn--------------------------------------------------------------------------------------

ELSE IF(@pFlag='EngTrainingScheduleTxn')

			BEGIN
				--SET @DocumentNumber=@Defaultkey+'/'+@pFacility+'/'--+right(cast(@pYear as varchar(10)),4)+right('0'+cast(@pMonth as varchar(10)),2)+'/'
				SET @DocumentNumber=@DocumentNumber_master
				SET @DocumentCount=ISNULL((SELECT COUNT(*) FROM FMDocumentNoGeneration WHERE DocumentNumber=@DocumentNumber and ScreenName='EngTrainingScheduleTxn'),0)

				IF(@DocumentCount=0)
				BEGIN
				INSERT INTO FMDocumentNoGeneration(	CustomerId,
													FacilityId,
													ScreenName,
													DocumentNumber,
													CodeNumber,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC) 
						VALUES (	@pCustomerId,
									@pFacilityId,
									'EngTrainingScheduleTxn',
									@DocumentNumber,
									1,
									1,
									GETDATE(),
									GETUTCDATE(),
									1,
									GETDATE(),
									GETUTCDATE()
								) 
				SET @DocumentNumber=@DocumentNumber+'00000'+cast (1 as varchar(10))
			END
			ELSE
				BEGIN
					SELECT	@CodeNumber=CodeNumber+1 
					FROM	FMDocumentNoGeneration 
					WHERE	DocumentNumber = @DocumentNumber 
							AND ScreenName='EngTrainingScheduleTxn'
					
					UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber	WHERE    DocumentNumber=@DocumentNumber AND ScreenName='EngTrainingScheduleTxn'
 					SET @DocumentNumber=@DocumentNumber+RIGHT('000000'+CAST (@CodeNumber AS VARCHAR(20)),6)
				END

				SET @pOutParam = @DocumentNumber; 
			END


--------------------------------------------------------12) EngWarrantyManagementTxn--------------------------------------------------------------------------------------

ELSE IF(@pFlag='EngWarrantyManagementTxn')

			BEGIN
				--SET @DocumentNumber=@Defaultkey+'/'+@pFacility+'/'--+right(cast(@pYear as varchar(10)),4)+right('0'+cast(@pMonth as varchar(10)),2)+'/'
				SET @DocumentNumber=@DocumentNumber_master
				SET @DocumentCount=ISNULL((SELECT COUNT(*) FROM FMDocumentNoGeneration WHERE DocumentNumber=@DocumentNumber and ScreenName='EngWarrantyManagementTxn'),0)

				IF(@DocumentCount=0)
				BEGIN
				INSERT INTO FMDocumentNoGeneration(	CustomerId,
													FacilityId,
													ScreenName,
													DocumentNumber,
													CodeNumber,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC) 
						VALUES (	@pCustomerId,
									@pFacilityId,
									'EngWarrantyManagementTxn',
									@DocumentNumber,
									1,
									1,
									GETDATE(),
									GETUTCDATE(),
									1,
									GETDATE(),
									GETUTCDATE()
								) 
				SET @DocumentNumber=@DocumentNumber+'00000'+cast (1 as varchar(10))
			END
			ELSE
				BEGIN
					SELECT	@CodeNumber=CodeNumber+1 
					FROM	FMDocumentNoGeneration 
					WHERE	DocumentNumber = @DocumentNumber 
							AND ScreenName='EngWarrantyManagementTxn'
					
					UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber	WHERE    DocumentNumber=@DocumentNumber AND ScreenName='EngWarrantyManagementTxn'
 					SET @DocumentNumber=@DocumentNumber+RIGHT('000000'+CAST (@CodeNumber AS VARCHAR(20)),6)
				END

				SET @pOutParam = @DocumentNumber; 
			END




--------------------------------------------------------13) QAPCarTxn--------------------------------------------------------------------------------------

ELSE IF(@pFlag='QAPCarTxn')

			BEGIN
				--SET @DocumentNumber=@Defaultkey+'/'+@pFacility+'/'--+right(cast(@pYear as varchar(10)),4)+right('0'+cast(@pMonth as varchar(10)),2)+'/'
				SET @DocumentNumber=@DocumentNumber_master
				SET @DocumentCount=ISNULL((SELECT COUNT(*) FROM FMDocumentNoGeneration WHERE DocumentNumber=@DocumentNumber and ScreenName='QAPCarTxn'),0)

				IF(@DocumentCount=0)
				BEGIN
				INSERT INTO FMDocumentNoGeneration(	CustomerId,
													FacilityId,
													ScreenName,
													DocumentNumber,
													CodeNumber,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC) 
						VALUES (	@pCustomerId,
									@pFacilityId,
									'QAPCarTxn',
									@DocumentNumber,
									1,
									1,
									GETDATE(),
									GETUTCDATE(),
									1,
									GETDATE(),
									GETUTCDATE()
								) 
				SET @DocumentNumber=@DocumentNumber+'00000'+cast (1 as varchar(10))
			END
			ELSE
				BEGIN
					SELECT	@CodeNumber=CodeNumber+1 
					FROM	FMDocumentNoGeneration 
					WHERE	DocumentNumber = @DocumentNumber 
							AND ScreenName='QAPCarTxn'
					
					UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber	WHERE    DocumentNumber=@DocumentNumber AND ScreenName='QAPCarTxn'
 					SET @DocumentNumber=@DocumentNumber+RIGHT('000000'+CAST (@CodeNumber AS VARCHAR(20)),6)
				END

				SET @pOutParam = @DocumentNumber; 
			END





--------------------------------------------------------14) EngAssetClassification--------------------------------------------------------------------------------------

ELSE IF(@pFlag='EngAssetClassification')

			BEGIN
				--SET @DocumentNumber=@Defaultkey+'/'+@pFacility+'/'--+right(cast(@pYear as varchar(10)),4)+right('0'+cast(@pMonth as varchar(10)),2)+'/'
				SET @DocumentNumber=@DocumentNumber_master
				SET @DocumentCount=ISNULL((SELECT COUNT(*) FROM FMDocumentNoGeneration WHERE DocumentNumber=@DocumentNumber and ScreenName='EngAssetClassification'),0)

				IF(@DocumentCount=0)
				BEGIN
				INSERT INTO FMDocumentNoGeneration(	CustomerId,
													FacilityId,
													ScreenName,
													DocumentNumber,
													CodeNumber,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC) 
						VALUES (	@pCustomerId,
									@pFacilityId,
									'EngAssetClassification',
									@DocumentNumber,
									1,
									1,
									GETDATE(),
									GETUTCDATE(),
									1,
									GETDATE(),
									GETUTCDATE()
								) 
				SET @DocumentNumber=@DocumentNumber+'000'+cast (1 as varchar(10))
			END
			ELSE
				BEGIN
					SELECT	@CodeNumber=CodeNumber+1 
					FROM	FMDocumentNoGeneration 
					WHERE	DocumentNumber = @DocumentNumber 
							AND ScreenName='EngAssetClassification'
					
					UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber	WHERE    DocumentNumber=@DocumentNumber AND ScreenName='EngAssetClassification'
 					SET @DocumentNumber=@DocumentNumber+RIGHT('000'+CAST (@CodeNumber AS VARCHAR(20)),3)
				END

				SET @pOutParam = @DocumentNumber; 
			END





--------------------------------------------------------15) MstCustomer--------------------------------------------------------------------------------------

ELSE IF(@pFlag='MstCustomer')

			BEGIN
				--SET @DocumentNumber=@Defaultkey+'/'+@pFacility+'/'--+right(cast(@pYear as varchar(10)),4)+right('0'+cast(@pMonth as varchar(10)),2)+'/'
				SET @DocumentNumber=@DocumentNumber_master
				SET @DocumentCount=ISNULL((SELECT COUNT(*) FROM FMDocumentNoGeneration WHERE DocumentNumber=@DocumentNumber and ScreenName='MstCustomer'),0)

				IF(@DocumentCount=0)
				BEGIN
				INSERT INTO FMDocumentNoGeneration(	CustomerId,
													FacilityId,
													ScreenName,
													DocumentNumber,
													CodeNumber,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC) 
						VALUES (	@pCustomerId,
									@pFacilityId,
									'MstCustomer',
									@DocumentNumber,
									1,
									1,
									GETDATE(),
									GETUTCDATE(),
									1,
									GETDATE(),
									GETUTCDATE()
								) 
				SET @DocumentNumber=@DocumentNumber+'00'+cast (1 as varchar(10))
			END
			ELSE
				BEGIN
					SELECT	@CodeNumber=CodeNumber+1 
					FROM	FMDocumentNoGeneration 
					WHERE	DocumentNumber = @DocumentNumber 
							AND ScreenName='MstCustomer'
					
					UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber	WHERE    DocumentNumber=@DocumentNumber AND ScreenName='MstCustomer'
 					SET @DocumentNumber=@DocumentNumber+RIGHT('000'+CAST (@CodeNumber AS VARCHAR(20)),3)
				END

				SET @pOutParam = @DocumentNumber; 
			END





--------------------------------------------------------16) MstLocationFacility--------------------------------------------------------------------------------------

ELSE IF(@pFlag='MstLocationFacility')

			BEGIN
				--SET @DocumentNumber=@Defaultkey+'/'+@pFacility+'/'--+right(cast(@pYear as varchar(10)),4)+right('0'+cast(@pMonth as varchar(10)),2)+'/'
				SET @DocumentNumber=@DocumentNumber_master
				SET @DocumentCount=ISNULL((SELECT COUNT(*) FROM FMDocumentNoGeneration WHERE DocumentNumber=@DocumentNumber and ScreenName='MstLocationFacility'),0)

				IF(@DocumentCount=0)
				BEGIN
				INSERT INTO FMDocumentNoGeneration(	CustomerId,
													FacilityId,
													ScreenName,
													DocumentNumber,
													CodeNumber,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC) 
						VALUES (	@pCustomerId,
									@pFacilityId,
									'MstLocationFacility',
									@DocumentNumber,
									1,
									1,
									GETDATE(),
									GETUTCDATE(),
									1,
									GETDATE(),
									GETUTCDATE()
								) 
				SET @DocumentNumber=@DocumentNumber+'00'+cast (1 as varchar(10))
			END
			ELSE
				BEGIN
					SELECT	@CodeNumber=CodeNumber+1 
					FROM	FMDocumentNoGeneration 
					WHERE	DocumentNumber = @DocumentNumber 
							AND ScreenName='MstLocationFacility'
					
					UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber	WHERE    DocumentNumber=@DocumentNumber AND ScreenName='MstLocationFacility'
 					SET @DocumentNumber=@DocumentNumber+RIGHT('000'+CAST (@CodeNumber AS VARCHAR(20)),3)
				END

				SET @pOutParam = @DocumentNumber; 
			END



----------------------------------------------------------	17) EngMaintenanceWorkOrderTxn (Only for Scheduled) ---------------------------------------------------------------

		ELSE IF(@pFlag='EngMaintenanceWorkOrderTxnSchd')

			BEGIN
				--SET @DocumentNumber=@Defaultkey+'/'+@pFacility+'/'--+right(cast(@pYear as varchar(10)),4)+right('0'+cast(@pMonth as varchar(10)),2)+'/'
				SET @DocumentNumber=@DocumentNumber_master
				SET @DocumentCount=isnull((select COUNT(*) from FMDocumentNoGeneration where DocumentNumber=@DocumentNumber and ScreenName='EngMaintenanceWorkOrderTxnSchd'),0)

				IF(@DocumentCount=0)
				begin
				INSERT INTO FMDocumentNoGeneration(	CustomerId,
													FacilityId,
													ScreenName,
													DocumentNumber,
													CodeNumber,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC) 
						VALUES (	@pCustomerId,
									@pFacilityId,
									'EngMaintenanceWorkOrderTxnSchd',
									@DocumentNumber,
									1,
									1,
									GETDATE(),
									GETUTCDATE(),
									1,
									GETDATE(),
									GETUTCDATE()
								) 
				SET @DocumentNumber=@DocumentNumber+'00000'+cast (1 as varchar(10))
			END
			ELSE
				BEGIN
					SELECT	@CodeNumber=CodeNumber+1 
					FROM	FMDocumentNoGeneration 
					WHERE	DocumentNumber = @DocumentNumber 
							AND ScreenName='EngMaintenanceWorkOrderTxnSchd'
					
					UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber	WHERE    DocumentNumber=@DocumentNumber AND ScreenName='EngMaintenanceWorkOrderTxnSchd'
 					SET @DocumentNumber=@DocumentNumber+RIGHT('000000'+CAST (@CodeNumber AS VARCHAR(20)),6)
				END

				SET @pOutParam = @DocumentNumber; 
			END




--------------------------------------------------------18) EngAssetClassification--------------------------------------------------------------------------------------

ELSE IF(@pFlag='EngAssetPPMCheckList')

			BEGIN
				--SET @DocumentNumber=@Defaultkey+'/'+@pFacility+'/'--+right(cast(@pYear as varchar(10)),4)+right('0'+cast(@pMonth as varchar(10)),2)+'/'
				SET @DocumentNumber=@DocumentNumber_master
				SET @DocumentCount=ISNULL((SELECT COUNT(*) FROM FMDocumentNoGeneration WHERE DocumentNumber=@DocumentNumber and ScreenName='EngAssetPPMCheckList'),0)

				IF(@DocumentCount=0)
				BEGIN
				INSERT INTO FMDocumentNoGeneration(	CustomerId,
													FacilityId,
													ScreenName,
													DocumentNumber,
													CodeNumber,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC) 
						VALUES (	@pCustomerId,
									@pFacilityId,
									'EngAssetPPMCheckList',
									@DocumentNumber,
									1,
									1,
									GETDATE(),
									GETUTCDATE(),
									1,
									GETDATE(),
									GETUTCDATE()
								) 
				SET @DocumentNumber=@DocumentNumber+'0000'+cast (1 as varchar(10))
			END
			ELSE
				BEGIN
					SELECT	@CodeNumber=CodeNumber+1 
					FROM	FMDocumentNoGeneration 
					WHERE	DocumentNumber = @DocumentNumber 
							AND ScreenName='EngAssetPPMCheckList'
					
					UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber	WHERE    DocumentNumber=@DocumentNumber AND ScreenName='EngAssetPPMCheckList'
 					SET @DocumentNumber=@DocumentNumber+RIGHT('0000'+CAST (@CodeNumber AS VARCHAR(20)),4)
				END

				SET @pOutParam = @DocumentNumber; 
			END





--------------------------------------------------------18) EngAsset--------------------------------------------------------------------------------------

ELSE IF(@pFlag='EngAsset')

			BEGIN
				--SET @DocumentNumber=@Defaultkey+'/'+@pFacility+'/'--+right(cast(@pYear as varchar(10)),4)+right('0'+cast(@pMonth as varchar(10)),2)+'/'
				SET @DocumentNumber=@DocumentNumber_master
				SET @DocumentCount=ISNULL((SELECT COUNT(*) FROM FMDocumentNoGeneration WHERE DocumentNumber=@DocumentNumber and ScreenName='EngAsset'),0)

				IF(@DocumentCount=0)
				BEGIN
				INSERT INTO FMDocumentNoGeneration(	CustomerId,
													FacilityId,
													ScreenName,
													DocumentNumber,
													CodeNumber,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC) 
						VALUES (	@pCustomerId,
									@pFacilityId,
									'EngAsset',
									@DocumentNumber,
									1,
									1,
									GETDATE(),
									GETUTCDATE(),
									1,
									GETDATE(),
									GETUTCDATE()
								) 
				SET @DocumentNumber=@DocumentNumber+'0000'+cast (1 as varchar(10))
			END
			ELSE
				BEGIN
					SELECT	@CodeNumber=CodeNumber+1 
					FROM	FMDocumentNoGeneration 
					WHERE	DocumentNumber = @DocumentNumber 
							AND ScreenName='EngAsset'
					
					UPDATE FMDocumentNoGeneration SET CodeNumber=@CodeNumber	WHERE    DocumentNumber=@DocumentNumber AND ScreenName='EngAsset'
 					SET @DocumentNumber=@DocumentNumber+RIGHT('00000'+CAST (@CodeNumber AS VARCHAR(20)),5)
				END

				SET @pOutParam = @DocumentNumber; 
			END




	--IF @mTRANSCOUNT = 0
 --       BEGIN
 --           COMMIT TRANSACTION
        --END   


END TRY

BEGIN CATCH

	--IF @mTRANSCOUNT = 0
 --       BEGIN
 --           ROLLBACK TRAN
 --       END

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
