USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_HWMSQualityCauseMasterTable]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_HWMSQualityCauseMasterTable]  
(@FailureType varchar(max),  
@FailureRootCauseCode varchar(max),  
@Details varchar(max),  
@Status varchar(max),  
@Idno int)  
as  
begin  
insert into HWMS_QualityCauseMASTER2 values(@FailureType,@FailureRootCauseCode,@Details,@Status,@Idno )  
end  
GO
