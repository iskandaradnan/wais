USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_VehicleDetailsSave]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_HWMS_VehicleDetailsSave](
@VehicleId int,
@CustomerId int,
@FacilityId int,
@VehicleNo nvarchar(50),
@Manufacturer  nvarchar(50),
@TreatmentPlant nvarchar(50),
@Status int,
@EffectiveFrom datetime,
@EffectiveTo datetime =null,
@LoadWeight int='',
@Route nvarchar(50)=''
)
AS
BEGIN
SET NOCOUNT ON;

BEGIN TRY
		IF(@VehicleId = 0)
		BEGIN
		    IF(EXISTS(SELECT 1 FROM HWMS_VehicleDetails WHERE CustomerId = @CustomerId and FacilityId = @FacilityId and VehicleNo = @VehicleNo))
			BEGIN
			SELECT -1 AS VehicleId
			END
			ELSE
			BEGIN
				INSERT INTO HWMS_VehicleDetails ( CustomerId, FacilityId, VehicleNo, Manufacturer, TreatmentPlant,Status,EffectiveFrom,EffectiveTo,LoadWeight,Route)
				VALUES(@CustomerId, @FacilityId, @VehicleNo, @Manufacturer, @TreatmentPlant, @Status, @EffectiveFrom, @EffectiveTo, @LoadWeight, @Route)

				SELECT MAX(VehicleId) as VehicleId FROM HWMS_VehicleDetails
			END
		END
		ELSE
		BEGIN
		
		 UPDATE HWMS_VehicleDetails SET VehicleNo = @VehicleNo, Manufacturer = @Manufacturer,TreatmentPlant= @TreatmentPlant,
		 Status= @Status,EffectiveFrom= @EffectiveFrom, EffectiveTo = @EffectiveTo, LoadWeight=@LoadWeight, Route=@Route WHERE VehicleId=@VehicleId

		 SELECT @VehicleId as VehicleId
		

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
Error_Procedure() as 'Sp_HWMS_VehicleDetailsSave',
Error_Severity() as ErrorSeverity,
Error_State() as ErrorState,
GETDATE () as DateErrorRaised
END CATCH
END
GO
