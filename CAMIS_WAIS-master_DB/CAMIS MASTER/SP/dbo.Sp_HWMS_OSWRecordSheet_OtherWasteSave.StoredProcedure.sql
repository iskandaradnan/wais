USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_OSWRecordSheet_OtherWasteSave]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_HWMS_OSWRecordSheet_OtherWasteSave]
(
@OSWRecordId int,
@Date datetime,
@CollectionTime nvarchar(50),
@CollectionStatus nvarchar(50),
@QC nvarchar(50)='',
@OSWRId int,
@isDeleted bit
)
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRY
IF(@OSWRecordId = 0)
	BEGIN
		IF(EXISTS(SELECT 1 FROM HWMS_OSWRecordSheet_OtherScheduleWasteSave WHERE [Date] = @Date ))			           
		BEGIN
			SELECT -1 	AS OSWRecordId		 
		END
		ELSE
		BEGIN
			INSERT INTO HWMS_OSWRecordSheet_OtherScheduleWasteSave ( [Date], [CollectionTime], [CollectionStatus], [QC], [OSWRId], [isDeleted] ) 
		    VALUES( @Date, @CollectionTime, @CollectionStatus, @QC,@OSWRId,  CAST(@isDeleted AS INT))	
	
			SELECT @@Identity as 'OSWRecordId'		    
		END
	END	
	ELSE
	BEGIN
	  	UPDATE HWMS_OSWRecordSheet_OtherScheduleWasteSave SET [Date] = @Date, [CollectionTime] = @CollectionTime, [CollectionStatus] = @CollectionStatus,[QC] = @QC,
		[isDeleted] = CAST(@isDeleted AS INT) 
		WHERE  OSWRecordId = @OSWRecordId AND OSWRId= @OSWRId  

		SELECT @OSWRecordId as OSWRecordId
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
	Error_Procedure() as 'Sp_HWMS_OSWRecordSheet_OtherScheduleWasteSave',  
	Error_Severity() as ErrorSeverity,  
	Error_State() as ErrorState,  
	GETDATE () as DateErrorRaised  
END CATCH
end
GO
