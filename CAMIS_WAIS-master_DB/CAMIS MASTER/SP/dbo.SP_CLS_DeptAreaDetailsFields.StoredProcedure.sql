USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_CLS_DeptAreaDetailsFields]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from CLS_DeptAreaDetails
CREATE procedure [dbo].[SP_CLS_DeptAreaDetailsFields](
		   @pDeptAreaId int,
		   @pUserAreaId int,
		   @pCustomerId int,
		   @pFacilityId int,
           @pUserAreaCode nvarchar(50),
		   @pUserAreaName varchar(100)='',
		   @pCategoryOfArea varchar(30),
		   @pStatus int,
		   @pOperatingDays varchar(30),
		   @pWorkingHours int='',
		   @pTotalReceptacles int='',
		   @pCleaningArea int,
		   @pNoOfHandWashingFacilities int,
		   @pNoOfBeds int='',
		   @pTotalNoOfUserLocations int='',
		   @pHospitalRepresentative nvarchar(75),
		   @pHospitalRepresentativeDesignation nvarchar(75)='',
		   @pCompanyRepresentative nvarchar(75),
		   @pCompanyRepresentativeDesignation nvarchar(75)='',
		   @pEffectiveFromDate datetime = null,	
		   @pEffectiveToDate datetime = null,
		   @pJISchedule nvarchar(30),
		   @pRemarks nvarchar(100) = '' 
		   )
AS
BEGIN
SET NOCOUNT ON;

BEGIN TRY

 IF(NOT EXISTS(SELECT 1 FROM CLS_DeptAreaDetails WHERE UserAreaCode = @pUserAreaCode))
 BEGIN

	--DECLARE @NEWID INT
	--SELECT @NEWID = MAX(IDENTITY) FROM CLS_DeptAreaDetails
		
	insert into CLS_DeptAreaDetails values(@pUserAreaId,@pCustomerId,@pFacilityId, @pUserAreaCode,  @pUserAreaName,
									   @pCategoryOfArea,   @pStatus,
									   @pOperatingDays,   @pWorkingHours,
									   @pTotalReceptacles, @pCleaningArea,
									   @pNoOfHandWashingFacilities, @pNoOfBeds,
									   @pTotalNoOfUserLocations, @pHospitalRepresentative,
									   @pHospitalRepresentativeDesignation, @pCompanyRepresentative,
									   @pCompanyRepresentativeDesignation, @pEffectiveFromDate,	@pEffectiveToDate,								   
									   @pJISchedule, @pRemarks)
		--IF(@@IDENTITY = @NEWID)
			--SELECT @NEWID AS NEWID; 
			SELECT MAX(DeptAreaId) as DeptAreaId FROM CLS_DeptAreaDetails
		--SELECT @@IDENTITY AS DeptAreaId
		--SELECT TOP 1 [DeptAreaId] FROM [CLS_DeptAreaDetails]order by DeptAreaId desc

 END
 ELSE
	BEGIN
		-- UPDATE
		UPDATE CLS_DeptAreaDetails SET CategoryOfArea = @pCategoryOfArea, [Status] = @pStatus, OperatingDays = @pOperatingDays,
		WorkingHours = @pWorkingHours, TotalReceptacles = @pTotalReceptacles, CleanableArea = @pCleaningArea,
		NoOfHandWashingFacilities = @pNoOfHandWashingFacilities, NoOfbeds = @pNoOfBeds, HospitalRepresentative = @pHospitalRepresentative,
		HospitalRepresentativeDesignation = @pHospitalRepresentativeDesignation , CompanyRepresentative = @pCompanyRepresentative,
		CompanyRepreSentativeDesignation = @pCompanyRepresentativeDesignation , EffectiveFromDate = @pEffectiveFromDate,
		EffectiveToDate = @pEffectiveToDate, JISchedule = @pJISchedule, Remarks = @pRemarks
		 WHERE UserAreaId = @pUserAreaId
		
		SELECT *  FROM CLS_DeptAreaDetails WHERE UserAreaCode = @pUserAreaCode;

	END

END TRY
BEGIN CATCH
	INSERT INTO ExceptionLog (
	ErrorLine, ErrorMessage, ErrorNumber,
	ErrorProcedure, ErrorSeverity, ErrorState,
	DateErrorRaised
	)
	SELECT
	ERROR_LINE () as ErrorLine,
	Error_Message() as ErrorMessage,
	Error_Number() as ErrorNumber,
	Error_Procedure() as 'sp_CLS_DeptAreaDetailsSave',
	Error_Severity() as ErrorSeverity,
	Error_State() as ErrorState,
	GETDATE () as DateErrorRaised

	--SELECT 0 AS 'NEWID'
END CATCH
END
GO
