USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_DeptAreaDetails_GetAll]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Sp_CLS_DeptAreaDetails_GetAll]
	-- exec  [dbo].[Sp_CLS_DeptAreaDetails_GetAll] 5 , 0, 'FacilityId = 25', 'DeptAreaId desc'
	-- select * from [CLS_DeptAreaDetails]
		@PageSize		INT,
		@PageIndex		INT,
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

	SET @PageIndex	=	@PageIndex+1		/* This is for JQ grid implementation */

-- Execution


SET @countQry =	'SELECT @Total =  COUNT(1) FROM
				( 	SELECT	[DeptAreaId], [CustomerId], [FacilityId], [UserAreaCode],  UserAreaId ,
		 [UserAreaName], B.FieldValue as [CategoryOfArea],    C.FieldValue as [Status],
		 [OperatingDays], [WorkingHours], [TotalReceptacles], [CleanableArea],[NoOfHandWashingFacilities],[NoOfBeds],
			[TotalNoOfUserLocations],[HospitalRepresentative],[HospitalRepresentativeDesignation],[CompanyRepresentative],
			[CompanyRepresentativeDesignation],[EffectiveFromDate],[EffectiveToDate],[JISchedule], A.[Remarks] 
			FROM [CLS_DeptAreaDetails] A
			LEFT JOIN FMLovMst B ON A.[CategoryOfArea] = B.LovId 
			LEFT JOIN FMLovMst C ON A.[Status] = C.LovId  ) A 				
				WHERE 1 = 1 ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' AND '+ REPLACE(ISNULL(@strCondition,''),'WHERE',' AND ')  END  

print @countQry;

EXECUTE sp_executesql @countQry, N' @Total INT OUTPUT', @Total = @TotalRecords OUTPUT
--select @TotalRecords as Counts

SET @qry = 'SELECT * FROM (SELECT	[DeptAreaId], [CustomerId], [FacilityId], [UserAreaCode],  UserAreaId ,
		 [UserAreaName], B.FieldValue as [CategoryOfArea],    C.FieldValue as [Status],
		 [OperatingDays], [WorkingHours], [TotalReceptacles], [CleanableArea],[NoOfHandWashingFacilities],[NoOfBeds],
			[TotalNoOfUserLocations],[HospitalRepresentative],[HospitalRepresentativeDesignation],[CompanyRepresentative],
			[CompanyRepresentativeDesignation],[EffectiveFromDate],[EffectiveToDate],[JISchedule], A.[Remarks]  , @TotalRecords AS TotalRecords
			FROM [CLS_DeptAreaDetails] A
			LEFT JOIN FMLovMst B ON A.[CategoryOfArea] = B.LovId 
			LEFT JOIN FMLovMst C ON A.[Status] = C.LovId  ) A
			WHERE 1 = 1 ' 
			+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
			+ ' ' + ' ORDER BY ' +  ISNULL(@strSorting, 'DeptAreaId DESC')
			+ ' OFFSET '  + CAST((@PageSize *  (@PageIndex-1)) AS VARCHAR(500)) + ' ROWS FETCH NEXT '  + CAST(@PageSize AS VARCHAR(100)) + ' ROWS ONLY ' ;
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
		   )

END CATCH
GO
