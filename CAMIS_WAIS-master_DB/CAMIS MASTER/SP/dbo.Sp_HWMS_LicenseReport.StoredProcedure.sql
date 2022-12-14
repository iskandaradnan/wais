USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_LicenseReport]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Sp_HWMS_LicenseReport]
AS
BEGIN
SELECT
[LicenseCode],[LicenseDescription],C.FieldValue AS LicenseType
		FROM		HWMS_LicenseTypeSave A 
		INNER JOIN HWMS_LicenseTypeTableSave B ON A.LicenseTypeId = A.LicenseTypeId
		LEFT JOIN FMLovMst C ON A.LicenseType = C.LovId 
END

GO
