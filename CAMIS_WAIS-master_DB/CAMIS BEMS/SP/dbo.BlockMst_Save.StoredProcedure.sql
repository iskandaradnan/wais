USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[BlockMst_Save]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Exec [SaveUserRole] 

--/*=====================================================================================================================
--APPLICATION		: UETrack
--NAME				: SaveUserRole
--DESCRIPTION		: SAVE RECORD IN UMUSERROLE TABLE 
--AUTHORS			: BIJU NB
--DATE				: 20-March-2018
-------------------------------------------------------------------------------------------------------------------------
--VERSION HISTORY 
--------------------:---------------:---------------------------------------------------------------------------------------
--Init				: Date          : Details
--------------------:---------------:---------------------------------------------------------------------------------------
--BIJU NB           : 20-March-2018 : 
-------:------------:----------------------------------------------------------------------------------------------------*/


CREATE PROCEDURE  [dbo].[BlockMst_Save]                           

(
	@Block As [dbo].[BemsBlockMst] readonly
)	     

AS      

BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY
	DECLARE @Table TABLE (ID INT)


	


	INSERT INTO MstLocationBlock (
				CustomerId, FacilityId,BlockCode, BlockName, ShortName, CreatedBy, CreatedDate, ActiveFromDate, ActiveFromDateUTC, ActiveToDate, ActiveToDateUTC,
				CreatedDateUTC, ModifiedBy, ModifiedDate, ModifiedDateUTC, Active, BuiltIn) OUTPUT INSERTED.BlockId INTO @Table
	SELECT CustomerId, FacilityId, BlockCode, BlockName, ShortName, 1, GETDATE(),GETDATE(),GETUTCDATE(), GETDATE(), GETUTCDATE(),
				GETUTCDATE(), UserId, GETDATE(), GETUTCDATE(), Active, 1
				FROM @Block

	SELECT BlockId, [Timestamp], '' ErrorMsg,GuId FROM MstLocationBlock WHERE BlockId IN (SELECT ID FROM @Table)

END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
