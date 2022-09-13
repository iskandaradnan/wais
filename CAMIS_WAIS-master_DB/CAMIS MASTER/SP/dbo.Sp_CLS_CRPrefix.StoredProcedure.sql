USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_CRPrefix]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_CLS_CRPrefix]
@pCompanyRepresentative nvarchar(MAX)
as
begin

select DISTINCT CompanyRepresentative from CLS_JiDetails where [CompanyRepresentative] like '%'+@pCompanyRepresentative+'%'

end
GO
