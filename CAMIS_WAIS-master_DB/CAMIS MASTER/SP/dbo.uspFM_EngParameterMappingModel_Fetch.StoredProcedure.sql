USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngParameterMappingModel_Fetch]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngAssetModel_Fetch
Description			: Model Fetch control
Authors				: Dhilip V
Date				: 17-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngAssetModel_Fetch  @pModel=null,@pAssetTypeCodeId=11,@pPageIndex=1,@pPageSize=5
SELECT * FROM EngAssetStandardization
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
create PROCEDURE  [dbo].[uspFM_EngParameterMappingModel_Fetch]                       
  @pModel				NVARCHAR(100)	=	NULL,
  @pAssetTypeCodeId		INT,
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
	select ModelId,max(m.ManufacturerId) as ManufacturerId   into #mapptable  from   EngAssetStandardization m
					group by ModelId

		SELECT		DISTINCT Model.ModelId,
					Model.Model,
					M.ManufacturerId,
					M.Manufacturer	,	
					Model.ModifiedDateUTC
		INTO		#TempRes
		FROM		EngAssetStandardizationModel			AS Model WITH(NOLOCK)
		outer apply (select top 1 b.ManufacturerId,b.Manufacturer  from #mapptable  a join EngAssetStandardizationManufacturer b on a.ManufacturerId=b.ManufacturerId where 	Model.ModelId = a.ModelId) M
					INNER JOIN EngAssetStandardization			AS AssetStd WITH(NOLOCK)	ON	Model.ModelId	=	AssetStd.ModelId
		WHERE		Model.Active =1 AND AssetStd.Status=1
					AND ((ISNULL(@pModel,'')='' )	OR ( ISNULL(@pModel,'') <> ''  AND Model LIKE '%' + @pModel + '%'))
					AND ((ISNULL(@pAssetTypeCodeId,'')='' )	OR ( ISNULL(@pAssetTypeCodeId,'') <> ''  AND AssetStd.AssetTypeCodeId = @pAssetTypeCodeId))
					AND not exists (select 1 from EngEODParameterMapping t where t.modelid=Model.modelid and t.assettypecodeid=AssetStd.assettypecodeid) 

		SELECT	@TotalRecords	=	COUNT(1)
		FROM	#TempRes

		SELECT	ModelId,
				Model,
				ManufacturerId,
				Manufacturer	,
				@TotalRecords	AS	TotalRecords
		FROM	#TempRes
		ORDER BY	ModifiedDateUTC DESC
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
