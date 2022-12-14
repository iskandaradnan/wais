USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_BinMaster_Save]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[Sp_HWMS_BinMaster_Save](
	@BinMasterId INT,
	@CustomerId INT,
	@FacilityId INT,
	@CapacityCode VARCHAR(50),
	@Description VARCHAR(50)='NULL',
	@WasteType VARCHAR(50),
	@NoofBins INT
)
AS
BEGIN 
SET NOCOUNT ON; 
BEGIN TRY
IF(@BinMasterId = 0)
         BEGIN					
	     INSERT INTO HWMS_BinMaster([CustomerId],[FacilityId],[CapacityCode],[Description],[WasteType],[NoofBins])
		 VALUES(@CustomerId,@FacilityId,@CapacityCode,@Description,@WasteType,@NoofBins)
         SELECT MAX([BinMasterId]) AS BinMasterId FROM HWMS_BinMaster				
         END
ELSE
        BEGIN		
		UPDATE HWMS_BinMaster SET [CapacityCode] = @CapacityCode, [Description] = @Description,[WasteType]=@WasteType,[NoofBins]=@NoofBins		 
		WHERE BinMasterId=@BinMasterId	
		 	
        SELECT @BinMasterId AS BinMasterId
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
	Error_Procedure() as 'Sp_HWMS_BinMaster',  
	Error_Severity() as ErrorSeverity,  
	Error_State() as ErrorState,  
	GETDATE () as DateErrorRaised  	
END CATCH 
END

GO
