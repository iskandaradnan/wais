USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_HWMS_ConsignmentNoteOSWCNTab]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_HWMS_ConsignmentNoteOSWCNTab]
(
@ConsignmentNoteNo int,@DateTime datetime,@TotalEst int,@TotalNoofPackaging int,@OSWRepresentative varchar(MAX),
@OSWRepresentativeDesignation varchar(MAX),@HospitalRepresentative varchar(max),@HospitalRepresentativeDesignation varchar(max),
@TreatmentPlant varchar(max),@Ownership varchar(max),@VehicleNo varchar(max),@DriverName varchar(max),@WasteType varchar(max),
@WasteCode varchar(max),@ChargeRM int,@ReturnValueRM int,@TransportationCategory varchar(max),@Remarks varchar(max),@StartDate datetime,
@EndDate datetime,@UserAreaCode varchar(max),@UserAreaName varchar(max),@OSWRSNo varchar(max)
)
as
begin
insert into ConsignmentNoteOSWCN values(@ConsignmentNoteNo,@DateTime,@TotalEst,@TotalNoofPackaging,@OSWRepresentative,@OSWRepresentativeDesignation,
@HospitalRepresentative,@HospitalRepresentativeDesignation,@TreatmentPlant,@Ownership,@VehicleNo,@DriverName,@WasteType,@WasteCode,
@ChargeRM,@ReturnValueRM,@TransportationCategory,@Remarks,@StartDate,@EndDate,@UserAreaCode,@UserAreaName,@OSWRSNo)
end
GO
