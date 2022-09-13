USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngStockUpdateRegisterTxn_Export]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngStockUpdateRegisterTxn_Export
Description			: Get the Location Block details
Authors				: Dhilip V
Date				: 26-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngStockUpdateRegisterTxn_Export  @StrCondition='',@StrSorting=null

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE [dbo].[uspFM_EngStockUpdateRegisterTxn_Export]


	@StrCondition	NVARCHAR(MAX)		=	NULL,
	@StrSorting		NVARCHAR(MAX)		=	NULL

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

SET @qry = 'SELECT	StockUpdateNo  AS	[StockUpdateNo.],
					FORMAT(Date,''dd-MMM-yyyy'')					AS	Date,
					Year,
					[TotalSparePartCost(RM)],
					[FacilityCode],
					FacilityName,
					PartNo			AS	[PartNo.],
					PartDescription,
					SparePartType,
					Location,
					ItemCode,
					ItemDescription,
					PartSource,
					LifeSpanOptions,
					EstimatedLifeSpan,
					ExpiryDate,
					Quantity,					
					PurchaseCost	AS		[ERPPurchaseCost/Pcs(RM)],
					Cost			AS		[Cost/Pcs(RM)],
					[InvoiceNo.],
					[VendorName],
					[BinNo],
					[Remarks]
			FROM	[V_EngStockUpdateRegisterTxn_Export]
			WHERE 1 = 1 ' 
			+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
			+ ' ' + ' ORDER BY ' +  ISNULL(@strSorting,'[V_EngStockUpdateRegisterTxn_Export].ModifiedDateUTC DESC')

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
