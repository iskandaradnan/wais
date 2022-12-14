USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_AreaCsc_Search]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_MstLocationLevel_Search
Description			: StaffName Fetch control
Authors				: Dhilip V
Date				: 12-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_MstLocationLevel_Search  @pLevelCode='pro',@pLevelName=NULL,@pBlockCode=NULL ,@pBlockName=NULL ,@pFacilityCode=NULL ,@pFacilityName=NULL ,@pCustomerCode=NULL ,@pCustomerName=NULL
,@pPageIndex=1,@pPageSize=5,@pFacilityId=1


EXEC UspFM_AreaCsc_Search  @pUserAreaCode='',@pUserAreaName=NULL,@pPageIndex=1,@pPageSize=5,@pFacilityId=1,@pLevelId=78
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_AreaCsc_Search]
          
  @pUserAreaCode			NVARCHAR(100)	=	NULL,
  @pUserAreaName			NVARCHAR(100)	=	NULL,
 
  --@pCustomerName		NVARCHAR(100)	=	NULL,
  @pPageIndex			INT,
  @pPageSize			INT,
  @pFacilityId			INT,
  @pLevelId				INT = NULL
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
		FROM		MstLocationUserArea area WITH(NOLOCK)
		            INNER JOIN	MstLocationLevel level WITH(NOLOCK) ON Level.LevelId=area.LevelId
					INNER JOIN	MstLocationBlock Block WITH(NOLOCK) ON Block.BlockId=area.BlockId
					INNER JOIN	MstLocationFacility Facility WITH(NOLOCK) ON Facility.FacilityId=area.FacilityId
					INNER JOIN	MstCustomer Customer WITH(NOLOCK) ON Customer.CustomerId=area.CustomerId
		WHERE		area.Active =1 and area.LevelId=@pLevelId
					AND ((ISNULL(@pUserAreaCode,'')='' )	OR ( ISNULL(@pUserAreaCode,'') <> ''  AND area.UserAreaCode LIKE '%' + @pUserAreaCode + '%'))
					AND ((ISNULL(@pUserAreaName,'')='' )	OR ( ISNULL(@pUserAreaName,'') <> ''  AND area.UserAreaName LIKE '%' + @pUserAreaName + '%'))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND area.FacilityId = @pFacilityId))
				--	AND ((ISNULL(@pBlockCode,'')='' )	OR ( ISNULL(@pBlockCode,'') <> ''  AND Block.BlockCode LIKE '%' + @pBlockCode + '%'))
				--  AND ((ISNULL(@pBlockName,'')='' )	OR ( ISNULL(@pBlockName,'') <> ''  AND Block.BlockName LIKE '%' + @pBlockName + '%'))
				--	AND ((ISNULL(@pFacilityCode,'')='' )	OR ( ISNULL(@pFacilityCode,'') <> ''  AND Facility.FacilityCode LIKE '%' + @pFacilityCode + '%'))
				--	AND ((ISNULL(@pFacilityName,'')='' )	OR ( ISNULL(@pFacilityName,'') <> ''  AND Facility.FacilityName LIKE '%' + @pFacilityName + '%'))
				--	AND ((ISNULL(@pCustomerCode,'')='' )	OR ( ISNULL(@pCustomerCode,'') <> ''  AND Customer.CustomerCode LIKE '%' + @pCustomerCode + '%'))
				--	AND ((ISNULL(@pCustomerName,'')='' )	OR ( ISNULL(@pCustomerName,'') <> ''  AND Customer.CustomerName LIKE '%' + @pCustomerName + '%'))

		SELECT		block.BlockId,
					block.BlockCode,
					block.BlockName,
					Block.BlockId,
					level.LevelId,
					level.LevelCode,
					level.LevelName,
					Facility.FacilityId,
					Customer.CustomerId,
					Facility.FacilityName,
					Facility.FacilityCode,
					area.UserAreaId,
					area.UserAreaCode,
					area.UserAreaName,
					@TotalRecords AS TotalRecords
		FROM		MstLocationUserArea area WITH(NOLOCK)
		            INNER JOIN	MstLocationLevel level WITH(NOLOCK) ON Level.LevelId=area.LevelId
					INNER JOIN	MstLocationBlock Block WITH(NOLOCK) ON Block.BlockId=area.BlockId
					INNER JOIN	MstLocationFacility Facility WITH(NOLOCK) ON Facility.FacilityId=area.FacilityId
					INNER JOIN	MstCustomer Customer WITH(NOLOCK) ON Customer.CustomerId=area.CustomerId
		WHERE		area.Active =1 and area.LevelId=@pLevelId
					AND ((ISNULL(@pUserAreaCode,'')='' )	OR ( ISNULL(@pUserAreaCode,'') <> ''  AND area.UserAreaCode LIKE '%' + @pUserAreaCode + '%'))
					AND ((ISNULL(@pUserAreaName,'')='' )	OR ( ISNULL(@pUserAreaName,'') <> ''  AND area.UserAreaName LIKE '%' + @pUserAreaName + '%'))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND area.FacilityId = @pFacilityId))
					--AND ((ISNULL(@pBlockCode,'')='' )	OR ( ISNULL(@pBlockCode,'') <> ''  AND Block.BlockCode LIKE '%' + @pBlockCode + '%'))
					--AND ((ISNULL(@pBlockName,'')='' )	OR ( ISNULL(@pBlockName,'') <> ''  AND Block.BlockName LIKE '%' + @pBlockName + '%'))
					--AND ((ISNULL(@pFacilityCode,'')='' )	OR ( ISNULL(@pFacilityCode,'') <> ''  AND Facility.FacilityCode LIKE '%' + @pFacilityCode + '%'))
					--AND ((ISNULL(@pFacilityName,'')='' )	OR ( ISNULL(@pFacilityName,'') <> ''  AND Facility.FacilityName LIKE '%' + @pFacilityName + '%'))
					--AND ((ISNULL(@pCustomerCode,'')='' )	OR ( ISNULL(@pCustomerCode,'') <> ''  AND Customer.CustomerCode LIKE '%' + @pCustomerCode + '%'))
					--AND ((ISNULL(@pCustomerName,'')='' )	OR ( ISNULL(@pCustomerName,'') <> ''  AND Customer.CustomerName LIKE '%' + @pCustomerName + '%'))
		ORDER BY	area.ModifiedDateUTC DESC
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
