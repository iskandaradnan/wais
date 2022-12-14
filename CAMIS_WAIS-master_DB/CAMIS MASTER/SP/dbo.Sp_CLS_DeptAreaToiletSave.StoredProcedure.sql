USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_DeptAreaToiletSave]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_CLS_DeptAreaToiletSave](
					@pDeptAreaId INT,	@pUserAreaId int,
					@pLocationId int,  @pLocationCode nvarchar(50),
					@pType  int='', @pFrequency  int='', @pDetails  int='',
					@pMirror bit, @pFloor bit,	@pWall bit,
					@pUrinal bit, @pBowl bit, @pBasin bit,
					@pToiletRoll bit, @pSoapDispenser bit,
					@pAutoAirFreshner bit, @pWaste bit,	@isDeleted bit)
AS
BEGIN
SET NOCOUNT ON;

BEGIN TRY
	IF(EXISTS(SELECT 1 FROM CLS_DeptAreaToilet WHERE UserAreaId = @pUserAreaId and LocationId = @pLocationId))
	BEGIN
		UPDATE CLS_DeptAreaToilet SET  DeptAreaId = @pDeptAreaId, LocationCode = @pLocationCode,[Type]=@pType, Frequency=@pFrequency, Details=@pDetails,  Mirror=@pMirror, [Floor]=@pFloor, Wall=@pWall, Urinal=@pUrinal, Bowl=@pBowl,
		  Basin=@pBasin, ToiletRoll=@pToiletRoll, SoapDispenser=@pSoapDispenser,
		  AutoAirFreshner=@pAutoAirFreshner, Waste=@pWaste,  [isDeleted] = CAST(@isDeleted AS INT) 
		  WHERE UserAreaId = @pUserAreaId and LocationId = @pLocationId
		
		SELECT *  FROM CLS_DeptAreaToilet WHERE UserAreaId = @pUserAreaId and LocationId = @pLocationId	and isDeleted = 0	
	END

ELSE
	BEGIN		
		INSERT INTO CLS_DeptAreaToilet VALUES (
								@pDeptAreaId, @pUserAreaId, @pLocationId, @pLocationCode,
								@pType, @pFrequency, @pDetails,	@pMirror, @pFloor, @pWall,
								@pUrinal, @pBowl, @pBasin,	@pToiletRoll, @pSoapDispenser,
								@pAutoAirFreshner, @pWaste, CAST(@isDeleted AS INT) )

		SELECT *  FROM CLS_DeptAreaToilet WHERE UserAreaId = @pUserAreaId and LocationId = @pLocationId and isDeleted = 0
	END

END TRY
	BEGIN CATCH
		INSERT INTO ExceptionLog (
		ErrorLine, ErrorMessage, ErrorNumber,
		ErrorProcedure, ErrorSeverity, ErrorState,
		DateErrorRaised)
		SELECT
		ERROR_LINE () as ErrorLine,
		Error_Message() as ErrorMessage,
		Error_Number() as ErrorNumber,
		Error_Procedure() as 'Sp_CLS_DeptAreaToilet',
		Error_Severity() as ErrorSeverity,
		Error_State() as ErrorState,
		GETDATE () as DateErrorRaised
	END CATCH
END
GO
