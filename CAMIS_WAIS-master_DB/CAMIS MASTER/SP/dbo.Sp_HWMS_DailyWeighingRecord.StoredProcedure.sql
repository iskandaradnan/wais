USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_DailyWeighingRecord]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_HWMS_DailyWeighingRecord]
(
@DWRId int,
@CustomerId int,
@FacilityId int,
@DWRNo varchar(30)=null,
@TotalWeight float=null,
@Date datetime,
@TotalBags int,
@TotalNoofBins int=null,
@HospitalRepresentative varchar(100),
@ConsignmentNo int=null,
@Status varchar(30)=null
)
AS
BEGIN 
SET NOCOUNT ON; 
BEGIN TRY
		IF(@DWRId = 0)
        BEGIN
			IF(EXISTS(SELECT 1 FROM HWMS_DailyWeighingRecord WHERE CustomerId = @Customerid and FacilityId = @Facilityid and Date = @Date))
			BEGIN
			SELECT -1 AS DWRId
			END
			ELSE
			BEGIN
				INSERT INTO HWMS_DailyWeighingRecord( [CustomerId],[FacilityId],[DWRNo],[TotalWeight],[Date],
				 [TotalBags],[TotalNoofBins],[HospitalRepresentative],[Status])
				VALUES(@CustomerId,@FacilityId,@DWRNo,@TotalWeight,@Date,@TotalBags,@TotalNoofBins,
				 @HospitalRepresentative, @Status)
				SELECT MAX([DWRId]) AS DWRId FROM HWMS_DailyWeighingRecord				
			END
		END
		ELSE
        BEGIN		
			UPDATE HWMS_DailyWeighingRecord SET [DWRNo] = @DWRNo, [TotalWeight] = @TotalWeight,[Date]=@Date,
			[TotalBags]=@TotalBags, [TotalNoofBins]=@TotalNoofBins, [HospitalRepresentative]= @HospitalRepresentative, [Status]= @Status WHERE DWRId=@DWRId	
			SELECT @DWRId AS DWRId
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
	Error_Procedure() as 'Sp_HWMS_DailyWeighingRecord',  
	Error_Severity() as ErrorSeverity,  
	Error_State() as ErrorState,  
	GETDATE () as DateErrorRaised  	
END CATCH 
END
GO
