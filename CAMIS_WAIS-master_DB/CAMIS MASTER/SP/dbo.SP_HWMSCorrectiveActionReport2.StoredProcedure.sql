USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_HWMSCorrectiveActionReport2]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
CREATE procedure [dbo].[SP_HWMSCorrectiveActionReport2]  
(@Indicator varchar(max),@CARDate varchar(max),@Assigne varchar(80),@Problemstatement varchar(max),@Rootcause varchar(max),  
@solution varchar(max),@priority varchar(80),@Issuer varchar(80),@Cartargetdate varchar(max),@Remarks varchar(max)  
)  
as  
begin  
insert into HWMS_CAR values(@Indicator,@CARDate,@Assigne,@Problemstatement,@Rootcause,@solution,@priority,@Issuer,@Cartargetdate,@Remarks)  
  
  
end  
GO
