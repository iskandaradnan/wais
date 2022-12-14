USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_HWMS_DeptAreaCollectionFrequency]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_HWMS_DeptAreaCollectionFrequency](
            @FrequencyId int,                                
            @pWasteType nvarchar(50),
			@pFrequencyType nvarchar(50),
			@pCollectionFrequency nvarchar(50)='',
			@pStartTime1 time=null,
			@pEndTime1 time=null,
		    @pStartTime2 time=null,
			@pEndTime2 time=null,
		    @pStartTime3 time=null,
		    @pEndTime3 time=null,
            @pStartTime4 time=null,
		    @pEndTime4 time=null,
		    @pDeptAreaId int,
		    @IsDeleted bit)
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRY
IF(EXISTS(SELECT 1 FROM HWMS_DeptAreaCollectionFrequency WHERE [FrequencyId]=@FrequencyId AND [DeptAreaId]=@pDeptAreaId ))
        BEGIN
		UPDATE HWMS_DeptAreaCollectionFrequency SET [WasteType]=@pWasteType,[FrequencyType]=@pFrequencyType,[CollectionFrequency]=@pCollectionFrequency,[StartTime1]=@pStartTime1,[EndTime1]=@pEndTime1,
		[StartTime2] = @pStartTime2,[EndTime2]=@pEndTime2,[StartTime3]=@pStartTime3,[EndTime3]=@pEndTime3,[StartTime4]=@pStartTime4,[EndTime4]=@pEndTime4,
		[isDelete] = CAST(@IsDeleted AS INT) WHERE [FrequencyId]=@FrequencyId AND [DeptAreaId]=@pDeptAreaId 																   
        END
ELSE
	    BEGIN
	
		INSERT INTO HWMS_DeptAreaCollectionFrequency([WasteType],[FrequencyType],[CollectionFrequency],[StartTime1],[EndTime1],[StartTime2],[EndTime2],
		[StartTime3],[EndTime3],[StartTime4],[EndTime4],[DeptAreaId],[isDelete])		
		VALUES(
        @pWasteType, @pFrequencyType, @pCollectionFrequency,@pStartTime1,  @pEndTime1,@pStartTime2,  @pEndTime2,@pStartTime3,  @pEndTime3,
	    @pStartTime4, @pEndTime4, @pDeptAreaId,CAST(@IsDeleted AS INT))      
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
	Error_Procedure() as 'SP_HWMS_DeptAreaCollectionFrequency',
	Error_Severity() as ErrorSeverity,
	Error_State() as ErrorState,
	GETDATE () as DateErrorRaised
END CATCH
END



GO
