USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngFacilitiesWorkshopTxn_Save]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngFacilitiesWorkshopTxn_Save
Description			: If Facility Work Shop details already exists then update else insert.
Authors				: Balaji M S
Date				: 09-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

DECLARE @EngFacilitiesWorkshopTxnDet		[dbo].[udt_EngFacilitiesWorkshopTxnDet]
INSERT INTO @EngFacilitiesWorkshopTxnDet (FacilitiesWorkshopDetId,FacilitiesWorkshopid,CustomerId,FacilityId,AssetId,[Description],Manufacturer,Model,SerialNo,CalibrationDueDate,CalibrationDueDateUTC,
Location,Quantity,SizeArea,UserId) 
VALUES (null,4,1,1,2,'dsgvfg','wergerger','wegergrg','erwgerwgerg','2018-04-09 20:04:04.457','2018-04-09 20:04:04.457',69,110,456,2)  
EXECUTE [uspFM_EngFacilitiesWorkshopTxn_Save]  @EngFacilitiesWorkshopTxnDet, 
@pFacilitiesWorkshopId=15,@pUserId=2,@CustomerId=1,@FacilityId=1,@ServiceId=2,@Year=2018,@FacilityType=101,@Category=104

select * from EngFacilitiesWorkshopTxn
select * from EngFacilitiesWorkshopTxnDet

DELETE FROM EngFacilitiesWorkshopTxn

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngFacilitiesWorkshopTxn_Save]
		
		@EngFacilitiesWorkshopTxnDet	[dbo].[udt_EngFacilitiesWorkshopTxnDet]   READONLY,
		@pFacilitiesWorkshopId			INT=null,
		@pUserId						INT,
		@CustomerId						INT,
		@FacilityId						INT,
		@ServiceId						INT,
		@Year							INT,
		@FacilityType					INT,
		@Category						INT =	NULL

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
	DECLARE @ErrorMsg NVARCHAR(1000)
	DECLARE @ComboineErrorMsg NVARCHAR(1000)
	DECLARE @FacilityTypeValue NVARCHAR(1000)
	DECLARE @CategoryValue NVARCHAR(1000)
	DECLARE @DuplicateCountinType INT
	DECLARE @DuplicateCountinTable INT
IF(@Category=0)
SET @Category=NULL

--------------------------------------------------------INSERT STATEMENT ------------------------------------------------------------------

--//1.EngFacilitiesWorkshopTxn

	SET @DuplicateCountinType = (SELECT top 1 COUNT(*) FROM @EngFacilitiesWorkshopTxnDet GROUP BY AssetId HAVING COUNT(*) > 1 AND AssetId IS NOT NULL) 
	SET @DuplicateCountinTable = (SELECT  COUNT(*) FROM @EngFacilitiesWorkshopTxnDet A INNER JOIN  EngFacilitiesWorkshopTxnDet B 
	ON A.FacilitiesWorkshopId = B.FacilitiesWorkshopId AND A.AssetId = B.AssetId  AND A.AssetId IS NOT NULL AND A.FacilitiesWorkshopDetId =0) 

	IF (@DuplicateCountinType>1 OR @DuplicateCountinTable>0)
			BEGIN
			select 0 AS FacilitiesWorkshopId, 'Asset No Should be Unique' AS  Display, CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS  [timestamp]
			RETURN
			END

IF(@pFacilitiesWorkshopId = NULL OR @pFacilitiesWorkshopId =0)

