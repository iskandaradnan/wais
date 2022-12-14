USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_TAndCCRMRequestNo_Fetch]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: [uspFM_MstCustomer_Fetch]
Description			: MstCustomer Fetch control
Authors				: Dhilip V
Date				: 13-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_TAndCCRMRequestNo_Fetch]  @pRequestNo='',@pPageIndex=1,@pPageSize=5

EXEC [uspFM_MstCustomer_Fetch]  @pPageIndex=1,@pPageSize=5

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_TAndCCRMRequestNo_Fetch]                           
  @pRequestNo				NVARCHAR(100)	=	NULL,
  @pPageIndex				INT,
  @pPageSize				INT,
  @pFacilityId					INT
AS                                              

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

	DECLARE @TotalRecords INT

-- Default Values

				SELECT CRMRequestId into #CRMRequestIdResult FROM CRMRequest where TypeOfRequest = 375 AND RequestStatus = 140
				except
				SELECT CRMRequestId FROM EngTestingandCommissioningTxn a  where  not exists (
				select 1 from CRMRequest  r where a.CRMRequestId = r.CRMRequestId  and RequestStatus = 140)


-- Execution
		SELECT		@TotalRecords	=	COUNT(*)
		FROM		CRMRequest						AS Request
					INNER JOIN MstLocationUserLocation			AS UserLocation WITH(NOLOCK) ON Request.UserLocationId = UserLocation.UserLocationId
					INNER JOIN	MstLocationUserArea				AS UserArea		WITH(NOLOCK) ON UserLocation.UserAreaId=UserArea.UserAreaId
					INNER JOIN MstLocationLevel		AS	Level	 WITH(NOLOCK)	ON	UserArea.LevelId		=	Level.LevelId
					INNER JOIN MstLocationBlock		AS	Block	 WITH(NOLOCK)	ON	Level.BlockId			=	Block.BlockId
		WHERE		TypeOfRequest = 375 AND Request.FacilityId = @pFacilityId AND RequestStatus = 140
					AND ((ISNULL(@pRequestNo,'')='' )	OR ( ISNULL(@pRequestNo,'') <> ''  AND RequestNo LIKE '%' + @pRequestNo + '%'))
					AND CRMRequestId IN (SELECT CRMRequestId FROM #CRMRequestIdResult)
					AND TargetDate IS NOT NULL

		SELECT		CRMRequestId,
					RequestNo,
					RequestDateTime,
					TargetDate,
					UserLocation.UserLocationId,
					UserLocation.UserLocationName,
					UserLocation.UserAreaId,
					UserArea.UserAreaName,
					Level.LevelName,
					Block.BlockName,
					Request.Requester,
					ReqMail.Email AS ReqEmail,
					@TotalRecords AS TotalRecords
		FROM		CRMRequest					AS Request
					INNER JOIN MstLocationUserLocation			AS UserLocation WITH(NOLOCK) ON Request.UserLocationId = UserLocation.UserLocationId
					INNER JOIN	MstLocationUserArea				AS UserArea		WITH(NOLOCK) ON UserLocation.UserAreaId=UserArea.UserAreaId
					INNER JOIN MstLocationLevel		AS	Level	 WITH(NOLOCK)	ON	UserArea.LevelId		=	Level.LevelId
					INNER JOIN MstLocationBlock		AS	Block	 WITH(NOLOCK)	ON	Level.BlockId			=	Block.BlockId
					Left JOIN UMUserRegistration	As  ReqMail  WITH(NOLOCK)	ON	Request.Requester		=	ReqMail.UserRegistrationId
		WHERE		TypeOfRequest = 375 AND Request.FacilityId = @pFacilityId AND RequestStatus = 140
					AND ((ISNULL(@pRequestNo,'')='' )	OR ( ISNULL(@pRequestNo,'') <> ''  AND RequestNo LIKE '%' + @pRequestNo + '%'))
					AND CRMRequestId IN (SELECT CRMRequestId FROM #CRMRequestIdResult)
					AND TargetDate IS NOT NULL
		ORDER BY	Request.ModifiedDateUTC DESC
		OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 

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
