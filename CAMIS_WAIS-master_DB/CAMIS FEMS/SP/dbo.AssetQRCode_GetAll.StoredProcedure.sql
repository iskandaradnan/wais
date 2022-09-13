USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[AssetQRCode_GetAll]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AssetQRCode_GetAll]
(
	@PageSize INT,
	@PageIndex INT,
	@StrCondition NVARCHAR(MAX) = NULL,
	@StrSorting NVARCHAR(MAX) = NULL
)
AS 

--EXEC [AssetQRCode_GetAll]  @PageIndex=0,@PageSize=5,@StrCondition='AssetNo like ''%PAN101%'' OR AssetNo = ''fghfgh''',@StrSorting=NULL

-- Exec [GetAllUserRole] 10, 0, null, null

--/*=====================================================================================================================
--APPLICATION		: UETrack
--NAME				: GetAllBlock
--DESCRIPTION		: GET RECORDS FOR THE LIST
--AUTHORS			: BIJU NB
--DATE				: 19-March-2018
-------------------------------------------------------------------------------------------------------------------------
--VERSION HISTORY 
--------------------:---------------:---------------------------------------------------------------------------------------
--Init				: Date          : Details
--------------------:---------------:---------------------------------------------------------------------------------------
--BIJU NB           : 19-March-2018 : 
-------:------------:----------------------------------------------------------------------------------------------------*/
BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY

DECLARE @countQry NVARCHAR(MAX);
DECLARE @qry NVARCHAR(MAX);
DECLARE @condition VARCHAR(MAX);
DECLARE @TotalRecords INT;

Create TABLE #temp_columns (actual_column varchar(500),replace_column varchar(500))

INSERT INTO #temp_columns(actual_column,replace_column) values	
				('[LevelName]','A.LevelName')
				--('[FacilityName]','B.FacilityName')

SELECT @strCondition =  replace(@strCondition,actual_column,replace_column) from #temp_columns
SELECT @strSorting =  replace(@strSorting,actual_column,replace_column) from #temp_columns

SET @countQry = 'SELECT @Total = COUNT(1)
				FROM EngAsset Asset
			INNER JOIN MstLocationUserLocation				AS UserLocation		ON		Asset.UserLocationId	 =  UserLocation.UserLocationId
			INNER JOIN MstLocationUserArea					AS UserArea			ON		UserLocation.UserAreaId	 =  UserArea.UserAreaId
			INNER JOIN EngAssetTypeCode						AS AssetTypeCode	ON		Asset.AssetTypeCodeId	 =  AssetTypeCode.AssetTypeCodeId
			INNER JOIN EngAssetStandardizationManufacturer	AS Manufacturer		ON		Asset.Manufacturer		 =  Manufacturer.ManufacturerId
			INNER JOIN EngAssetStandardizationModel			AS Model			ON		Asset.Model				 =  Model.ModelId
			WHERE 1=1' 
				+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' AND '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  

print @countQry;

EXECUTE sp_executesql @countQry, N' @Total INT OUTPUT', @Total = @TotalRecords OUTPUT
--select @TotalRecords as Counts

SET @qry = 'SELECT
			Asset.AssetId,
			Asset.AssetNo,
			Asset.AssetDescription,
			UserLocation.UserLocationCode,
			UserArea.UserAreaCode,
			AssetTypeCode.AssetTypeCode,
			Manufacturer.Manufacturer,
			Model.Model,
			@TotalRecords TotalRecords
			FROM EngAsset Asset
			INNER JOIN MstLocationUserLocation				AS UserLocation		ON		Asset.UserLocationId	 =  UserLocation.UserLocationId
			INNER JOIN MstLocationUserArea					AS UserArea			ON		UserLocation.UserAreaId	 =  UserArea.UserAreaId
			INNER JOIN EngAssetTypeCode						AS AssetTypeCode	ON		Asset.AssetTypeCodeId	 =  AssetTypeCode.AssetTypeCodeId
			INNER JOIN EngAssetStandardizationManufacturer	AS Manufacturer		ON		Asset.Manufacturer		 =  Manufacturer.ManufacturerId
			INNER JOIN EngAssetStandardizationModel			AS Model			ON		Asset.Model				 =  Model.ModelId
			WHERE 1=1'
			+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
			+ ' ' + ' ORDER BY ' +  ISNULL(@strSorting,'Asset.ModifiedDateUTC DESC')
			+ ' OFFSET '  + CAST((@PageSize *  @PageIndex) AS VARCHAR(500)) + ' ROWS FETCH NEXT '  + CAST(@PageSize AS VARCHAR(100)) + ' ROWS ONLY ' ;
print @qry;
EXECUTE sp_executesql @qry, N' @TotalRecords INT', @TotalRecords = @TotalRecords
	
END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
