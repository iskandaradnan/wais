USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngTestingandCommissioningTxn_Export]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngTestingandCommissioningTxn_Export
Description			: To export the TestingandCommissioning details
Authors				: Dhilip V
Date				: 21-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngTestingandCommissioningTxn_Export  @StrCondition='',@StrSorting=null

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE [dbo].[uspFM_EngTestingandCommissioningTxn_Export]

	@StrCondition	NVARCHAR(MAX) = NULL,
	@StrSorting		NVARCHAR(MAX) = NULL

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


-- Execution

/*
SET @countQry =	'SELECT @Total = COUNT(1)
				FROM [V_EngTestingandCommissioningTxn_Export]
				WHERE 1 = 1 ' 
				+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' AND '+ REPLACE(ISNULL(@strCondition,''),'WHERE',' AND ')  END  

print @countQry;

EXECUTE sp_executesql @countQry, N' @Total INT OUTPUT', @Total = @TotalRecords OUTPUT
*/


SET @qry = 'SELECT	AssetCategory
					,RequestNo
					,TandCDocumentNo
					,TandCDateTime AS TandCDate
					,AssetTypeCode
					,AssetTypeDescription
					,AssetPreRegistrationNo
					,TandCStatus
					,FORMAT(RequiredCompletionDate,''dd-MMM-yyyy'') as RequiredCompletionDate
					,Model
					,Manufacturer
					,SerialNo AS [SerialNo.]
					,AssetNoOld AS [OldAssetNumber]
					,TandCCompletedDate
					,HandoverDate
					,VariationStatus
					,TandCContractorRepresentative
					,LocationName
					,AreaName
					,BlockName
					,LevelName
					,CompanyRepresentative
					,FacilityRepresentative
					,Remarks
					--,StatusName
					,AssetNo AS [AssetNo.]
			FROM [V_EngTestingandCommissioningTxn_Export]
			WHERE 1 = 1 ' 
			+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
			+ ' ' + ' ORDER BY ' +  ISNULL(@strSorting,'[V_EngTestingandCommissioningTxn_Export].ModifiedDateUTC DESC')

print @qry;
EXECUTE sp_executesql @qry, N' @TotalRecords INT', @TotalRecords = @TotalRecords
	
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
