USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetPPMCheckList_Export]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngAssetPPMCheckList_Export
Description			: To export the PPM Checklist details
Authors				: Dhilip V
Date				: 25-July-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngAssetPPMCheckList_Export  @StrCondition='([PPMFrequencyValue] = ''Annually'')',@StrSorting=null

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE [dbo].[uspFM_EngAssetPPMCheckList_Export]

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
Create TABLE #temp_columns (actual_column varchar(500),replace_column varchar(500))



				INSERT INTO #temp_columns(actual_column,replace_column) values	
				('[PPMFrequencyValue]','PPMFrequency')

				
SELECT @strCondition =  replace(@strCondition,actual_column,replace_column) from #temp_columns
SELECT @strSorting =  replace(@strSorting,actual_column,replace_column) from #temp_columns

SET @qry = 'SELECT   PPMChecklistNo
					,AssetTypeCode
					,AssetTypeDescription as AssetTypeCodeDescription
					,TaskCode				
					,Model
					,Manufacturer
					,PPMFrequency as PPMFrequencyValue
					,PPMHours
					,SpecialPrecautions AS SpecialPrecaution
					,Remarks
					,Category
					,Number AS No
					,Description
					,QuantitativeTasks  AS QuantitativeTaskDescription
					,UOM   AS [Units/UOM]
					,SetValues
					,LimitTolerance  AS [Limit/Tolerance]
					
			FROM [V_EngAssetPPMCheckList_Export]
			WHERE 1 = 1 ' 
			+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
			+ ' ' + ' ORDER BY ' +  ISNULL(@strSorting,'[V_EngAssetPPMCheckList_Export].ModifiedDateUTC DESC')

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
