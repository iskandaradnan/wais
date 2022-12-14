USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_HWMS_OSWRecordSheet]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec [dbo].[SP_HWMS_OSWRecordSheet] 
CREATE procedure [dbo].[sp_HWMS_OSWRecordSheet](
@OSWRId int,
@CustomerId int,
@FacilityId int,
@OSWRSNo nvarchar(50)=null,
@TotalPackage int,
@WasteType nvarchar(100),
@ConsignmentNo nvarchar(100)=null,
@UserAreaCode nvarchar(50),
@UserAreaName nvarchar(100)=null,
@Month nvarchar(100),								
@Year int,
@CollectionFrequency nvarchar(50)=null,								
@CollectionType nvarchar(50),
@Status int=null
)	

AS
BEGIN
SET NOCOUNT ON;
BEGIN TRY
IF(@OSWRId = 0)
		BEGIN
		    IF(EXISTS(SELECT 1 FROM HWMS_OSWRecordSheet WHERE CustomerId = @CustomerId and FacilityId = @FacilityId and WasteType = @WasteType 
			and UserAreaCode = @UserAreaCode and Month = @Month and Year = @Year))
			BEGIN
			SELECT -1 AS OSWRId
			END
			ELSE
			BEGIN
				INSERT INTO HWMS_OSWRecordSheet ( CustomerId, FacilityId, OSWRSNo, TotalPackage, WasteType, UserAreaCode, UserAreaName,
				                                  Month, Year, CollectionFrequency, CollectionType, Status, CreatedDate)
				VALUES(@CustomerId, @FacilityId, @OSWRSNo, @TotalPackage, @WasteType, @UserAreaCode, @UserAreaName,
				       @Month, @Year,@CollectionFrequency ,@CollectionType ,@Status, GETDATE() )

				SELECT MAX(OSWRId) as OSWRId FROM HWMS_OSWRecordSheet
			END
		END
		ELSE
		BEGIN
				 UPDATE HWMS_OSWRecordSheet SET OSWRSNo = @OSWRSNo, TotalPackage = @TotalPackage,WasteType= @WasteType,
				 UserAreaCode= @UserAreaCode, UserAreaName = @UserAreaName, 
				 Month=@Month, Year=@Year,CollectionFrequency = @CollectionFrequency,CollectionType = @CollectionType,Status = @Status ,
				 ModifiedDate = GETDATE()
				  WHERE OSWRId=@OSWRId
		 SELECT @OSWRId as OSWRId
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
	Error_Procedure() as 'sp_HWMS_OSWRecordSheet',  
	Error_Severity() as ErrorSeverity,  
	Error_State() as ErrorState,  
	GETDATE () as DateErrorRaised  
END CATCH
end
GO
