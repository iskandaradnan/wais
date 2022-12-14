USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_BERMaintenanceWOHistory_GetAll]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_BERMaintenanceWOHistory_GetAll
Description			: Get the Maintenance Work Order in BER  details
Authors				: Dhilip V
Date				: 16-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_BERMaintenanceWOHistory_GetAll  @PageSize=10,@PageIndex=0,@StrCondition='MaintenanceWorkNo=''WO030/308489/2017''',@StrSorting=null
EXEC uspFM_BERMaintenanceWOHistory_GetAll  @PageSize=10,@PageIndex=0,@StrCondition=null,@StrSorting=null

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE [dbo].[uspFM_BERMaintenanceWOHistory_GetAll]

  @pApplicationId	INT

AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

  SELECT	        ApplicationId,
					MaintenanceWorkNo,
					MaintenanceWorkDateTime,
					MaintenanceWorkCategory,
					MaintenanceWorkType,
					DowntimeHoursMin,
					TotalCost
				
			FROM [V_BERMaintenanceWOHistory]	WHERE ApplicationId = @pApplicationId  
	

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























--     @pApplicationId INT,


--AS 
 
--BEGIN TRY

---- Paramter Validation 

--	SET NOCOUNT ON; 
--	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

---- Declaration
--	DECLARE @countQry	NVARCHAR(MAX);
--	DECLARE @qry		NVARCHAR(MAX);
--	DECLARE @condition	VARCHAR(MAX);
--	DECLARE @TotalRecords INT;

---- Default Values

--	SET @PageIndex	=	@PageIndex+1		/* This is for JQ grid implementation */
	
--	CREATE TABLE #TempRes (	Id int identity(1,1),
--							ApplicationId	int,
--							MaintenanceWorkNo nvarchar(50),
--							MaintenanceWorkDateTime	datetime,
--							MaintenanceWorkCategory nvarchar(100),
--							MaintenanceWorkType nvarchar(100),
--							DowntimeHoursMin numeric(24,2),
--							TotalCost numeric(24,2)
--						)
---- Execution


--SET @countQry =	'SELECT @Total = COUNT(1)
--				FROM [V_BERMaintenanceWOHistory]
--				WHERE 1 = 1 ' 
--				+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' AND '+ REPLACE(ISNULL(@strCondition,''),'WHERE',' AND ')  END  

----print @countQry;

--EXECUTE sp_executesql @countQry, N' @Total INT OUTPUT', @Total = @TotalRecords OUTPUT
----select @TotalRecords as Counts

--SET @qry = 'SELECT	ApplicationId,
--					MaintenanceWorkNo,
--					MaintenanceWorkDateTime,
--					MaintenanceWorkCategory,
--					MaintenanceWorkType,
--					DowntimeHoursMin,
--					TotalCost,
--					@TotalRecords AS TotalRecords
--			FROM [V_BERMaintenanceWOHistory]
--			WHERE 1 = 1  '   
--			+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
--			+ ' ' + ' ORDER BY ' +  ISNULL(@strSorting,'[V_BERMaintenanceWOHistory].ModifiedDateUTC DESC')
--			--+ ' OFFSET '  + CAST((@PageSize *  (@PageIndex-1)) AS VARCHAR(500)) + ' ROWS FETCH NEXT '  + CAST(@PageSize AS VARCHAR(100)) + ' ROWS ONLY ' ;
--PRINT @qry;

----INSERT  #TempRes
--EXECUTE sp_executesql @qry, N' @TotalRecords INT', @TotalRecords = @TotalRecords

--	--SELECT @TotalRecords = COUNT(1) 
--	--FROM #TempRes
	
--	--SELECT	ApplicationId,
--	--		MaintenanceWorkNo,
--	--		MaintenanceWorkDateTime,
--	--		MaintenanceWorkCategory,
--	--		MaintenanceWorkType,
--	--		DowntimeHoursMin,
--	--		TotalCost,
--	--		@TotalRecords AS TotalRecords 
--	--FROM #TempRes where ApplicationId	=	@pApplicationId
	
--END TRY

--BEGIN CATCH

--	INSERT INTO ErrorLog(
--				Spname,
--				ErrorMessage,
--				createddate)
--	VALUES(		OBJECT_NAME(@@PROCID),
--				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
--				getdate()
--		   );
--	THROW;
--END CATCH
GO
