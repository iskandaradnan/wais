USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_CARAutoIdentity]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_CLS_CARAutoIdentity]
as begin 
select CARId from CLS_CorrectiveActionReport order by CARId desc
end
GO
