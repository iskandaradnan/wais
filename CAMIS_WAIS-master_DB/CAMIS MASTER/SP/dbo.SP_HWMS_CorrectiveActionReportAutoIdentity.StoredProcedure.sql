USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_HWMS_CorrectiveActionReportAutoIdentity]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_HWMS_CorrectiveActionReportAutoIdentity]
as
begin
select Idno from HWMS_CorrectiveActionReportTab order by Idno desc
end
GO
