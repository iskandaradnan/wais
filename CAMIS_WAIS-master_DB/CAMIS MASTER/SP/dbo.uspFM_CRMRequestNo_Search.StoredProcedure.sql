USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_CRMRequestNo_Search]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: [uspFM_CRMRequestNo_Search]
Description			: CRM Request Number fetch control
Authors				: Dhilip V
Date				: 23-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_CRMRequestNo_Search]  @pRequestNo='Doc',@pPageIndex=1,@pPageSize=20
EXEC [uspFM_CRMRequestNo_Search]  @pRequestNo=NULL,@pPageIndex=1,@pPageSize=20,@pFacilityId=1
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_CRMRequestNo_Search]                           
                            
  @pRequestNo				NVARCHAR(100)	=	NULL,
  @pPageIndex			INT,
  @pPageSize			INT,
  @pFacilityId			INT

AS                                              

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

	DECLARE @TotalRecords INT

-- Default Values


-- Execution

		SELECT		@TotalRecords	=	COUNT(*)
		FROM		CRMRequest										AS CRM				WITH(NOLOCK)
					LEFT JOIN	FMLovMst							AS	LovRequest		WITH(NOLOCK) ON	CRM.TypeOfRequest				= LovRequest.LovId
		WHERE		((ISNULL(@pRequestNo,'')='' )	OR (ISNULL(@pRequestNo,'') <> '' AND CRM.RequestNo LIKE '%' + @pRequestNo + '%'))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND CRM.FacilityId = @pFacilityId))
					AND CRMRequestId NOT IN (SELECT CRMRequestId FROM CRMRequestWorkOrderTxn)
					AND CRM.RequestStatus	<>	143
						
	
		SELECT		CRM.CRMRequestId,
					CRM.RequestNo,
					CRM.RequestDateTime,
					CRM.TypeOfRequest,
					LovRequest.FieldValue	AS	TypeOfRequestValue,
					CRM.ModifiedDateUTC,
					@TotalRecords AS TotalRecords
		FROM		CRMRequest										AS CRM				WITH(NOLOCK)
					LEFT JOIN	FMLovMst							AS	LovRequest		WITH(NOLOCK) ON	CRM.TypeOfRequest				= LovRequest.LovId
		WHERE		((ISNULL(@pRequestNo,'')='' )	OR (ISNULL(@pRequestNo,'') <> '' AND CRM.RequestNo LIKE '%' + @pRequestNo + '%'))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND CRM.FacilityId = @pFacilityId))
					AND CRMRequestId NOT IN (SELECT CRMRequestId FROM CRMRequestWorkOrderTxn)
					AND CRM.RequestStatus	<>	143
		ORDER BY	ModifiedDateUTC DESC
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
