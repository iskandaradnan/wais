USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetAddFields_Save]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngAssetAddFields_Save
Description			: Asset additional fields save
Authors				: Dhilip V
Date				: 13-July-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

-- Insert
EXEC uspFM_EngAssetAddFields_Save  @pAssetId=0,@pField1=null,@pField2='',@pField3='',@pField4='',@pField5='',@pField6='',@pField7='',@pField8='',@pField9='',@pField10=''

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngAssetAddFields_Save]

	@pAssetId								INT,
	@pField1								NVARCHAR(500)			=NULL,
	@pField2								NVARCHAR(500)			=NULL,
	@pField3								NVARCHAR(500)			=NULL,
	@pField4								NVARCHAR(500)			=NULL,
	@pField5								NVARCHAR(500)			=NULL,
	@pField6								NVARCHAR(500)			=NULL,
	@pField7								NVARCHAR(500)			=NULL,
	@pField8								NVARCHAR(500)			=NULL,
	@pField9								NVARCHAR(500)			=NULL,
	@pField10								NVARCHAR(500)			=NULL

AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)	

-- Default Values

-- Execution
 

	IF (ISNULL(@pAssetId,0)=0 OR @pAssetId='')

	BEGIN

				SELECT	@pAssetId	AS AssetId,
						'AssetId is Mandatory' ErrorMessage
		
	END



	ELSE


		BEGIN

			UPDATE EngAsset SET	Field1		=	@pField1,
								Field2		=	@pField2,
								Field3		=	@pField3,
								Field4		=	@pField4,
								Field5		=	@pField5,
								Field6		=	@pField6,
								Field7		=	@pField7,
								Field8		=	@pField8,
								Field9		=	@pField9,
								Field10		=	@pField10
							OUTPUT INSERTED.AssetId INTO @Table
					WHERE	AssetId=@pAssetId

		

				SELECT	AssetId,
						'' ErrorMessage
				FROM	EngAsset
				WHERE	AssetId = @pAssetId

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
		   throw;

END CATCH
GO
