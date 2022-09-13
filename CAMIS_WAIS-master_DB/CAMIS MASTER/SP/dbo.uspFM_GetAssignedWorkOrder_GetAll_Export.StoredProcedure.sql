USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_GetAssignedWorkOrder_GetAll_Export]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_GetAssignedWorkOrder_GetAll
Description			: Get the Assigned WorkOrders
Authors				: Dhilip V
Date				: 16-July-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_GetAssignedWorkOrder_GetAll_Export]  @PageSize=100,@PageIndex=0,@StrCondition=null,@StrSorting=null
EXEC [uspFM_GetAssignedWorkOrder_GetAll_Export]  @StrCondition=null,@StrSorting=null
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE [dbo].[uspFM_GetAssignedWorkOrder_GetAll_Export]

	--@PageSize		INT,
	--@PageIndex		INT,
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

	--SET @PageIndex	=	@PageIndex+1		/* This is for JQ grid implementation */

-- Execution


		SET @countQry =	'SELECT @Total = COUNT(1)
						FROM [V_GetAssignedWorkOrder_Export]
						WHERE 1 = 1 ' 
						+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' AND '+ REPLACE(ISNULL(@strCondition,''),'WHERE',' AND ')  END  
		
		print @countQry;
		
		EXECUTE sp_executesql @countQry, N' @Total INT OUTPUT', @Total = @TotalRecords OUTPUT
		--select @TotalRecords as Counts
		
		SET @qry = 'SELECT	CustomerName,
							FacilityName,
							MaintenanceWorkNo as [Work Order No.],
							MaintenanceWorkDateTime as [Work Order Date / Time],
							AssetNo as [Asset No.],
							TypeOfWorkOrder,							
							TargetDateTime,
							WorkOrderPriority,
							WorkOrderStatus,
							MaintenanceDetails,
							AssigneeType,
							AssignedName
					FROM [V_GetAssignedWorkOrder_Export]
					WHERE 1 = 1 ' 
					+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
					+ ' ' + ' ORDER BY ' +  ISNULL(@strSorting,'[V_GetAssignedWorkOrder_Export].CountingDays DESC')
					--+ ' OFFSET '  + CAST((@PageSize *  (@PageIndex-1)) AS VARCHAR(500)) + ' ROWS FETCH NEXT '  + CAST(@PageSize AS VARCHAR(100)) + ' ROWS ONLY ' ;
		print @qry;
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
		   );
	THROW;
END CATCH
GO
