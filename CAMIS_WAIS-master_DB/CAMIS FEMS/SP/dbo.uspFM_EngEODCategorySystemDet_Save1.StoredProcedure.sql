USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngEODCategorySystemDet_Save1]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngEODCategorySystemDet_Save
Description			: If EOD Category System already exists then update else insert.
Authors				: Balaji M S
Date				: 05-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

DECLARE @EngEODCategorySystemDet	udt_EngEODCategorySystemDet
INSERT INTO @EngEODCategorySystemDet (	[CategorySystemDetId],[CategorySystemId],[AssetTypeCodeId],UserId)
VALUES (0,9,11,2)

EXEC uspFM_EngEODCategorySystemDet_Save1 @EngEODCategorySystemDet,@pCategorySystemId=9,@pServiceId=2,@pCategorySystemName='MRI 5050',@pEntrymode=0

SELECT * FROM EngEODCategorySystem
SELECT * FROM EngEODCategorySystemDet

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngEODCategorySystemDet_Save1]

			@EngEODCategorySystemDet	udt_EngEODCategorySystemDet	READONLY,
			@pCategorySystemId				INT,
			@pServiceId						INT,
			@pCategorySystemName			NVARCHAR(200),
			@pEntrymode						INT						
			--@pTimestamp					VARBINARY(100)	=	NULL
AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)
	DECLARE @EngEODCategorySystemDets	udt_EngEODCategorySystemDet	
	DECLARE @DuplicateCount INT
	DECLARE @MaxofId		INT

	SET @MaxofId = (SELECT MAX(CategorySystemDetId) FROM @EngEODCategorySystemDets)
	
-- Default Values


-- Execution

IF (@pEntrymode = 1 AND @MaxofId=0)
BEGIN
IF ((SELECT COUNT(*) FROM EngEODCategorySystem A INNER JOIN EngEODCategorySystemDet B ON A.CategorySystemId = B.CategorySystemId WHERE A.ServiceId = @pServiceId AND A.CategorySystemName = @pCategorySystemName ) > 0)
BEGIN
SELECT		0 As CategorySystemId,
			CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS  [timestamp],
			'Category / System Name should be unique' AS ErrorMessage
END
ELSE
BEGIN 
	
	IF((SELECT COUNT(*) FROM EngEODCategorySystemDet A INNER JOIN @EngEODCategorySystemDet B ON A.CategorySystemId = B.CategorySystemId AND A.AssetTypeCodeId = B.AssetTypeCodeId
		WHERE B.CategorySystemDetId =0) > 0)
	BEGIN
			SELECT 0 As CategorySystemId,
			CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS  [timestamp],
			'System/Asset Type Code should be unique' AS ErrorMessage
	END

ELSE 

BEGIN
			SET		@DuplicateCount=(SELECT  COUNT(*) FROM @EngEODCategorySystemDet GROUP BY CategorySystemId,AssetTypeCodeId HAVING COUNT(*) > 1)

			IF (@DuplicateCount>0)
			BEGIN

			SELECT 0 As CategorySystemId,
			CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS  [timestamp],
			'System/Asset Type Code should be unique' AS ErrorMessage

			END

			ELSE
			BEGIN
			INSERT INTO EngEODCategorySystemDet(	CategorySystemId,
													AssetTypeCodeId,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC                                                                                                        
                           )OUTPUT INSERTED.CategorySystemId INTO @Table
				SELECT	udt.CategorySystemId,
						udt.AssetTypeCodeId,
						UserId,
						GETDATE(),
						GETUTCDATE(),
						UserId,
						GETDATE(),
						GETUTCDATE()
				FROM	@EngEODCategorySystemDet udt
				WHERE ISNULL(udt.CategorySystemDetId,0)= 0

					SELECT	CategorySystemId,
							[Timestamp],
							''	ErrorMessage
				   FROM		EngEODCategorySystemDet
				   WHERE	CategorySystemId IN (SELECT ID FROM @Table)
				   END
END
END
END

