USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LevelMst_IsLevelCodeDuplicate]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[LevelMst_IsLevelCodeDuplicate]
(
	@pLevelId INT,
	@pFacilityId INT, 
	@pCustomerId INT,
	@LevelCode NVARCHAR(50)
	--@IsDuplicate BIT OUTPUT
)
	
AS 

-- Exec [LevelMst_IsLevelCodeDuplicate] 1, 'Role1'

--/*=====================================================================================================================
--APPLICATION		: UETrack
--NAME				: LevelMst_IsLevelCodeDuplicate
--DESCRIPTION		: CHECKS FOR THE UNIQUENESS OF USER ROLE
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
	
	--SET @IsDuplicate = 1;
	DECLARE @Cnt INT;

	--IF (isnull(@pLevelId, 0) = 0)
	SELECT @Cnt = (select COUNT(1) FROM MstLocationLevel WHERE LevelCode = @LevelCode  and FacilityId=@pFacilityId)
	

	if(@Cnt = 0 )
	begin
	       Select 1 Isvalid
	end 
	else
	begin
	       Select 2 Isvalid
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
