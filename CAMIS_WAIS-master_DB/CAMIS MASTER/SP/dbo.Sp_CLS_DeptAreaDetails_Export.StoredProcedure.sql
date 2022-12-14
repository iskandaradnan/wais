USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_DeptAreaDetails_Export]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec [dbo].[Sp_CLS_DeptAreaDetails_Export] 'FacilityId = 25', 'DeptAreaId desc'
CREATE PROC [dbo].[Sp_CLS_DeptAreaDetails_Export]

		@StrCondition	NVARCHAR(MAX) = NULL,
		@StrSorting		NVARCHAR(MAX) = NULL
AS 
BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @qry NVARCHAR(MAX);


SET @qry = 'SELECT UserAreaCode, UserAreaName, CategoryOfArea, TotalReceptacles, CleanableArea, NoOfHandWashingFacilities, 
			 NoOfBeds, TotalNoOfUserLocations, Status FROM (SELECT	[DeptAreaId], [CustomerId], [FacilityId], [UserAreaCode],  UserAreaId ,
		 [UserAreaName], B.FieldValue as [CategoryOfArea],    C.FieldValue as [Status],
		 [OperatingDays], [WorkingHours], [TotalReceptacles], [CleanableArea],[NoOfHandWashingFacilities],[NoOfBeds],
			[TotalNoOfUserLocations],[HospitalRepresentative],[HospitalRepresentativeDesignation],[CompanyRepresentative],
			[CompanyRepresentativeDesignation],[EffectiveFromDate],[EffectiveToDate],[JISchedule], A.[Remarks]  
			FROM [CLS_DeptAreaDetails] A
			LEFT JOIN FMLovMst B ON A.[CategoryOfArea] = B.LovId 
			LEFT JOIN FMLovMst C ON A.[Status] = C.LovId  ) A
			WHERE 1 = 1 ' 
			+  CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
			+ ' ORDER BY ' +  ISNULL(@strSorting, 'DeptAreaId DESC')
			
print @qry;

EXECUTE sp_executesql @qry



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
