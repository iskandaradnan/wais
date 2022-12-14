USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[BlockMst_Update]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[BlockMst_Update]
(
	@Block As [dbo].[BemsBlockMst] readonly
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


	declare @blockcount int = (select count(1) from MstLocationBlock where BlockId=(select BlockId from  @Block))
	if(@blockcount = 0 )
	begin
	          SELECT 0  BlockId, null  Timestamp , 'Record does not exist' ErrorMsg ,'' AS GuId
	end 
	else 
	begin
	      
		DECLARE	   @mStatus NVARCHAR(1000)
		DECLARE    @mLastUpdatedBy NVARCHAR(1000)
		SET		   @mStatus = (SELECT CASE when Active = 1 then 'Active' else case when Active = 0 then 'Inactive' END END as Status FROM  MstLocationBlock where BlockId in (SELECT BlockId FROM @Block))
		SET		   @mLastUpdatedBy = (SELECT a.StaffName FROM UMUserRegistration  A INNER JOIN MstLocationBlock B on A.UserRegistrationId = B.ModifiedBy WHERE B.BlockId in (SELECT BlockId FROM @Block) )	
		insert into [FmHistory](TableName,TableGuid,TableRowData,ModifiedDate,ModifiedUTCDate)
		select 'MstLocationBlock',GuId,(SELECT Block.BlockName,Block.ShortName,@mStatus as Status,@mLastUpdatedBy as LastUpdatedBy,Block.ModifiedDate as LastUpdateOn
		FROM MstLocationBlock Block
		where Block.BlockId in (SELECT BlockId FROM @Block)
		FOR JSON AUTO),GETDATE(),GETUTCDATE() 
		from MstLocationBlock b1 where BlockId in (SELECT BlockId FROM @Block)
		and Not exists (select 1 from @Block a where  isnull(a.BlockName,'')=isnull(b1.BlockName,'') and  isnull(a.ShortName,'')=isnull(b1.ShortName,'')  and isnull(a.Active,'')= isnull(b1.Active,''))

UPDATE A
SET 
A.FacilityId = B.FacilityId,
A.BlockName = B.BlockName,
A.BlockCode = B.BlockCode,
A.ShortName = B.ShortName,
A.Active = B.Active,
A.ModifiedBy = B.UserId,
A.ModifiedDate = GETDATE(),
A.ModifiedDateUTC = GETUTCDATE()
FROM MstLocationBlock A
INNER JOIN @Block B
ON A.BlockId = B.BlockId

	SELECT BlockId, [Timestamp], ''  ErrorMsg,GuId FROM MstLocationBlock WHERE BlockId = (SELECT BlockId FROM @Block)

	end 

END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
