USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_HWMSCorrectiveActionReport3]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_HWMSCorrectiveActionReport3](@Activity varchar(80),@StartDate varchar(max),@TargetDate varchar(max),  
@Responsibility varchar(max)  
)  
as   
begin  
insert into HWMS_CAR1 values(@Activity,@StartDate,@TargetDate,@Responsibility)  
  
  
  
end  
GO
