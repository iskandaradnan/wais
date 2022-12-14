USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_BlockCsc_Search]    Script Date: 20-09-2021 17:05:51 ******/
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
CREATE PROCEDURE  [dbo].[UspFM_BlockCsc_Search]
          
  @pBlockCode			NVARCHAR(100)	=	NULL,
  @pBlockName			NVARCHAR(100)	=	NULL,
 
  --@pCustomerName		NVARCHAR(100)	=	NULL,
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
		FROM		MstLocationBlock block WITH(NOLOCK)
					--INNER JOIN	MstLocationBlock Block WITH(NOLOCK) ON Level.BlockId=Block.BlockId
					INNER JOIN	MstLocationFacility Facility WITH(NOLOCK) ON block.FacilityId=Facility.FacilityId
					INNER JOIN	MstCustomer Customer WITH(NOLOCK) ON Facility.CustomerId=Customer.CustomerId
		WHERE		block.Active =1
					AND ((ISNULL(@pBlockCode,'')='' )	OR ( ISNULL(@pBlockCode,'') <> ''  AND block.blockCode LIKE '%' + @pBlockCode + '%'))
					AND ((ISNULL(@pBlockName,'')='' )	OR ( ISNULL(@pBlockName,'') <> ''  AND block.BlockName LIKE '%' + @pBlockName + '%'))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND block.FacilityId = @pFacilityId))
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
					Facility.FacilityId,
					Customer.CustomerId,
					Facility.FacilityName,
					Facility.FacilityCode,
					@TotalRecords AS TotalRecords
		FROM		MstLocationBlock block WITH(NOLOCK)
					--INNER JOIN	MstLocationBlock Block WITH(NOLOCK) ON Level.BlockId=Block.BlockId
					INNER JOIN	MstLocationFacility Facility WITH(NOLOCK) ON block.FacilityId=Facility.FacilityId
					INNER JOIN	MstCustomer Customer WITH(NOLOCK) ON Facility.CustomerId=Customer.CustomerId
		WHERE		block.Active =1
					AND ((ISNULL(@pBlockCode,'')='' )	OR ( ISNULL(@pBlockCode,'') <> ''  AND block.blockCode LIKE '%' + @pBlockCode + '%'))
					AND ((ISNULL(@pBlockName,'')='' )	OR ( ISNULL(@pBlockName,'') <> ''  AND block.BlockName LIKE '%' + @pBlockName + '%'))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND block.FacilityId = @pFacilityId))
					--AND ((ISNULL(@pBlockCode,'')='' )	OR ( ISNULL(@pBlockCode,'') <> ''  AND Block.BlockCode LIKE '%' + @pBlockCode + '%'))
					--AND ((ISNULL(@pBlockName,'')='' )	OR ( ISNULL(@pBlockName,'') <> ''  AND Block.BlockName LIKE '%' + @pBlockName + '%'))
					--AND ((ISNULL(@pFacilityCode,'')='' )	OR ( ISNULL(@pFacilityCode,'') <> ''  AND Facility.FacilityCode LIKE '%' + @pFacilityCode + '%'))
					--AND ((ISNULL(@pFacilityName,'')='' )	OR ( ISNULL(@pFacilityName,'') <> ''  AND Facility.FacilityName LIKE '%' + @pFacilityName + '%'))
					--AND ((ISNULL(@pCustomerCode,'')='' )	OR ( ISNULL(@pCustomerCode,'') <> ''  AND Customer.CustomerCode LIKE '%' + @pCustomerCode + '%'))
					--AND ((ISNULL(@pCustomerName,'')='' )	OR ( ISNULL(@pCustomerName,'') <> ''  AND Customer.CustomerName LIKE '%' + @pCustomerName + '%'))
		ORDER BY	block.ModifiedDateUTC DESC
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
