USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_DriverDetails_Save]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_HWMS_DriverDetails_Save](
@DriverId int,
@CustomerId int,
@FacilityId int,
@DriverCode nvarchar(50),
@DriverName nvarchar(50),
@TreatmentPlant nvarchar(50),
@Status int,
@EffectiveFrom datetime,
@EffectiveTo datetime =null,
@ContactNo nvarchar(50)='',
@Route nvarchar(50)=''
)
AS
BEGIN
SET NOCOUNT ON;

BEGIN TRY
		IF(@DriverId = 0)
		BEGIN
		    IF(EXISTS(SELECT 1 FROM HWMS_DriverDetails WHERE CustomerId = @CustomerId and FacilityId = @FacilityId and DriverCode = @DriverCode))
			BEGIN
			SELECT -1 AS DriverId
		END
		ELSE
            INSERT INTO HWMS_DriverDetails ( CustomerId, FacilityId, DriverCode, DriverName, TreatmentPlant,Status,EffectiveFrom,EffectiveTo,ContactNo,Route)
			VALUES(@CustomerId, @FacilityId, @DriverCode, @DriverName, @TreatmentPlant, @Status, @EffectiveFrom, @EffectiveTo, @ContactNo, @Route)

			SELECT MAX(@DriverId) as DriverId FROM HWMS_DriverDetails
		 END
		 ELSE
		 BEGIN
		
		 UPDATE HWMS_DriverDetails SET DriverCode = @DriverCode, DriverName = @DriverName,TreatmentPlant= @TreatmentPlant,
		 Status= @Status,EffectiveFrom= @EffectiveFrom, EffectiveTo = @EffectiveTo, ContactNo=@ContactNo, Route=@Route WHERE DriverId=@DriverId

		 SELECT @DriverId as DriverId
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
Error_Procedure() as 'Sp_HWMS_DriverDetails',
Error_Severity() as ErrorSeverity,
Error_State() as ErrorState,
GETDATE () as DateErrorRaised
END CATCH
END
GO
