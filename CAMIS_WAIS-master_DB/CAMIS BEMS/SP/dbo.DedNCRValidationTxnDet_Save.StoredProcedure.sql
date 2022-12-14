USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[DedNCRValidationTxnDet_Save]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC DedNCRValidationTxnDet_Save 2021,1             
        
CREATE PROCEDURE [dbo].[DedNCRValidationTxnDet_Save]       
(       
 @YEAR INT       
,@MONTH INT       
)              
AS BEGIN         
        
--1) open previous month completed current month

		SELECT '157'  as  CustomerId   
		,'144' as FacilityId      
		,NULL as DedNCRValidationId       
		,CRMRequestId       
		,RequestNo       
		,RequestDateTime       
		,A.AssetId       
		,C.AssetNo       
		,1  AS DemeritPoint           
		,1  AS FinalDemeritPoint     
		,1  AS DisputedDemeritPoints     
		,1     AS IsValid  
		,CASE WHEN C.PurchaseCostRM BETWEEN 0 AND 5000 THEN 50                    
		WHEN C.PurchaseCostRM BETWEEN 5001 AND 10000 THEN 100                    
		WHEN C.PurchaseCostRM BETWEEN 10001 AND 15000 THEN 150                    
		WHEN C.PurchaseCostRM BETWEEN 15001 AND 20000 THEN 200                    
		WHEN C.PurchaseCostRM BETWEEN 20001 AND 30000 THEN 250                    
		WHEN C.PurchaseCostRM BETWEEN 30001 AND 50000 THEN 300                    
		WHEN C.PurchaseCostRM BETWEEN 50001 AND 100000 THEN 500                    
		WHEN C.PurchaseCostRM BETWEEN 100001 AND 500000 THEN 2000                    
		WHEN C.PurchaseCostRM BETWEEN 500001 AND 1000000 THEN 5000                    
		WHEN C.PurchaseCostRM > 1000000 THEN 7500                    
		END AS DeductionFigurePerAsset              
		,'19'   AS CreatedBy    
		,GETDATE()   AS    CreatedDate 
		,GETUTCDATE()      AS CreatedDateUTC 
		,'19'       AS ModifiedBy
		,GETDATE()   AS ModifiedDate    
		,GETUTCDATE()  AS ModifiedDateUTC     
		,@YEAR      AS Year 
		,@MONTH   AS Month    
		,Indicators_all     as IndicatorDetId      
		,'' AS [FileName]      
		,'' AS RemarksJOHN       
		,Completed_Date    
		INTO #PreviousMonthCompleted  
		FROM [uetrackMasterdbPreProd].[dbo].CRMRequest A             
		LEFT OUTER JOIN EngAsset C       
		ON A.AssetId=C.AssetId       
		WHERE TypeOfRequest=10020      
		AND YEAR(A.createddate) = @YEAR
		AND MONTH(A.createddate) < @MONTH
		AND MONTH(A.Completed_Date) = @MONTH
		AND A.ServiceId=2            

UNION

		SELECT DISTINCT '157'   as CustomerId   
		,'144'   as     FacilityId
		,NULL as DedNCRValidationId       
		,CRMRequestId       
		,RequestNo       
		,RequestDateTime       
		,A.AssetId       
		,C.AssetNo       
		,1  AS DemeritPoint           
		,1  AS FinalDemeritPoint     
		,1  AS DisputedDemeritPoints     
		,1     AS IsValid      
		,CASE WHEN C.PurchaseCostRM BETWEEN 0 AND 5000 THEN 50                    
		WHEN C.PurchaseCostRM BETWEEN 5001 AND 10000 THEN 100                    
		WHEN C.PurchaseCostRM BETWEEN 10001 AND 15000 THEN 150                    
		WHEN C.PurchaseCostRM BETWEEN 15001 AND 20000 THEN 200                    
		WHEN C.PurchaseCostRM BETWEEN 20001 AND 30000 THEN 250                    
		WHEN C.PurchaseCostRM BETWEEN 30001 AND 50000 THEN 300                    
		WHEN C.PurchaseCostRM BETWEEN 50001 AND 100000 THEN 500                    
		WHEN C.PurchaseCostRM BETWEEN 100001 AND 500000 THEN 2000                    
		WHEN C.PurchaseCostRM BETWEEN 500001 AND 1000000 THEN 5000                    
		WHEN C.PurchaseCostRM > 1000000 THEN 7500                    
		END AS DeductionFigurePerAsset              
		,'19'   AS CreatedBy    
		,GETDATE()   AS    CreatedDate 
		,GETUTCDATE()      AS CreatedDateUTC 
		,'19'       AS ModifiedBy
		,GETDATE()   AS ModifiedDate    
		,GETUTCDATE()  AS ModifiedDateUTC     
		,@YEAR      AS Year 
		,@MONTH   AS Month    
		,Indicators_all     as IndicatorDetId          
		,'' AS [FileName]      
		,'' AS RemarksJOHN       
		,Completed_Date      
		FROM [uetrackMasterdbPreProd].[dbo].CRMRequest A                  
		LEFT OUTER JOIN EngAsset C       
		ON A.AssetId=C.AssetId       
		WHERE TypeOfRequest=10020      
		AND MONTH(A.Completed_Date) = @MONTH
		AND A.ServiceId=2       
		AND YEAR(A.createddate) < @YEAR
		AND MONTH(A.createddate) <= 12 


