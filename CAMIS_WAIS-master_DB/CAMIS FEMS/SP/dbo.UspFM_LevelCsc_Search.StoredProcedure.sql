USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_LevelCsc_Search]    Script Date: 20-09-2021 16:56:53 ******/
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


EXEC uspFM_MstLocationLevel_Search  @pLevelCode='',@pLevelName=NULL,@pPageIndex=1,@pPageSize=5,@pFacilityId=1
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_LevelCsc_Search]
          
  @pLevelCode			NVARCHAR(100)	=	NULL,
  @pLevelName			NVARCHAR(100)	=	NULL,
 
  --@pCustomerName		NVARCHAR(100)	=	NULL,
  @pPageIndex			INT,
  @pPageSize			INT,
  @pFacilityId			INT,
  @pBlockId				INT = NULL
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
		FROM		MstLocationLevel Level WITH(NOLOCK)
					INNER JOIN	MstLocationBlock Block WITH(NOLOCK) ON Level.BlockId=Block.BlockId
					INNER JOIN	MstLocationFacility Facility WITH(NOLOCK) ON Level.FacilityId=Facility.FacilityId
					INNER JOIN	MstCustomer Customer WITH(NOLOCK) ON Facility.CustomerId=Customer.CustomerId
		WHERE		Level.Active =1 AND LEVEL.BlockId=@pBlockId
					AND ((ISNULL(@pLevelCode,'')='' )	OR ( ISNULL(@pLevelCode,'') <> ''  AND LEVEL.LevelCode LIKE '%' + @pLevelCode + '%'))
					AND ((ISNULL(@pLevelName,'')='' )	OR ( ISNULL(@pLevelName,'') <> ''  AND level.LevelName LIKE '%' + @pLevelName + '%'))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND level.FacilityId = @pFacilityId))
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
					@TotalRecords AS TotalRecords
		FROM		MstLocationLevel Level WITH(NOLOCK)
					INNER JOIN	MstLocationBlock Block WITH(NOLOCK) ON Level.BlockId=Block.BlockId
					INNER JOIN	MstLocationFacility Facility WITH(NOLOCK) ON Level.FacilityId=Facility.FacilityId
					INNER JOIN	MstCustomer Customer WITH(NOLOCK) ON Facility.CustomerId=Customer.CustomerId
		WHERE		Level.Active =1 AND LEVEL.BlockId=@pBlockId
					AND ((ISNULL(@pLevelCode,'')='' )	OR ( ISNULL(@pLevelCode,'') <> ''  AND LEVEL.LevelCode LIKE '%' + @pLevelCode + '%'))
					AND ((ISNULL(@pLevelName,'')='' )	OR ( ISNULL(@pLevelName,'') <> ''  AND level.LevelName LIKE '%' + @pLevelName + '%'))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Level.FacilityId = @pFacilityId))
					--AND ((ISNULL(@pBlockCode,'')='' )	OR ( ISNULL(@pBlockCode,'') <> ''  AND Block.BlockCode LIKE '%' + @pBlockCode + '%'))
					--AND ((ISNULL(@pBlockName,'')='' )	OR ( ISNULL(@pBlockName,'') <> ''  AND Block.BlockName LIKE '%' + @pBlockName + '%'))
					--AND ((ISNULL(@pFacilityCode,'')='' )	OR ( ISNULL(@pFacilityCode,'') <> ''  AND Facility.FacilityCode LIKE '%' + @pFacilityCode + '%'))
					--AND ((ISNULL(@pFacilityName,'')='' )	OR ( ISNULL(@pFacilityName,'') <> ''  AND Facility.FacilityName LIKE '%' + @pFacilityName + '%'))
					--AND ((ISNULL(@pCustomerCode,'')='' )	OR ( ISNULL(@pCustomerCode,'') <> ''  AND Customer.CustomerCode LIKE '%' + @pCustomerCode + '%'))
					--AND ((ISNULL(@pCustomerName,'')='' )	OR ( ISNULL(@pCustomerName,'') <> ''  AND Customer.CustomerName LIKE '%' + @pCustomerName + '%'))
		ORDER BY	level.ModifiedDateUTC DESC
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
