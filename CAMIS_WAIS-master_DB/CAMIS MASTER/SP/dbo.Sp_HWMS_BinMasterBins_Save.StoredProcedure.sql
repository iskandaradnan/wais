USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_BinMasterBins_Save]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Sp_HWMS_BinMasterBins_Save](
  @BinMasterId INT,
  @BinNoId INT,
  @BinNo VARCHAR(50),
  @Manufacturer VARCHAR(50),
  @Weight VARCHAR(50) = NULL,
  @OperationDate DATETIME,
  @Status VARCHAR(50),
  @DisposedDate DATETIME = NULL,
  @IsDeleted BIT
)
AS
BEGIN
SET NOCOUNT ON;

BEGIN TRY
	IF(EXISTS(SELECT 1 FROM HWMS_BinMasterBins WHERE BinNoId = @BinNoId and BinMasterId = @BinMasterId))
		BEGIN
			UPDATE HWMS_BinMasterBins SET [BinNo] = @BinNo, [Manufacturer] = @Manufacturer,[Weight]=@Weight,[OperationDate]=@OperationDate,
			[Status]=@Status, [DisposedDate]=@DisposedDate,[isDeleted] = CAST(@IsDeleted AS INT)	    
			WHERE BinNoId= @BinNoId and BinMasterId = @BinMasterId
	  END	        
	ELSE
		BEGIN
		  INSERT INTO HWMS_BinMasterBins([BinMasterId],[BinNo],[Manufacturer],[Weight],[OperationDate],[Status],[DisposedDate],[isDeleted])
		  VALUES(@BinMasterId,@BinNo,@Manufacturer,@Weight,@OperationDate,@Status,@DisposedDate,CAST(@IsDeleted AS INT))
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
	Error_Procedure() as 'Sp_HWMS_BinMasterGridFields',  
	Error_Severity() as ErrorSeverity,  
	Error_State() as ErrorState,  
	GETDATE () as DateErrorRaised  
END CATCH
end
GO
