USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_BERApplicationAttachmentTxn_GetById]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================

Application Name	: UETrack-BEMS              

Version				: 1.0

Procedure Name		: uspFM_BERApplicationAttachmentTxn_GetById

Description			: Get the SpareParts details by passing the SparePartsId.

Authors				: Balaji M S

Date				: 26-April-2018

-----------------------------------------------------------------------------------------------------------



Unit Test:

EXEC [uspFM_BERApplicationAttachmentTxn_GetById]  @pApplicationId=66

SELECT * FROM EngSpareParts

-----------------------------------------------------------------------------------------------------------

Version History 

-----:------------:---------------------------------------------------------------------------------------

Init : Date       : Details

========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_BERApplicationAttachmentTxn_GetById]                           

  @pApplicationId		INT

AS                                               



BEGIN TRY



-- Paramter Validation 



	SET NOCOUNT ON; 

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;



-- Declaration





-- Default Values





-- Execution





	IF(ISNULL(@pApplicationId,0) = 0) RETURN



    SELECT	ApplicationAtta.BERApplicationAttachmentId			AS BERApplicationAttachmentId,

			ApplicationAtta.CustomerId							AS CustomerId,

			ApplicationAtta.FacilityId							AS FacilityId,

			ApplicationAtta.ServiceId							AS ServiceId,

			Service.ServiceKey									AS Service,

			FMDoc.FilePath										AS FilePath,

			FMDoc.DocumentTitle									AS DocumentTitle,

			ApplicationAtta.ApplicationId						AS ApplicationId,

			BERApplication.BERno								AS BERno,

			BERApplication.ApplicationDate						AS BERApplication,

			ApplicationAtta.DocumentId							AS DocumentId,

			ApplicationAtta.FileType							AS FileType,

			FileType.FileType									AS FileTypeValue,

			ApplicationAtta.AttachedBy							AS AttachedBy,

			AttachedBy.StaffName								AS AttachedBy,
			FMDoc.DocumentExtension, 

			ApplicationAtta.FileName							AS FileName, 

			FMDoc.GuId                                          As [GuId]
 	FROM	BERApplicationAttachmentTxn							AS  ApplicationAtta WITH(NOLOCK)	

			INNER JOIN	MstService								AS	Service			WITH(NOLOCK)	ON ApplicationAtta.ServiceId		=	Service.ServiceId
			
			INNER JOIN FMDocument                               AS FMDoc          WITH(NOLOCK)      ON ApplicationAtta.DocumentId		=	FMDoc.DocumentId

			INNER JOIN	BERApplicationTxn						AS	BERApplication	WITH(NOLOCK)	ON ApplicationAtta.ApplicationId	=	BERApplication.ApplicationId

			LEFT JOIN	UMUserRegistration						AS	AttachedBy		WITH(NOLOCK)	ON ApplicationAtta.AttachedBy		=	AttachedBy.UserRegistrationId

			LEFT JOIN	FMDocumentFileType	AS	FileType		WITH(NOLOCK)	ON ApplicationAtta.FileType			=	FileType.FileTypeId

	WHERE	ApplicationAtta.ApplicationId = @pApplicationId 

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
