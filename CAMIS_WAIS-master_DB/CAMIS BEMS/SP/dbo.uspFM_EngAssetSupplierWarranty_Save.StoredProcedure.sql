USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetSupplierWarranty_Save]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngAssetSupplierWarranty_Save
Description			: If staff already exists then update else insert.
Authors				: Dhilip V
Date				: 03-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

DECLARE @WarrantyProviderType   [dbo].[WarrantyProvideType]
INSERT INTO @WarrantyProviderType (SupplierWarrantyId,Category,ContractorId,pAssetId,UserId) VALUES (38,15,2,1,1)  
INSERT INTO @WarrantyProviderType (SupplierWarrantyId,Category,ContractorId,pAssetId,UserId) VALUES (40,15,1,1,1) 
EXECUTE [uspFM_EngAssetSupplierWarranty_Save] @WarrantyProviderType   

select * from EngAssetSupplierWarranty
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngAssetSupplierWarranty_Save]
 
	 @WarrantyProviderType  [dbo].[WarrantyProvideType]   Readonly              

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
 

--IF EXISTS (SELECT 1 FROM EngAssetSupplierWarranty WITH(NOLOCK) WHERE AssetId=(select AssetId from  @WarrantyProviderType) 
--			and Category=(select Category from  @WarrantyProviderType) )
	
	--BEGIN
	
	    UPDATE  SupplierWarr	SET	SupplierWarr.ContractorId		=	udt.ContractorId,
									SupplierWarr.ModifiedBy			=	udt.UserId,
									SupplierWarr.ModifiedDate		=	GETDATE(),
									SupplierWarr.ModifiedDateUTC	=	GETUTCDATE()
									OUTPUT INSERTED.SupplierWarrantyId INTO @Table
				FROM	EngAssetSupplierWarranty SupplierWarr 
						INNER JOIN @WarrantyProviderType udt on SupplierWarr.SupplierWarrantyId=udt.SupplierWarrantyId
				WHERE	SupplierWarr.AssetId= udt.PAssetId 
						AND ISNULL(udt.SupplierWarrantyId,0)>0
						AND SupplierWarr.Category= udt.Category 

	    
	    
	--END

--ELSE

--	BEGIN
			INSERT INTO EngAssetSupplierWarranty
						(	AssetId,
							Category,
							ContractorId,
							CreatedBy,
							CreatedDate,
							CreatedDateUTC,
							ModifiedBy,
							ModifiedDate,
							ModifiedDateUTC
						)	OUTPUT INSERTED.SupplierWarrantyId INTO @Table							
			SELECT  pAssetId,
					Category,
					ContractorId,
					UserId, 
					GETDATE(), 
					GETDATE(),
					UserId, 
					GETDATE(), 
					GETDATE()   
			FROM	@WarrantyProviderType
			WHERE   ISNULL(SupplierWarrantyId,0)=0
							
			SELECT	SupplierWarrantyId,
					[Timestamp]
			FROM	EngAssetSupplierWarranty
			WHERE	SupplierWarrantyId IN (SELECT ID FROM @Table)

		--END

	

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
