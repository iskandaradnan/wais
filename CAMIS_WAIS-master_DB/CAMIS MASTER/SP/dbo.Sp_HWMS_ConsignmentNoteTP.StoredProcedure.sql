USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_ConsignmentNoteTP]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[Sp_HWMS_ConsignmentNoteTP](@pTreatmentPlant varchar(max))
as
begin
select Ownership from HWMS_ConsignmentNoteCWCN where TreatmentPlant=@pTreatmentPlant
end
GO
