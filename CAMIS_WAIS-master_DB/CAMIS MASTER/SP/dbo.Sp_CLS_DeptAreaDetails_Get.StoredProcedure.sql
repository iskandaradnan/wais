USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_DeptAreaDetails_Get]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec [dbo].[Sp_CLS_DeptAreaDetails_Get] 30
CREATE PROCEDURE [dbo].[Sp_CLS_DeptAreaDetails_Get] ( @DeptAreaId INT  )	

AS 

BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

BEGIN TRY
	
	SELECT * FROM [dbo].[CLS_DeptAreaDetails] WHERE DeptAreaId = @DeptAreaId

	SELECT * FROM [dbo].[CLS_DeptAreaDetailsLocation] WHERE DeptAreaId = @DeptAreaId

	SELECT * , FlipFlop as FilpFlop FROM [dbo].[CLS_DeptAreaReceptacles] WHERE DeptAreaId = @DeptAreaId

	SELECT * FROM [dbo].[CLS_DeptAreaDailyCleaning] WHERE DeptAreaId = @DeptAreaId

	SELECT * FROM [dbo].[CLS_DeptAreaPeriodicWork] WHERE DeptAreaId = @DeptAreaId

	SELECT * FROM [dbo].[CLS_DeptAreaToilet]  WHERE DeptAreaId = @DeptAreaId AND [isDeleted] = 0

	SELECT * FROM [dbo].[CLS_DeptAreaDispenser]  WHERE DeptAreaId = @DeptAreaId

	SELECT * FROM [dbo].[CLS_DeptAreaVariationDetails]  WHERE DeptAreaId = @DeptAreaId AND [isDeleted] = 0
		
	
END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END




GO
