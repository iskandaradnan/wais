USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_ToiletInspectionTxn_LocSave]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[Sp_CLS_ToiletInspectionTxn_LocSave]
(
@pToiletInspectionId int,@pLocationCode nvarchar(50)='',@pStatus nvarchar(50),@pMirror int='',@pFloor int='',@pWall int='',
@pUrinal int='',@pBowl int='',@pBasin int='',@pToiletRoll int='',@pSoapDispenser int='',@pAutoAirFreshner int='',@pWaste int=''
)
AS
BEGIN
SET NOCOUNT ON;
--select * from CLS_ToiletInspectionTable
BEGIN TRY
	IF(EXISTS(SELECT 1 FROM CLS_ToiletInspectionTxn_Loc WHERE ToiletInspectionId = @pToiletInspectionId and LocationCode=@pLocationCode))
		BEGIN
			--INSERT
			UPDATE  CLS_ToiletInspectionTxn_Loc SET ToiletInspectionId=@pToiletInspectionId,LocationCode=@pLocationCode,
			Status=@pStatus,Mirror=@pMirror,Floor=@pFloor,Wall=@pWall,Urinal=@pUrinal,Bowl=@pBowl,Basin=@pBasin,
			ToiletRoll=@pToiletRoll,SoapDispenser=@pSoapDispenser,AutoAirFreshner=@pAutoAirFreshner,Waste=@pWaste
			WHERE LocationCode=@pLocationCode and ToiletInspectionId=@pToiletInspectionId 

			SELECT ToiletLocationId  FROM CLS_ToiletInspectionTxn_Loc WHERE ToiletInspectionId = @pToiletInspectionId AND LocationCode = @pLocationCode 

			--SELECT MAX(ToiletLocationId) as ToiletLocationId FROM CLS_ToiletInspectionTable
		END
	ELSE
		BEGIN 
			--UPDATE
			
			INSERT INTO CLS_ToiletInspectionTxn_Loc
			( [ToiletInspectionId] ,[LocationCode] ,[Status] ,[Mirror] ,[Floor] ,[Wall] ,[Urinal] ,[Bowl] ,[Basin] ,[ToiletRoll] ,[SoapDispenser] ,
	[AutoAirFreshner] ,[Waste] )
			 VALUES( @pToiletInspectionId,@pLocationCode, @pStatus,@pMirror,@pFloor,@pWall,@pUrinal,@pBowl,@pBasin,
			 @pToiletRoll,@pSoapDispenser, 	@pAutoAirFreshner,@pWaste)
		END

END TRY

BEGIN CATCH
		INSERT INTO ExceptionLog (
		ErrorLine, ErrorMessage, ErrorNumber,
		ErrorProcedure, ErrorSeverity, ErrorState,
		DateErrorRaised
		)
		SELECT
		ERROR_LINE () as ErrorLine,
		Error_Message() as ErrorMessage,
		Error_Number() as ErrorNumber,
		Error_Procedure() as 'Sp_CLS_ToiletInspectionTableSave',
		Error_Severity() as ErrorSeverity,
		Error_State() as ErrorState,
		GETDATE () as DateErrorRaised
END CATCH
END
GO
