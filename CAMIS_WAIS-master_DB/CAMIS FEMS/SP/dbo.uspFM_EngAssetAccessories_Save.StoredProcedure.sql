USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetAccessories_Save]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngAssetAccessories_Save
Description			: If Penalty already exists then update else insert.
Authors				: Balaji M S
Date				: 05-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
DECLARE @EngAssetAccessories AS [dbo].[udt_EngAssetAccessories]
 insert into  @EngAssetAccessories(AccessoriesId,AssetId,AccessoriesDescription,SerialNo,Manufacturer,Model,UserId,DocumentTitle,DocumentExtension,FileName,DocumentRemarks,FilePath,DocumentGuid) VALUES
(0,1,'kjlfofmkfj','pkjiowpefk8097347',2,1,1,'DFSG','SGSGHSH','FILE','FBHDB','DSFGSRHGD',NEWID()),
(125,1,'kjlfofmkfj','pkjiowpefk8097347',2,1,1,'DFSG','SGSGHSH','FILE','FBHDB','DSFGSRHGD',NEWID())
EXEC [uspFM_EngAssetAccessories_Save] @EngAssetAccessories

SELECT * FROM EngAssetAccessories

DECLARE @EngAssetAccessories AS [dbo].[udt_EngAssetAccessories]
 insert into  @EngAssetAccessories(AccessoriesId,AssetId,AccessoriesDescription,SerialNo,Manufacturer,Model,UserId) VALUES
(0,1,'kjlfofmkfj','pkjiowpefk8097347',2,1,1),
(2,1,'1231654','pkjiowpefk8097347',2,1,1)
EXEC [uspFM_EngAssetAccessories_Save] @EngAssetAccessories
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngAssetAccessories_Save]

			@EngAssetAccessories			AS [dbo].[udt_EngAssetAccessories] READONLY
AS                                              

BEGIN TRY

	--DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	--BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)

-- Default Values


-- Execution	
				DECLARE @DuplicateCount INT
				SET	@DuplicateCount=(SELECT  COUNT(*) FROM @EngAssetAccessories GROUP BY AssetId,DocumentTitle HAVING COUNT(*) > 1 AND DocumentTitle IS NOT NULL )

				  IF(@DuplicateCount>1)
				  BEGIN
					SELECT	0   AS			AssetId,
							CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS  [timestamp],
					'File Name Should be Unique'			AS			ErrorMessage
				  END

				ELSE IF EXISTS (SELECT 1 FROM EngAssetAccessories A INNER JOIN @EngAssetAccessories B ON A.AssetId = B.AssetId AND A.DocumentTitle = B.DocumentTitle 
				WHERE B.DocumentTitle IS NOT NULL AND B.AccessoriesId =0 )
				  BEGIN

					SELECT	0   AS			AssetId,
							CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS  [timestamp],
					'File Name Should be Unique'			AS			ErrorMessage

				  END

				  ELSE

				  BEGIN

				  INSERT INTO EngAssetAccessories(		
													AssetId,
													AccessoriesDescription,
													SerialNo,
													Manufacturer,
													Model,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC,
													DocumentTitle,		
													DocumentExtension,
													FileName,	
													DocumentRemarks,
													FilePath,	
													DocumentGuid		
                                                   )OUTPUT INSERTED.AccessoriesId INTO @Table

				   SELECT							
													AssetId,
													AccessoriesDescription,
													SerialNo,
													Manufacturer,
													Model,
													UserId,		
													GETDATE(),
													GETUTCDATE(),
													UserId,
													GETDATE(),
													GETUTCDATE(),
													DocumentTitle,		
													DocumentExtension,
													FileName,	
													DocumentRemarks,
													FilePath,	
													DocumentGuid		
				   FROM     @EngAssetAccessories		AS AssetAccessories
				   WHERE	ISNULL(AssetAccessories.AccessoriesId,0)=0 


				   UPDATE AssetAccessories SET
									AssetAccessories.AssetId					= AssetAccessoriesType.AssetId,
									AssetAccessories.AccessoriesDescription		= AssetAccessoriesType.AccessoriesDescription,
									AssetAccessories.SerialNo					= AssetAccessoriesType.SerialNo,
									AssetAccessories.Manufacturer				= AssetAccessoriesType.Manufacturer,
									AssetAccessories.Model						= AssetAccessoriesType.Model,
									AssetAccessories.ModifiedBy					= UserId,
									AssetAccessories.ModifiedDate				= GETDATE(),
									AssetAccessories.ModifiedDateUTC			= GETUTCDATE(),
									AssetAccessories.DocumentTitle				= AssetAccessoriesType.DocumentTitle,
									AssetAccessories.DocumentExtension			= AssetAccessoriesType.DocumentExtension,
									AssetAccessories.FileName					= AssetAccessoriesType.FileName,
									AssetAccessories.DocumentRemarks			= AssetAccessoriesType.DocumentRemarks,
									AssetAccessories.FilePath					= AssetAccessoriesType.FilePath,
									AssetAccessories.DocumentGuid				= AssetAccessoriesType.DocumentGuid	
									OUTPUT INSERTED.AccessoriesId INTO @Table
					FROM	EngAssetAccessories								AS AssetAccessories 
							INNER JOIN @EngAssetAccessories					AS AssetAccessoriesType ON AssetAccessories.AccessoriesId	=	AssetAccessoriesType.AccessoriesId
					WHERE ISNULL(AssetAccessoriesType.AccessoriesId,0)>0

					SELECT				AssetId,
										[Timestamp],
					''		AS			ErrorMessage
				   FROM					EngAssetAccessories
				   WHERE				AccessoriesId IN (SELECT ID FROM @Table)
	
	END
	--IF @mTRANSCOUNT = 0
 --       BEGIN
 --           COMMIT TRANSACTION
 --       END   


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

-------------------------------------------------------------------UDT CREATION----------------------------------------------------------

--drop proc [uspFM_EngAssetAccessories_Save]
--DROP TYPE [udt_EngAssetAccessories]

--CREATE TYPE [dbo].[udt_EngAssetAccessories] AS TABLE(
--	[AccessoriesId] [int] NULL,
--	[AssetId] [int] NULL,
--	[AccessoriesDescription] [nvarchar](510) NULL,
--	[SerialNo] [nvarchar](100) NULL,
--	[Manufacturer] [int] NULL,
--	[Model] [int] NULL,
--	[UserId] [int] NULL,
--	[DocumentTitle] [nvarchar](300) NULL,	
--	[DocumentExtension] [nvarchar](255) NULL,
--	[FileName] [nvarchar](255) NULL,
--	[DocumentRemarks] [nvarchar](500) NULL,
--	[FilePath] [nvarchar](500) NULL,
--	[DocumentGuid] [nvarchar](500) NULL
--)
GO
