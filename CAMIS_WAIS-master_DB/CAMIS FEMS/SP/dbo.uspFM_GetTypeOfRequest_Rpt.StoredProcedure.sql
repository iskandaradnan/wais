USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_GetTypeOfRequest_Rpt]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
EXEC [UET_Ds_GetTypeOfRequest] 132
*/
CREATE Procedure [dbo].[uspFM_GetTypeOfRequest_Rpt]
(@RequestType varchar(20) = null)
As
BEGIN

  if (@RequestType = 'null')
  begin
    set @RequestType=''
  end
   select fieldvalue as RequestType,lovid from FMLovMst
where LovKey='CRMRequestTypeValue' and lovid=@RequestType

END
GO
