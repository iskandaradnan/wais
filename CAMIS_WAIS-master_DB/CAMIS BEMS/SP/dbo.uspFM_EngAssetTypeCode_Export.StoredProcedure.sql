USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetTypeCode_Export]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngAssetTypeCode_Export
Description			: Get the Location Block details
Authors				: Dhilip V
Date				: 24-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngAssetTypeCode_Export  @StrCondition='AssetClassificationCode=''Lab''',@StrSorting=null

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE [dbo].[uspFM_EngAssetTypeCode_Export]

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

SET @qry = 'SELECT	AssetClassificationCode,
					AssetClassificationDescription,
					AssetTypeCode,
					ExpectedLifeSpan,
					AssetTypeDescription,
					MaintenanceFlag,
					EquipmentFunctionDescription,
					LifeExpectancy,
					QAPAssetService,
					QAPAssetTypeB1  AS	[QAPAssetType(B1)],
					QAPServiceAvailabilityB2 AS	[QAPServiceAvailability(B2)],
					QAPUptimeTargetPerc    AS	[QAPUptimeTarget(%)],
					EffectiveFrom,
					EffectiveTo,
					TRPILessThan5YrsPerc     AS       [AssetAge < 5 Yrs (%)],
					TRPI5to10YrsPerc           AS       [AssetAge 5 - 10 Yrs (%)],
					TRPIGreaterThan10YrsPerc   AS	    [AssetAge >10 Yrs (%)],
					TypeCodeParameter as Parameter,
					VariationRate    AS [Variation Rate (%)],
					EffectiveFromDate
			FROM	[V_EngAssetTypeCode_Export]
			WHERE 1 = 1 ' 
			+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
			+ ' ' + ' ORDER BY ' +  ISNULL(@strSorting,'[V_EngAssetTypeCode_Export].ModifiedDateUTC DESC')

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
