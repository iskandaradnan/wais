USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_DeptAreaPeriodicWorkSave]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Sp_CLS_DeptAreaPeriodicWorkSave] (
			   @pDeptAreaId int, @pUserAreaId int, @pContainerReceptaclesWashing int, @pCeilingHighDusting int,
			   @pLightsAirCondOutletFanWiping int, @pFloorNonPolishableScrubbing int, @pFloorPolishablePolishing int, @pFloorPolishableBuffing int,
			   @pFloorCarpetBonnetBuffing int, @pFloorCarpetShampooing int, @pFloorCarpetHeatSteamExtraction int, @pWallWiping int,
			   @pWindowDoorWiping int, @pPerimeterDrainWashScrub int,   @pToiletDescaling int, @pHighRiseNetttingHighDusting int,
			   @pExternalFacadeCleaning int, @pExternalHighLevelGlassCleaning int,    @pInternetGlass int, @pFlatRoofWashScrub int,
			   @pStainlessSteelPolishing int, @pExposeCeilingTruss int,   @pLedgesDampWipe int, @pSkylightHighDusting int,
			   @pSignagesWiping int, @pDecksHighDusting int )
AS 
BEGIN
SET NOCOUNT ON;

BEGIN TRY

	IF(EXISTS(SELECT 1 FROM [dbo].[CLS_DeptAreaPeriodicWork] WHERE [UserAreaId] = @pUserAreaId ))
	BEGIN
		UPDATE CLS_DeptAreaPeriodicWork SET UserAreaId = @pUserAreaId, ContainerWashing = @pContainerReceptaclesWashing,   
		[Ceiling] = @pCeilingHighDusting,  Lights = @pLightsAirCondOutletFanWiping,
		FloorScrubbing = @pFloorNonPolishableScrubbing, FloorPolishing = @pFloorPolishablePolishing,
		FloorBuffing = @pFloorPolishableBuffing, FloorBB = @pFloorCarpetBonnetBuffing,
		FloorShampooing = @pFloorCarpetShampooing, FloorExtraction = @pFloorCarpetHeatSteamExtraction, 
		WallWiping = @pWallWiping,  WindowDW = @pWindowDoorWiping,  PerimeterDrain = @pPerimeterDrainWashScrub, 
		ToiletDescaling = @pToiletDescaling,  HighRiseNetting = @pHighRiseNetttingHighDusting, 	
		ExternalFacade = @pExternalFacadeCleaning,  ExternalHighLevelGlass = @pExternalHighLevelGlassCleaning,
		InternetGlass = @pInternetGlass, FlatRoof = @pFlatRoofWashScrub,  
		StainlessSteelPolishing = @pStainlessSteelPolishing,  ExposeCeiling = @pExposeCeilingTruss, LedgesDampWipe = @pLedgesDampWipe,  
		SkylightHighDusting = @pSkylightHighDusting, SignagesWiping = @pSignagesWiping, DecksHighDusting = @pDecksHighDusting

		SELECT * FROM [dbo].[CLS_DeptAreaPeriodicWork] WHERE [UserAreaId] = @pUserAreaId
	END
	ELSE
	BEGIN

		INSERT INTO CLS_DeptAreaPeriodicWork ([DeptAreaId], [UserAreaId], ContainerWashing, [Ceiling] ,Lights,FloorScrubbing,FloorPolishing,FloorBuffing,
								FloorBB,FloorShampooing,FloorExtraction,WallWiping,WindowDW,PerimeterDrain,
								ToiletDescaling,HighRiseNetting,ExternalFacade,ExternalHighLevelGlass,
								InternetGlass,FlatRoof,StainlessSteelPolishing,ExposeCeiling,LedgesDampWipe,
								SkylightHighDusting,SignagesWiping,DecksHighDusting )

		VALUES (@pDeptAreaId, @pUserAreaId, @pContainerReceptaclesWashing,   @pCeilingHighDusting, @pLightsAirCondOutletFanWiping,
			 @pFloorNonPolishableScrubbing, @pFloorPolishablePolishing, @pFloorPolishableBuffing, @pFloorCarpetBonnetBuffing,
			 @pFloorCarpetShampooing, @pFloorCarpetHeatSteamExtraction,  @pWallWiping,  @pWindowDoorWiping,  @pPerimeterDrainWashScrub, @pToiletDescaling,
			 @pHighRiseNetttingHighDusting, 	 @pExternalFacadeCleaning,  @pExternalHighLevelGlassCleaning,  @pInternetGlass, @pFlatRoofWashScrub,  
			 @pStainlessSteelPolishing,  @pExposeCeilingTruss,  @pLedgesDampWipe,   @pSkylightHighDusting, @pSignagesWiping, @pDecksHighDusting )

		SELECT * FROM [dbo].[CLS_DeptAreaPeriodicWork] WHERE [UserAreaId] = @pUserAreaId

	END


END TRY
BEGIN CATCH
	INSERT INTO ExceptionLog (
	ErrorLine, ErrorMessage, ErrorNumber,
	ErrorProcedure, ErrorSeverity, ErrorState,
	DateErrorRaised )
	SELECT
	ERROR_LINE () as ErrorLine,
	Error_Message() as ErrorMessage,
	Error_Number() as ErrorNumber,
	Error_Procedure() as 'sp_CLS_DeptAreaDetailsPWS',
	Error_Severity() as ErrorSeverity,
	Error_State() as ErrorState,
	GETDATE () as DateErrorRaised
END CATCH
END
GO
