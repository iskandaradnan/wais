USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[DedNCRValidationTxnDet_SaveBackup11122020]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  ---EXEC DedNCRValidationTxnDet_Save 2020,5       
        
CREATE PROCEDURE [dbo].[DedNCRValidationTxnDet_SaveBackup11122020] ( @YEAR INT ,@MONTH INT )        
AS BEGIN   
  
DELETE FROM DedNCRValidationTxnDet WHERE YEAR=@YEAR AND MONTH=@MONTH  
  
INSERT INTO DedNCRValidationTxnDet (  CustomerId        
,FacilityId        
,DedNCRValidationId        
,CRMRequestId        
,RequestNo        
,RequestDateTime        
,AssetId        
,AssetNo        
,DemeritPoint        
,FinalDemeritPoint        
,DisputedDemeritPoints        
,IsValid        
,Remarks        
,DeductionValue        
,CreatedBy        
,CreatedDate        
,CreatedDateUTC        
,ModifiedBy        
,ModifiedDate        
,ModifiedDateUTC        
,Year        
,Month        
,IndicatorDetId)      
SELECT '157' , '144' ,B.DedNCRValidationId ,CRMRequestId ,RequestNo ,RequestDateTime ,A.AssetId ,C.AssetNo ,1 ,1 ,1 ,1 ,NULL ,NULL ,'19' ,GETDATE() ,GETUTCDATE() ,'19' ,GETDATE() ,GETUTCDATE() ,B.Year ,B.Month ,B.IndicatorDetId     
FROM [uetrackMasterdbPreProd].[dbo].CRMRequest A INNER JOIN DedNCRValidationTxn B ON A.Indicators_all=B.IndicatorDetId AND YEAR(A.RequestDateTime)=B.Year AND MONTH(A.RequestDateTime)=B.Month LEFT OUTER JOIN EngAsset C ON A.AssetId=C.AssetId WHERE TypeOfRequest=10020 AND A.ServiceId=2 AND B.Year=@YEAR AND B.Month=@MONTH  END    
    
    
GO
