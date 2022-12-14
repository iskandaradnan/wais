USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_FMLovMst_GetById]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_FMLovMst_GetById
Description			: To Get the data from table EngStockUpdateRegisterTxn using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_FMLovMst_GetById] @pLovKey='DedIndicatorValue',@pUserId=NULL
SELECT * FROM FMLovMst
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[UspFM_FMLovMst_GetById] 
  
  --@pScreenName		NVARCHAR(100)	=	NULL,
  @pLovKey			NVARCHAR(100)	=	NULL,
  @pUserId			INT	=	NULL
  --@pPageIndex		INT,
  --@pPageSize		INT	

AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE	  @TotalRecords		INT
	DECLARE   @pTotalPage		NUMERIC(24,2)
	DECLARE   @pTotalPageCalc	NUMERIC(24,2)


	--SELECT	@TotalRecords	=	COUNT(*)
	--FROM	FMLovMst											AS Lov				WITH(NOLOCK)
	--WHERE	Lov.LovKey = @pLovKey 
	--		--AND Lov.ScreenName = @pScreenName 

	--SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))

	--SET @pTotalPageCalc = CEILING(@pTotalPage)


    SELECT	Lov.LovId											AS LovId,
			Lov.ModuleName										AS ModuleName,
			Lov.ScreenName										AS ScreenName,
			Lov.FieldName										AS FieldName,
			Lov.LovKey											AS LovKey,
			Lov.FieldCode										AS FieldCode,
			Lov.FieldValue										AS FieldValue,
			Lov.Remarks											AS Remarks,
			Lov.ParentId										AS ParentId,
			Lov.SortNo											AS SortNo,
			Lov.Active											AS Active,
			Lov.BuiltIn											AS BuiltIn,
			Lov.IsDefault										AS IsDefault,
			Lov.LovType                                         As LovType,
			Lov.Timestamp										AS [Timestamp]
			--@TotalRecords										AS TotalRecords,
			--@pTotalPageCalc										AS TotalPageCalc
	FROM	FMLovMst										AS Lov				WITH(NOLOCK)
	WHERE	Lov.LovKey = @pLovKey
			--AND Lov.ScreenName = @pScreenName
	--ORDER BY Lov.SortNo ASC
	--OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY
UNION
    SELECT	LovId,
			ModuleName,
			ScreenName,
			FieldName,
			LovKey,
			FieldCode,
			FieldValue,
			Remarks,
			ParentId,
			SortNo,
			Active,
			BuiltIn,
			IsDefault,
			1,
			[Timestamp]
			--@TotalRecords										AS TotalRecords,
			--@pTotalPageCalc										AS TotalPageCalc
	FROM	[V_FMLovMst_MetaData]										AS Lov				WITH(NOLOCK)
	WHERE	LovKey = @pLovKey
			--AND Lov.ScreenName = @pScreenName
	--ORDER BY SortNo ASC

END TRY

BEGIN CATCH

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
