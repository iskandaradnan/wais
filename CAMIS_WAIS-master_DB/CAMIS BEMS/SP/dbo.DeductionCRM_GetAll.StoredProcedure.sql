USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[DeductionCRM_GetAll]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--132--Advisory Services  
--134--Incident      
CREATE PROCEDURE [dbo].[DeductionCRM_GetAll]        
AS        
BEGIN         
SELECT                 
A.RequestDateTime,A.RequestNo,B.FieldValue,A.NCRDescription,A.RequestStatus,D.FieldValue AS Status,A.TypeOfRequest,B.FieldValue AS TypeRequest,A.Action_Taken,              
YEAR(A.RequestDateTime) AS Year                
,MONTH(A.RequestDateTime)  AS Month                
,Indicators_all                
           
FROM [uetrackMasterdbPreProd].[dbo].CRMRequest A          
        
INNER JOIN [uetrackMasterdbPreProd].[dbo].FMLovMst B                
ON A.TypeOfRequest=B.LovId           
        
INNER JOIN [uetrackMasterdbPreProd].[dbo].FMLovMst D                
ON A.RequestStatus=D.LovId              
        
        
WHERE         
--B.LovId='10020'                
--A.RequestStatus IN (142)           
--(TypeOfRequest IN ('132','134'))  
(TypeOfRequest IN ('10020'))  
AND Indicators_all=5
AND ServiceId=2                      
END 
GO
