USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAsset_GetAll]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngAsset_GetAll
Description			: Get the staff details by passing the staffId.
Authors				: Dhilip V
Date				: 05-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngAsset_GetAll  @PageSize=50,@PageIndex=0,@StrCondition='',@StrSorting=null,@pUserId=1,@pAccessLevel=4

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE [dbo].[uspFM_EngAsset_GetAll]

	@PageSize		INT,
	@PageIndex		INT,
	@StrCondition	NVARCHAR(MAX)	= NULL,
	@StrSorting		NVARCHAR(MAX)	= NULL,
	@pUserId		INT				= NULL,
	@pAccessLevel	INT				= NULL

AS 

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;



-- Declaration
	DECLARE @countQry	NVARCHAR(MAX);
	DECLARE @qry		NVARCHAR(MAX);
	DECLARE @condition	VARCHAR(MAX);
	DECLARE @TotalRecords INT;

-- Default Values

	SET @PageIndex	=	@PageIndex+1		/* This is for JQ grid implementation */

-- Execution

IF(ISNULL(@pAccessLevel,0)=4)
	
	BEGIN

		SET @countQry =	'SELECT @Total = COUNT(1)
						FROM [V_EngAsset]
						WHERE 1 = 1  AND ' + 'UserRegistrationId = ' + cast(@pUserId as nvarchar(10)) 
						+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' AND '+ REPLACE(ISNULL(@strCondition,''),'WHERE',' AND ')  END  
		
		print @countQry;
		
		EXECUTE sp_executesql @countQry, N' @Total INT OUTPUT', @Total = @TotalRecords OUTPUT
		--select @TotalRecords as Counts
		
		SET @qry = 'SELECT	AssetId,
							AssetNo,
							AssetTypeCode,
							AssetTypeDescription,
							UserLocationCode,
							UserLocationName,
							UserAreaName,
							Model,
							Manufacturer,
							Active,
							[AuthorizationStatus],
							VariationStatus,
							IsLoanerValue,
							AssetClassificationCode,
							AssetClassification,
							ContractTypeName as ContractType,
							SerialNumber,
							ModifiedDateUTC,
							@TotalRecords AS TotalRecords
					FROM [V_EngAsset]
					WHERE 1 = 1  AND ' + 'UserRegistrationId = ' + cast(@pUserId as nvarchar(10))
					+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
					+ ' ' + ' ORDER BY ' +  ISNULL(@strSorting,'[V_EngAsset].ModifiedDateUTC DESC')
					+ ' OFFSET '  + CAST((@PageSize *  (@PageIndex-1)) AS VARCHAR(500)) + ' ROWS FETCH NEXT '  + CAST(@PageSize AS VARCHAR(100)) + ' ROWS ONLY ' ;
		print @qry;
		EXECUTE sp_executesql @qry, N' @TotalRecords INT', @TotalRecords = @TotalRecords
	
	END

	ELSE

	BEGIN

		SET @countQry =	'SELECT @Total = COUNT(1)
						FROM [V_EngAsset]
						WHERE 1 = 1 ' 
						+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' AND '+ REPLACE(ISNULL(@strCondition,''),'WHERE',' AND ')  END  
		
		print @countQry;
		
		EXECUTE sp_executesql @countQry, N' @Total INT OUTPUT', @Total = @TotalRecords OUTPUT
		--select @TotalRecords as Counts
		
		SET @qry = 'SELECT	AssetId,
							AssetNo,
							AssetTypeCode,
							AssetTypeDescription,
							UserLocationCode,
							UserLocationName,
							UserAreaName,
							Manufacturer,
							Model,
							Active,
							[AuthorizationStatus],
							VariationStatus,
							IsLoanerValue,
							AssetClassificationCode,
							AssetClassification,
							ContractTypeName as ContractType,
							SerialNumber,
							ModifiedDateUTC,
							@TotalRecords AS TotalRecords
					FROM [V_EngAsset]
					WHERE 1 = 1 ' 
					+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
					+ ' ' + ' ORDER BY ' +  ISNULL(@strSorting,'[V_EngAsset].ModifiedDateUTC DESC')
					+ ' OFFSET '  + CAST((@PageSize *  (@PageIndex-1)) AS VARCHAR(500)) + ' ROWS FETCH NEXT '  + CAST(@PageSize AS VARCHAR(100)) + ' ROWS ONLY ' ;
		print @qry;
		EXECUTE sp_executesql @qry, N' @TotalRecords INT', @TotalRecords = @TotalRecords
	END
	
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
