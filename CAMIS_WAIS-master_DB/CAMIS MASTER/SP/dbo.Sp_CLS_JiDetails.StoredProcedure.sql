USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_JiDetails]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_CLS_JiDetails](@pDetailsId int,
                                    @pCustomerid int,
                                    @pFacilityid int,
                                    @pJIDocumentNo nvarchar(30)='',
                                    @pJIDateTime datetime,
                                    @pUserAreaCode nvarchar(30)='',
                                    @pUserAreaName nvarchar(30)='',
                                    @pHospitalRepresentative nvarchar(30),
                                    @pHospitalRepresentativeDesignation nvarchar(30)='',
                                    @pCompanyRepresentative nvarchar(30),
                                    @pCompanyRepresentativeDesignation nvarchar(30)='',
                                    @pRemarks nvarchar(100)='',
                                    @pRefereceNo nvarchar(30)='',
									@pSatisfactory int,
                                    @pNoOfUserLocations int,
							        @pUnSatisfactory int,
								    @pGrandTotal int,
									@pNotApplicable int)

AS
BEGIN
SET NOCOUNT ON;
BEGIN TRY
 IF(@pDetailsId = 0)
  BEGIN
insert into [dbo].[CLS_JiDetails]  values (
                                            @pCustomerid,
                                            @pFacilityid,
                                            @pJIDocumentNo,
                                           @pJIDateTime,
										   @pUserAreaCode,
										   @pUserAreaName,
										   @pHospitalRepresentative,
										   @pHospitalRepresentativeDesignation,
										   @pCompanyRepresentative,
										   @pCompanyRepresentativeDesignation,
										   @pRemarks,
										   @pRefereceNo,
										   @pSatisfactory,
                                           @pNoOfUserLocations,
										   @pUnSatisfactory,
										   @pGrandTotal,
										   @pNotApplicable,
										   0)
 
select MAX(DetailsId) as DetailsId from CLS_JiDetails
select *from CLS_JiDetails
END
 ELSE
	BEGIN
		-- UPDATE
		UPDATE CLS_JiDetails SET DocumentNo=@pJIDocumentNo,DateTime=@pJIDateTime,UserAreaCode=@pUserAreaCode,UserAreaName=@pUserAreaName,
		HospitalRepresentative=@pHospitalRepresentative,HospitalRepresentativeDesignation=@pHospitalRepresentativeDesignation,
		CompanyRepresentative=@pCompanyRepresentative,CompanyRepresentativeDesignation=@pCompanyRepresentativeDesignation,
		Remarks=@pRemarks,ReferenceNo=@pRefereceNo,Satisfactory=@pSatisfactory,NoofUserLocation=@pNoOfUserLocations,
		UnSatisfactory=@pUnSatisfactory,GrandTotalElementsInspected=@pGrandTotal,NotApplicable=@pNotApplicable
		where DetailsId=@pDetailsId

		DELETE CLS_JiDetails_LocationCode WHERE DetailsId = @pDetailsId
		
		SELECT @pDetailsId as DetailsId
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
	Error_Procedure() as 'Sp_CLS_JIDetails',
	Error_Severity() as ErrorSeverity,
	Error_State() as ErrorState,
	GETDATE () as DateErrorRaised

	--SELECT 0 AS 'NEWID'
END CATCH
END
GO
