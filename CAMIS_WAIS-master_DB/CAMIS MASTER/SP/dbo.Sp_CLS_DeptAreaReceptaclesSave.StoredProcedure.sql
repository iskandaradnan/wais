USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_DeptAreaReceptaclesSave]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_CLS_DeptAreaReceptaclesSave]
 @pDeptAreaId int, @pUserAreaId int,	 @pBin660L int,     @pBin240L int,
  @pWastePaperBasket int, @pPedalBin int,  @pBedsideBin int,  @pFlipFlop int,  @pFoodBin int  
as
begin
SET NOCOUNT ON;

BEGIN TRY

DECLARE @pTotalReceptacles INT
SET @pTotalReceptacles = @pBin660L + @pBin240L +  @pWastePaperBasket + @pPedalBin +  @pBedsideBin +  @pFlipFlop +  @pFoodBin   

	IF(EXISTS(SELECT 1 FROM CLS_DeptAreaReceptacles WHERE UserAreaId = @pUserAreaId ))
	BEGIN
		UPDATE CLS_DeptAreaReceptacles SET	 Bin660L = @pBin660L,  Bin240L = @pBin240L, WastePaperBasket = @pWastePaperBasket,  
	  PedalBin = @pPedalBin, BedsideBin = @pBedsideBin,  FlipFlop = @pFlipFlop,   FoodBin = @pFoodBin, DeptAreaId = @pDeptAreaId WHERE UserAreaId = @pUserAreaId
	  SELECT * FROM CLS_DeptAreaReceptacles WHERE  UserAreaId = @pUserAreaId

	  UPDATE CLS_DeptAreaDetails SET TotalReceptacles = @pTotalReceptacles WHERE UserAreaId = @pUserAreaId

	END
	ELSE
	BEGIN
		INSERT INTO CLS_DeptAreaReceptacles
		(  [DeptAreaId], [UserAreaId], [Bin660L], [BIn240L], [WastePaperBasket], [PedalBin], [BedsideBin], [FlipFlop], [FoodBin] )
		
		 VALUES(@pDeptAreaId, @pUserAreaId,	@pBin660L,  @pBin240L,  @pWastePaperBasket,   @pPedalBin,  @pBedsideBin,  @pFlipFlop,   @pFoodBin  )

	 UPDATE CLS_DeptAreaDetails SET TotalReceptacles = @pTotalReceptacles WHERE UserAreaId = @pUserAreaId
	 --SELECT * FROM CLS_DeptAreaReceptacles WHERE  UserAreaId = @pUserAreaId

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
	Error_Procedure() as 'sp_CLS_DeptAreaDetailsReceptacles',
	Error_Severity() as ErrorSeverity,
	Error_State() as ErrorState,
	GETDATE () as DateErrorRaised
END CATCH
END
GO
