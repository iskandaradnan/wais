USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_CLS_DeptAreaDetailsDisplayUserAreaName]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_CLS_DeptAreaDetailsDisplayUserAreaName](@pUserAreaCode varchar(25))
as
begin 
select UserAreaName,ActiveFromDate from MstLocationUserArea where UserAreaCode=@pUserAreaCode
end
GO
