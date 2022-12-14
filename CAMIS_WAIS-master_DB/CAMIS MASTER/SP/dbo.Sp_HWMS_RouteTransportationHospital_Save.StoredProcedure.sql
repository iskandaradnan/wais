USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_RouteTransportationHospital_Save]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- select * from [HWMS_RouteTransportationHospital]
CREATE procedure [dbo].[Sp_HWMS_RouteTransportationHospital_Save]
@RouteTransportationId int,
@RouteHospitalId int,
@HospitalCode nvarchar(100),
@HospitalName varchar(200),
@Remarks nvarchar(200) = null,
@isDeleted bit

AS
BEGIN
SET NOCOUNT ON;
BEGIN TRY
BEGIN

	IF(@RouteHospitalId = 0)
	BEGIN
		IF(EXISTS(SELECT 1 FROM [HWMS_RouteTransportationHospital] WHERE RouteTransportationId = @RouteTransportationId AND HospitalCode = @HospitalCode and [isDeleted] = 0))
			BEGIN
				SELECT -1 AS RouteHospitalId
			END
		ELSE
		BEGIN
			INSERT INTO [HWMS_RouteTransportationHospital] ( [RouteTransportationId], [HospitalCode], [HospitalName], [Remarks], [isDeleted] )
			VALUES	( @RouteTransportationId, @HospitalCode, @HospitalName, @Remarks, CAST(@isDeleted AS INT))
			SELECT @@IDENTITY AS RouteHospitalId
		END
	END
		ELSE
			BEGIN
				UPDATE [HWMS_RouteTransportationHospital] SET HospitalCode = @HospitalCode , HospitalName = @HospitalName, Remarks = @Remarks ,
				[isDeleted] = CAST(@isDeleted AS INT)
				WHERE RouteHospitalId = @RouteHospitalId AND RouteTransportationId = @RouteTransportationId

				SELECT @RouteHospitalId as RouteHospitalId

			END			
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
	Error_Procedure() as 'sp_HWMS_TransportationCategoryTable',  
	Error_Severity() as ErrorSeverity,  
	Error_State() as ErrorState,  
	GETDATE () as DateErrorRaised  
END CATCH
end
GO
