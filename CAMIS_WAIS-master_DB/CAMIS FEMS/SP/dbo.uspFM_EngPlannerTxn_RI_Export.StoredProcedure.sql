USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngPlannerTxn_RI_Export]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngPlannerTxn_RI_Export
Description			: Get the RI planner details
Authors				: Dhilip V
Date				: 05-July-2018
----------------------------------------------------------------- ------------------------------------------

Unit Test:
EXEC uspFM_EngPlannerTxn_RI_Export  @StrCondition='([TotalNoOfAssets] LIKE ''%12%'')',@StrSorting=null

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE [dbo].[uspFM_EngPlannerTxn_RI_Export]

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


--SET @countQry =	'SELECT @Total = COUNT(1)
--				FROM [V_EngPlannerTxn_RI_Export]
--				WHERE 1 = 1 ' 
--				+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' AND '+ REPLACE(ISNULL(@strCondition,''),'WHERE',' AND ')  END  

--print @countQry;

--EXECUTE sp_executesql @countQry, N' @Total INT OUTPUT'--, @Total = @TotalRecords OUTPUT
--select @TotalRecords as Counts

SET @qry = 'SELECT 
					Year,
					
					UserAreaCode,
					UserAreaName,
					TotalNoOfAssets,
					Assignee,
					FacilityRepresentative,
					--Engineer,
					ScheduleType,
					Status,
					PlannerDate  as PlannerDate --,
					--@TotalRecords AS TotalRecords
			FROM [V_EngPlannerTxn_RI_Export]
			WHERE 1 = 1 ' 
			+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' AND '+ REPLACE(ISNULL(@strCondition,''),'WHERE',' AND ')  END  
			+ ' ' + ' ORDER BY ' +  ISNULL(@strSorting,'[V_EngPlannerTxn_RI_Export].ModifiedDateUTC DESC')

print @qry;
EXECUTE sp_executesql @qry--, N' @TotalRecords INT', @TotalRecords = @TotalRecords
	
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
