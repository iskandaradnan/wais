USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_HWMS_ConsignmentNoteOSWCNAutoDisplay]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[SP_HWMS_ConsignmentNoteOSWCNAutoDisplay](@OSWRepresentative varchar(max))
as
begin
select OSWRepresentativeDesignation from ConsignmentNoteOSWCN where OSWRepresentative=@OSWRepresentative
end
GO
