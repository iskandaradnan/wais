USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_ToiletInspectionTxn_Get]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Sp_CLS_ToiletInspectionTxn_Get]
(
	@Id INT
)
	
AS 

BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY

	SELECT * FROM CLS_ToiletInspectionTxn where  ToiletInspectionId =  @Id

	select * from CLS_ToiletInspectionTxn_Loc where  ToiletInspectionId = @Id
	
	SELECT * FROM CLS_ToiletInspectionTxn_Attachment WHERE ToiletInspectionId = @Id AND isDeleted = 0	
			
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
		Error_Procedure() as 'Sp_CLS_ToiletInspection_Get',  
		Error_Severity() as ErrorSeverity,  
		Error_State() as ErrorState,  
		GETDATE () as DateErrorRaised  	
END CATCH
SET NOCOUNT OFF
END
GO
