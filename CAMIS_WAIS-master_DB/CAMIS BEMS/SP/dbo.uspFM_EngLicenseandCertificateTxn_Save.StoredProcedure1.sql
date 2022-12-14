USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngLicenseandCertificateTxn_Save]    Script Date: 30-11-2021 19:12:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE  [dbo].[uspFM_EngLicenseandCertificateTxn_Save]

			@EngLicenseandCertificateTxnDet		AS [dbo].[udtT_EngLicenseandCertificateTxnDet] READONLY,		
			@pUserId							INT					=	NULL,
			@pLicenseId							INT,
			@pCustomerId						INT,
			@pFacilityId						INT,
			@pServiceId							INT,
			@pLicenseNo							NVARCHAR(100),
			@pLicenseDescription				NVARCHAR(500),
			@pStatus							INT					=	NULL,
			@pCategory							INT					=	NULL,
			@pIfOthersSpecify					NVARCHAR(200)		=	NULL,
			@pType								INT					=	NULL,
			@pClassGrade						NVARCHAR(50)		=	NULL,
			@pContactPersonStaffId				INT					=	NULL,
			@pIssuingBody						INT,
			@pIssuingDate						DATETIME,
			@pIssuingDateUTC					DATETIME,
			@pNotificationForInspection			DATETIME			=	NULL,
			@pNotificationForInspectionUTC		DATETIME			=	NULL,
			@pInspectionConductedOn				DATETIME			=	NULL,
			@pInspectionConductedOnUTC			DATETIME			=	NULL,
			@pNextInspectionDate				DATETIME			=	NULL,
			@pNextInspectionDateUTC				DATETIME			=	NULL,
			@pExpireDate						DATETIME			=	NULL,
			@pExpireDateUTC						DATETIME			=	NULL,
			@pPreviousExpiryDate				DATETIME			=	NULL,
			@pPreviousExpiryDateUTC				DATETIME			=	NULL,
			@pRegistrationNo					NVARCHAR(50)		=	NULL,
			@pRemarks							NVARCHAR(1000)		=	NULL,
			@pTimestamp							VARBINARY(200)		=	NULL,
			@pGuId					         	VARBINARY(200)		=	NULL,
			@pAssetTypeCodeId                   INT					=	NULL,
			@pAssetTypeCode                   NVARCHAR(50)					=	NULL
AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)
	DECLARE @TableDet TABLE (ID INT)

-- Default Values


