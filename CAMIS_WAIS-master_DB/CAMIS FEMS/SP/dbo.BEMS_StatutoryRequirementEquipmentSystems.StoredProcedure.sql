USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[BEMS_StatutoryRequirementEquipmentSystems]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		BABULAL.S
-- Create date: 05-08-2016
-- Description:	BEMS_StatutoryRequirementEquipmentSystems
---exec dbo.BEMS_StatutoryRequirementEquipmentSystems 85,2018
-- =============================================

CREATE PROCEDURE [dbo].[BEMS_StatutoryRequirementEquipmentSystems]
 @HospitalId int,
 @Year int
AS
BEGIN
SET NOCOUNT ON;
        
		--For New scenario for CheckBox in Screen
		DECLARE @XMLData AS XML, @hDoc AS INT, @SQL NVARCHAR (MAX)
		SET @XMLData =(select Data from HSIPDownloadTxn where GridId=67)
		EXEC sp_xml_preparedocument @hDoc OUTPUT, @XMLData
		SELECT ReferenceId,IsChecked  into #TrainingScheduleTemp
		FROM OPENXML(@hDoc, '/root/BemsStatutoryRequirement' ,2)
		WITH 
		(
		ReferenceId [varchar](50) ,
		IsChecked [varchar](100) 
		)

		SELECT a.AssetNo,a.AssetDescription,b.AssetTypeCode AS TypeCode,d.LicenseNo AS [CertificateNo],	FORMAT(d.ExpireDate,'dd-MMM-yyyy')AS [CertificateValidity],
		ROW_NUMBER() OVER (ORDER BY A.AssetRegisterId) AS PK_Id ,
	    ISNULL(tmp.IsChecked,'undefined') as IsChecked,
	    a.AssetRegisterId as ReferenceId
		FROM EngAssetRegisterMst AS a
		INNER JOIN [EngAssetTypeCodeMstDet] AS b ON b.AssetTypeCodeId = a.AssetTypeCodeId
		INNER JOIN EngLicenseandCertificateTxnDet AS c ON c.AssetRegisterId = a.AssetRegisterId
		LEFT OUTER JOIN FmsLicenseandCertificateTxn AS d ON d.LicenseId = c.LicenseId
		LEFT OUTER JOIN #TrainingScheduleTemp tmp  ON a.AssetRegisterId = tmp.ReferenceId
		WHERE 
		a.IsDeleted = 0 AND a.HospitalId=@HospitalId AND a.ServiceId =2	--AND YEAR(d.ExpireDate)>@Year --certificate validity next year
		AND a.AssetStatus = 127 AND b.Status = 413 AND c.IsDeleted = 0 AND d.IsDeleted = 0 AND d.Status= 413

END
GO
