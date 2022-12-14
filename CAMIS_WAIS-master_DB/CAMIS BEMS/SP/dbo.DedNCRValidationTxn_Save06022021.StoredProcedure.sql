USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[DedNCRValidationTxn_Save06022021]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  ---EXEC DedNCRValidationTxnB5_Save 2020,6       
        
  CREATE PROCEDURE [dbo].[DedNCRValidationTxn_Save06022021]   
  ( @YEAR INT   
  ,@MONTH INT )        
  AS       
  
  DELETE FROM DedNCRValidationTxn WHERE YEAR=@YEAR AND MONTH=@MONTH  
  
  BEGIN   INSERT INTO DedNCRValidationTxn (  CustomerId        
,FacilityId        
,ServiceId        
,Month        
,Year        
,DedGenerationId        
,IndicatorDetId        
,CreatedBy        
,CreatedDate        
,CreatedDateUTC        
,ModifiedBy        
,ModifiedDate        
,ModifiedDateUTC        
,IsAdjustmentSaved )  SELECT DISTINCT         
157 AS  CustomerId        
,144 AS FacilityId        
,2 AS ServiceId        
,MONTH(RequestDateTime) AS Month        
,YEAR(RequestDateTime) AS Year        
,NULL AS DedGenerationId        
,A.Indicators_all         
,19 AS CreatedBy        
,GETDATE() AS CreatedDate        
,GETUTCDATE() AS CreatedDateUTC        
,19 AS ModifiedBy        
,GETDATE() AS ModifiedDate        
,GETUTCDATE() AS ModifiedDateUTC        
,0 AS IsAdjustmentSaved FROM [uetrackMasterdbPreProd].[DBO].CRMRequest A WITH(NOLOCK) WHERE YEAR(RequestDateTime)=@YEAR AND MONTH(RequestDateTime)=@MONTH AND ServiceId=2 AND ISNULL(Indicators_all,'')<>''  END
GO
