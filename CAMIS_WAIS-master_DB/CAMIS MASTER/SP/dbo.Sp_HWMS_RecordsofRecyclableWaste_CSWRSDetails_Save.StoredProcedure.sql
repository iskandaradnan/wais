USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_RecordsofRecyclableWaste_CSWRSDetails_Save]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[Sp_HWMS_RecordsofRecyclableWaste_CSWRSDetails_Save]
    @CSWRSId INT,
	@UserAreaCode VARCHAR(50)=null,
	@UserAreaName VARCHAR(50)=null,
	@CSWRSNo VARCHAR(50)=null,
	@RecyclableId INT,
	@IsDeleted BIT		
		
AS
BEGIN 
SET NOCOUNT ON; 
BEGIN TRY	
		
	IF(EXISTS(SELECT 1 FROM HWMS_RecordsofRecyclableWaste_CSWRSDetails WHERE [CSWRSId]=@CSWRSId AND [RecyclableId] =@RecyclableId ))
	BEGIN
	UPDATE HWMS_RecordsofRecyclableWaste_CSWRSDetails SET [UserAreaCode] = @UserAreaCode,[UserAreaName] = @UserAreaName,[CSWRSNo]=@CSWRSNo,
	[RecyclableId]=@RecyclableId,[isDeleted]=CAST(@IsDeleted AS INT)	
	WHERE [CSWRSId]=@CSWRSId AND [RecyclableId] =@RecyclableId 
	END
ELSE
	BEGIN
	INSERT INTO HWMS_RecordsofRecyclableWaste_CSWRSDetails([UserAreaCode],[UserAreaName],[CSWRSNo],[RecyclableId],[isDeleted]) 
	VALUES(@UserAreaCode,@UserAreaName,@CSWRSNo,@RecyclableId,CAST(@IsDeleted AS INT))	
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
	Error_Procedure() as 'Sp_HWMS_RecordsofRecyclableWaste_CSWRSDetails_Save',  
	Error_Severity() as ErrorSeverity,  
	Error_State() as ErrorState,  
	GETDATE () as DateErrorRaised  

	SELECT 'Error occured while inserting'
END CATCH 
END
						
	
GO
