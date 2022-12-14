USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_ConsignmentNoteOSWCN_Save]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Sp_HWMS_ConsignmentNoteOSWCN_Save]
(
		@ConsignmentOSWCNId int,
		@CustomerId INT,
		@FacilityId INT,
		@ConsignmentNoteNo nvarchar(30),@DateTime datetime,@TotalEst int,@TotalNoofPackaging int,@OSWRepresentative nvarchar(30),
        @OSWRepresentativeDesignation nvarchar(30) =null,@HospitalRepresentative nvarchar(30),@HospitalRepresentativeDesignation nvarchar(30) =null,
        @TreatmentPlant nvarchar(30),@Ownership nvarchar(30) =null,@VehicleNo nvarchar(30),@DriverName nvarchar(30),@WasteType nvarchar(30),
        @WasteCode nvarchar(30),@ChargeRM int =null,@ReturnValueRM int =null,@TransportationCategory nvarchar(30) =null,@TotalWeight nvarchar(30) =null,@Remarks nvarchar(100)='NULL',@StartDate datetime,
        @EndDate datetime
		)
				
AS
BEGIN 
SET NOCOUNT ON; 

BEGIN TRY
IF(@ConsignmentOSWCNId = 0)
	BEGIN
	    IF(EXISTS(SELECT 1 FROM HWMS_ConsignmentNoteOSWCN WHERE CustomerId = @CustomerId and FacilityId = @FacilityId and ConsignmentNoteNo = @ConsignmentNoteNo))
	       BEGIN
		       SELECT -1 AS ConsignmentOSWCNId
	       END
	   ELSE
	       BEGIN
		        INSERT INTO HWMS_ConsignmentNoteOSWCN (CustomerId, FacilityId, ConsignmentNoteNo, DateTime, TotalEst, TotalNoofPackaging, OSWRepresentative, OSWRepresentativeDesignation,
			    HospitalRepresentative, HospitalRepresentativeDesignation, TreatmentPlant, Ownership, VehicleNo, DriverName, WasteType, WasteCode, ChargeRM, ReturnValueRM, TransportationCategory,
			    TotalWeight, Remarks, StartDate, EndDate)
				VALUES (@CustomerId, @FacilityId, @ConsignmentNoteNo,@DateTime,@TotalEst,@TotalNoofPackaging,@OSWRepresentative,@OSWRepresentativeDesignation,
                @HospitalRepresentative,@HospitalRepresentativeDesignation,@TreatmentPlant,@Ownership,@VehicleNo,@DriverName,@WasteType,@WasteCode,
                @ChargeRM,@ReturnValueRM,@TransportationCategory,@TotalWeight, @Remarks,@StartDate,@EndDate)

				SELECT MAX(ConsignmentOSWCNId) as ConsignmentOSWCNId FROM HWMS_ConsignmentNoteOSWCN
		   END
    END
ELSE
    BEGIN
	    UPDATE HWMS_ConsignmentNoteOSWCN SET ConsignmentNoteNo=@ConsignmentNoteNo, DateTime=@DateTime,TotalEst=@TotalEst,TotalNoofPackaging=@TotalNoofPackaging,
		OSWRepresentative=@OSWRepresentative,HospitalRepresentative= @HospitalRepresentative,TreatmentPlant=@TreatmentPlant,VehicleNo=@VehicleNo, DriverName=@DriverName,WasteType= @WasteType,
		ChargeRM=@ChargeRM,ReturnValueRM=@ReturnValueRM,TransportationCategory=@TransportationCategory,TotalWeight=@TotalWeight,Remarks=@Remarks,StartDate=@StartDate,EndDate=@EndDate
		WHERE ConsignmentOSWCNId = @ConsignmentOSWCNId 
		 SELECT @ConsignmentOSWCNId as ConsignmentOSWCNId
	END
			
END TRY 
BEGIN CATCH  

	INSERT INTO ExceptionLog (  
	ErrorLine, ErrorMessage, ErrorNumber,  
	ErrorProcedure, ErrorSeverity, ErrorState,  
	DateErrorRaised  )  
	SELECT  
	ERROR_LINE () as ErrorLine,  
	Error_Message() as ErrorMessage,  
	Error_Number() as ErrorNumber,  
	Error_Procedure() as 'Sp_HWMS_ConsignmentNoteOSWCN_Save',  
	Error_Severity() as ErrorSeverity,  
	Error_State() as ErrorState,  
	GETDATE () as DateErrorRaised  

	SELECT 'Error occured while inserting'
END CATCH 
END
						
GO
