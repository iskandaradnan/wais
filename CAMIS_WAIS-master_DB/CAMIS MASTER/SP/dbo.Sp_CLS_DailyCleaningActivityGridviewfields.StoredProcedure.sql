USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_DailyCleaningActivityGridviewfields]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_CLS_DailyCleaningActivityGridviewfields]
(
@DailyActivityId int,
@UserAreaCode varchar(30)='',
@Status varchar(30),
@A1 int='',
@A2 int='',
@A3 int='',
@A4 int='',
@A5 int='',
@B1 int='',
@C1 int='',
@D1 int='',
@D2 int='',
@D3 int='',
@D4 int='',
@E1 int=''
)
AS
BEGIN
SET NOCOUNT ON;

BEGIN TRY

IF(EXISTS(SELECT 1 FROM CLS_DailyCleaningActivityGridviewfields WHERE DailyActivityId = @DailyActivityId AND UserAreaCode = @UserAreaCode))
      BEGIN
           UPDATE CLS_DailyCleaningActivityGridviewfields SET DailyActivityId = @DailyActivityId, UserAreaCode = @UserAreaCode,
           Status=@Status, A1=@A1, A2=@A2, A3=@A3, A4=@A4, A5=@A5,B1=@B1,C1=@C1,D1=@D1,D2=@D2,D3=@D3,D4=@D4,E1=@E1 
           WHERE UserAreaCode = @UserAreaCode AND DailyActivityId = @DailyActivityId

		   SELECT DailyFetchId  FROM CLS_DailyCleaningActivityGridviewfields WHERE DailyActivityId = @DailyActivityId AND UserAreaCode = @UserAreaCode

      END
   ELSE
      BEGIN

          INSERT INTO CLS_DailyCleaningActivityGridviewfields VALUES(@DailyActivityId,@UserAreaCode,@Status,@A1,@A2,@A3,@A4,@A5,@B1,@C1,@D1,@D2,@D3,@D4,@E1)
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
	Error_Procedure() as 'Sp_CLS_DailyCleaningActivityGridviewfields',  
	Error_Severity() as ErrorSeverity,  
	Error_State() as ErrorState,  
	GETDATE () as DateErrorRaised  
END CATCH
end
GO
