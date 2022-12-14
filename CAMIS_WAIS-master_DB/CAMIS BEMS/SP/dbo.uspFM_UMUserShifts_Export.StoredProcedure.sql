USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_UMUserShifts_Export]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_UMUserShifts_Export
Description			: To export the User Shift details
Authors				: Dhilip V
Date				: 13-July-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_UMUserShifts_Export  @StrCondition='',@StrSorting=null

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE [dbo].[uspFM_UMUserShifts_Export]

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
				('[Assignee]','ShiftStarttime')
			
			

SELECT @strCondition =  replace(@strCondition,actual_column,replace_column) from #temp_columns
SELECT @strSorting =  replace(@strSorting,actual_column,replace_column) from #temp_columns


SET @qry = 'SELECT	StaffName,
					UserName,
					MobileNo ,
					UserType,
					Designation,
					--ShiftLunchTime AS ShiftBreakTime,
					--ShiftTime,
					ShiftStarttime,
					ShiftEndtime,
					ShiftBreakStartTime,
					ShiftBreakEndTime,
					FORMAT(LeaveFrom,''dd-MMM-yyyy'')	AS [LeaveFrom],
					FORMAT(LeaveTo,''dd-MMM-yyyy'')	AS [LeaveTo],
					NoOfDays
			FROM [V_UMUserShifts_Export]
			WHERE 1 = 1 ' 
			+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
			+ ' ' + ' ORDER BY ' +  ISNULL(@strSorting,'[V_UMUserShifts_Export].ModifiedDateUTC DESC')

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
