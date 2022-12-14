USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_ToiletInspectionTxn_Save]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from CLS_ToiletInspectionTxn
CREATE proc [dbo].[Sp_CLS_ToiletInspectionTxn_Save](
@ToiletInspectionId int,
@pCustomerId int,
@pFacilityId int,
@pDocumentNo nvarchar(50)='',
@pDate DateTime,
@pTotalDone int='',
@pTotalNotDone int=''
)
AS
BEGIN
SET NOCOUNT ON;

BEGIN TRY
	IF(@ToiletInspectionId=0)
		BEGIN
			IF(EXISTS(SELECT 1 FROM CLS_ToiletInspectionTxn WHERE [Date] = @pDate AND CustomerId= @pCustomerId AND FacilityId = @pFacilityId))
				BEGIN
					SELECT -1 AS ToiletInspectionId
				END		
			ELSE
				BEGIN
					INSERT INTO CLS_ToiletInspectionTxn values(@pCustomerId,@pFacilityId,@pDocumentNo,@pDate,@pTotalDone,@pTotalNotDone)
					SELECT MAX(ToiletInspectionId) as ToiletInspectionId FROM CLS_ToiletInspectionTxn
				END
		END
	ELSE
		BEGIN			
			UPDATE CLS_ToiletInspectionTxn SET  Date = @pDate ,TotalDone=@pTotalDone,TotalNotDone=@pTotalNotDone WHERE ToiletInspectionId=@ToiletInspectionId
			SELECT @ToiletInspectionId AS ToiletInspectionId
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
	Error_Procedure() as 'Sp_CLS_ToiletInspectionFieldSave',  
	Error_Severity() as ErrorSeverity,  
	Error_State() as ErrorState,  
	GETDATE () as DateErrorRaised  

END CATCH
END
GO
