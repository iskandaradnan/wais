USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngFacilitiesWorkshopTxn_Export]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngFacilitiesWorkshopTxn_Export
Description			: Get the WarrantyManagement details
Authors				: Dhilip V
Date				: 25-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngFacilitiesWorkshopTxn_Export  @StrCondition='',@StrSorting=null

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE [dbo].[uspFM_EngFacilitiesWorkshopTxn_Export]

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
	SET @StrCondition = REPLACE(@StrCondition,'([Category] = (''''''''))','([Category] = (''''))')

-- Execution

SET @qry = 'SELECT	
					Year,					
					FacilityType	AS	[Type ofFacility],
					Category,
					AssetNo			AS	[AssetNo.],
					Description,
					Manufacturer,
					Model,
					SerialNo		AS	[SerialNo.],
					CalibrationDueDate,
					Location,
					Quantity,
					SizeArea		AS	[Size/Area(Sq m)]
			FROM	[V_EngFacilitiesWorkshopTxn_Export]
			WHERE 1 = 1 ' 
			+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
			+ ' ' + ' ORDER BY ' +  ISNULL(@strSorting,'[V_EngFacilitiesWorkshopTxn_Export].ModifiedDateUTC DESC')

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
