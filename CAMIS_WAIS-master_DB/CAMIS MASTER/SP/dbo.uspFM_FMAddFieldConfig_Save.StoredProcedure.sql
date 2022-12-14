USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_FMAddFieldConfig_Save]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_FMAddFieldConfig_Save
Description			: Insert/update the Attachment
Authors				: Dhilip V
Date				: 10-July-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

DECLARE 		@pFMAddFieldConfig			[dbo].[udt_FMAddFieldConfig]
 INSERT INTO @pFMAddFieldConfig(AddFieldConfigId,	CustomerId,ScreenNameLovId,FieldTypeLovId,	FieldName,DropDownValues,RequiredLovId,PatternLovId,MaxLength,USERID)
						VALUES (0,1,1,1,1,1,1,1,1,1)
EXEC [uspFM_FMAddFieldConfig_Save] @pFMAddFieldConfig=@pFMAddFieldConfig

SELECT * FROM FMAddFieldConfig

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/


CREATE PROCEDURE  [dbo].[uspFM_FMAddFieldConfig_Save]
		@pFMAddFieldConfig			[dbo].[udt_FMAddFieldConfig]	READONLY,
		@pErrorMessage nvarchar(500) OUTPUT
AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)	
	DECLARE	@PrimaryKeyId	 INT
	DECLARE @FieldName NVARCHAR(100) ='Field'
	DECLARE @FieldNo INT ='0'

	DECLARE @CustormerId INT 
	DECLARE @ScreenNameLovId INT

--------------------------------------------------------INSERT STATEMENT ------------------------------------------------------------------

