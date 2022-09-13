USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngEODCategorySystem_Fetch]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngEODCategorySystem_Fetch
Description			: StaffName search popup
Authors				: Dhilip V
Date				: 16-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngEODCategorySystem_Fetch  @pCategorySystemName='b',@pPageIndex=1,@pPageSize=5
EXEC uspFM_EngEODCategorySystem_Fetch  @pPageIndex=1,@pPageSize=5,@pCategorySystemName='b'
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_EngEODCategorySystem_Fetch]                           
  @pCategorySystemName				NVARCHAR(100)	= NULL,
  @pPageIndex			INT,
  @pPageSize			INT
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
		FROM		EngEODCategorySystem AS CategorySystem					WITH(NOLOCK)
					LEFT JOIN EngEODCategorySystemDet AS CategorySystemDet	WITH(NOLOCK)	ON CategorySystem.CategorySystemId	=	CategorySystemDet.CategorySystemId
					INNER JOIN MstService AS Service						WITH(NOLOCK)	ON CategorySystem.ServiceId			=	Service.ServiceId
		WHERE		CategorySystem.Active =1
					AND ((ISNULL(@pCategorySystemName,'') = '' )	OR (ISNULL(@pCategorySystemName,'') <> '' AND CategorySystem.CategorySystemName LIKE + '%' + @pCategorySystemName + '%' ))


		SELECT		CategorySystem.CategorySystemId,
					ServiceKey AS	ServiceName,
					CategorySystem.CategorySystemName,
					CategorySystem.ModifiedDateUTC,
					@TotalRecords AS TotalRecords
		FROM		EngEODCategorySystem AS CategorySystem					WITH(NOLOCK)
					LEFT JOIN EngEODCategorySystemDet AS CategorySystemDet	WITH(NOLOCK)	ON CategorySystem.CategorySystemId	=	CategorySystemDet.CategorySystemId
					INNER JOIN MstService AS Service						WITH(NOLOCK)	ON CategorySystem.ServiceId			=	Service.ServiceId
		WHERE		CategorySystem.Active =1
					AND ((ISNULL(@pCategorySystemName,'') = '' )	OR (ISNULL(@pCategorySystemName,'') <> '' AND CategorySystem.CategorySystemName LIKE + '%' + @pCategorySystemName + '%' ))
		ORDER BY	CategorySystem.ModifiedDateUTC DESC
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