ELSE IF (@pEntrymode = 1 AND @MaxofId>0)
BEGIN 
	
	IF((SELECT COUNT(*) FROM EngEODCategorySystemDet A INNER JOIN @EngEODCategorySystemDet B ON A.CategorySystemId = B.CategorySystemId AND A.AssetTypeCodeId = B.AssetTypeCodeId
		WHERE B.CategorySystemDetId =0) > 0)
	BEGIN
	SELECT 0 As CategorySystemId,
			CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS  [timestamp],
	'System/Asset Type Code should be unique' AS ErrorMessage
	END

	ELSE 
		BEGIN
			SET		@DuplicateCount=(SELECT  COUNT(*) FROM @EngEODCategorySystemDet GROUP BY CategorySystemId,AssetTypeCodeId HAVING COUNT(*) > 1)

			IF (@DuplicateCount>0)
			BEGIN

			SELECT 0 As CategorySystemId,
			CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS  [timestamp],
			'System/Asset Type Code should be unique' AS ErrorMessage

			END

			ELSE

			BEGIN
			INSERT INTO EngEODCategorySystemDet(	CategorySystemId,
													AssetTypeCodeId,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC                                                                                                        
                           )OUTPUT INSERTED.CategorySystemId INTO @Table
				SELECT	udt.CategorySystemId,
						udt.AssetTypeCodeId,
						UserId,
						GETDATE(),
						GETUTCDATE(),
						UserId,
						GETDATE(),
						GETUTCDATE()
				FROM	@EngEODCategorySystemDet udt
				WHERE ISNULL(udt.CategorySystemDetId,0)= 0

					SELECT	CategorySystemId,
							[Timestamp],
							''	ErrorMessage
				   FROM		EngEODCategorySystemDet
				   WHERE	CategorySystemId IN (SELECT ID FROM @Table)
				   
END
END
END

ELSE
BEGIN 
	
	IF((SELECT COUNT(*) FROM EngEODCategorySystemDet A INNER JOIN @EngEODCategorySystemDet B ON A.CategorySystemId = B.CategorySystemId AND A.AssetTypeCodeId = B.AssetTypeCodeId
		WHERE B.CategorySystemDetId =0) > 0)
	BEGIN
	SELECT 0 As CategorySystemId,
			CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS  [timestamp],
	'System/Asset Type Code should be unique' AS ErrorMessage
	END

	ELSE 
		BEGIN
			SET		@DuplicateCount=(SELECT  COUNT(*) FROM @EngEODCategorySystemDet GROUP BY CategorySystemId,AssetTypeCodeId HAVING COUNT(*) > 1)

			IF (@DuplicateCount>0)
			BEGIN

			SELECT 0 As CategorySystemId,
			CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS  [timestamp],
			'System/Asset Type Code should be unique' AS ErrorMessage

			END

			ELSE

			BEGIN
			INSERT INTO EngEODCategorySystemDet(	CategorySystemId,
													AssetTypeCodeId,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC                                                                                                        
                           )OUTPUT INSERTED.CategorySystemId INTO @Table
				SELECT	udt.CategorySystemId,
						udt.AssetTypeCodeId,
						UserId,
						GETDATE(),
						GETUTCDATE(),
						UserId,
						GETDATE(),
						GETUTCDATE()
				FROM	@EngEODCategorySystemDet udt
				WHERE ISNULL(udt.CategorySystemDetId,0)= 0

					SELECT	CategorySystemId,
							[Timestamp],
							''	ErrorMessage
				   FROM		EngEODCategorySystemDet
				   WHERE	CategorySystemId IN (SELECT ID FROM @Table)
				   
END
END
END
IF((SELECT COUNT(*) FROM EngEODCategorySystemDet A INNER JOIN @EngEODCategorySystemDet B ON A.CategorySystemDetId = B.CategorySystemDetId) > 0)

BEGIN
UPDATE SystemDet SET 
									SystemDet.CategorySystemId	=	udtSystemDet.CategorySystemId,
									SystemDet.AssetTypeCodeId	=	udtSystemDet.AssetTypeCodeId,
									SystemDet.ModifiedBy		=	udtSystemDet.UserId,
									SystemDet.ModifiedDate		=	GETDATE(),
									SystemDet.ModifiedDateUTC	=	GETUTCDATE()

				FROM	EngEODCategorySystemDet	AS	SystemDet 
						INNER JOIN @EngEODCategorySystemDet	AS	udtSystemDet	ON SystemDet.CategorySystemDetId	=	udtSystemDet.CategorySystemDetId
						AND	SystemDet.CategorySystemId	=	udtSystemDet.CategorySystemId	
						AND SystemDet.AssetTypeCodeId	=	udtSystemDet.AssetTypeCodeId
			   WHERE udtSystemDet.CategorySystemDetId > 0

				SELECT	CategorySystemId,
						[Timestamp],
						''	ErrorMessage
				FROM	EngEODCategorySystemDet
				WHERE	CategorySystemId IN (SELECT	udtSystemDet.CategorySystemId FROM @EngEODCategorySystemDet	AS	udtSystemDet	)
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
