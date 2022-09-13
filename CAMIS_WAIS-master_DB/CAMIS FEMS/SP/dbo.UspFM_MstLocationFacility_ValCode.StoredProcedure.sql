USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_MstLocationFacility_ValCode]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[UspFM_MstLocationFacility_ValCode]
(
	@FacilityId INT,
	@FacilityCode NVARCHAR(100)
	--@IsDuplicate BIT OUTPUT
)
	
AS 

-- Exec [IsRoleDuplicate] 1, 'Role1'

--/*=====================================================================================================================
--APPLICATION		: UETrack
--NAME				: IsRoleDuplicate
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
	
	Declare  @IsDuplicate bit = 0;
	DECLARE @Cnt INT=0;

	IF (@FacilityId = 0)
	SELECT @Cnt = COUNT(1) FROM MstLocationFacility WHERE FacilityCode = @FacilityCode
	
	IF (@Cnt = 0) SET @IsDuplicate = 0;
	ELSE SET @IsDuplicate = 1;

	select @IsDuplicate IsDuplicate
	
END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
