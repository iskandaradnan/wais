USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_MstLocationFacility_Export]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_MstLocationFacility_Export
Description			: Get all customer details
Authors				: Dhilip V
Date				: 24-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_MstLocationFacility_Export @StrCondition='FacilityCode=''PAN''',@StrSorting=null

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE [dbo].[uspFM_MstLocationFacility_Export]

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


-- Execution


SET @qry = 'SELECT	
					
			CustomerCode,
			CustomerName,
			FacilityCode,
			FacilityName,
			Address1,
			Address2,
			PostCode,
			State,
			Country,
			WeekEnds,
			Latitude,
			Longitude,
			PhoneNumber as [PhoneNo.],
			FaxNumber as [FaxNo.],
			format(ActiveFrom,''dd-MMM-yyyy'')   ActiveFrom,
			format(ActiveTo,''dd-MMM-yyyy'') ActiveTo , 
			ContractPeriodInMonths,
			InitialProjectCost AS [InitialProjectCost(RM)],
			TypeofNomenclature,
			--LifeExpectancy,
			MonthlyServiceFee As [CurrentMonthlyServiceFee(RM)],
			Name,
			Designation,
			ContactNo,
			Email
			FROM [V_MstLocationFacility_Export]
			WHERE 1 = 1 ' 
			+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
			+ ' ' + ' ORDER BY ' +  ISNULL(@strSorting,'[V_MstLocationFacility_Export].ModifiedDateUTC DESC')
			
PRINT @qry;
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
