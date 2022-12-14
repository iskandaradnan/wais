USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LevelMst_Save]    Script Date: 20-09-2021 17:05:50 ******/
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


create PROCEDURE  [dbo].[LevelMst_Save]                           

(
	@Level As [dbo].[BemsLevelMst] readonly
)	     

AS      

BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY
	DECLARE @Table TABLE (ID INT)

	INSERT INTO MstLocationLevel (
				CustomerId, FacilityId, BlockId, LevelCode, LevelName, ShortName, CreatedBy, CreatedDate, ActiveFromDate, ActiveFromDateUTC, ActiveToDate, ActiveToDateUTC,
				CreatedDateUTC, ModifiedBy, ModifiedDate, ModifiedDateUTC, Active, BuiltIn) OUTPUT INSERTED.LevelId INTO @Table
	SELECT     CustomerId, FacilityId, BlockId, LevelCode, LevelName, ShortName, 1, GETDATE(),GETDATE(),GETUTCDATE(), GETDATE(), GETUTCDATE(),
				GETUTCDATE(), UserId, GETDATE(), GETUTCDATE(), Active, 1
				FROM @Level

	SELECT LevelId, [Timestamp],GuId FROM MstLocationLevel WHERE LevelId IN (SELECT ID FROM @Table)

END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
