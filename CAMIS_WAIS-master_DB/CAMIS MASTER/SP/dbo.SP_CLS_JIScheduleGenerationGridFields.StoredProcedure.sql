USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_CLS_JIScheduleGenerationGridFields]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_CLS_JIScheduleGenerationGridFields](
@Year varchar(20),@Month varchar(20),@Week varchar(20),
@DocumentNo varchar(100),@UserAreaCode varchar(50),@UserAreaName varchar(50),@Day varchar(20),@TargetDate varchar(20),@Status int)
as
begin
insert into CLS_JIScheduleGenerationFields values(@Year,@Month,@Week,@DocumentNo,@UserAreaCode,@UserAreaName,@Day,
@TargetDate,@Status)
end
GO
