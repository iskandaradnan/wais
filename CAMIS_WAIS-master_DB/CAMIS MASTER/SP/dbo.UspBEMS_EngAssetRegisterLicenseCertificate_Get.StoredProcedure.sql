USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspBEMS_EngAssetRegisterLicenseCertificate_Get]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[UspBEMS_EngAssetRegisterLicenseCertificate_Get]
(
	@Id INT
)
	
AS 

-- Exec [GetUserRole] 

--/*=====================================================================================================================
--APPLICATION		: UETrack
--NAME				: GetUserRole
--DESCRIPTION		: GET USER ROLE FOR THE GIVEN ID
--AUTHORS			: Sairaj
--DATE				: 20-March-2018
-------------------------------------------------------------------------------------------------------------------------
--VERSION HISTORY 
--------------------:---------------:---------------------------------------------------------------------------------------
--Init				: Date          : Details
--------------------:---------------:---------------------------------------------------------------------------------------
--Sairaj           : 20-March-2018 : 
-------:------------:----------------------------------------------------------------------------------------------------*/
BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY
	
	SELECT	LicenseandCertificate.LicenseId,
			LicenseandCertificate.FacilityId,
			Facility.FacilityName,
			LicenseandCertificate.LicenseNo,
			LicenseandCertificate.NotificationForInspection,
			LicenseandCertificate.InspectionConductedOn,
			LicenseandCertificate.NextInspectionDate,
			LicenseandCertificate.ExpireDate,
			LicenseandCertificate.IssuingBody,
			IssuingBody.IssuingBodyName,
			LicenseandCertificate.IssuingDate,
			LicenseandCertificateDet.Remarks			
	FROM	EngLicenseandCertificateTxn AS LicenseandCertificate
			INNER JOIN EngLicenseandCertificateTxnDet AS LicenseandCertificateDet ON  LicenseandCertificateDet.LicenseId = LicenseandCertificate.LicenseId
			INNER JOIN MstLocationFacility AS Facility ON LicenseandCertificate.FacilityId = Facility.FacilityId
			LEFT JOIN MstIssuingBody AS IssuingBody ON LicenseandCertificate.IssuingBody = IssuingBody.IssuingBodyId
	WHERE	LicenseandCertificateDet.AssetId = @Id
	
END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
