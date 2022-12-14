USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_BERApplicationHistoryTxn_GetById]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_BERApplicationHistoryTxn_GetById
Description			: To Get the data from table BERApplicationHistoryTxn using the Primary Key id
Authors				: Balaji M S
Date				: 11-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_BERApplicationHistoryTxn_GetById] @pApplicationId=67,@pUserId=1
SELECT * FROM BERApplicationHistoryTxn
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[UspFM_BERApplicationHistoryTxn_GetById]                           
  @pUserId			INT	=	NULL,
  @pApplicationId	INT

AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


	DECLARE @pRejectedBERReferenceId INT 

	SET @pRejectedBERReferenceId = (SELECT RejectedBERReferenceId FROM BERApplicationTxn WHERE ApplicationId = @pApplicationId)

	IF(@pRejectedBERReferenceId IS NULL)

	BEGIN

    SELECT	BERApplication.ApplicationId						AS ApplicationId,
			BERApplication.BERno								AS BERno,
			BERApplicationHistory.ModifiedDate						AS ApplicationDate,
			BERApplicationHistory.Status						AS Status,
			BERStatus.FieldValue								AS StatusValue,
			(select top 1 berno from BERApplicationTxn where ApplicationId=BERApplication.RejectedBERReferenceId) RejectedBERNo,
			UserRegistration.StaffName							AS StaffName,
			StaffDesignation.Designation						AS Designation,
			BERApplicationHistory.CreatedDate					AS CreatedDate

	FROM	BERApplicationTxn									AS BERApplication			WITH(NOLOCK)
			INNER JOIN BERApplicationHistoryTxn					AS BERApplicationHistory	WITH(NOLOCK)		ON BERApplication.ApplicationId					= BERApplicationHistory.ApplicationId
			LEFT JOIN UMUserRegistration						AS UserRegistration			WITH(NOLOCK)		ON BERApplicationHistory.ModifiedBy						= UserRegistration.UserRegistrationId		
			LEFT  JOIN UserDesignation							AS StaffDesignation			WITH(NOLOCK)		ON UserRegistration.UserDesignationId			= StaffDesignation.UserDesignationId
			INNER JOIN FMLovMst									AS BERStatus				WITH(NOLOCK)		ON BERApplicationHistory.Status					= BERStatus.LovId
	WHERE	BERApplication.ApplicationId = @pApplicationId  

	order by BERApplicationHistory.ApplicationHistoryId desc
	
	END

	IF(@pRejectedBERReferenceId IS NOT NULL)

	BEGIN

    SELECT	BERApplication.ApplicationId						AS ApplicationId,
			BERApplication.BERno								AS BERno,
			BERApplicationHistory.ModifiedDate						AS ApplicationDate,
			BERApplicationHistory.Status						AS Status,
			BERStatus.FieldValue								AS StatusValue,
			(select top 1 berno from BERApplicationTxn where ApplicationId=BERApplication.RejectedBERReferenceId) RejectedBERNo,
			UserRegistration.StaffName							AS StaffName,
			StaffDesignation.Designation						AS Designation,
			BERApplicationHistory.CreatedDate					AS CreatedDate
	FROM	BERApplicationTxn									AS BERApplication			WITH(NOLOCK)
			INNER JOIN BERApplicationHistoryTxn					AS BERApplicationHistory	WITH(NOLOCK)		ON BERApplication.ApplicationId					= BERApplicationHistory.ApplicationId
			LEFT JOIN UMUserRegistration						AS UserRegistration			WITH(NOLOCK)		ON BERApplicationHistory.ModifiedBy						= UserRegistration.UserRegistrationId		
			LEFT  JOIN UserDesignation							AS StaffDesignation			WITH(NOLOCK)		ON UserRegistration.UserDesignationId			= StaffDesignation.UserDesignationId
			INNER JOIN FMLovMst									AS BERStatus				WITH(NOLOCK)		ON BERApplicationHistory.Status					= BERStatus.LovId
	WHERE	BERApplication.ApplicationId IN (@pApplicationId , @pRejectedBERReferenceId)

	order by BERApplicationHistory.ApplicationHistoryId desc
	
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
