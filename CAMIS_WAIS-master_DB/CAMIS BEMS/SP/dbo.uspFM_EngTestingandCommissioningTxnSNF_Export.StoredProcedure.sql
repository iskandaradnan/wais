USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngTestingandCommissioningTxnSNF_Export]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngTestingandCommissioningTxnSNF_Export
Description			: To export the QAPQualityCause details
Authors				: Dhilip V
Date				: 07-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngTestingandCommissioningTxnSNF_Export  @StrCondition='CauseCode=''C01''',@StrSorting=null

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE [dbo].[uspFM_EngTestingandCommissioningTxnSNF_Export]

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


SET @qry = 'SELECT	SNFNo,
					SNFDate,
					AssetNo,
					AssetDescription,
					VariationStatus,
					PurchaseDate,
					PurchaseCost,
					ContractLPONo,
					ServiceStartDate,
					ServiceEndDate,
					MainSupplierCode,
					MainSupplierName,
					WarrantyDuration,
					WarrantyStartDate,
					WarrantyEndDate,
					Remarks
			FROM [V_EngTestingandCommissioningTxnSNF_Export]
			WHERE 1 = 1 ' 
			+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
			+ ' ' + ' ORDER BY ' +  ISNULL(@strSorting,'[V_EngTestingandCommissioningTxnSNF_Export].ModifiedDateUTC DESC')

PRINT @qry;

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
