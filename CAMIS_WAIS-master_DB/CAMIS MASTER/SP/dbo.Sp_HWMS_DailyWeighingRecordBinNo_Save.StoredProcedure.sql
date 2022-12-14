USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_DailyWeighingRecordBinNo_Save]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_HWMS_DailyWeighingRecordBinNo_Save]
(
@BinDetailsId int,
@BinNo varchar(50),
@Weight float, 
@DWRId int,
@IsDeleted BIT
)
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRY
IF(EXISTS(SELECT 1 FROM HWMS_DailyWeighingRecordBinNo_Save WHERE [BinDetailsId] = @BinDetailsId  AND [DWRid]= @DWRId))
      BEGIN
	  UPDATE HWMS_DailyWeighingRecordBinNo_Save SET [BinNo] = @BinNo, [Weight]=@Weight, [isDeleted] = CAST(@IsDeleted AS INT)	    
	  WHERE [BinDetailsId] = @BinDetailsId AND [DWRid]= @DWRId
	  END	        
ELSE
      BEGIN
	  INSERT INTO HWMS_DailyWeighingRecordBinNo_Save([BinNo], [Weight], [DWRId], [isDeleted])
	  VALUES(@BinNo, @Weight, @DWRId, CAST(@IsDeleted AS INT))
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
	Error_Procedure() as 'Sp_HWMS_DailyWeighingRecordBinNo_Save',  
	Error_Severity() as ErrorSeverity,  
	Error_State() as ErrorState,  
	GETDATE () as DateErrorRaised  
END CATCH
end
GO
