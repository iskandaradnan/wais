USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_CLS_JiDetails_QualityRating]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[sp_CLS_JiDetails_QualityRating](@pSatisfactory int,
                                                @pNoOfUserLocations int,
												@pUnSatisfactory int,
												@pGrandTotal int,
												@pNotApplicable int,
												@pDetailsId int
                                                )
												as
begin
SET NOCOUNT ON;

BEGIN TRY
--IF(@pDeptAreaId = 0)
BEGIN
insert into CLS_JiDetails_QualityRating values(@pSatisfactory,
                                               @pNoOfUserLocations,
											   @pUnSatisfactory,
											   @pGrandTotal,
											   @pNotApplicable,
											   @pDetailsId)
END
--ELSE
--	BEGIN
--		-- UPDATE
--		UPDATE CLS_JiDetails_QualityRating SET Satisfactory=@pSatisfactory,NoOfUserLocations=@pNoOfUserLocations,UnSatisfactory=@pUnSatisfactory,GrandTotalElementsInspected=@pGrandTotal,
--		NotApplicable = @pNotApplicable
--		where DetailsId=@pDetailsId
--		END
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
	Error_Procedure() as 'sp_CLS_JiDetails_QualityRating',
	Error_Severity() as ErrorSeverity,
	Error_State() as ErrorState,
	GETDATE () as DateErrorRaised
END CATCH
END
GO
