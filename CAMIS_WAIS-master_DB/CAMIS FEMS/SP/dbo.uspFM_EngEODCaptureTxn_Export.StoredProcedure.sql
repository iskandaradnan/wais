USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngEODCaptureTxn_Export]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngEODCaptureTxn_Export
Description			: To export the PPMRegister details
Authors				: Dhilip V
Date				: 08-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngEODCaptureTxn_Export  @StrCondition='([RecordDate] = ''2018-10-22 20:35'')',@StrSorting=null

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE [dbo].[uspFM_EngEODCaptureTxn_Export]

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
    ('[AssetDesc]','AssetDescription')
   
   

SELECT @strCondition =  replace(@strCondition,actual_column,replace_column) from #temp_columns
SELECT @strSorting =  replace(@strSorting,actual_column,replace_column) from #temp_columns

SET @qry = 'SELECT	AssetNo,
					AssetDescription AS AssetDescription,
					CaptureDocumentNo,
					FORMAT(RecordDate,''dd-MMM-yyyy hh:mm'') AS [Record Date/Time],
					AssetClassificationCode as AssetClassification,
					UserAreaCode as AreaCode,
					UserAreaName AS AreaName,
					UserLocationCode AS LocationCode,
					UserLocationName AS LocationName,
					AssetTypeCode AS TypeCode,
					format(NextCapdate,''dd-MMM-yyyy'')   NextCaptureDate,
					Paramter AS Parameter,
					UnitOfMeasurement  AS UOM,
					Minimum as Min,
					Maximum as Max,
					ActualValue,
					Status
			FROM [V_EngEODCaptureTxn_Export]
			WHERE 1 = 1 ' 
			+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
			+ ' ' + ' ORDER BY ' +  ISNULL(@strSorting,'[V_EngEODCaptureTxn_Export].ModifiedDateUTC DESC')

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
