USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetTypeCodesServiceMapping_GetById]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--EXEC uspFM_EngAssetTypeCodesServiceMapping_GetById 1101
CREATE PROCEDURE [dbo].[uspFM_EngAssetTypeCodesServiceMapping_GetById]
(
@pAssetTypeCodeId AS INT
)
AS

BEGIN 

SET NOCOUNT ON;          
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;          


SELECT AssetTypeCodeId_mappingTo_SeviceDB
FROM EngAssetTypeCode 
WHERE AssetTypeCodeId=@pAssetTypeCodeId 
AND ISNULL(AssetTypeCodeId_mappingTo_SeviceDB,'')<>''


END
GO
