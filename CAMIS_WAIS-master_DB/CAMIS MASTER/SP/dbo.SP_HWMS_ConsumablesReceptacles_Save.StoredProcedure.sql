USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_HWMS_ConsumablesReceptacles_Save]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_HWMS_ConsumablesReceptacles_Save](

@ConsumablesId INT,
@Customerid int,
@Facilityid int,
@WasteCategory nvarchar(30) ,
@WasteType nvarchar(30)
)
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRY
IF(@ConsumablesId = 0)
	BEGIN
	    INSERT INTO HWMS_ConsumablesReceptacles (CustomerId, FacilityId, WasteCategory, WasteType )
		 VALUES( @CustomerId, @FacilityId,  @WasteCategory, @WasteType)	   											  
	    select MAX(ConsumablesId) as ConsumablesId from HWMS_ConsumablesReceptacles

    END
ELSE
	  BEGIN			
		UPDATE HWMS_ConsumablesReceptacles SET  Wastecategory = @WasteCategory, WasteType = @WasteType 
        WHERE ConsumablesId = @ConsumablesId
		
		SELECT @ConsumablesId AS ConsumablesId
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
Error_Procedure() as 'SP_HWMS_ConsumablesReceptacles',
Error_Severity() as ErrorSeverity,
Error_State() as ErrorState,
GETDATE () as DateErrorRaised
END CATCH
END
GO
