USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetStandardizationModel_Fetch]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngAssetStandardizationModel_Fetch
Description			: Model search popup
Authors				: Balaji M S
Date				: 02-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngAssetStandardizationModel_Fetch  @pModel='N',@pPageIndex=1,@pPageSize=5

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_EngAssetStandardizationModel_Fetch]                           
  @pModel				NVARCHAR(100)	=	NULL,
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

select ModelId,max(m.ManufacturerId) as ManufacturerId   into #mapptable  from   EngAssetStandardization m
					group by ModelId

-- Execution
		SELECT		@TotalRecords	=	COUNT(*)
		--FROM		EngAssetStandardizationModel						AS Model WITH(NOLOCK)
		--WHERE		Model.Active =1
		--			AND ((ISNULL(@pModel,'')='' )	OR ( ISNULL(@pModel,'') <> ''  AND Model LIKE '%' + @pModel + '%'))
		FROM		EngAssetStandardizationModel						AS Model WITH(NOLOCK)
		outer apply (select top 1 b.ManufacturerId,b.Manufacturer  from #mapptable  a join EngAssetStandardizationManufacturer b on a.ManufacturerId=b.ManufacturerId
					 where 	Model.ModelId = a.ModelId) M
		
				
		WHERE		Model.Active =1
					AND ((ISNULL(@pModel,'')='' )	OR ( ISNULL(@pModel,'') <> ''  AND Model LIKE '%' + @pModel + '%'))
		
		--ORDER BY	Model.ModifiedDateUTC DESC





		SELECT		Model.ModelId,
					Model.Model,
					M.ManufacturerId,
					M.Manufacturer	,				
					@TotalRecords AS TotalRecords
		FROM		EngAssetStandardizationModel						AS Model WITH(NOLOCK)
		outer apply (select top 1 b.ManufacturerId,b.Manufacturer  from #mapptable  a join EngAssetStandardizationManufacturer b on a.ManufacturerId=b.ManufacturerId
					 where 	Model.ModelId = a.ModelId) M
		
				
		WHERE		Model.Active =1
					AND ((ISNULL(@pModel,'')='' )	OR ( ISNULL(@pModel,'') <> ''  AND Model LIKE '%' + @pModel + '%'))
		
		ORDER BY	Model.ModifiedDateUTC DESC
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
