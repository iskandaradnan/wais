USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_HWMS_CollectionCategoryUserArea_Save]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- SELECT * FROM HWMS_RouteCollectionUserArea
CREATE procedure [dbo].[sp_HWMS_CollectionCategoryUserArea_Save](
@RouteCollectionUserAreaId int,
@RouteCollectionId int,
@UserAreaCode nvarchar(100),
@UserAreaName varchar(100)  = null,
@Remarks nvarchar(500) = null,
@isDeleted bit
)	
AS
BEGIN
SET NOCOUNT ON;

BEGIN TRY
		IF(@RouteCollectionUserAreaId = 0)
		BEGIN
			IF(EXISTS(SELECT 1 FROM HWMS_RouteCollectionUserArea WHERE [RouteCollectionId] = @RouteCollectionId AND [UserAreaCode] = @UserAreaCode AND [isDeleted] = 0))
			BEGIN
				SELECT -1 AS RouteCollectionUserAreaId
			END
			ELSE
			BEGIN
				INSERT INTO HWMS_RouteCollectionUserArea ( [RouteCollectionId], [UserAreaCode], [UserAreaName], [Remarks], [isDeleted] )
				VALUES	( @RouteCollectionId, @UserAreaCode, @UserAreaName, @Remarks, CAST(@isDeleted AS INT))
				SELECT @@IDENTITY AS RouteCollectionUserAreaId
			END
		END
		ELSE
		BEGIN
				UPDATE HWMS_RouteCollectionUserArea SET [UserAreaCode] = @UserAreaCode , [UserAreaName] = @UserAreaName, [Remarks] = @Remarks ,
				[isDeleted] = CAST(@isDeleted AS INT)
				WHERE RouteCollectionUserAreaId = @RouteCollectionUserAreaId AND [RouteCollectionId] = @RouteCollectionId	
				SELECT @RouteCollectionUserAreaId AS RouteCollectionUserAreaId				
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
	Error_Procedure() as 'sp_HWMS_CollectionCategoryUserArea_Save',  
	Error_Severity() as ErrorSeverity,  
	Error_State() as ErrorState,  
	GETDATE () as DateErrorRaised  
END CATCH
end



GO
