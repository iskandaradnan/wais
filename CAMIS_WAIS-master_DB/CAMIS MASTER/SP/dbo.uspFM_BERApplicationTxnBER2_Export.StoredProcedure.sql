USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_BERApplicationTxnBER2_Export]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_BERApplicationTxnBER2_Export
Description			: To export the BERApplication details
Authors				: Dhilip V
Date				: 21-June-2018
-----------------------------------------------------------------------------------------------------------
Unit Test:
EXEC uspFM_BERApplicationTxnBER2_Export  @StrCondition='([UserLocationCode] LIKE ''%oUyOq%'')',@StrSorting=null
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE [dbo].[uspFM_BERApplicationTxnBER2_Export]
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

SET @qry = 'SELECT	[BERno]		AS	[BERNo.],
					[ApplicationDate]	AS	[ApplicationDate],									
					[AssetNo],
					[AssetDescription] as AssetTypeDescription,
					[UserLocationCode],
					[LocationName],
					[Manufacturer],
					[Model],
					[SupplierName],
					[PurchaseCost (RM)],
					[PurchaseDate],
					[EstimatedRepairCost(RM)],
					[AfterRepairValue(RM)],
					[CurrentValue(RM)],
					[EstimatedDurationOfUsageAfterRepair(Months)],				
					[RequestorName],
					[Position],
					[EstimatedRepairCostTooExpensive] as  BeyondEconomicRepair,
					[Obsolescence],
					[NotReliable],
					[StatutoryRequirements] as FailedStatutoryRequirements,
					[OtherObservations],
					[Applicant],
					[Designation],
					[BER1Remarks] AS Remarks,
					[BERStatusValue] AS Status
			FROM [V_BERApplicationTxnBER2_Export]
			WHERE 1 = 1 ' 
			+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
			+ ' ' + ' ORDER BY ' +  ISNULL(@strSorting,'[V_BERApplicationTxn_Export].ModifiedDateUTC DESC')
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
