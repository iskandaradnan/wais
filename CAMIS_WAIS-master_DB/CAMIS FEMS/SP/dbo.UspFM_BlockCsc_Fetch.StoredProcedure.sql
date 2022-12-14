USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_BlockCsc_Fetch]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_MstLocationLevel_Fetch
Description			: StaffName Fetch control
Authors				: Dhilip V
Date				: 12-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC UspFM_BlockCsc_Fetch  @pBlockCode=null,@pPageIndex=1,@pPageSize=5,@pFacilityId=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_BlockCsc_Fetch]   
      
  @pBlockCode			NVARCHAR(100)	=	NULL,
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
					AND ((ISNULL(@pBlockCode,'') = '' )	OR (ISNULL(@pBlockCode,'') <> '' AND (block.BlockCode LIKE  + '%' + @pBlockCode + '%' or block.BlockCode LIKE  + '%' + @pBlockCode + '%') ))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Facility.FacilityId = @pFacilityId))

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
					AND ((ISNULL(@pBlockCode,'') = '' )	OR (ISNULL(@pBlockCode,'') <> '' AND (block.BlockCode LIKE  + '%' + @pBlockCode + '%' or block.BlockCode LIKE  + '%' + @pBlockCode + '%') ))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Facility.FacilityId = @pFacilityId))
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
