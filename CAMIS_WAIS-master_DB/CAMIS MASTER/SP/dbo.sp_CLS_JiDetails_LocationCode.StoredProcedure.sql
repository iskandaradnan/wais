USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_CLS_JiDetails_LocationCode]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
  
CREATE procedure [dbo].[sp_CLS_JiDetails_LocationCode]  
 @pLocationCode nvarchar(50)='',  @pLocationName nvarchar(100)='',  
@pFloor nvarchar(50), @pWalls nvarchar(50),  
 @pCeiling nvarchar(50), @pWindows nvarchar(50),  
@pRC nvarchar(50), @pFFE nvarchar(50), @pRemarks nvarchar(100)='',  
 @pDetailsId int  
                                                  
as  
begin  
SET NOCOUNT ON;  
  
BEGIN TRY  
  
BEGIN  
  
 IF(EXISTS(SELECT 1 FROM CLS_JiDetails_LocationCode WHERE LocationCode = @pLocationCode AND DetailsId = @pDetailsId))  
  BEGIN  
   UPDATE CLS_JiDetails_LocationCode SET [Floor] = @pFloor, Walls = @pWalls, [Ceiling] = @pCeiling,  
    WindowsDoors = @pWindows, ReceptaclesContainers = @pRC ,  
   FFEquipment = @pFFE, Remarks = @pRemarks  
   WHERE LocationCode = @pLocationCode AND DetailsId = @pDetailsId  
  END  
 ELSE  
  BEGIN  
   INSERT INTO CLS_JiDetails_LocationCode 
   (
   LocationCode
,LocationName
,Floor
,Walls
,Ceiling
,WindowsDoors
,ReceptaclesContainers
,FFEquipment
,Remarks
,DetailsId
   )
   VALUES ( @pLocationCode,  @pLocationName,  @pFloor,  
              @pWalls, @pCeiling,  @pWindows,  
              @pRC, @pFFE,  @pRemarks,  @pDetailsId )  
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
 Error_Procedure() as 'CLS_JiDetails_LocationCode',  
 Error_Severity() as ErrorSeverity,  
 Error_State() as ErrorState,  
 GETDATE () as DateErrorRaised  
END CATCH  
END
GO
