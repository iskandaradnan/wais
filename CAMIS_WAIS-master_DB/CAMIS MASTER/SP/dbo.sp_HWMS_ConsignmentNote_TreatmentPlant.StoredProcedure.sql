USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_HWMS_ConsignmentNote_TreatmentPlant]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_HWMS_ConsignmentNote_TreatmentPlant]      
    
AS    
    
BEGIN    
    
SELECT TreatmentPlantId, TreatmentPlantName FROM HWMS_TreatementPlant      
    
END
GO
