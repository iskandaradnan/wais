USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_IncidentReport]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Sp_HWMS_IncidentReport](@CMRRequestNum bigint,@ReportSent varchar(max),@IncidentCategory varchar(max),
@PartiesInvolved varchar(max),@CriteriaofCriticalEvent varchar(max),@Events varchar(max),@IncidentDescription varchar(max),
@FindingRootCause varchar(max),@ImmediateActionTaken varchar(max))
as
begin 
insert into HWMS_IncidentReport values(@CMRRequestNum,@ReportSent,@IncidentCategory,@PartiesInvolved,@CriteriaofCriticalEvent,
@Events,@IncidentDescription,@FindingRootCause,@ImmediateActionTaken)
end
GO
