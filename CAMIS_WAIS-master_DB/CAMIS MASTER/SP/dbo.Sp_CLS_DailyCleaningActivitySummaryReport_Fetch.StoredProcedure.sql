USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_DailyCleaningActivitySummaryReport_Fetch]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_CLS_DailyCleaningActivitySummaryReport_Fetch]
(@Year int,
@Month varchar(max)
)
as begin
select Hospital,Year,Month,UserAreaCode,UserArea,A1,A2,A3,A4,A5,B1,C1,D1,D2,D3,D4,E1 from CLS_DailyCleaningActivitySummaryReportFetch where Month=@Month and Year=@Year
end
GO
