USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_MstLocationBlockQR_Fetch]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: [uspFM_MstLocationBlockQR_Fetch]
Description			: QR Code Asset number fetch control
Authors				: Dhilip V
Date				: 23-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_MstLocationBlockQR_Fetch]  @pUserLocationName='loc',@pPageIndex=1,@pPageSize=20,@pFacilityId=1
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_MstLocationBlockQR_Fetch]                           
                            
  @pUserLocationName				NVARCHAR(100)	=	NULL,
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
		FROM		MstLocationUserArea							AS	UserArea			WITH(NOLOCK)
					INNER JOIN	MstLocationUserLocation			AS	UserLocation		WITH(NOLOCK) ON	UserArea.UserAreaId		=	UserLocation.UserAreaId
					INNER JOIN	MstLocationLevel				AS	Level				WITH(NOLOCK) ON	UserArea.LevelId		=	Level.LevelId
					INNER JOIN	MstLocationBlock				AS	Block				WITH(NOLOCK) ON	UserArea.BlockId		=	Block.BlockId					
		WHERE		Block.Active =1
					AND UserLocation.Active = 1
					AND ((ISNULL(@pUserLocationName,'')='' )		OR (ISNULL(@pUserLocationName,'') <> '' AND (UserLocation.UserLocationCode LIKE '%' + @pUserLocationName + '%'	OR UserLocation.UserLocationName LIKE '%' + @pUserLocationName + '%')))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Block.FacilityId = @pFacilityId))

		SELECT		Block.BlockId,
					Block.BlockCode,
					Block.BlockName,
					Level.LevelId,
					Level.LevelCode,
					Level.LevelName,
					UserArea.UserAreaId,
					UserArea.UserAreaCode,
					UserArea.UserAreaName,
					UserArea.QRCode					AS	UserAreaQRCode,
					UserLocation.UserLocationId,
					UserLocation.UserLocationCode,
					UserLocation.UserLocationName,
					UserLocation.QRCode				AS	UserLocationQRCode,
					@TotalRecords					AS TotalRecords
		FROM		MstLocationUserArea							AS	UserArea			WITH(NOLOCK)
					INNER JOIN	MstLocationUserLocation			AS	UserLocation		WITH(NOLOCK) ON	UserArea.UserAreaId		=	UserLocation.UserAreaId
					INNER JOIN	MstLocationLevel				AS	Level				WITH(NOLOCK) ON	UserArea.LevelId		=	Level.LevelId
					INNER JOIN	MstLocationBlock				AS	Block				WITH(NOLOCK) ON	UserArea.BlockId		=	Block.BlockId	
		WHERE		Block.Active =1
					AND UserArea.Active = 1
					AND UserLocation.Active = 1
					AND ((ISNULL(@pUserLocationName,'')='' )		OR (ISNULL(@pUserLocationName,'') <> '' AND (UserLocation.UserLocationCode LIKE '%' + @pUserLocationName + '%'	OR UserLocation.UserLocationName LIKE '%' + @pUserLocationName + '%')))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Block.FacilityId = @pFacilityId))
		ORDER BY	Block.ModifiedDateUTC DESC
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
