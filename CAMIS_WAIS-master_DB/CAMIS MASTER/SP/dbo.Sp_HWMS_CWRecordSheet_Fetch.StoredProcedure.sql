USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_CWRecordSheet_Fetch]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EXEC [dbo].[Sp_HWMS_CWRecordSheet_Fetch] 25  
--EXEC [dbo].[Sp_HWMS_CWRecordSheet_Fetch] 0  
CREATE PROC [dbo].[Sp_HWMS_CWRecordSheet_Fetch]  
@pCWRecordSheetId INT  
AS  
  
BEGIN  
SET NOCOUNT ON;   
BEGIN TRY  
BEGIN  
  
  IF(EXISTS(SELECT 1 FROM HWMS_CWRS_CollectionDetails_Save WHERE CWRecordSheetId = @pCWRecordSheetId))  
  BEGIN  
   SELECT * FROM HWMS_CWRS_CollectionDetails_Save  WHERE CWRecordSheetId = @pCWRecordSheetId  
  END  
  ELSE  
  BEGIN  
   SELECT 0 as CollectionDetailsId, UserAreaCode,C.FieldValue AS [CollectionFrequency],D.FieldValue AS [FrequencyType], '' as CollectionTime, '' as CollectionStatus,' ' as QC, 0 as NoofBags , 
   ( select SUM (case when ISNUMERIC(ShelfLevelQuantity) = 1 then  ShelfLevelQuantity else 0 end ) from HWMS_DeptAreaConsumablesReceptacles K WHERE K.DeptAreaId = A.DeptAreaId ) as NoofReceptaclesOnsite, 
   ( select SUM (case when ISNUMERIC(ShelfLevelQuantity) = 1 then  ShelfLevelQuantity else 0 end ) from HWMS_DeptAreaConsumablesReceptacles K WHERE K.DeptAreaId = A.DeptAreaId ) as NoofReceptacleSanitize, '' as Sanitize  
  
    FROM HWMS_DeptAreaDetails A    
    INNER JOIN HWMS_DeptAreaCollectionFrequency B ON A.DeptAreaId=B.DeptAreaId  
    LEFT JOIN FMLovMst C ON B.CollectionFrequency = C.LovId   
    LEFT JOIN FMLovMst D ON B.FrequencyType = D.LovId   
  


  

  
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
  Error_Procedure() as 'Sp_HWMS_CollectionDetailsFetch_Get',    
  Error_Severity() as ErrorSeverity,    
  Error_State() as ErrorState,    
  GETDATE () as DateErrorRaised    
END CATCH   
END
GO