-- Execution
	IF EXISTS(SELECT 1 FROM @EngLicenseandCertificateTxnDet WHERE ( AssetId = 0 OR AssetId is null )AND @pCategory = 144)
	BEGIN

			SELECT				0 AS LicenseId,
								CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS  [timestamp],
								'Please Enter Valid Asset No.'	ErrorMessage


	END

	ELSE
	BEGIN

    IF(ISNULL(@pLicenseId,0)=0 OR @pLicenseId='')

	BEGIN

		DECLARE @Cnt INT;

			SELECT	@Cnt = COUNT(1) 
			FROM	EngLicenseandCertificateTxn 
			WHERE	LicenseNo = @pLicenseNo


		IF (@Cnt = 0) 

		BEGIN
	          INSERT INTO EngLicenseandCertificateTxn(
													CustomerId,
													FacilityId,
													ServiceId,
													LicenseNo,
													LicenseDescription,
													Status,
													Category,
													IfOthersSpecify,
													Type,
													ClassGrade,
													ContactPersonUserId,
													IssuingBody,
													IssuingDate,
													IssuingDateUTC,
													NotificationForInspection,
													NotificationForInspectionUTC,
													InspectionConductedOn,
													InspectionConductedOnUTC,
													NextInspectionDate,
													NextInspectionDateUTC,
													ExpireDate,
													ExpireDateUTC,
													PreviousExpiryDate,
													PreviousExpiryDateUTC,
													RegistrationNo,
													Remarks,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC,
													Guid,
													AssetTypeCodeId
                           )OUTPUT INSERTED.LicenseId INTO @Table
			  VALUES								(
													@pCustomerId,
													@pFacilityId,
													@pServiceId,
													@pLicenseNo,
													@PLicenseDescription,
													@pStatus,
													@pCategory,
													@pIfOthersSpecify,
													@pType,
													@pClassGrade,
													@pContactPersonStaffId,
													@pIssuingBody,
													@pIssuingDate,
													@pIssuingDateUTC,
													@pNotificationForInspection,
													@pNotificationForInspectionUTC,
													@pInspectionConductedOn,
													@pInspectionConductedOnUTC,
													@pNextInspectionDate,
													@pNextInspectionDateUTC,
													@pExpireDate,
													@pExpireDateUTC,
													@pPreviousExpiryDate,
													@pPreviousExpiryDateUTC,
													@pRegistrationNo,
													@pRemarks,
													@pUserId,													
													GETDATE(), 
													GETUTCDATE(),
													@pUserId,													
													GETDATE(), 
													GETUTCDATE(),
													NEWID(),
													@pAssetTypeCodeId
													)
			Declare @mPrimaryId int= (select LicenseId from EngLicenseandCertificateTxn WHERE	LicenseId IN (SELECT ID FROM @Table))

			--SET IDENTITY_INSERT tableA ON
			INSERT INTO EngLicenseandCertificateTxn_History
			(
													LicenseId,
													CustomerId,
													FacilityId,
													ServiceId,
													LicenseNo,
													LicenseDescription,
													Status,
													Category,
													IfOthersSpecify,
													Type,
													ClassGrade,
													ContactPersonUserId,
													IssuingBody,
													IssuingDate,
													IssuingDateUTC,
													NotificationForInspection,
													NotificationForInspectionUTC,
													InspectionConductedOn,
													InspectionConductedOnUTC,
													NextInspectionDate,
													NextInspectionDateUTC,
													ExpireDate,
													ExpireDateUTC,
													PreviousExpiryDate,
													PreviousExpiryDateUTC,
													RegistrationNo,
													Remarks,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC,
													Guid,
													AssetTypeCodeId
												 )
								VALUES			(
												@mPrimaryId,
													@pCustomerId,
													@pFacilityId,
													@pServiceId,
													@pLicenseNo,
													@PLicenseDescription,
													@pStatus,
													@pCategory,
													@pIfOthersSpecify,
													@pType,
													@pClassGrade,
													@pContactPersonStaffId,
													@pIssuingBody,
													@pIssuingDate,
													@pIssuingDateUTC,
													@pNotificationForInspection,
													@pNotificationForInspectionUTC,
													@pInspectionConductedOn,
													@pInspectionConductedOnUTC,
													@pNextInspectionDate,
													@pNextInspectionDateUTC,
													@pExpireDate,
													@pExpireDateUTC,
													@pPreviousExpiryDate,
													@pPreviousExpiryDateUTC,
													@pRegistrationNo,
													@pRemarks,
													@pUserId,													
													GETDATE(), 
													GETUTCDATE(),
													@pUserId,													
													GETDATE(), 
													GETUTCDATE(),
													NEWID(),
													@pAssetTypeCodeId
													)



			  INSERT INTO EngLicenseandCertificateTxnDet(	
													CustomerId,
													FacilityId,
													ServiceId,
													LicenseId,
													AssetId,
													UserId,
													Remarks,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC,
													StaffName,
													Designation	,
													AssetTypeCode
                                                    ) OUTPUT INSERTED.LicenseDetId INTO @TableDet


				   SELECT							
													CustomerId,
													FacilityId,
													ServiceId,
													@mPrimaryId,
													AssetId,
													StaffId,
													Remarks,
													@pUserId,
													GETDATE(),
													GETUTCDATE(),
													@pUserId,
													GETDATE(),
													GETUTCDATE(),
													StaffName,
													Designation,
													AssetTypeCode
													
				   FROM @EngLicenseandCertificateTxnDet					AS LicenseandCertificateType
				   WHERE	ISNULL(LicenseandCertificateType.LicenseDetId,0)=0

			    Declare @mPrimaryDetId int= (select LicenseDetId from EngLicenseandCertificateTxnDet WHERE	LicenseDetId IN (SELECT ID FROM @TableDet))

							  INSERT INTO EngLicenseandCertificateTxnDet_History(	
													LicenseDetId,
													CustomerId,
													FacilityId,
													ServiceId,
													LicenseId,
													AssetId,
													UserId,
													Remarks,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC,
													StaffName,
													Designation	,
													AssetTypeCode
                                                    ) 


				   SELECT							
													@mPrimaryDetId,
													CustomerId,
													FacilityId,
													ServiceId,
													@mPrimaryId,
													AssetId,
													StaffId,
													Remarks,
													@pUserId,
													GETDATE(),
													GETUTCDATE(),
													@pUserId,
													GETDATE(),
													GETUTCDATE(),
													StaffName,
													Designation,
													AssetTypeCode
													
				   FROM @EngLicenseandCertificateTxnDet					AS LicenseandCertificateType
				   WHERE	ISNULL(LicenseandCertificateType.LicenseDetId,0)=0

			   	   SELECT				LicenseId,
										[Timestamp],
										''	ErrorMessage,
										GuId
				   FROM					EngLicenseandCertificateTxn
				   WHERE				LicenseId IN (SELECT ID FROM @Table)
	
		
		END
		ELSE
			
				SELECT	0		AS	LicenseId,
						NULL	AS	[Timestamp],
						'License No. Already Exists' ErrorMessage ,
						NULL AS GuId
		END
		
			
  ELSE

	  BEGIN
				DECLARE @mTimestamp varbinary(200);
				SELECT	@mTimestamp = Timestamp FROM	EngLicenseandCertificateTxn 
				WHERE	LicenseId	=	@pLicenseId

				IF (@mTimestamp=@pTimestamp)
				
				BEGIN
	IF EXISTS(SELECT 1 FROM @EngLicenseandCertificateTxnDet WHERE ( AssetId = 0 OR AssetId is null )AND @pCategory = 144)
	BEGIN

			SELECT		0 AS LicenseId,
						CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS  [timestamp],
						'Please Enter Valid Asset No.'	ErrorMessage,
						NULL AS GuId


	END

	ELSE
	BEGIN
				UPDATE EngLicenseandCertificateTxn SET 
				
									CustomerId									= @pCustomerId,							
									FacilityId									= @pFacilityId,
									ServiceId									= @pServiceId,
									LicenseNo									= @pLicenseNo,
									LicenseDescription							= @PLicenseDescription,
									Status										= @pStatus,
									Category									= @pCategory,
									IfOthersSpecify								= @pIfOthersSpecify,
									Type										= @pType,
									ClassGrade									= @pClassGrade,
									ContactPersonUserId							= @pContactPersonStaffId,
									IssuingBody									= @pIssuingBody,
									IssuingDate									= @pIssuingDate,
									IssuingDateUTC								= @pIssuingDateUTC,
									NotificationForInspection					= @pNotificationForInspection,
									NotificationForInspectionUTC				= @pNotificationForInspectionUTC,
									InspectionConductedOn						= @pInspectionConductedOn,
									InspectionConductedOnUTC					= @pInspectionConductedOnUTC,
									NextInspectionDate							= @pNextInspectionDate,
									NextInspectionDateUTC						= @pNextInspectionDateUTC,
									ExpireDate									= @pExpireDate,
									ExpireDateUTC								= @pExpireDateUTC,
									PreviousExpiryDate							= @pPreviousExpiryDate,
									PreviousExpiryDateUTC						= @pPreviousExpiryDateUTC,
									RegistrationNo								= @pRegistrationNo,
									Remarks										= @pRemarks,
									ModifiedBy									= @pUserId,
									ModifiedDate								= GETDATE(),
									ModifiedDateUTC								= GETUTCDATE(),
									GuId                                        =NEWID(),
									AssetTypeCodeId                             =@pAssetTypeCodeId
									OUTPUT INSERTED.LicenseId INTO @Table
			   WHERE LicenseId=@pLicenseId

			      INSERT INTO EngLicenseandCertificateTxn_History
													(
													LicenseId,
													CustomerId,
													FacilityId,
													ServiceId,
													LicenseNo,
													LicenseDescription,
													Status,
													Category,
													IfOthersSpecify,
													Type,
													ClassGrade,
													ContactPersonUserId,
													IssuingBody,
													IssuingDate,
													IssuingDateUTC,
													NotificationForInspection,
													NotificationForInspectionUTC,
													InspectionConductedOn,
													InspectionConductedOnUTC,
													NextInspectionDate,
													NextInspectionDateUTC,
													ExpireDate,
													ExpireDateUTC,
													PreviousExpiryDate,
													PreviousExpiryDateUTC,
													RegistrationNo,
													Remarks,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC,
													Guid,
													AssetTypeCodeId
												 )
								VALUES			(	
													@pLicenseId,
													@pCustomerId,
													@pFacilityId,
													@pServiceId,
													@pLicenseNo,
													@PLicenseDescription,
													@pStatus,
													@pCategory,
													@pIfOthersSpecify,
													@pType,
													@pClassGrade,
													@pContactPersonStaffId,
													@pIssuingBody,
													@pIssuingDate,
													@pIssuingDateUTC,
													@pNotificationForInspection,
													@pNotificationForInspectionUTC,
													@pInspectionConductedOn,
													@pInspectionConductedOnUTC,
													@pNextInspectionDate,
													@pNextInspectionDateUTC,
													@pExpireDate,
													@pExpireDateUTC,
													@pPreviousExpiryDate,
													@pPreviousExpiryDateUTC,
													@pRegistrationNo,
													@pRemarks,
													@pUserId,													
													GETDATE(), 
													GETUTCDATE(),
													@pUserId,													
													GETDATE(), 
													GETUTCDATE(),
													NEWID(),
													@pAssetTypeCodeId
													)



		DELETE FROM EngLicenseandCertificateTxnDet WHERE LicenseId=@pLicenseId

			  --  UPDATE LicenseandCertificateTxnDet SET
					--				LicenseandCertificateTxnDet.CustomerId			= LicenseandCertificateType.CustomerId,
					--				LicenseandCertificateTxnDet.FacilityId			= LicenseandCertificateType.FacilityId,
					--				LicenseandCertificateTxnDet.ServiceId			= LicenseandCertificateType.ServiceId,
					--				LicenseandCertificateTxnDet.AssetId				= LicenseandCertificateType.AssetId,
					--				LicenseandCertificateTxnDet.UserId				= LicenseandCertificateType.StaffId,
					--				LicenseandCertificateTxnDet.Remarks				= LicenseandCertificateType.Remarks,
					--				LicenseandCertificateTxnDet.ModifiedBy			= @pUserId,
					--				LicenseandCertificateTxnDet.ModifiedDate		= GETDATE(),
					--				LicenseandCertificateTxnDet.ModifiedDateUTC		= GETUTCDATE(),
					--				LicenseandCertificateTxnDet.StaffName			= LicenseandCertificateType.StaffName,
					--				LicenseandCertificateTxnDet.DesignationId		= LicenseandCertificateType.DesignationId	
					--				--OUTPUT INSERTED.StockUpdateDetId INTO @Table
					--FROM	EngLicenseandCertificateTxnDet					AS LicenseandCertificateTxnDet 
					--		INNER JOIN @EngLicenseandCertificateTxnDet		AS LicenseandCertificateType	ON LicenseandCertificateTxnDet.LicenseDetId	=	LicenseandCertificateType.LicenseDetId
					--WHERE ISNULL(LicenseandCertificateType.LicenseDetId,0)>0
			
				   SELECT				LicenseId,
										[Timestamp],
										'' AS ErrorMessage,
										GuId
				   FROM					EngLicenseandCertificateTxn
				   WHERE				LicenseId IN (SELECT ID FROM @Table)



				   ----------------------------------------------------- Detail Table Extra Data Insertion -------------------------------------------------

				   	INSERT INTO EngLicenseandCertificateTxnDet(	
													CustomerId,
													FacilityId,
													ServiceId,
													LicenseId,
													AssetId,
													UserId,
													Remarks,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC	,
													StaffName,
													Designation	,
													AssetTypeCode
                                                    ) OUTPUT INSERTED.LicenseDetId INTO @TableDet
				   SELECT							
													CustomerId,
													FacilityId,
													ServiceId,
													@pLicenseId,
													AssetId,
													StaffId,
													Remarks,
													@pUserId,
													GETDATE(),
													GETUTCDATE(),
													@pUserId,
													GETDATE(),
													GETUTCDATE(),
													StaffName,
													Designation,
													AssetTypeCode
													
				   FROM @EngLicenseandCertificateTxnDet					AS LicenseandCertificateType
				   --WHERE	ISNULL(LicenseandCertificateType.LicenseDetId,0)=0

				   Declare @mPrimaryDetId1 int= (select LicenseDetId from EngLicenseandCertificateTxnDet WHERE	LicenseDetId IN (SELECT ID FROM @TableDet))

				   							  INSERT INTO EngLicenseandCertificateTxnDet_History(	
													LicenseDetId,
													CustomerId,
													FacilityId,
													ServiceId,
													LicenseId,
													AssetId,
													UserId,
													Remarks,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC,
													StaffName,
													Designation	,
													AssetTypeCode
                                                    ) 


				   SELECT							
													@mPrimaryDetId1,
													CustomerId,
													FacilityId,
													ServiceId,
													@pLicenseId,
													AssetId,
													StaffId,
													Remarks,
													@pUserId,
													GETDATE(),
													GETUTCDATE(),
													@pUserId,
													GETDATE(),
													GETUTCDATE(),
													StaffName,
													Designation,
													AssetTypeCode
													
				   FROM @EngLicenseandCertificateTxnDet					AS LicenseandCertificateType

        END   
		END
				ELSE
			BEGIN
				SELECT	LicenseId,
						LicenseNo,
						[Timestamp],							
						'Record Modified. Please Re-Select' AS ErrorMessage,
						GuId
				FROM	EngLicenseandCertificateTxn
				WHERE	LicenseId =@pLicenseId
			END

END
END
			  


	IF @mTRANSCOUNT = 0
        BEGIN
            COMMIT TRANSACTION
        END   


END TRY

BEGIN CATCH

	IF @mTRANSCOUNT = 0
        BEGIN
            ROLLBACK TRAN
        END

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   );
		   THROW;

END CATCH