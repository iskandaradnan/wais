USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_MstLocationFacility_Fetch]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_MstLocationFacility_Fetch
Description			: Facility Fetch Control
Authors				: Dhilip V
Date				: 13-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_MstLocationFacility_Fetch  @pFacilityCode='png' ,@pPageIndex=1,@pPageSize=5,@pFacilityId=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_MstLocationFacility_Fetch]
          
  @pFacilityCode		NVARCHAR(100)	=	NULL,
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
		FROM		MstLocationFacility Facility
					INNER JOIN	MstCustomer Customer WITH(NOLOCK) ON Facility.CustomerId=Customer.CustomerId
		WHERE		Facility.Active =1
					AND ((ISNULL(@pFacilityCode,'') = '' )	OR (ISNULL(@pFacilityCode,'') <> '' AND (Facility.FacilityCode LIKE  + '%' + @pFacilityCode + '%' or Facility.FacilityName LIKE  + '%' + @pFacilityCode + '%') ))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Facility.FacilityId = @pFacilityId))

		SELECT		Facility.FacilityId,
					Facility.FacilityCode,
					Facility.FacilityName,
					Customer.CustomerCode,
					Customer.CustomerName,
					@TotalRecords AS TotalRecords
		FROM		MstLocationFacility Facility
					INNER JOIN	MstCustomer Customer WITH(NOLOCK) ON Facility.CustomerId=Customer.CustomerId
		WHERE		Facility.Active =1
					AND ((ISNULL(@pFacilityCode,'') = '' )	OR (ISNULL(@pFacilityCode,'') <> '' AND (Facility.FacilityCode LIKE  + '%' + @pFacilityCode + '%' or Facility.FacilityName LIKE  + '%' + @pFacilityCode + '%') ))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND Facility.FacilityId = @pFacilityId))
		ORDER BY	Facility.ModifiedDateUTC DESC
		OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 



END TRY

BEGIN CATCH

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	ERROR_LINE())+' - '+ERROR_MESSAGE(),
				GETDATE()
		   )

END CATCH
GO
