USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Get_Services_byFacilityId]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[Get_Services_byFacilityId]
(
	@FacilityID INT
)
	
AS 

-- Exec [Get_Services_byFacilityId] 

--/*=====================================================================================================================
--APPLICATION		: UETrack
--NAME				: GetServicesbyFacility
--DESCRIPTION		: GET LOV VALUES FOR USERROLE 
--AUTHORS			: Srinivas Gangula
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
	select [FEMS],[BEMS],[CLS],[LLS],[HWMS] FROM [dbo].[MstLocationFacility] where [FacilityId]=@FacilityID

END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
