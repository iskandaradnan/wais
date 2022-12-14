USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_TreatmentPlant]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_TreatmentPlant]
(@TreatmentPlantCode nvarchar(MAX),@TreatmentPlantName nvarchar(MAX),@RegistrationNo nvarchar(MAX),@AdressLine nvarchar(MAX),@AdressLines nvarchar(MAX),@City nvarchar(MAX),@State nvarchar(MAX),@PostCode nvarchar(MAX),@Ownership nvarchar(MAX),@ContactNumber nvarchar(MAX),@FaxNumber nvarchar(MAX),@DOEFileNo nvarchar(MAX),@OwnerName nvarchar(MAX),@NumberOfStore nvarchar(MAX),@CapacityOfStorage nvarchar(MAX),@Remarks nvarchar(MAX))
as 
begin
insert into [dbo].[HWMS_TreatmentPlant] values(@TreatmentPlantCode,@TreatmentPlantName,@RegistrationNo,@AdressLine,@AdressLines,@City,@State,@PostCode,@Ownership,@ContactNumber,@FaxNumber,@DOEFileNo,@OwnerName,@NumberOfStore,@CapacityOfStorage,@Remarks)
end
GO
