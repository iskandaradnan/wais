USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_MstContractorName_Fetch]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_MstContractorandVendor_Fetch
Description			: SupplierWarranty providers fetch details based on SSMRegistrationCode
Authors				: Dhilip V
Date				: 03-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_MstContractorName_Fetch  @pContractorName	='asdasdsad',@pPageIndex=1,@pPageSize=5

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_MstContractorName_Fetch]  
                         
  @pContractorName			NVARCHAR(100)	=	NULL,
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
		FROM		MstContractorandVendor AS Contractor	WITH(NOLOCK)
					OUTER APPLY( SELECT DISTINCT TOP 1 Name AS ContactPerson,ISNULL(Designation,'')Designation,ISNULL(ContactNo,'')ContactNo,ISNULL(Email,'')Email
								FROM MstContractorandVendorContactInfo AS ContractorDet WITH(NOLOCK)  
								WHERE Contractor.ContractorId	=	ContractorDet.ContractorId) AS ContactInfo
		WHERE		Contractor.Active =1
					AND ((ISNULL(@pContractorName,'') = '' )	OR (ISNULL(@pContractorName,'') <> '' 
					AND (SSMRegistrationCode LIKE  '%' + @pContractorName + '%' OR ContractorName LIKE  '%' + @pContractorName + '%')  
					
					))


		SELECT		Contractor.ContractorId,
					Contractor.SSMRegistrationCode,
					Contractor.ContractorName,
					ContactInfo.ContactPerson AS ContactPerson,
					ContactInfo.Designation,
					ContactInfo.ContactNo,
					ContactInfo.Email,
					Contractor.FaxNo,
					Contractor.Address,
					@TotalRecords AS TotalRecords
		FROM		MstContractorandVendor AS Contractor	WITH(NOLOCK)
					OUTER APPLY( SELECT DISTINCT TOP 1 Name AS ContactPerson,ISNULL(Designation,'')Designation,ISNULL(ContactNo,'')ContactNo,ISNULL(Email,'')Email
								FROM MstContractorandVendorContactInfo AS ContractorDet WITH(NOLOCK)  
								WHERE Contractor.ContractorId	=	ContractorDet.ContractorId) AS ContactInfo
		WHERE		Contractor.Active =1
					AND ((ISNULL(@pContractorName,'') = '' )	OR (ISNULL(@pContractorName,'') <> '' 
					AND (SSMRegistrationCode LIKE  '%' + @pContractorName + '%' OR ContractorName LIKE  '%' + @pContractorName + '%')  
					))
		ORDER BY	Contractor.ModifiedDate DESC
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
