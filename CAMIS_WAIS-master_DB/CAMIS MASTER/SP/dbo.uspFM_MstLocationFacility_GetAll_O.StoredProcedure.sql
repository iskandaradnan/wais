USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_MstLocationFacility_GetAll_O]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_MstLocationFacility_GetAll_O
Description			: Get all customer details
Authors				: Dhilip V
Date				: 13-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_MstLocationFacility_GetAll_O  @PageSize=10,@PageIndex=0,@StrCondition='FacilityCode=''PNG120''',@StrSorting=null

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE [dbo].[uspFM_MstLocationFacility_GetAll_O]

	@PageSize		INT,
	@PageIndex		INT,
	@StrCondition	NVARCHAR(MAX) = NULL,
	@StrSorting		NVARCHAR(MAX) = NULL

AS 

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	DECLARE @countQry		NVARCHAR(MAX);
	DECLARE @qry			NVARCHAR(MAX);
	DECLARE @condition		VARCHAR(MAX);
	DECLARE @TotalRecords	INT;

-- Default Values

	SET @PageIndex	=	@PageIndex+1		/* This is for JQ grid implementation GET All*/

-- Execution


SET @countQry =	'SELECT @Total = COUNT(1)
				FROM [V_MstLocationFacility_Export]
				WHERE 1 = 1 ' 
				+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' AND '+ REPLACE(ISNULL(@strCondition,''),'WHERE',' AND ')  END  

print @countQry;

EXECUTE sp_executesql @countQry, N' @Total INT OUTPUT', @Total = @TotalRecords OUTPUT
--select @TotalRecords as Counts

SET @qry = 'SELECT	FacilityId,
					CustomerName,
					FacilityName,
					FacilityCode,
					Address,
					ActiveFrom,
					ActiveTo,
					@TotalRecords AS TotalRecords
			FROM [V_MstLocationFacility_Export]
			WHERE 1 = 1 ' 
			+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
			+ ' ' + ' ORDER BY ' +  ISNULL(@strSorting,'[V_MstLocationFacility_Export].ModifiedDateUTC DESC')
			+ ' OFFSET '  + CAST((@PageSize *  (@PageIndex-1)) AS VARCHAR(500)) + ' ROWS FETCH NEXT '  + CAST(@PageSize AS VARCHAR(100)) + ' ROWS ONLY ' ;
print @qry;
EXECUTE sp_executesql @qry, N' @TotalRecords INT', @TotalRecords = @TotalRecords
	
END TRY

BEGIN CATCH

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	ERROR_LINE())+' - '+ERROR_MESSAGE(),
				GETDATE()
		   )

END CATCH
GO
