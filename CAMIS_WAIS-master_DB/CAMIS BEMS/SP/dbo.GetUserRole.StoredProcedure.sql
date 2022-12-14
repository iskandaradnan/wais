USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[GetUserRole]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetUserRole]
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
	
	SELECT UserTypeId, Name, [Status], Remarks, [Timestamp] FROM UMUserRole WHERE UMUserRoleId = @Id
	
END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
