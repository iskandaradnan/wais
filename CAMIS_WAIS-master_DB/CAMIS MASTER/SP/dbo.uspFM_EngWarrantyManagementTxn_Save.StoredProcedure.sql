USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngWarrantyManagementTxn_Save]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngWarrantyManagementTxn_Save
Description			: If Warranty management details already exists then update else insert.
Authors				: Balaji M S
Date				: 11-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngWarrantyManagementTxn_Save @PWarrantyMgmtId=15,@pUserId=2,@CustomerId=1,@FacilityId=1,@ServiceId=2,@WarrantyNo='JKGIYEDHFLNUIOFGH',@WarrantyDate='2018-04-11 14:47:32.283'
,@WarrantyDateUTC='2018-04-11 14:47:32.283',@AssetId=1,@Remarks='KJDFIOHDFOH',@pTimestamp=null

SELECT * FROM EngWarrantyManagementTxn

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngWarrantyManagementTxn_Save]
	
		@PWarrantyMgmtId						INT,
		@pUserId								INT,
		@CustomerId								INT,
		@FacilityId								INT,
		@ServiceId								INT,
		@WarrantyNo								NVARCHAR(200)	=	NULL,
		@WarrantyDate							DATETIME,
		@WarrantyDateUTC						DATETIME,
		@AssetId								INT,
		@Remarks								NVARCHAR(1000)	=	NULL,
		@pTimestamp								varbinary(100)	=	NULL
AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)	
	DECLARE @mMonth INT,@mYear INT
-- Default Values


-- Execution
 
-------------------------------------------------------------UPDATE STATEMENT-------------------------------------------------------------

--//1.EngWarrantyManagementTxn
		

		


------------------------------------------------------------INSERT STATEMENT-------------------------------------------------------------

--//1.EngWarrantyManagementTxn
		
		IF(@pWarrantyMgmtId = NULL OR @pWarrantyMgmtId =0)
		BEGIN



	SET @mMonth	=	MONTH(@WarrantyDate)
	SET @mYear	=	YEAR(@WarrantyDate)

	DECLARE @pOutParam NVARCHAR(50) 
	EXEC [uspFM_GenerateDocumentNumber] @pFlag='EngWarrantyManagementTxn',@pCustomerId=@CustomerId,@pFacilityId=@FacilityId,@Defaultkey='WRM',@pModuleName='BEMS',@pService=NULL,@pMonth=@mMonth,@pYear=@mYear,@pOutParam=@pOutParam output
	SELECT @WarrantyNo	=	@pOutParam

			INSERT INTO EngWarrantyManagementTxn(
								CustomerId,
								FacilityId,
								ServiceId,
								WarrantyNo,
								WarrantyDate,
								WarrantyDateUTC,
								AssetId,
								Remarks,
								CreatedBy,
								CreatedDate,
								CreatedDateUTC,
								ModifiedBy,
								ModifiedDate,
								ModifiedDateUTC		
							
							)	OUTPUT INSERTED.WarrantyMgmtId INTO @Table
							VALUES
							(
							 @CustomerId,
							 @FacilityId,
							 @ServiceId,	
							 @WarrantyNo,		
							 @WarrantyDate,
							 @WarrantyDateUTC,
							 @AssetId,		
							 @Remarks,		
							 @pUserId,
							 GETDATE(),
							 GETUTCDATE(),
							 @pUserId,
							 GETDATE(),
							 GETUTCDATE()
							)
		
		SELECT	WarrantyMgmtId,
				[Timestamp],
				'' AS ErrorMessage
		FROM	EngWarrantyManagementTxn
		WHERE	WarrantyMgmtId IN (SELECT ID FROM @Table)
	END


	ELSE

		BEGIN

			DECLARE @mTimestamp varbinary(100);
			SELECT @mTimestamp = Timestamp from EngWarrantyManagementTxn where WarrantyMgmtId = @PWarrantyMgmtId

			IF (@mTimestamp = @pTimestamp)
			BEGIN
				UPDATE WarrantyManagement SET	
							WarrantyManagement.Remarks					=@Remarks,		
							WarrantyManagement.ModifiedBy				=@pUserId,
							WarrantyManagement.ModifiedDate				=GETDATE(),
							WarrantyManagement.ModifiedDateUTC			=GETUTCDATE()
					FROM	EngWarrantyManagementTxn		AS 			WarrantyManagement				
					WHERE	WarrantyManagement.WarrantyMgmtId=@pWarrantyMgmtId
							AND ISNULL(@pWarrantyMgmtId,0)>0

					SELECT	WarrantyMgmtId,
							[Timestamp],
							'' AS ErrorMessage
					FROM	EngWarrantyManagementTxn
					WHERE	WarrantyMgmtId = @pWarrantyMgmtId
			END
		ELSE
			BEGIN
				SELECT	WarrantyMgmtId,
						[Timestamp],
						'Record Modified. Please Re-Select' AS ErrorMessage
				FROM	EngWarrantyManagementTxn
				WHERE	WarrantyMgmtId=@pWarrantyMgmtId
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
		   )

END CATCH
GO
