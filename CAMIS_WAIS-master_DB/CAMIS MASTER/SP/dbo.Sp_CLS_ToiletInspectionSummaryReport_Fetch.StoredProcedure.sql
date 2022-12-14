USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_ToiletInspectionSummaryReport_Fetch]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_CLS_ToiletInspectionSummaryReport_Fetch]
(
@Year int,
@Month varchar(max)
)
as begin 
select Hospital,Month,Year,TotalToiletLocation,TotalDone,TotalNotDone from CLS_ToiletInspectionSummaryReport_DiplicateData where Year=@Year and Month=@Month
end
GO