--//1.EngAssetTypeCode


	--IF((SELECT COUNT(*) FROM @pFMAddFieldConfig WHERE AddFieldConfigId=0)>0)
		
	--	BEGIN

	--IF EXISTS (	SELECT 1 
	--			FROM @pFMAddFieldConfig WHERE AddFieldConfigId=0
	--			GROUP BY NAME HAVING COUNT(NAME)>1
	--			)
				IF EXISTS (	SELECT 1 
					FROM @pFMAddFieldConfig WHERE IsDeleted = 0
					GROUP BY NAME HAVING COUNT(NAME)>1
				)
	BEGIN
		SET @pErrorMessage ='Name should be unique'
	END
	--ELSE IF EXISTS (	SELECT 1 
	--			FROM FMAddFieldConfig WITH(NOLOCK) 
	--			WHERE	Name IN	(SELECT Name FROM  @pFMAddFieldConfig WHERE AddFieldConfigId=0)
	--					AND	CustomerId IN (SELECT DISTINCT CustomerId FROM @pFMAddFieldConfig)
	--					AND ScreenNameLovId IN (SELECT DISTINCT ScreenNameLovId FROM @pFMAddFieldConfig)
	--			)
	--BEGIN
	--	SET @pErrorMessage ='Name should be unique'
	--END

	ELSE
	BEGIN

	SELECT TOP 1 @CustormerId = CustomerId FROM @pFMAddFieldConfig
	SELECT TOP 1 @ScreenNameLovId = ScreenNameLovId FROM @pFMAddFieldConfig

		SELECT @FieldNo = ISNULL(REPLACE(FieldName,@FieldName,''),0) FROM FMAddFieldConfig 
		WHERE	CustomerId IN (SELECT DISTINCT CustomerId FROM @pFMAddFieldConfig)
				AND ScreenNameLovId IN (SELECT DISTINCT ScreenNameLovId FROM @pFMAddFieldConfig)

			DELETE FROM FMAddFieldConfig 
			WHERE AddFieldConfigId IN (SELECT AddFieldConfigId FROM @pFMAddFieldConfig WHERE IsDeleted = 1)

			-----------------------------------------------------------------------------------------------------------------------

					DECLARE  @FieldNames TABLE (FieldName VARCHAR(100));
					DECLARE @FieldNames1 TABLE  (Id INT IDENTITY(1,1), FieldName VARCHAR(100))

					DECLARE @UDTFieldNames TABLE (
						Id INT IDENTITY(1,1),
						[AddFieldConfigId] [int] NULL,
						[CustomerId] [int] NULL,
						[ScreenNameLovId] [int] NULL,
						[FieldTypeLovId] [int] NULL,
						[FieldName] [nvarchar](100) NULL,
						[Name] [nvarchar](100) NULL,
						[DropDownValues] [nvarchar](1000) NULL,
						[RequiredLovId] [int] NULL,
						[PatternLovId] [int] NULL,
						[MaxLength] [int] NULL,
						[UserId] [int] NULL,
						[IsDeleted] [bit] NULL)

						INSERT INTO @UDTFieldNames(	
						AddFieldConfigId,
									CustomerId,
									ScreenNameLovId,
									FieldTypeLovId,
									FieldName,
									Name,
									DropDownValues,
									RequiredLovId,
									PatternLovId,
									MaxLength,
									UserId
								)	
							SELECT	
									AddFieldConfigId,
									CustomerId,
									ScreenNameLovId,
									FieldTypeLovId,
									FieldName,
									Name,
									DropDownValues,
									RequiredLovId,
									PatternLovId,
									MaxLength,
									UserId
							FROM	@pFMAddFieldConfig	udtConfig
							WHERE	ISNULL(udtConfig.AddFieldConfigId,0)=0

					INSERT INTO @FieldNames (FieldName) VALUES ('Field1'), ('Field2'), ('Field3'), ('Field4'), ('Field5'), ('Field6'), ('Field7'), ('Field8'), ('Field9'), ('Field10')
					
					INSERT INTO @FieldNames1 (FieldName)
					SELECT FieldName FROM @FieldNames WHERE FieldName NOT IN 
					(select FieldName from FMAddFieldConfig where CustomerId = @CustormerId and ScreenNameLovId = @ScreenNameLovId);

					UPDATE A 
					SET A.FieldName = B.FieldName
					FROM
					@UDTFieldNames A
					JOIN @FieldNames1 B ON A.Id = B.Id
					
			-------------------------------------------------------------------------------------------------------------------------

			UPDATE A 
			SET A.FieldTypeLovId = B.FieldTypeLovId,
				--A.FieldName = B.FieldName,
				A.Name = B.Name,
				A.DropDownValues = B.DropDownValues,
				A.RequiredLovId = B.RequiredLovId,
				A.PatternLovId = B.PatternLovId,
				A.MaxLength = B.MaxLength,
				A.ModifiedBy = UserId,
				A.ModifiedDate = GETDATE(),
				ModifiedDateUTC = GETUTCDATE()
			FROM
			FMAddFieldConfig A INNER JOIN @pFMAddFieldConfig B
			ON A.AddFieldConfigId = B.AddFieldConfigId AND B.IsDeleted = 0
			
			--CREATE TABLE #UDTFieldNames (AddFieldConfigId INT, FieldName VARCHAR(100))
			--INSERT INTO #UDTFieldNames (AddFieldConfigId, FieldName) SELECT AddFieldConfigId, ''
			--FROM @pFMAddFieldConfig	udtConfig WHERE ISNULL(udtConfig.AddFieldConfigId,0)=0

			  INSERT INTO FMAddFieldConfig(	CustomerId,
											ScreenNameLovId,
											FieldTypeLovId,
											FieldName,
											Name,
											DropDownValues,
											RequiredLovId,
											PatternLovId,
											MaxLength,
											CreatedBy,
											CreatedDate,
											CreatedDateUTC,
											ModifiedBy,
											ModifiedDate,
											ModifiedDateUTC
								)	OUTPUT INSERTED.AddFieldConfigId INTO @Table
							SELECT	CustomerId,
									ScreenNameLovId,
									FieldTypeLovId,
									FieldName,
									Name,
									DropDownValues,
									RequiredLovId,
									PatternLovId,
									MaxLength,
									UserId,
									GETDATE(),
									GETUTCDATE(),
									UserId,
									GETDATE(),
									GETUTCDATE()
							FROM	@UDTFieldNames
							--	udtConfig
							--WHERE	ISNULL(udtConfig.AddFieldConfigId,0)=0



				SELECT	AddFieldConfigId,
						FieldName,
						CustomerId,
						ScreenNameLovId,
						FieldTypeLovId,
						Name,
						DropDownValues,
						RequiredLovId,
						PatternLovId,
						MaxLength,
						'' AS	ErrorMessage ,
						dbo.[udf_AdditionalFieldsCheck](CustomerId, ScreenNameLovId, FieldName, FieldTypeLovId) AS IsUsed
				FROM	FMAddFieldConfig
				WHERE	CustomerId IN (SELECT DISTINCT CustomerId FROM @pFMAddFieldConfig)
						AND ScreenNameLovId IN (SELECT DISTINCT ScreenNameLovId FROM @pFMAddFieldConfig)
				ORDER BY FieldName ASC

	END

	IF @mTRANSCOUNT = 0
        BEGIN
            COMMIT
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
