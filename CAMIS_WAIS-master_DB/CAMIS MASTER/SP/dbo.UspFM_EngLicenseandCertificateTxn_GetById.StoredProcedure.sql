USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngLicenseandCertificateTxn_GetById]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_EngLicenseandCertificateTxn_GetById
Description			: To Get the data from table EngLicenseandCertificateTxn using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_EngLicenseandCertificateTxn_GetById] @pLicenseId=50
SELECT * FROM EngLicenseandCertificateTxn
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[UspFM_EngLicenseandCertificateTxn_GetById]                           

  @pLicenseId		INT

AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	IF(ISNULL(@pLicenseId,0) = 0) RETURN

    SELECT	LicenseandCertificate.LicenseId							AS LicenseId,
			LicenseandCertificate.CustomerId						AS CustomerId,
			LicenseandCertificate.FacilityId						AS FacilityId,
			LicenseandCertificate.ServiceId							AS ServiceId,
			ServiceKey.ServiceKey									AS ServiceName,
			LicenseandCertificate.LicenseNo							AS LicenseNo,
			LicenseandCertificate.LicenseDescription				AS LicenseDescription,
			LicenseandCertificate.Status							AS Status,
			StatusValue.FieldValue									AS StatusValue,
			LicenseandCertificate.Category							AS Category,
			CategoryValue.FieldValue								AS CategoryValue,
			LicenseandCertificate.IfOthersSpecify					AS IfOthersSpecify,
			LicenseandCertificate.Type								AS Type,
			TypeValue.FieldValue									AS TypeValue,
			LicenseandCertificate.ClassGrade						AS ClassGrade,
			LicenseandCertificate.ContactPersonUserId				AS ContactPersonStaffId,
			ContactPerson.StaffName									AS ContactPersonName,
			LicenseandCertificate.IssuingBody						AS IssuingBody,
			IssuingBodyValue.FieldValue								AS IssuingBodyValue,
			LicenseandCertificate.IssuingDate						AS IssuingDate,
			LicenseandCertificate.IssuingDateUTC					AS IssuingDateUTC,
			LicenseandCertificate.NotificationForInspection			AS NotificationForInspection,
			LicenseandCertificate.NotificationForInspectionUTC		AS NotificationForInspectionUTC,
			LicenseandCertificate.InspectionConductedOn				AS InspectionConductedOn,
			LicenseandCertificate.InspectionConductedOnUTC			AS InspectionConductedOnUTC,
			LicenseandCertificate.NextInspectionDate				AS NextInspectionDate,
			LicenseandCertificate.NextInspectionDateUTC				AS NextInspectionDateUTC,
			LicenseandCertificate.[ExpireDate]						AS [ExpireDate],
			LicenseandCertificate.ExpireDateUTC						AS ExpireDateUTC,
			LicenseandCertificate.PreviousExpiryDate				AS PreviousExpiryDate,
			LicenseandCertificate.PreviousExpiryDateUTC				AS PreviousExpiryDateUTC,
			LicenseandCertificate.RegistrationNo					AS RegistrationNo,
			LicenseandCertificate.Timestamp							AS [Timestamp],
			LicenseandCertificate.GuId
	FROM	EngLicenseandCertificateTxn								AS LicenseandCertificate			WITH(NOLOCK)
			INNER JOIN  MstService									AS ServiceKey						WITH(NOLOCK)			on LicenseandCertificate.ServiceId				= ServiceKey.ServiceId
			LEFT  JOIN	UMUserRegistration							AS ContactPerson					WITH(NOLOCK)			on LicenseandCertificate.ContactPersonUserId	= ContactPerson.UserRegistrationId
			LEFT  JOIN	FMLovMst									AS StatusValue						WITH(NOLOCK)			on LicenseandCertificate.Status					= StatusValue.LovId
			LEFT  JOIN	FMLovMst									AS CategoryValue					WITH(NOLOCK)			on LicenseandCertificate.Category				= CategoryValue.LovId
			LEFT  JOIN	FMLovMst									AS TypeValue						WITH(NOLOCK)			on LicenseandCertificate.Type					= TypeValue.LovId
			LEFT  JOIN	FMLovMst									AS IssuingBodyValue					WITH(NOLOCK)			on LicenseandCertificate.IssuingBody			= IssuingBodyValue.LovId
	WHERE	LicenseandCertificate.LicenseId = @pLicenseId 
	ORDER BY LicenseandCertificate.ModifiedDate ASC

	DECLARE @mCategory INT
	SET @mCategory = (SELECT Category FROM EngLicenseandCertificateTxn WHERE LicenseId = @pLicenseId)


	IF(@mCategory=144)
	BEGIN



		SELECT 	LicenseandCertificate.LicenseId							AS LicenseId,
				LicenseandCertificateTxnDet.LicenseDetId				AS LicenseDetId,
				LicenseandCertificateTxnDet.AssetId						AS AssetId,
				Asset.AssetNo											AS Asset,
				Asset.AssetDescription									AS AssetDescription,
				LicenseandCertificateTxnDet.Remarks						AS Remarks
		FROM	EngLicenseandCertificateTxn								AS LicenseandCertificate			WITH(NOLOCK)
				INNER JOIN  EngLicenseandCertificateTxnDet				AS LicenseandCertificateTxnDet		WITH(NOLOCK)			on LicenseandCertificate.LicenseId				= LicenseandCertificateTxnDet.LicenseId
				INNER  JOIN	EngAsset									AS Asset							WITH(NOLOCK)			on LicenseandCertificateTxnDet.AssetId			= Asset.AssetId
		WHERE	LicenseandCertificate.LicenseId = @pLicenseId 
	
	END

	ELSE IF(@mCategory=146)
	BEGIN


		SELECT 	LicenseandCertificate.LicenseId							AS LicenseId,
				LicenseandCertificateTxnDet.LicenseDetId				AS LicenseDetId,
				LicenseandCertificateTxnDet.UserId						AS UserId,
				LicenseandCertificateTxnDet.StaffName					AS StaffName,
				LicenseandCertificateTxnDet.Designation,
				LicenseandCertificateTxnDet.Remarks						AS Remarks
		FROM	EngLicenseandCertificateTxn								AS LicenseandCertificate			WITH(NOLOCK)
				INNER JOIN  EngLicenseandCertificateTxnDet				AS LicenseandCertificateTxnDet		WITH(NOLOCK)	ON LicenseandCertificate.LicenseId				= LicenseandCertificateTxnDet.LicenseId
		WHERE	LicenseandCertificate.LicenseId = @pLicenseId 
	END
END TRY

BEGIN CATCH

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   )

END CATCH
GO
