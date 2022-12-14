USE [UetrackBemsdbPreProd]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_DisplayTypeCode]    Script Date: 20-09-2021 17:09:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_DisplayTypeCode]
(
	@Type_Code	INT
)
  RETURNS VARCHAR(1000) WITH SCHEMABINDING 
  AS
  BEGIN
	
	DECLARE @Asset_Type_Code VARCHAR(300)
	--  select * from MstService

	SELECT @Asset_Type_Code = AssetTypeCode
	FROM DBO.EngAssetTypeCode (nolock)	WHERE Active=0
	AND ServiceId=2 AND AssetTypeCodeId = @Type_Code
	RETURN @Asset_Type_Code

  END
GO
