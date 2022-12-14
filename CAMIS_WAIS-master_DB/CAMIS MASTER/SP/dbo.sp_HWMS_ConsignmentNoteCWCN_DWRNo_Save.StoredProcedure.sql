USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_HWMS_ConsignmentNoteCWCN_DWRNo_Save]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_HWMS_ConsignmentNoteCWCN_DWRNo_Save](
        @DWRNoId int,
        @ConsignmentId int,
        @DWRDocId INT,
		@BinNo varchar(100),
        @Weight varchar(100),
		@Remarks_Bin varchar(500)='NULL',
		@IsDeleted bit)
AS
BEGIN
SET NOCOUNT ON; 
BEGIN TRY
   IF(EXISTS(SELECT 1 FROM HWMS_ConsignmentNoteCWCN_DWRNo WHERE [DWRNoId] =  @DWRNoId AND [ConsignmentId]=@ConsignmentId ))    
	   BEGIN
		   UPDATE HWMS_ConsignmentNoteCWCN_DWRNo SET DWRDocId = @DWRDocId, [BinNo] = @BinNo,
		   [Weight]= @Weight, [Remarks_Bin]= @Remarks_Bin, isDeleted = CAST(@isDeleted AS INT) 
			WHERE [DWRNoId] =  @DWRNoId AND [ConsignmentId]=@ConsignmentId

			
			update HWMS_DailyWeighingRecord  set ConsignmentNo =  @ConsignmentId 	 where DWRId = @DWRDocId
			
			
	   END
	ELSE
	   BEGIN
			INSERT INTO HWMS_ConsignmentNoteCWCN_DWRNo ([ConsignmentId], DWRDocId, [BinNo], [Weight], [Remarks_Bin], [isDeleted])
			VALUES(@ConsignmentId,@DWRDocId,@BinNo,@Weight,@Remarks_Bin,CAST(@isDeleted AS INT))

			update HWMS_DailyWeighingRecord  set ConsignmentNo =  @ConsignmentId 	 where DWRId = @DWRDocId
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
		Error_Procedure() as 'sp_HWMS_ConsignmentNoteCWCN_DWRNo_Save',  
		Error_Severity() as ErrorSeverity,  
		Error_State() as ErrorState,  
		GETDATE () as DateErrorRaised  	
END CATCH 
end
GO
