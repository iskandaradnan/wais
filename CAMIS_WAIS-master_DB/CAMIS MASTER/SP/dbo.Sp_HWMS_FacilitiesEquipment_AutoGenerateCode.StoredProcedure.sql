USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_FacilitiesEquipment_AutoGenerateCode]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_HWMS_FacilitiesEquipment_AutoGenerateCode]
as
begin
SELECT TOP 1 ItemCode FROM HWMS_FacilitiesEquipment order by FetcId desc
end
GO
