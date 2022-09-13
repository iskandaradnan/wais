USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_HWMSCARDesible]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_HWMSCARDesible](@CARGeneration varchar(max),@CARNo varchar(max),@CARPeriod varchar(max),@FollowUpCar varchar(max)  
,@Status varchar(max),@VerifiedDate varchar(max),@VerifiedBy varchar(max)  
)  
as  
begin  
  
insert into HWMS_CARDesible values(@CARGeneration,@CARNo,@CARPeriod,@FollowUpCar,@Status,@VerifiedDate,@VerifiedBy)  
end  
GO
