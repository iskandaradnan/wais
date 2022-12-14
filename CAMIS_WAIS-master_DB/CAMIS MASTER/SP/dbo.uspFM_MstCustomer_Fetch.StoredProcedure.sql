USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_MstCustomer_Fetch]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: [uspFM_MstCustomer_Fetch]
Description			: MstCustomer Fetch control
Authors				: Dhilip V
Date				: 13-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_MstCustomer_Fetch]  @pCustomerCode='MSB',@pPageIndex=1,@pPageSize=5

EXEC [uspFM_MstCustomer_Fetch]  @pPageIndex=1,@pPageSize=5

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_MstCustomer_Fetch]                           
  @pCustomerCode			NVARCHAR(100)	=	NULL,
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
					AND ((ISNULL(@pCustomerCode,'') = '' )	OR (ISNULL(@pCustomerCode,'') <> '' AND (MstCustomer.CustomerCode LIKE  + '%' + @pCustomerCode + '%' or MstCustomer.CustomerName LIKE  + '%' + @pCustomerCode + '%') ))


		SELECT		CustomerId,
					CustomerName,
					CustomerCode,
					ActiveFromDate,
					@TotalRecords AS TotalRecords
		FROM		MstCustomer
		WHERE		Active =1
					AND ((ISNULL(@pCustomerCode,'') = '' )	OR (ISNULL(@pCustomerCode,'') <> '' AND (MstCustomer.CustomerCode LIKE  + '%' + @pCustomerCode + '%' or MstCustomer.CustomerName LIKE  + '%' + @pCustomerCode + '%') ))
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
