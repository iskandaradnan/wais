USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngAssetClassification_GetTimestamp]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[UspFM_EngAssetClassification_GetTimestamp]
(
	@Id INT
)
	
AS 

-- Exec [GetUserRoleTimestamp] 1

--/*=====================================================================================================================
--APPLICATION		: UETrack
--NAME				: GetUserRoleTimestamp
--DESCRIPTION		: GETS THE TIMESTAMP FOR CHECKING CONCURRENCY ISSUES
--AUTHORS			: BIJU NB
--DATE				: 20-March-2018
-------------------------------------------------------------------------------------------------------------------------
--VERSION HISTORY 
--------------------:---------------:---------------------------------------------------------------------------------------
--Init				: Date          : Details
--------------------:---------------:---------------------------------------------------------------------------------------
--BIJU NB           : 20-March-2018 : 
-------:------------:----------------------------------------------------------------------------------------------------*/
BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY
	
	SELECT [Timestamp] FROM EngAssetClassification WHERE AssetClassificationId = @Id;
	
END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
