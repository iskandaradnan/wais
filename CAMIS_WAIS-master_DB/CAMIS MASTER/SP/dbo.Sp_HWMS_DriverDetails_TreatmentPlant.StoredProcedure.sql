USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_DriverDetails_TreatmentPlant]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_HWMS_DriverDetails_TreatmentPlant]
as
begin
select TreatmentPlantName from HWMS_TreatementPlant
end

GO
