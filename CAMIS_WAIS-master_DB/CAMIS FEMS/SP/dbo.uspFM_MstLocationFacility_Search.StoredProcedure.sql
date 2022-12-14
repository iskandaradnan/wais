USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_MstLocationFacility_Search]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_MstLocationFacility_Search
Description			: Facility Search popup
Authors				: Dhilip V
Date				: 13-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_MstLocationFacility_Search  @pFacilityCode='png' ,@pFacilityName=NULL ,@pCustomerCode=NULL ,@pCustomerName=NULL
,@pPageIndex=1,@pPageSize=5

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_MstLocationFacility_Search]
          
  @pFacilityCode		NVARCHAR(100)	=	NULL,
  @pFacilityName		NVARCHAR(100)	=	NULL, 
  @pCustomerCode		NVARCHAR(100)	=	NULL,
  @pCustomerName		NVARCHAR(100)	=	NULL,
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
		FROM		MstLocationFacility Facility
					INNER JOIN	MstCustomer Customer WITH(NOLOCK) ON Facility.CustomerId=Customer.CustomerId
		WHERE		Facility.Active =1
					AND ((ISNULL(@pFacilityCode,'')='' )	OR ( ISNULL(@pFacilityCode,'') <> ''  AND Facility.FacilityCode LIKE '%' + @pFacilityCode + '%'))
					AND ((ISNULL(@pFacilityName,'')='' )	OR ( ISNULL(@pFacilityName,'') <> ''  AND Facility.FacilityName LIKE '%' + @pFacilityName + '%'))
					AND ((ISNULL(@pCustomerCode,'')='' )	OR ( ISNULL(@pCustomerCode,'') <> ''  AND Customer.CustomerCode LIKE '%' + @pCustomerCode + '%'))
					AND ((ISNULL(@pCustomerName,'')='' )	OR ( ISNULL(@pCustomerName,'') <> ''  AND Customer.CustomerName LIKE '%' + @pCustomerName + '%'))

		SELECT		Facility.FacilityId,
					Facility.FacilityCode,
					Facility.FacilityName,
					Customer.CustomerCode,
					Customer.CustomerName,
					@TotalRecords AS TotalRecords
		FROM		MstLocationFacility Facility
					INNER JOIN	MstCustomer Customer WITH(NOLOCK) ON Facility.CustomerId=Customer.CustomerId
		WHERE		Facility.Active =1
					AND ((ISNULL(@pFacilityCode,'')='' )	OR ( ISNULL(@pFacilityCode,'') <> ''  AND Facility.FacilityCode LIKE '%' + @pFacilityCode + '%'))
					AND ((ISNULL(@pFacilityName,'')='' )	OR ( ISNULL(@pFacilityName,'') <> ''  AND Facility.FacilityName LIKE '%' + @pFacilityName + '%'))
					AND ((ISNULL(@pCustomerCode,'')='' )	OR ( ISNULL(@pCustomerCode,'') <> ''  AND Customer.CustomerCode LIKE '%' + @pCustomerCode + '%'))
					AND ((ISNULL(@pCustomerName,'')='' )	OR ( ISNULL(@pCustomerName,'') <> ''  AND Customer.CustomerName LIKE '%' + @pCustomerName + '%'))
		ORDER BY	Facility.ModifiedDateUTC DESC
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
