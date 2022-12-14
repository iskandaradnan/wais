USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_JointInspectionSummaryReport_Fetch]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_CLS_JointInspectionSummaryReport_Fetch]
(@Year int,
@Month varchar(max)
)
as
begin
select Hospital,Year,Month,UserAreaCode,UserArea,InspectionScheduled,Compliance,NonCompliance,NoofTotalRatings,NoofUserLocationInspected from CLS_JointInspectionSummaryReportFetch where Month=@Month and Year=@Year

end
GO
