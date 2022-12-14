USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_FETC_Save]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec [Sp_CLS_FETC] 66, 25, 25, 'C003', 'WELLS', '10395', 10392, '10/16/2020 12:00:00 AM', null    
CREATE procedure [dbo].[Sp_CLS_FETC_Save] (    
@FETCId int,    
@Customerid int,    
@Facilityid int,    
@ItemCode varchar(50) = '',    
@ItemDescription varchar(100),    
@ItemType varchar(50),    
@Status int,    
@Quantity int,  
@EffectiveFrom datetime,    
@EffectiveTo datetime = null     
)    
AS    
BEGIN    
SET NOCOUNT ON;     
BEGIN TRY    
      
  if(@FETCId = 0)    
      BEGIN       
         INSERT INTO CLS_FETC values(@Customerid,@Facilityid,@ItemCode,@ItemDescription,@ItemType,@Quantity, @Status,@EffectiveFrom,@EffectiveTo)    
   select @@Identity as 'FETCId'    
    
       END    
    else    
     BEGIN       
   UPDATE CLS_FETC SET ItemCode = @ItemCode, ItemDescription = @ItemDescription, ItemType=@ItemType, Quantity = @Quantity, [Status]=@Status, EffectiveFrom=@EffectiveFrom ,   EffectiveTo = @EffectiveTo  WHERE FETCId=@FETCId    
    
   SELECT @FETCId as FETCId    
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
 Error_Procedure() as 'Sp_CLS_FETC',      
 Error_Severity() as ErrorSeverity,      
 Error_State() as ErrorState,      
 GETDATE () as DateErrorRaised      
    
 SELECT 'Error occured while inserting'    
END CATCH     
END
GO
