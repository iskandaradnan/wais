USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_MstStaff_IsStaffEmployeeIdDuplicate]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[uspFM_MstStaff_IsStaffEmployeeIdDuplicate]
(
	@pStaffMasterId INT,
	@StaffEmployeeId NVARCHAR(50),
	@IsDuplicate BIT OUTPUT
)
	
AS 

-- Exec [uspFM_MstStaff_IsStaffEmployeeIdDuplicate] 1, 'Role1'

--/*=====================================================================================================================
--APPLICATION		: UETrack
--NAME				: uspFM_MstStaff_IsStaffEmployeeIdDuplicate
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

	IF (@pStaffMasterId = 0)
	SELECT @Cnt = COUNT(1) FROM MstStaff WHERE StaffEmployeeId = @StaffEmployeeId
	ELSE
	SELECT @Cnt = COUNT(1) FROM MstStaff WHERE StaffEmployeeId = @StaffEmployeeId

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
