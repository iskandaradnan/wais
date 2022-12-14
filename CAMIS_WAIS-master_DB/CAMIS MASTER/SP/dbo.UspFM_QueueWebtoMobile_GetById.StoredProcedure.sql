USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_QueueWebtoMobile_GetById]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_EngAssetTypeCodeStandardTasks_GetById
Description			: To Get the data from table EngAssetTypeCodeStandardTasks using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_QueueWebtoMobile_GetById]  @pUserId='17',@pPageSize=300

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_QueueWebtoMobile_GetById]                           
  @pUserId			INT,
  @pPageSize		 INT NULL

AS                                              

BEGIN TRY
		

	DECLARE @pPageIndex int 
	set @pPageIndex =0

	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	IF(ISNULL(@pUserId,0) = 0) RETURN

    SELECT	
			WebtoMobile.Queueid,
			WebtoMobile.TableName,
			WebtoMobile.Tableprimaryid,
			WebtoMobile.UserId,
			userregistration.FacilityId,
			userregistration.ServicesID
	FROM	QueueWebtoMobile AS WebtoMobile WITH(NOLOCK) , UMUserRegistration AS userregistration WITH(NOLOCK)
		
	WHERE	userregistration.UserRegistrationId = @pUserId and WebtoMobile.UserId = @pUserId
	ORDER BY WebtoMobile.Queueid ASC
	OFFSET @pPageIndex   ROWS FETCH NEXT  @pPageSize  ROWS ONLY

	 SELECT	WebtoMobile.TableName,
			COUNT(WebtoMobile.TableName) as CountValue	,
			userregistration.FacilityId,
			userregistration.ServicesID
	 FROM	QueueWebtoMobile									AS WebtoMobile WITH(NOLOCK)
	 
	 INNER JOIN UMUserRegistration AS userregistration ON userregistration.UserRegistrationId = @pUserId 
	WHERE	WebtoMobile.UserId = @pUserId
	GROUP BY WebtoMobile.TableName , userregistration.FacilityId , userregistration.ServicesID
	ORDER BY WebtoMobile.TableName ASC
	OFFSET @pPageIndex   ROWS FETCH NEXT  @pPageSize  ROWS ONLY

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
