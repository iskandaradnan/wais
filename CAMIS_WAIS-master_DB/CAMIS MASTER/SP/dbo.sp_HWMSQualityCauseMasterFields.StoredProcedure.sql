USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_HWMSQualityCauseMasterFields]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_HWMSQualityCauseMasterFields]  
(@FailureSystemCode varchar(max),@Description varchar(max))  
as  
  
begin  
insert into HWMS_QualityCauseMASTER1 values(@FailureSystemCode,@Description)  
end  
GO
