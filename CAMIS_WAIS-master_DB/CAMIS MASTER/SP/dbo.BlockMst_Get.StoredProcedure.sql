USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[BlockMst_Get]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[BlockMst_Get]
(
	@Id INT
)
	
AS 

-- Exec [GetUserRole] 

--/*=====================================================================================================================
--APPLICATION		: UETrack
--NAME				: GetUserRole
--DESCRIPTION		: GET USER ROLE FOR THE GIVEN ID
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
	
	SELECT FacilityId, BlockName, BlockCode, ShortName, Active, [Timestamp],GuId FROM MstLocationBlock WHERE BlockId = @Id
	
END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
