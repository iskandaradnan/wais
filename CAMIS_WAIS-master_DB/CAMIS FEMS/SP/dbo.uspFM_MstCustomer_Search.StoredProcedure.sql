USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_MstCustomer_Search]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: [uspFM_MstCustomer_Search]
Description			: Asset Type Code Search popup
Authors				: Dhilip V
Date				: 07-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_MstCustomer_Search]  @pCustomerCode='MSB',@pCustomerName=NULL,@pPageIndex=1,@pPageSize=5

EXEC [uspFM_MstCustomer_Search]  @pPageIndex=1,@pPageSize=5

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_MstCustomer_Search]                           
                            
  @pCustomerCode			NVARCHAR(100)	=	NULL,
  @pCustomerName			NVARCHAR(100)	=	NULL,
  @pPageIndex				INT,
  @pPageSize				INT
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
		FROM		MstCustomer
		WHERE		Active =1
					AND ((ISNULL(@pCustomerCode,'')='' )	OR ( ISNULL(@pCustomerCode,'') <> ''  AND CustomerCode LIKE '%' + @pCustomerCode + '%'))
					AND ((ISNULL(@pCustomerName,'')='' ) OR (ISNULL(@pCustomerName ,'') <> '' AND CustomerName LIKE '%' + @pCustomerName + '%'))

		SELECT		CustomerId,
					CustomerName,
					CustomerCode,
					ActiveFromDate,
					@TotalRecords AS TotalRecords
		FROM		MstCustomer
		WHERE		Active =1
					AND ((ISNULL(@pCustomerCode,'')='' )	OR ( ISNULL(@pCustomerCode,'') <> ''  AND CustomerCode LIKE '%' + @pCustomerCode + '%'))
					AND ((ISNULL(@pCustomerName,'')='' ) OR (ISNULL(@pCustomerName ,'') <> '' AND CustomerName LIKE '%' + @pCustomerName + '%'))
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
