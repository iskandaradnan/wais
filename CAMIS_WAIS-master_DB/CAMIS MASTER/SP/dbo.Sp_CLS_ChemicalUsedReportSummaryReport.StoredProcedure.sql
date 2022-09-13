USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_ChemicalUsedReportSummaryReport]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_CLS_ChemicalUsedReportSummaryReport]
as
begin
select Category, AreaOfApplication,ChemicalName,
KMMNo,Properties,Status,EffectiveDate from CLS_ChemicalInUseTable
end
GO