--2) open previous month & still open in current month

                 
		SELECT DISTINCT '157'   as CustomerId   
		,'144'   as     FacilityId
		,NULL as DedNCRValidationId       
		,CRMRequestId       
		,RequestNo       
		,RequestDateTime       
		,A.AssetId       
		,C.AssetNo       
		,1  AS DemeritPoint           
		,1  AS FinalDemeritPoint     
		,1  AS DisputedDemeritPoints     
		,1     AS IsValid      
		,CASE WHEN C.PurchaseCostRM BETWEEN 0 AND 5000 THEN 50                    
		WHEN C.PurchaseCostRM BETWEEN 5001 AND 10000 THEN 100                    
		WHEN C.PurchaseCostRM BETWEEN 10001 AND 15000 THEN 150                    
		WHEN C.PurchaseCostRM BETWEEN 15001 AND 20000 THEN 200                    
		WHEN C.PurchaseCostRM BETWEEN 20001 AND 30000 THEN 250                    
		WHEN C.PurchaseCostRM BETWEEN 30001 AND 50000 THEN 300                    
		WHEN C.PurchaseCostRM BETWEEN 50001 AND 100000 THEN 500                    
		WHEN C.PurchaseCostRM BETWEEN 100001 AND 500000 THEN 2000                    
		WHEN C.PurchaseCostRM BETWEEN 500001 AND 1000000 THEN 5000                    
		WHEN C.PurchaseCostRM > 1000000 THEN 7500                    
		END AS DeductionFigurePerAsset              
		,'19'   AS CreatedBy    
		,GETDATE()   AS    CreatedDate 
		,GETUTCDATE()      AS CreatedDateUTC 
		,'19'       AS ModifiedBy
		,GETDATE()   AS ModifiedDate    
		,GETUTCDATE()  AS ModifiedDateUTC     
		,@YEAR      AS Year 
		,@MONTH   AS Month    
		,Indicators_all     as IndicatorDetId          
		,'' AS [FileName]      
		,'' AS RemarksJOHN       
		,Completed_Date  
		INTO #PreviousMonthOpen    
		FROM [uetrackMasterdbPreProd].[dbo].CRMRequest A           
		LEFT OUTER JOIN EngAsset C       
		ON A.AssetId=C.AssetId       
		WHERE TypeOfRequest=10020      
		AND YEAR(A.createddate) = @YEAR
		AND MONTH(A.createddate) < @MONTH
		AND A.Completed_Date IS NULL
		AND A.ServiceId=2       
    
