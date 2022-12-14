USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_QRCodeAsset_GetAll]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_QRCodeAsset_GetAll
Description			: Get the ASSET details with QRCode
Authors				: Dhilip V
Date				: 02-JUNE-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_QRCodeAsset_GetAll  @StrCondition='',@StrSorting=null,@pFacilityId=2

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/


CREATE PROCEDURE [dbo].[uspFM_QRCodeAsset_GetAll]

	--@PageSize INT,
	--@PageIndex INT,
	@StrCondition NVARCHAR(MAX) = NULL,
	@StrSorting NVARCHAR(MAX) = NULL,
	@pFacilityId int 

AS 


BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY

DECLARE @countQry NVARCHAR(MAX);
DECLARE @qry NVARCHAR(MAX);
DECLARE @condition VARCHAR(MAX);
DECLARE @TotalRecords INT;
DECLARE @pTotalPage NUMERIC(24,2);


--SET @countQry = 'SELECT @Total = COUNT(1)
--					FROM V_QRCodeAsset
--				WHERE 1=1 AND ' + 'FacilityId = ' + cast(@pFacilityId as nvarchar(10))
--				+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' AND '+ REPLACE(ISNULL(@strCondition,''),'WHERE',' AND ')  END  

--print @countQry;



EXECUTE sp_executesql @countQry, N' @Total INT OUTPUT', @Total = @TotalRecords OUTPUT
--select @TotalRecords as Counts

	--SET @pTotalPage = IIF(@PageSize=0,0,CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@PageSize AS NUMERIC(24,2)))
	--SET @pTotalPage = CEILING(@pTotalPage)


SET @qry = 'SELECT	AssetId,
					AssetNo,
					AssetDescription,
					AssetQRCode,
					AssetClassificationCode,
					AssetTypeCodeId,
					AssetTypeCode,
					AssetTypeDescription,
					Manufacturer,
					Model,
					UserAreaId,
					UserAreaCode,
					UserAreaName,
					UserLocationId,
					UserLocationCode,
					UserLocationName,
					ContractTypeId,
					ContractType
			FROM V_QRCodeAsset
			WHERE 1=1 AND ' + 'FacilityId = ' + cast(@pFacilityId as nvarchar(10))
			+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'WHERE',' AND ')  END  
			+ ' ' + ' ORDER BY ' +  ISNULL(@strSorting,'V_QRCodeAsset.ModifiedDateUTC DESC')
			--+ ' OFFSET '  + CAST((@PageSize *  (@PageIndex-1)) AS VARCHAR(500)) + ' ROWS FETCH NEXT '  + CAST(@PageSize AS VARCHAR(100)) + ' ROWS ONLY ' ;
print @qry;

EXECUTE sp_executesql @qry, N' @TotalRecords INT,@pTotalPage int',   @TotalRecords = @TotalRecords , @pTotalPage = @pTotalPage
	
END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW;

END CATCH
SET NOCOUNT OFF
END
GO
