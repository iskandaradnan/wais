USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_FEAcknowledge_GetById]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: [UspFM_FEAcknowledge_GetById]
Description			: To Get the data from table FEAcknowledge using the Primary Key id
Authors				: Dhilip V
Date				: 13-June-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_FEAcknowledge_GetById] @pUserId=1,@pAcknowledgeId='1,2'

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[UspFM_FEAcknowledge_GetById]                           
  @pUserId			INT	=	NULL,
  @pAcknowledgeId	NVARCHAR(1000) = null

AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

    SELECT	AcknowledgeId,
			ScreenName,
			Documentid,
			DocumentNo,
			Description,
			Userid,
			UserRegistration.StaffName AS	UserName,
			Remarks,
			Acknowledge,
			Signatureimage			
	FROM	FEAcknowledge						AS Acknowledge			WITH(NOLOCK)			
			LEFT JOIN UMUserRegistration		AS UserRegistration		WITH(NOLOCK)		ON Acknowledge.UserId	= UserRegistration.UserRegistrationId			
	WHERE	Acknowledge.UserId = @pUserId
			and 
			Acknowledge.AcknowledgeId in (select Item from dbo.[SplitString] (@pAcknowledgeId,','))   
	

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