UNION

		SELECT DISTINCT '157'   as CustomerId   
		,'144'   as     FacilityId
		,NULL as DedNCRValidationId       
		,CRMRequestId       
		,RequestNo       
		,RequestDateTime       
		,A.AssetId       
		,C.AssetNo       
		,1  AS DemeritPoint           
		,1  AS FinalDemeritPoint     
		,1  AS DisputedDemeritPoints     
		,1     AS IsValid      
		,CASE WHEN C.PurchaseCostRM BETWEEN 0 AND 5000 THEN 50                    
		WHEN C.PurchaseCostRM BETWEEN 5001 AND 10000 THEN 100                    
		WHEN C.PurchaseCostRM BETWEEN 10001 AND 15000 THEN 150                    
		WHEN C.PurchaseCostRM BETWEEN 15001 AND 20000 THEN 200                    
		WHEN C.PurchaseCostRM BETWEEN 20001 AND 30000 THEN 250                    
		WHEN C.PurchaseCostRM BETWEEN 30001 AND 50000 THEN 300                    
		WHEN C.PurchaseCostRM BETWEEN 50001 AND 100000 THEN 500                    
		WHEN C.PurchaseCostRM BETWEEN 100001 AND 500000 THEN 2000                    
		WHEN C.PurchaseCostRM BETWEEN 500001 AND 1000000 THEN 5000                    
		WHEN C.PurchaseCostRM > 1000000 THEN 7500                    
		END AS DeductionFigurePerAsset              
		,'19'   AS CreatedBy    
		,GETDATE()   AS    CreatedDate 
		,GETUTCDATE()      AS CreatedDateUTC 
		,'19'       AS ModifiedBy
		,GETDATE()   AS ModifiedDate    
		,GETUTCDATE()  AS ModifiedDateUTC     
		,@YEAR      AS Year 
		,@MONTH   AS Month    
		,Indicators_all     as IndicatorDetId          
		,'' AS [FileName]      
		,'' AS RemarksJOHN       
		,Completed_Date     
		FROM [uetrackMasterdbPreProd].[dbo].CRMRequest A                
		LEFT OUTER JOIN EngAsset C       
		ON A.AssetId=C.AssetId       
		WHERE TypeOfRequest=10020      
		AND A.Completed_Date IS NULL
		AND A.ServiceId=2       
		AND YEAR(A.createddate) < @YEAR
		AND MONTH(A.createddate) <= 12   

--3) completed current month & 4) open in current month

   
		SELECT DISTINCT '157'   as CustomerId   
		,'144'   as     FacilityId
		,NULL as DedNCRValidationId       
		,CRMRequestId       
		,RequestNo       
		,RequestDateTime       
		,A.AssetId       
		,C.AssetNo       
		,1  AS DemeritPoint           
		,1  AS FinalDemeritPoint     
		,1  AS DisputedDemeritPoints     
		,1     AS IsValid      
		,CASE WHEN C.PurchaseCostRM BETWEEN 0 AND 5000 THEN 50                    
		WHEN C.PurchaseCostRM BETWEEN 5001 AND 10000 THEN 100                    
		WHEN C.PurchaseCostRM BETWEEN 10001 AND 15000 THEN 150                    
		WHEN C.PurchaseCostRM BETWEEN 15001 AND 20000 THEN 200                    
		WHEN C.PurchaseCostRM BETWEEN 20001 AND 30000 THEN 250                    
		WHEN C.PurchaseCostRM BETWEEN 30001 AND 50000 THEN 300                    
		WHEN C.PurchaseCostRM BETWEEN 50001 AND 100000 THEN 500                    
		WHEN C.PurchaseCostRM BETWEEN 100001 AND 500000 THEN 2000                    
		WHEN C.PurchaseCostRM BETWEEN 500001 AND 1000000 THEN 5000                    
		WHEN C.PurchaseCostRM > 1000000 THEN 7500                    
		END AS DeductionFigurePerAsset              
		,'19'   AS CreatedBy    
		,GETDATE()   AS    CreatedDate 
		,GETUTCDATE()      AS CreatedDateUTC 
		,'19'       AS ModifiedBy
		,GETDATE()   AS ModifiedDate    
		,GETUTCDATE()  AS ModifiedDateUTC     
		,@YEAR      AS Year 
		,@MONTH   AS Month    
		,Indicators_all     as IndicatorDetId          
		,'' AS [FileName]      
		,'' AS RemarksJOHN       
		,Completed_Date
		INTO #CurrentMonth     
		FROM [uetrackMasterdbPreProd].[dbo].CRMRequest A              
		LEFT OUTER JOIN EngAsset C       
		ON A.AssetId=C.AssetId       
		WHERE TypeOfRequest=10020      
		AND YEAR(A.createddate) = @YEAR
		AND MONTH(A.createddate) = @MONTH
		AND MONTH(A.Completed_Date) = @MONTH
		AND A.ServiceId=2       
		AND YEAR(A.createddate) < @YEAR
  
