USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_HWMS_CollectionCategory_Get]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_HWMS_CollectionCategory_Get]
(
	@RouteCollectionId INT
)
	
AS 
BEGIN
SET NOCOUNT ON
BEGIN TRY
        SELECT * FROM HWMS_RouteCollectionCategory where  RouteCollectionId =  @RouteCollectionId
		select * from HWMS_RouteCollectionUserArea where  RouteCollectionId = @RouteCollectionId AND isDeleted = 0
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
		Error_Procedure() as 'sp_HWMS_CollectionCategory_Get',  
		Error_Severity() as ErrorSeverity,  
		Error_State() as ErrorState,  
		GETDATE () as DateErrorRaised  	
END CATCH
END
GO
