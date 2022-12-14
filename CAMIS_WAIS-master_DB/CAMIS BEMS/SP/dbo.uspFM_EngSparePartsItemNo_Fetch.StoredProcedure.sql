USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngSparePartsItemNo_Fetch]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngSpareParts_Fetch
Description			: SpareParts search popup
Authors				: Dhilip V
Date				: 04-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_EngSparePartsPartNo_Fetch]  @pSparePartNo='sp',@pPageIndex=1,@pPageSize=50
EXEC [uspFM_EngSparePartsPartNo_Fetch]  @pSparePartNo=null,@pPageIndex=1,@pPageSize=5
select * from EngSpareParts
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_EngSparePartsItemNo_Fetch]                           
  @ItemCode			NVARCHAR(100) =	NULL,
  @pPageIndex			INT,
  @pPageSize			INT
AS                                              

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

	DECLARE @TotalRecords INT
-- Default Values


-- Execution

		
		SELECT		DISTINCT --SpareParts.SparePartsId,
					--SpareParts.PartNo,
					--SpareParts.PartDescription,
					ItemMaster.ItemId,
					ItemMaster.ItemNo,
					ItemMaster.ItemDescription
					--SpareParts.PartSourceId,
					--LovPartSource.FieldValue AS PartSource,
					
					--SpareParts.LifeSpanOptionId,
					--LifeSpanOption.FieldValue as LifeSpanOptionValue,
					--SpareParts.Location					AS LocationLovId,
					--LovLocation.FieldValue				AS Location
					----ISNULL(SpareParts.IsExpirydate,0) AS IsExpirydate
		INTO #ResSet
		FROM		FMItemMaster ItemMaster WITH(NOLOCK)
					--INNER JOIN EngSpareParts SpareParts							WITH(NOLOCK)	ON	ItemMaster.ItemId			=	SpareParts.ItemId
					
					--LEFT JOIN FMLovMst LovPartSource							WITH(NOLOCK)	ON	SpareParts.PartSourceId		=	LovPartSource.LovId
					--LEFT JOIN FMLovMst LifeSpanOption							WITH(NOLOCK)	ON	SpareParts.LifeSpanOptionId	=	LifeSpanOption.LovId
					--LEFT JOIN	FMLovMst					AS	LovLocation		WITH(NOLOCK)	ON SpareParts.Location			=	LovLocation.LovId
		WHERE		ItemMaster.Active =1
					--AND SpareParts.Status=1
					AND ((ISNULL(@ItemCode,'') = '' )	OR (ISNULL(@ItemCode,'') <> '' AND (ItemMaster.ItemNo LIKE + '%' +
					 @ItemCode + '%' OR ItemMaster.ItemNo LIKE + '%' + @ItemCode + '%' )))
		

		SELECT		@TotalRecords	=	COUNT(*)
		FROM	#ResSet

		SELECT * ,@TotalRecords AS TotalRecords
		FROM #ResSet
		ORDER BY	ItemId DESC
		OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 

END TRY

BEGIN CATCH

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
