USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_CLS_DeptAreaDetailsLocation]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_CLS_DeptAreaDetailsLocation] (
		   @pDeptAreaId int, @pUserAreaId int, @pLocationId int, @pLocationCode nvarchar(50)='',
		   @pStatus int='', @pFloor bit, @pWalls bit, @pCelling bit, @pWindowsDoors bit, 
		   @pReceptaclesContainers bit,  @pFurnitureFixtureEquipments bit  )

AS
BEGIN

SET NOCOUNT ON;

BEGIN TRY

	IF(EXISTS(SELECT 1 FROM [dbo].[CLS_DeptAreaDetailsLocation] WHERE UserAreaId = @pUserAreaId AND LocationId = @pLocationId))
	BEGIN

		UPDATE [dbo].[CLS_DeptAreaDetailsLocation] SET  
		LocationCode = @pLocationCode, [Status] = @pStatus, [Floor] = @pFloor, 
		Walls = @pWalls,	[Celling] = @pCelling, WindowsDoors = @pWindowsDoors,
		ReceptaclesContainers = @pReceptaclesContainers, FurnitureFixtureEquipments = @pFurnitureFixtureEquipments 
		WHERE UserAreaId = @pUserAreaId AND LocationId = @pLocationId

		SELECT * FROM [dbo].[CLS_DeptAreaDetailsLocation]  WHERE UserAreaId = @pUserAreaId AND LocationId = @pLocationId

	END
	ELSE
	BEGIN

		INSERT INTO [dbo].[CLS_DeptAreaDetailsLocation]
		( [DeptAreaId], [UserAreaId], [LocationId], [LocationCode], [Status], [Floor], [Walls], [Celling], [WindowsDoors], [ReceptaclesContainers], [FurnitureFixtureEquipments] )
		 VALUES
		( @pDeptAreaId, @pUserAreaId, @pLocationId, @pLocationCode, @pStatus, @pFloor, @pWalls, @pCelling, @pWindowsDoors,
		 @pReceptaclesContainers, @pFurnitureFixtureEquipments )

		 SELECT * FROM [dbo].[CLS_DeptAreaDetailsLocation]  WHERE UserAreaId = @pUserAreaId AND LocationId = @pLocationId

	END

END TRY

BEGIN CATCH
	INSERT INTO ExceptionLog ( ErrorLine, ErrorMessage, ErrorNumber, ErrorProcedure, ErrorSeverity, ErrorState, DateErrorRaised )
	SELECT
	ERROR_LINE () as ErrorLine,
	Error_Message() as ErrorMessage,
	Error_Number() as ErrorNumber,
	Error_Procedure() as 'SP_CLS_DeptAreaDetailsLocation',
	Error_Severity() as ErrorSeverity,
	Error_State() as ErrorState,
	GETDATE () as DateErrorRaised
END CATCH
END
GO
