USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngLicenseandCertificateTxn_Export]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngLicenseandCertificateTxn_Export
Description			: Get License and Certificate Details
Authors				: Dhilip V
Date				: 07-June-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngLicenseandCertificateTxn_Export  @StrCondition='([ClassGrade] LIKE ''%4567%'') AND FacilityId = 1',@StrSorting=null

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE [dbo].[uspFM_EngLicenseandCertificateTxn_Export]

	@StrCondition	NVARCHAR(MAX)		=	NULL,
	@StrSorting		NVARCHAR(MAX)		=	NULL

AS

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


-- Declaration
	DECLARE @countQry	NVARCHAR(MAX);
	DECLARE @qry		NVARCHAR(MAX);
	DECLARE @condition	VARCHAR(MAX);
	DECLARE @TotalRecords INT;

-- Default Values


-- Execution

SET @qry = 'SELECT	LicenseDescription AS [License and Certificate Description],
					LicenseNo	AS [LicenseNo.],
					AssetNo				AS [AssetNo.],
					AssetDescription,
					--Service,
					CategoryVal AS Category,
					--[IfOthers,Specify],
					Type,
					IssuingBodyVal AS IssuingBody,
					[ClassGrade] AS [Class /Grade],
					StatusVal As  [Status],
					ContactPerson AS PersonIncharge,
					IssuingDate,
					NotificationForInspection,
					InspectionConductedOn,
					NextInspectionDate,
					FORMAT(ExpiryDate,''dd-MMM-yyyy'') AS ExpiryDate,
					PreviousExpiryDate,
					RegistrationNo		AS [RegistrationNo.],
					Remarks
			FROM	[V_EngLicenseandCertificateTxn_Export]
			WHERE 1 = 1 ' 
			+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
			+ ' ' + ' ORDER BY ' +  ISNULL(@strSorting,'[V_EngLicenseandCertificateTxn_Export].ModifiedDateUTC DESC')

PRINT @qry;

EXECUTE sp_executesql @qry, N' @TotalRecords INT', @TotalRecords = @TotalRecords
	
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
