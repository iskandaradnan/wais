USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Get_Services_byCustomerId]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[Get_Services_byCustomerId]
(
	@CustomerId INT
)
	
AS 

-- Exec [Get_Services_byFacilityId] 

--/*=====================================================================================================================
--APPLICATION		: UETrack
--NAME				: GetServicesbyFacility
--DESCRIPTION		: GET LOV VALUES FOR USERROLE 
--AUTHORS			: Deepak vijay
--DATE				: 4-Sep-2019
-------------------------------------------------------------------------------------------------------------------------
--VERSION HISTORY 
--------------------:---------------:---------------------------------------------------------------------------------------
--Init				: Date          : Details
--------------------:---------------:---------------------------------------------------------------------------------------
--SRINIVAS GANGULA           : 04-SEP-2019 : 
-------:------------:----------------------------------------------------------------------------------------------------*/
BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY
	
	--Gets service coloums of the Selected Block
	select [FEMS_ID],[BEMS_ID],[CLS_ID],[LLS_ID],[HWMS_ID] FROM [dbo].[MstCustomer_Mapping] where [CustomerId]=@CustomerId

END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
