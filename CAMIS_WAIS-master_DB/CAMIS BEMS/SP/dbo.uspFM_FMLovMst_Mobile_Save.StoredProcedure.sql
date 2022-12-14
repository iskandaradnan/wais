USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_FMLovMst_Mobile_Save]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_FMLovMst_Save
Description			: If Lov already exists then update else insert.
Authors				: Balaji M S
Date				: 09-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

declare @FMLovMst					DBO.[udt_FMLovMst]
insert into @FMLovMst(LovId,ModuleName,ScreenName,FieldName,LovKey,FieldCode,FieldValue,Remarks,ParentId,SortNo,IsDefault,IsEditable,Active,BuiltIn,UserId)values
(0,'AAA','AAA','AAA','AAA','1','Active','Acitve',1,0,1,1,1,1,2),
(0,'AAA','AAA','AAA','AAA','2','InActive','InAcitve',1,0,1,1,1,1,2)

EXECUTE [uspFM_FMLovMst_Mobile_Save]  @FMLovMst

declare @FMLovMst					DBO.[udt_FMLovMst]
insert into @FMLovMst(LovId,ModuleName,ScreenName,FieldName,LovKey,FieldCode,FieldValue,Remarks,ParentId,SortNo,IsDefault,IsEditable,Active,BuiltIn,UserId)values
(240,'AAA','AAA','AAA','AAA','1','Active','InAcitve',1,0,1,1,1,1,2),
(241,'AAA','AAA','AAA','AAA','2','InActive','Acitve',1,0,1,1,1,1,2)

EXECUTE [uspFM_FMLovMst_Mobile_Save]  @FMLovMst

select * from EngStockAdjustmentTxn
select * from EngStockAdjustmentTxndET

rollback
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_FMLovMst_Mobile_Save]
		@FMLovMst					DBO.[udt_FMLovMst_Mobile] READONLY

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

	DECLARE @CNT INT=0 
	DECLARE @DuplicateCount INT
	SET		@DuplicateCount=(SELECT  COUNT(*) FROM @FMLovMst GROUP BY SortNo HAVING COUNT(*) > 1)

	IF(@DuplicateCount>0)
	BEGIN
			SELECT 
		0 as LovId,
		CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS  [timestamp],
		'Sort No Value Should be Unique' AS ErrorMessage
	END

	ELSE IF EXISTS (SELECT 1 FROM @FMLovMst WHERE SortNo =0)
	BEGIN
			SELECT 
		0 as LovId,
		CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS  [timestamp],
		'Sort No Should not be zero' AS ErrorMessage
	END

	ELSE
	BEGIN
--------------------------------------------------------INSERT STATEMENT ------------------------------------------------------------------

--//1.FMLovMst
		IF EXISTS(SELECT 1 FROM FMLovMst A INNER JOIN @FMLovMst B ON A.FieldValue = B.FieldValue AND A.LovKey = B.LovKey AND B.Lovid=0)
		BEGIN

		SELECT 
		0 as LovId,
		CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS  [timestamp],
		'Field Value Should be Unique' AS ErrorMessage


		END

		ELSE

		BEGIN

			IF EXISTS (SELECT 1 FROM @FMLovMst WHERE LovId = NULL OR LovId =0)

BEGIN
			INSERT INTO FMLovMst
						(	
							ModuleName,
							ScreenName,
							FieldName,
							LovKey,
							FieldCode,
							FieldValue,
							Remarks,
							ParentId,
							SortNo,
							IsDefault,
							IsEditable,
							CreatedBy,
							CreatedDate,
							CreatedDateUTC,
							ModifiedBy,
							ModifiedDate,
							ModifiedDateUTC,
							Active,
							BuiltIn
						)	OUTPUT INSERTED.LovId INTO @Table							

						
								
			SELECT			ModuleName,
							ScreenName,
							FieldName,
							LovKey,
							FieldCode,
							FieldValue,
							Remarks,
							ParentId,
							SortNo,
							IsDefault,
							IsEditable,
							UserId,			
							GETDATE(), 
							GETDATE(),
							UserId, 
							GETDATE(), 
							GETDATE(),
							Active,
							BuiltIn   
			FROM 	@FMLovMst where ISNULL(LovId,0)=0
					
			SELECT	LovId,
					[Timestamp],
					'' AS ErrorMessage
			FROM	FMLovMst
			WHERE	LovId IN (SELECT ID FROM @Table)


		     

END

ELSE 
------------------------------------------------------------------ UPDATE STATEMENT ----------------------------------------------------

--1.FMLovMst UPDATE

			

BEGIN

	    UPDATE  Lov	SET			Lov.ModuleName							= Lovudt.ModuleName,
								Lov.ScreenName							= Lovudt.ScreenName,
								Lov.FieldName							= Lovudt.FieldName,
								Lov.LovKey								= Lovudt.LovKey,
								Lov.FieldCode							= Lovudt.FieldCode,
								Lov.FieldValue							= Lovudt.FieldValue,
								Lov.Remarks								= Lovudt.Remarks,
								Lov.ParentId							= Lovudt.ParentId,
								Lov.SortNo								= Lovudt.SortNo,
								Lov.IsDefault							= Lovudt.IsDefault,
								Lov.IsEditable							= Lovudt.IsEditable,
								Lov.ModifiedBy							= Lovudt.UserId,
								Lov.ModifiedDate						= GETDATE(),
								Lov.ModifiedDateUTC						= GETUTCDATE()
									OUTPUT INSERTED.LovId INTO @Table
				FROM	FMLovMst							AS Lov
				INNER JOIN @FMLovMst							AS Lovudt on Lov.LovId		= Lovudt.LovId
				WHERE ISNULL(Lovudt.LovId,0)>0
		  
			SELECT	LovId,
					[Timestamp],
					'' AS ErrorMessage
			FROM	FMLovMst
			WHERE	LovId IN (SELECT ID FROM @Table)


END

END

	IF @mTRANSCOUNT = 0
        BEGIN
            COMMIT
        END
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
