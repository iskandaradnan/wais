USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_AutoComplete]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_AutoComplete]
(
@prefix varchar(max)
)
as begin
select Name from ConsignmentNote_Prefix where Name like '%'+@prefix+'%'
end
GO
