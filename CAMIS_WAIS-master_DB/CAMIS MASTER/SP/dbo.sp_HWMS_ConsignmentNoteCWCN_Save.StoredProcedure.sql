USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_HWMS_ConsignmentNoteCWCN_Save]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROC [dbo].[sp_HWMS_ConsignmentNoteCWCN_Save](
        @ConsignmentId int,@CustomerId int,@FacilityId int,		
		@ConsignmentNoteNo nvarchar(100),@DateTime datetime,@OnSchedule nvarchar(100) =null,
		@QC nvarchar(100) = NULL, @CWRepresentative nvarchar(100),@CWRepresentativeDesignation nvarchar(100) =null,
        @HospitalRepresentative nvarchar(100),@HospitalRepresentativeDesignation nvarchar(100) =null,
		@TreatmentPlantName nvarchar(100),@Ownership nvarchar(100) =null,@VehicleNo nvarchar(100),
		@DriverCode nvarchar(100),@DriverName nvarchar(100) = NULL,@TotalNoOfBins nvarchar(100) =null,
        @TotalEst nvarchar(100) =null,@Remarks nvarchar(100)= NULL )
AS
BEGIN
SET NOCOUNT ON;		

BEGIN TRY
IF(@ConsignmentId = 0)
BEGIN
    IF(EXISTS(SELECT 1 FROM HWMS_ConsignmentNoteCWCN WHERE CustomerId = @CustomerId and FacilityId = @FacilityId and ConsignmentNoteNo = @ConsignmentNoteNo))
	   BEGIN
		   SELECT -1 AS ConsignmentId
	   END
	ELSE
	   BEGIN
			INSERT INTO HWMS_ConsignmentNoteCWCN (CustomerId, FacilityId, ConsignmentNoteNo, DateTime, OnSchedule, QC, CWRepresentative, CWRepresentativeDesignation,
			HospitalRepresentative, HospitalRepresentativeDesignation, TreatmentPlantName, Ownership, VehicleNo, DriverCode, DriverName, TotalNoOfBins, TotalEst, Remarks)
			VALUES(@CustomerId,@FacilityId,@ConsignmentNoteNo,@DateTime,@OnSchedule,@QC,@CWRepresentative,@CWRepresentativeDesignation,@HospitalRepresentative,
			@HospitalRepresentativeDesignation,@TreatmentPlantName, @Ownership,@VehicleNo,@DriverCode,@DriverName,@TotalNoOfBins,@TotalEst,@Remarks)

			SELECT MAX(ConsignmentId) as ConsignmentId FROM HWMS_ConsignmentNoteCWCN
	   END
END
ELSE
    BEGIN
        UPDATE HWMS_ConsignmentNoteCWCN SET ConsignmentNoteNo = @ConsignmentNoteNo, DateTime = @DateTime, OnSchedule =@OnSchedule,
		QC =@QC, CWRepresentative =@CWRepresentative, CWRepresentativeDesignation =@CWRepresentativeDesignation,  HospitalRepresentative =@HospitalRepresentative,
		HospitalRepresentativeDesignation =@HospitalRepresentativeDesignation, TreatmentPlantName =@TreatmentPlantName, Ownership =@Ownership, VehicleNo =@VehicleNo, DriverCode =@DriverCode, 
		DriverName =@DriverName, TotalNoOfBins =@TotalNoOfBins, TotalEst =@TotalEst, Remarks=@Remarks
	    WHERE ConsignmentId=@ConsignmentId	
		
		 SELECT @ConsignmentId as ConsignmentId
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
	Error_Procedure() as 'sp_HWMS_ConsignmentNoteCWCN_Save',
	Error_Severity() as ErrorSeverity,
	Error_State() as ErrorState,
	GETDATE () as DateErrorRaised
END CATCH
END
GO
