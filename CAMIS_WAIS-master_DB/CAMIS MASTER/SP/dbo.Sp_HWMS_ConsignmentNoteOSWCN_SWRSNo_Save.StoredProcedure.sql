USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_ConsignmentNoteOSWCN_SWRSNo_Save]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Sp_HWMS_ConsignmentNoteOSWCN_SWRSNo_Save](
        @SWRSNoId int,
		@ConsignmentOSWCNId int,
		@UserAreaCode nvarchar(30),
		@UserAreaName nvarchar(30),
		@SWRSNo nvarchar(30),
		@IsDeleted bit)
AS
BEGIN 
SET NOCOUNT ON; 
BEGIN TRY	
     IF(EXISTS(SELECT 1 FROM HWMS_ConsignmentNoteOSWCN_SWRSNo WHERE [SWRSNoId] =  @SWRSNoId AND [ConsignmentOSWCNId]=@ConsignmentOSWCNId ))    
	   BEGIN
		   UPDATE HWMS_ConsignmentNoteOSWCN_SWRSNo SET  [UserAreaCode] = @UserAreaCode,
		   [UserAreaName]= @UserAreaName, [SWRSNo]= @SWRSNo, isDeleted = CAST(@isDeleted AS INT) 
			WHERE [SWRSNoId] =  @SWRSNoId AND [ConsignmentOSWCNId]=@ConsignmentOSWCNId

			
			 UPDATE HWMS_OSWRecordSheet SET ConsignmentNo = @ConsignmentOSWCNId WHERE OSWRSNo = @SWRSNo
			 			

	   END
     ELSE
	   BEGIN				
			INSERT INTO HWMS_ConsignmentNoteOSWCN_SWRSNo ([ConsignmentOSWCNId], [UserAreaCode], [UserAreaName], [SWRSNo], [isDeleted] )
			VALUES(@ConsignmentOSWCNId,@UserAreaCode,@UserAreaName,@SWRSNo, CAST(@isDeleted AS INT))	
			
			UPDATE HWMS_OSWRecordSheet SET ConsignmentNo = @ConsignmentOSWCNId WHERE OSWRSNo = @SWRSNo				   											
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
	Error_Procedure() as 'Sp_HWMS_ConsignmentNoteOSWCN_SWRSNo_Save',  
	Error_Severity() as ErrorSeverity,  
	Error_State() as ErrorState,  
	GETDATE () as DateErrorRaised  

	SELECT 'Error occured while inserting'
END CATCH 
END

       
GO
