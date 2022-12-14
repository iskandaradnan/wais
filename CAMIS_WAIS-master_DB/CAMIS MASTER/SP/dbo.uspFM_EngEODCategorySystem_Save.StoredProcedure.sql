USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngEODCategorySystem_Save]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngEODCategorySystem_Save
Description			: If EOD Category System details already exists then update else insert.
Authors				: Balaji M S
Date				: 11-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngEODCategorySystem_Save @pCategorySystemId='0',@pUserId=2,@ServiceId=2,@CategorySystemName='MRI',@Remarks='FHFRHFJYJ'
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngEODCategorySystem_Save]
	
		@pCategorySystemId						INT,
		@pUserId								INT,
		@ServiceId								INT,
		@CategorySystemName						NVARCHAR(300),
		@Remarks								NVARCHAR(1000)      =NULL,
		@Active									INT					=1,
		@BuiltIn								INT					=1
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
 
-------------------------------------------------------------UPDATE STATEMENT-------------------------------------------------------------

--//1.EngWarrantyManagementTxn

	IF EXISTS (SELECT 1 FROM EngEODCategorySystem WITH(NOLOCK) WHERE CategorySystemId=@pCategorySystemId)
		BEGIN
			UPDATE CategorySystem SET
							CategorySystem.ServiceId					=@ServiceId,
							CategorySystem.CategorySystemName			=@CategorySystemName,
							CategorySystem.Remarks						=@Remarks,
							CategorySystem.ModifiedBy					=@pUserId,
							CategorySystem.ModifiedDate					=GETUTCDATE(),
							CategorySystem.ModifiedDateUTC				=GETDATE()
							
					FROM	EngEODCategorySystem					AS 			CategorySystem				
					WHERE	CategorySystem.CategorySystemId=@pCategorySystemId
							AND ISNULL(@pCategorySystemId,0)>0
		SELECT	CategorySystemId,
				[Timestamp],
				'' AS ErrorMessage
		FROM	EngEODCategorySystem WITH(NOLOCK)
		WHERE	CategorySystemId =@pCategorySystemId
	END
	ELSE
		


------------------------------------------------------------INSERT STATEMENT-------------------------------------------------------------

--//1.EngWarrantyManagementTxn
	BEGIN

	IF EXISTS (SELECT 1 FROM EngEODCategorySystem WITH(NOLOCK) WHERE CategorySystemName = @CategorySystemName)
	BEGIN
	SELECT 0 AS CategorySystemId,
	CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS  [timestamp],
	'Category System Name Should be Unique' AS ErrorMessage
	END

	ELSE
	BEGIN
			INSERT INTO EngEODCategorySystem(
								ServiceId,
								CategorySystemName,
								Remarks,
								CreatedBy,
								CreatedDate,
								CreatedDateUTC,
								ModifiedBy,
								ModifiedDate,
								ModifiedDateUTC,
								Active,
								BuiltIn

							
							)	OUTPUT INSERTED.CategorySystemId INTO @Table
							VALUES
							(
							 @ServiceId,			
							 @CategorySystemName,		
							 @Remarks,			
							 @pUserId,
							 GETDATE(),
							 GETUTCDATE(),
							 @pUserId,
							 GETDATE(),
							 GETUTCDATE(),
							 @Active,
							 @BuiltIn
							)

		SELECT	CategorySystemId,
				[Timestamp],
				'' AS ErrorMessage
		FROM	EngEODCategorySystem WITH(NOLOCK)
		WHERE	CategorySystemId IN (SELECT ID FROM @Table)
		
		END
		END
		

	

	--IF @mTRANSCOUNT = 0
 --       BEGIN
 --           COMMIT 
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
		   )

END CATCH
GO
