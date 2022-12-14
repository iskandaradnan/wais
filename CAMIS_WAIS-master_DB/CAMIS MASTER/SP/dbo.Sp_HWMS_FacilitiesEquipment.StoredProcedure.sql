USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_FacilitiesEquipment]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_HWMS_FacilitiesEquipment] (
@FetcId int,
@Customerid int,
@Facilityid int,
@ItemCode varchar(50),
@ItemDescription varchar(100),
@ItemType varchar(50),
@Status int,
@EffectiveFrom datetime,
@EffectiveTo datetime = null 
)
AS
BEGIN
SET NOCOUNT ON; 
BEGIN TRY
		
		if(@FetcId = 0)
      BEGIN			
         INSERT INTO HWMS_FacilitiesEquipment values(@Customerid,@Facilityid,@ItemCode,@ItemDescription,@ItemType,@Status,@EffectiveFrom,@EffectiveTo)
		 select @@IDENTITY as 'FetcId'
       END
	   else
     BEGIN		 
		 UPDATE HWMS_FacilitiesEquipment SET ItemCode = @ItemCode, ItemDescription = @ItemDescription, ItemType=@ItemType, Status=@Status, EffectiveFrom=@EffectiveFrom,
		 EffectiveTo = @EffectiveTo   WHERE FetcId=@FetcId

			select @FetcId as 'FetcId'
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
	Error_Procedure() as 'Sp_HWMS_FacilitiesEquipment',  
	Error_Severity() as ErrorSeverity,  
	Error_State() as ErrorState,  
	GETDATE () as DateErrorRaised  

	SELECT 'Error occured while inserting'
END CATCH 
END
GO
