USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_GetCustomer_Type]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


Create PROCEDURE [dbo].[uspFM_GetCustomer_Type]

	
AS 

-- Exec [uspFM_GetCustomerType]

--/*=====================================================================================================================
--APPLICATION		: UETrack
--NAME				: GetCustomer_Type
--DESCRIPTION		: GET USER ROLE FOR THE GIVEN ID
--AUTHORS			: Pranay Kumar 
--DATE				: 23-SEP-2019
-------------------------------------------------------------------------------------------------------------------------
--VERSION HISTORY 
--------------------:---------------:---------------------------------------------------------------------------------------
--Init				: Date          : Details
--------------------:---------------:---------------------------------------------------------------------------------------
--PRANAY KUMAR           : 27-SEP-2019 : 
-------:------------:----------------------------------------------------------------------------------------------------*/
BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY
	
	SELECT [Customer_Type_ID] as LovId
      ,[Customer_Type_Name] as FieldValue
      ,0 as IsDefault FROM [MstCustomer_Type] 		
	
END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
