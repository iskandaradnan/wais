USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_DeptAreaDailyCleaningSave]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_CLS_DeptAreaDailyCleaningSave](
				@pDeptAreaId int, @pUserAreaId int,@pDustmop int,@pDampmop int,
				@pVacuum int,@pWash int,@pSweeping int,
				@pWiping int,@pPaperHandTowel int,
				@pToiletJumbo int,@pHandSoap int,@pDeodorisers int,
				@pDomesticWasteCollection int)
AS
BEGIN
SET NOCOUNT ON;

BEGIN TRY
	IF(EXISTS(SELECT 1 FROM CLS_DeptAreaDailyCleaning WHERE UserAreaId = @pUserAreaId ))
	BEGIN
		UPDATE CLS_DeptAreaDailyCleaning SET DustMop=@pDustmop,DampMop=@pDampmop,Vacuum=@pVacuum,Washing=@pWash,Sweeping=@pSweeping,Wiping=@pWiping,
				PaperHandTowel=@pPaperHandTowel,Toilet=@pToiletJumbo,HandSoap=@pHandSoap,Deodorisers=@pDeodorisers,
				DomesticWasteCollection=@pDomesticWasteCollection, DeptAreaId = @pDeptAreaId WHERE UserAreaId=@pUserAreaId

		SELECT @pUserAreaId AS UserAreaId
	END
	ELSE
	BEGIN
		INSERT INTO CLS_DeptAreaDailyCleaning
		(
		DeptAreaId
,UserAreaId
,DustMop
,DampMop
,Vacuum
,Washing
,Sweeping
,Wiping
,PaperHandTowel
,Toilet
,HandSoap
,Deodorisers
,DomesticWasteCollection
		) VALUES
		(@pDeptAreaId, @pUserAreaId,@pDustmop,@pDampmop,@pVacuum,@pWash,@pSweeping,@pWiping,
				@pPaperHandTowel,@pToiletJumbo,@pHandSoap,@pDeodorisers,@pDomesticWasteCollection)

		 SELECT * FROM CLS_DeptAreaDailyCleaning WHERE  UserAreaId = @pUserAreaId
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
	Error_Procedure() as 'Sp_CLS_DeptAreaDailyCleaningSave',
	Error_Severity() as ErrorSeverity,
	Error_State() as ErrorState,
	GETDATE () as DateErrorRaised
END CATCH
END
GO
