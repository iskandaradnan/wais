USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_WasteCategoryList]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[Sp_HWMS_WasteCategoryList]
as
begin
select WasteCategory from HWMs_WasteTypeDetails
end
GO