UNION

		SELECT DISTINCT '157'   as CustomerId   
		,'144'   as     FacilityId
		,NULL as DedNCRValidationId       
		,CRMRequestId       
		,RequestNo       
		,RequestDateTime       
		,A.AssetId       
		,C.AssetNo       
		,1  AS DemeritPoint           
		,1  AS FinalDemeritPoint     
		,1  AS DisputedDemeritPoints     
		,1     AS IsValid      
		,CASE WHEN C.PurchaseCostRM BETWEEN 0 AND 5000 THEN 50                    
		WHEN C.PurchaseCostRM BETWEEN 5001 AND 10000 THEN 100                    
		WHEN C.PurchaseCostRM BETWEEN 10001 AND 15000 THEN 150                    
		WHEN C.PurchaseCostRM BETWEEN 15001 AND 20000 THEN 200                    
		WHEN C.PurchaseCostRM BETWEEN 20001 AND 30000 THEN 250                    
		WHEN C.PurchaseCostRM BETWEEN 30001 AND 50000 THEN 300                    
		WHEN C.PurchaseCostRM BETWEEN 50001 AND 100000 THEN 500                    
		WHEN C.PurchaseCostRM BETWEEN 100001 AND 500000 THEN 2000                    
		WHEN C.PurchaseCostRM BETWEEN 500001 AND 1000000 THEN 5000                    
		WHEN C.PurchaseCostRM > 1000000 THEN 7500                    
		END AS DeductionFigurePerAsset              
		,'19'   AS CreatedBy    
		,GETDATE()   AS    CreatedDate 
		,GETUTCDATE()      AS CreatedDateUTC 
		,'19'       AS ModifiedBy
		,GETDATE()   AS ModifiedDate    
		,GETUTCDATE()  AS ModifiedDateUTC     
		,@YEAR      AS Year 
		,@MONTH   AS Month    
		,Indicators_all     as IndicatorDetId          
		,'' AS [FileName]      
		,'' AS RemarksJOHN       
		,Completed_Date     
		FROM [uetrackMasterdbPreProd].[dbo].CRMRequest A        
		LEFT OUTER JOIN EngAsset C       
		ON A.AssetId=C.AssetId       
		WHERE TypeOfRequest=10020      
		AND YEAR(A.createddate) = @YEAR
		AND MONTH(A.createddate) = @MONTH
		AND A.Completed_Date IS NULL
		AND A.ServiceId=2       
		AND YEAR(A.createddate) < @YEAR 

--------------------------------------------------------------------

--UNION ALL in temp table

		SELECT * 
		INTO #NCRDetails
		FROM #PreviousMonthCompleted

UNION

		SELECT * 
		FROM #PreviousMonthOpen

UNION

		SELECT * 
		FROM #CurrentMonth


--UPDATE DedNCRValidationId


UPDATE  A
SET A.DedNCRValidationId = B.DedNCRValidationId
FROM #NCRDetails A
LEFT JOIN DedNCRValidationTxn B
ON A.Month = B.Month
AND A.Year = B.Year


---------------------------------------------------------------------

--Insert into DedNCRValidationTxnDet 

DELETE FROM DedNCRValidationTxnDet WHERE YEAR=@YEAR AND MONTH=@MONTH  


INSERT INTO DedNCRValidationTxnDet      
(      
 CustomerId      
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
,[Year]      
,[Month]      
,IndicatorDetId      
,[FileName]      
,RemarksJOHN      
,Completed_Date      
)      

SELECT 

 CustomerId      
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
,'' AS Remarks
,DeductionFigurePerAsset*DemeritPoint AS DeductionValue
,CreatedBy      
,CreatedDate      
,CreatedDateUTC      
,ModifiedBy      
,ModifiedDate      
,ModifiedDateUTC      
,[Year]      
,[Month]      
,IndicatorDetId      
,[FileName]      
,RemarksJOHN      
,Completed_Date  
FROM 
#NCRDetails 

END


GO
