USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_HWMS_CorrectiveActionReportAutoDisplay]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_HWMS_CorrectiveActionReportAutoDisplay]
as
begin
select CARGeneration,CARPeriod,CARPeriodTo,Followupcar,Verfieddate,Verifiedby from HWMS_CorrectiveActionReportTab where Idno=1
end
GO