BEGIN
			IF((SELECT COUNT(*) FROM EngFacilitiesWorkshopTxn WHERE FacilityId = @FacilityId AND Year =@Year AND FacilityType = @FacilityType AND ISNULL(Category,'') = ISNULL(@Category,''))>0)
			BEGIN


			SET @FacilityTypeValue = (SELECT FieldValue FROM FMLovMst WHERE LovId = @FacilityType)
			SET @CategoryValue = (SELECT FieldValue FROM FMLovMst WHERE LovId = @Category)
			SET @ErrorMsg = cast(@Year as nvarchar(100)) + '-' + @FacilityTypeValue + '-' + ISNULL(@CategoryValue,'')
			SET @ComboineErrorMsg = @ErrorMsg +' '+'Combination Exists'
			CREATE TABLE #DisplayFunction(Display NVARCHAR(100), primaryid int null, timestampvalue timestamp --,
					--[Timestamp] timestamp null
					)

			INSERT INTO #DisplayFunction (primaryid, Display )
			VALUES
			(0, @ComboineErrorMsg)
			select 0  FacilitiesWorkshopId,  Display, timestampvalue [Timestamp] from #DisplayFunction
	drop table  #DisplayFunction

			END


			else 
			begin

			INSERT INTO EngFacilitiesWorkshopTxn
						(	
							CustomerId,
							FacilityId,
							ServiceId,
							Year,
							FacilityType,
							Category,
							CreatedBy,
							CreatedDate,
							CreatedDateUTC,
							ModifiedBy,
							ModifiedDate,
							ModifiedDateUTC
						)	OUTPUT INSERTED.FacilitiesWorkshopId INTO @Table							

			VALUES			
						(	
							@CustomerId,
							@FacilityId,
							@ServiceId,
							@Year,
							@FacilityType,
							@Category,
							@pUserId,			
							GETDATE(), 
							GETDATE(),
							@pUserId, 
							GETDATE(), 
							GETDATE()   
						)			
			SELECT	FacilitiesWorkshopId,
					[Timestamp], 
					''  Display					
			FROM	EngFacilitiesWorkshopTxn
			WHERE	FacilitiesWorkshopId IN (SELECT ID FROM @Table)


		     SET @PrimaryKeyId  = (SELECT ID FROM @Table)
			 

--//2.EngFacilitiesWorkshopTxnDet

		INSERT INTO EngFacilitiesWorkshopTxnDet
						(
							FacilitiesWorkshopId,
							CustomerId,
							FacilityId,
							AssetId,
							Description,
							Manufacturer,
							Model,
							SerialNo,
							CalibrationDueDate,
							CalibrationDueDateUTC,
							Location,
							Quantity,
							SizeArea,
							CreatedBy,
							CreatedDate,
							CreatedDateUTC,
							ModifiedBy,
							ModifiedDate,
							ModifiedDateUTC

						)

			SELECT
							@PrimaryKeyId,
							CustomerId,			
							FacilityId,			
							AssetId,				
							[Description],
							Manufacturer,			
							Model,					
							SerialNo,				
							CalibrationDueDate,	
							CalibrationDueDateUTC,	
							Location,				
							Quantity,				
							SizeArea,				
							UserId,				
							GETDATE(),			
							GETUTCDATE(),
							UserId,			
							GETDATE(),			
							GETUTCDATE()
			FROM	@EngFacilitiesWorkshopTxnDet
			WHERE   ISNULL(FacilitiesWorkshopDetId,0)=0			
			end 

end

ELSE 
------------------------------------------------------------------ UPDATE STATEMENT ----------------------------------------------------


		
			--PRINT('Record Already Exists')

BEGIN
		
		
--1.EngFacilitiesWorkshopTxn UPDATE
				
			
			
	    UPDATE  FacilitiesWorkshop	SET		
								FacilitiesWorkshop.CustomerId			= @CustomerId,	
								FacilitiesWorkshop.FacilityId			= @FacilityId,
								FacilitiesWorkshop.ServiceId			= @ServiceId,
								FacilitiesWorkshop.Year					= @Year,
								FacilitiesWorkshop.FacilityType			= @FacilityType,
								FacilitiesWorkshop.Category				= @Category,
								FacilitiesWorkshop.ModifiedBy			= @pUserId,
								FacilitiesWorkshop.ModifiedDate			= GETDATE(),
								FacilitiesWorkshop.ModifiedDateUTC		= GETUTCDATE()
				
								OUTPUT INSERTED.FacilitiesWorkshopId INTO @Table
				FROM	EngFacilitiesWorkshopTxn						AS FacilitiesWorkshop
				WHERE	FacilitiesWorkshop.FacilitiesWorkshopId= @pFacilitiesWorkshopId 
						AND ISNULL(@pFacilitiesWorkshopId,0)>0
		  SET @PrimaryKeyId  = (SELECT ID FROM @Table) 
