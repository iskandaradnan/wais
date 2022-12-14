USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LevelMst_Update]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[LevelMst_Update]
(
	@Level As [dbo].[BemsLevelMst] readonly
)	
AS 

-- Exec [UpdateUserRole] 

--/*=====================================================================================================================
--APPLICATION		: UETrack
--NAME				: UpdateUserRole
--DESCRIPTION		: SAVE RECORD IN UMUSERROLE TABLE 
--AUTHORS			: BIJU NB
--DATE				: 19-March-2018
-------------------------------------------------------------------------------------------------------------------------
--VERSION HISTORY 
--------------------:---------------:---------------------------------------------------------------------------------------
--Init				: Date          : Details
--------------------:---------------:---------------------------------------------------------------------------------------
--BIJU NB           : 19-March-2018 : 
-------:------------:----------------------------------------------------------------------------------------------------*/
BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY
	DECLARE @Table TABLE (ID INT)



DECLARE	   @mStatus NVARCHAR(1000)
DECLARE    @mLastUpdatedBy NVARCHAR(1000)
SET		   @mStatus = (SELECT CASE when Active = 1 then 'Active' else case when Active = 0 then 'Inactive' END END as Status FROM  MstLocationLevel where LevelId =(SELECT LevelId FROM @Level))
SET		   @mLastUpdatedBy = (SELECT a.StaffName FROM UMUserRegistration  A INNER JOIN MstLocationLevel B on A.UserRegistrationId = B.ModifiedBy WHERE B.LevelId =(SELECT LevelId FROM @Level))	
insert into [FmHistory](TableName,TableGuid,TableRowData,ModifiedDate,ModifiedUTCDate)
select 'MstLocationLevel',GuId,(SELECT Levels.LevelName,Levels.ShortName,@mStatus as Status,@mLastUpdatedBy as LastUpdatedBy,Levels.ModifiedDate as LastUpdateOn
FROM MstLocationLevel Levels
where Levels.LevelId =(SELECT LevelId FROM @Level)
FOR JSON AUTO),GETDATE(),GETUTCDATE() from MstLocationLevel b1 where LevelId =(SELECT LevelId FROM @Level)
and Not exists (select 1 from @Level a where  isnull(a.LevelName,'')=isnull(b1.LevelName,'') and  isnull(a.ShortName,'')=isnull(b1.ShortName,'')  and isnull(a.Active,'')= isnull(b1.Active,''))

UPDATE A
SET 

A.BlockId = B.BlockId,
A.LevelName = B.LevelName,
A.LevelCode = B.LevelCode,
A.ShortName = B.ShortName,
A.Active = B.Active,
A.ModifiedBy = B.UserId,
A.ModifiedDate = GETDATE(),
A.ModifiedDateUTC = GETUTCDATE()
FROM MstLocationLevel A
INNER JOIN @Level B
ON A.LevelId = B.LevelId

	SELECT LevelId, [Timestamp],GuId FROM MstLocationLevel WHERE LevelId = (SELECT LevelId FROM @Level)

END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
