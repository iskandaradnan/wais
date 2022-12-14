USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngAssetContractorandVendor_GetByContractorId]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================

Application Name	: UETrack-BEMS              

Version				: 1.0

Procedure Name		: UspFM_EngAssetContractorandVendor_GetByAssetId

Description			: To Get the details for ContractorandVendor using the asset id

Authors				: Dhilip V

Date				: 24-April-2018

-----------------------------------------------------------------------------------------------------------



Unit Test:

EXEC [UspFM_EngAssetContractorandVendor_GetByContractorId] @pContractorId=1

SELECT * FROM EngContractOutRegister

SELECT * FROM EngContractOutRegisterDet

-----------------------------------------------------------------------------------------------------------

Version History 

-----:------------:---------------------------------------------------------------------------------------

Init : Date       : Details

========================================================================================================*/



CREATE PROCEDURE  [dbo].[UspFM_EngAssetContractorandVendor_GetByContractorId]                           



  @pContractorId			INT = null



AS                                              



BEGIN TRY







	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;





    SELECT	
	um.UserRegistrationId,
	ContractorName as StaffName,

			um.Email

	FROM	MstContractorandVendor			AS	MstContractor		WITH(NOLOCK)	

	left  join umuserregistration 	um WITH(NOLOCK) on 		MstContractor.ContractorId = um.ContractorId

	WHERE	MstContractor.ContractorId  = @pContractorId 







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