--2.EngFacilitiesWorkshopTxnDet UPDATE

	    UPDATE  FacilitiesWorkshopTxnDet	SET	

									FacilitiesWorkshopTxnDet.CustomerId					= FacilitiesWorkshopDetudt.CustomerId,				
									FacilitiesWorkshopTxnDet.FacilityId					= FacilitiesWorkshopDetudt.FacilityId,				
									FacilitiesWorkshopTxnDet.AssetId					= FacilitiesWorkshopDetudt.AssetId,				
									FacilitiesWorkshopTxnDet.Description				= FacilitiesWorkshopDetudt.Description,			
									FacilitiesWorkshopTxnDet.Manufacturer				= FacilitiesWorkshopDetudt.Manufacturer,			
									FacilitiesWorkshopTxnDet.Model						= FacilitiesWorkshopDetudt.Model,					
									FacilitiesWorkshopTxnDet.SerialNo					= FacilitiesWorkshopDetudt.SerialNo,				
									FacilitiesWorkshopTxnDet.CalibrationDueDate			= FacilitiesWorkshopDetudt.CalibrationDueDate,		
									FacilitiesWorkshopTxnDet.CalibrationDueDateUTC		= FacilitiesWorkshopDetudt.CalibrationDueDateUTC,	
									FacilitiesWorkshopTxnDet.Location					= FacilitiesWorkshopDetudt.Location,				
									FacilitiesWorkshopTxnDet.Quantity					= FacilitiesWorkshopDetudt.Quantity,				
									FacilitiesWorkshopTxnDet.SizeArea					= FacilitiesWorkshopDetudt.SizeArea,				
									FacilitiesWorkshopTxnDet.ModifiedBy					= FacilitiesWorkshopDetudt.UserId,
									FacilitiesWorkshopTxnDet.ModifiedDate				= GETDATE(),
									FacilitiesWorkshopTxnDet.ModifiedDateUTC			= GETUTCDATE()

			FROM	EngFacilitiesWorkshopTxnDet								AS FacilitiesWorkshopTxnDet 
				INNER JOIN @EngFacilitiesWorkshopTxnDet					AS FacilitiesWorkshopDetudt on FacilitiesWorkshopTxnDet.FacilitiesWorkshopDetId=FacilitiesWorkshopDetudt.FacilitiesWorkshopDetId
		WHERE	ISNULL(FacilitiesWorkshopDetudt.FacilitiesWorkshopDetId,0)>0
	    


--//2.EngFacilitiesWorkshopTxnDet

		

		INSERT INTO EngFacilitiesWorkshopTxnDet
						(
							FacilitiesWorkshopId,
							CustomerId,
							FacilityId,
							AssetId,
							Description,
							Manufacturer,
							Model,
							SerialNo,
							CalibrationDueDate,
							CalibrationDueDateUTC,
							Location,
							Quantity,
							SizeArea,
							CreatedBy,
							CreatedDate,
							CreatedDateUTC,
							ModifiedBy,
							ModifiedDate,
							ModifiedDateUTC

						)

			SELECT
							@pFacilitiesWorkshopId,
							CustomerId,			
							FacilityId,			
							AssetId,				
							[Description],
							Manufacturer,			
							Model,					
							SerialNo,				
							CalibrationDueDate,	
							CalibrationDueDateUTC,	
							Location,				
							Quantity,				
							SizeArea,				
							UserId,				
							GETDATE(),			
							GETUTCDATE(),
							UserId,			
							GETDATE(),			
							GETUTCDATE()
			FROM	@EngFacilitiesWorkshopTxnDet		AS EngFacilitiesWorkshopTxnDetType
			WHERE   ISNULL(EngFacilitiesWorkshopTxnDetType.FacilitiesWorkshopDetId,0)=0
			
			
			--drop table  #DisplayFunction

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
---THROW;
END CATCH



-----------------------------------------------------------------------------------UDT CREATION ---------------------------------------------------

--drop proc [uspFM_EngFacilitiesWorkshopTxn_Save]
--drop type udt_EngFacilitiesWorkshopTxnDet


--CREATE TYPE [dbo].[udt_EngFacilitiesWorkshopTxnDet] AS TABLE
--(
--FacilitiesWorkshopDetId				INT,
--FacilitiesWorkshopId					INT,
--CustomerId							INT,
--FacilityId							INT,
--AssetId								INT,
--[Description]						NVARCHAR(510),
--Manufacturer						NVARCHAR(1000),
--Model								NVARCHAR(1000),
--SerialNo							NVARCHAR(1000),
--CalibrationDueDate					DATETIME,
--CalibrationDueDateUTC				DATETIME,
--Location							INT,
--Quantity							INT,
--SizeArea							NUMERIC,
--UserId								INT

--)
GO
