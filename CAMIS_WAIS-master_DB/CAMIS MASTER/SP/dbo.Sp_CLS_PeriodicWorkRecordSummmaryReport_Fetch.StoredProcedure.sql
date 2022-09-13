USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_PeriodicWorkRecordSummmaryReport_Fetch]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_CLS_PeriodicWorkRecordSummmaryReport_Fetch]
(
@Year int,
@Month varchar(max)
)
as begin
select Hospital,Year,Month,UserAreaCode,UserArea,Done,NotDone from CLS_PeriodicWorkRecordSummmaryReport_DuplicateData where Year=@Year and Month=@Month
end
GO
