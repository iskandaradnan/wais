USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[BlockMst_IsBlockCodeDuplicate]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[BlockMst_IsBlockCodeDuplicate]
(
	@pBlockId INT,
	@pCustomerId INT, 
	@pFacilityId INT, 
	@BlockCode NVARCHAR(50),
	@IsDuplicate BIT OUTPUT
)
	
AS 

-- Exec [BlockMst_IsBlockCodeDuplicate] 1, 'Role1'

--/*=====================================================================================================================
--APPLICATION		: UETrack
--NAME				: BlockMst_IsBlockCodeDuplicate
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
	
	SET @IsDuplicate = 1;
	DECLARE @Cnt INT;

	IF (@pBlockId = 0)
	SELECT @Cnt = COUNT(1) FROM MstLocationBlock WHERE BlockCode = @BlockCode and CustomerId=@pCustomerId and FacilityId=@pFacilityId
	ELSE
	SELECT @Cnt = COUNT(1) FROM MstLocationBlock WHERE BlockCode = @BlockCode and CustomerId=@pCustomerId and FacilityId=@pFacilityId

	IF (@Cnt = 0) SET @IsDuplicate = 0;
	ELSE SET @IsDuplicate = 1;
	
END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
