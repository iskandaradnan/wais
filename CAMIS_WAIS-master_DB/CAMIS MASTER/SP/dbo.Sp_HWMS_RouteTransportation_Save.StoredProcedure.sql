USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_RouteTransportation_Save]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_HWMS_RouteTransportation_Save]

@RouteTransportationId int,
@CustomerId int,
@FacilityId int,
@RouteCode nvarchar(100),
@RouteDescription nvarchar(max),
@RouteCategory varchar(100),
@Status int

AS
BEGIN
SET NOCOUNT ON;
BEGIN TRY

IF(@RouteTransportationId = 0)
BEGIN
	IF(EXISTS(SELECT 1 FROM [HWMS_RouteTransportation] WHERE CustomerId = @CustomerId and FacilityId = @FacilityId and RouteCode = @RouteCode))
	BEGIN
			SELECT -1 AS RouteTransportationId		
	END
	ELSE
	BEGIN 
		INSERT INTO [HWMS_RouteTransportation] VALUES(@CustomerId,@FacilityId,@RouteCode,@RouteDescription,@RouteCategory,@Status)	
		SELECT @@Identity as RouteTransportationId	
	END
END
ELSE
	BEGIN	
		UPDATE [HWMS_RouteTransportation] SET RouteCode = @RouteCode, RouteDescription = @RouteDescription, RouteCategory = @RouteCategory, Status = @Status WHERE RouteTransportationId = @RouteTransportationId
		SELECT @RouteTransportationId as RouteTransportationId
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
	Error_Procedure() as 'sp_HWMS_TransportationCategory',  
	Error_Severity() as ErrorSeverity,  
	Error_State() as ErrorState,  
	GETDATE () as DateErrorRaised  
END CATCH
end
GO
