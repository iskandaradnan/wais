USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_TandCRequesterEmail_GetById]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_TandCConvertToAsset_GetById
Description			: To Get the data from table EngTestingandCommissioningTxn using the Primary Key id
Authors				: Dhilip V
Date				: 10-July-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
declare @pErrorMessage nvarchar(1000)
EXEC [uspFM_TandCConvertToAsset_GetById] @pTestingandCommissioningId=195, @pErrorMessage = @pErrorMessage output
print @pErrorMessage
select * from EngTestingandCommissioningTxn
select * from EngTestingandCommissioningTxnDet
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_TandCRequesterEmail_GetById]
                     
  @pTestingandCommissioningId		INT = null
  

AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	declare @Requester int,@email nvarchar(500)

	select top 1 @Requester =Requester ,@email=(select top 1 email from UMUserRegistration u where u.UserRegistrationId = b.Requester ) from EngTestingandCommissioningTxn a join CRMRequest b on a.CRMRequestId=b.CRMRequestId
	where TestingandCommissioningId =@pTestingandCommissioningId

	select isnull(@Requester,0) as Requester,isnull(@email,'') as Email
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
