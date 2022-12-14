USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[WorkOrderUserMappingIssueBEMS]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
        
        
              
--EXEC WorkOrderUserMappingIssueBEMS              
CREATE PROCEDURE [dbo].[WorkOrderUserMappingIssueBEMS]              
AS              
BEGIN              
              
IF OBJECT_ID('uetrackbemsdbPreProd.dbo.UserMappingIssue', 'U') IS NOT NULL                      
DROP TABLE UserMappingIssue                  
              
              
DECLARE @COUNT INT              
DECLARE @XML NVARCHAR(MAX)                    
DECLARE @BODY NVARCHAR(MAX)                    
              
              
SELECT * INTO UserMappingIssue FROM (              
SELECT DISTINCT C.AssetNo              
      ,A.MaintenanceWorkNo              
   ,A.WorkOrderId              
   ,B.UserId              
   ,E.employee_name AS [Employee Name]              
   ,E.Employee_ID   AS [Employee ID]            
   ,E.location_code AS [Location Code]        
   ,'Assesment' TableName              
   ,'BEMS' AS [Service]               
FROM EngMaintenanceWorkOrderTxn  A WITH (NOLOCK)             
INNER JOIN EngMwoAssesmentTxn B  WITH (NOLOCK)            
ON A.WorkOrderId=B.WorkOrderId              
INNER JOIN EngAsset C  WITH (NOLOCK)            
ON A.AssetId=C.AssetId              
INNER JOIN [10.249.116.8].[eng_ipoh].[DBO].eng_wr_assessment_details D  WITH (NOLOCK)            
ON A.MaintenanceWorkNo COLLATE SQL_1xCompat_CP850_CI_AS=D.WR_NO COLLATE SQL_1xCompat_CP850_CI_AS              
INNER JOIN [10.249.116.8].common.[DBO].eng_emp_master E WITH (NOLOCK)              
ON D.assessed_by=E.Employee_ID              
WHERE MIGRATED_DATA=1              
AND B.UserId=387              
--AND ISNULL(A.AssignedUserId,'')=''              
              
        
UNION ALL              
              
SELECT DISTINCT C.AssetNo              
      ,A.MaintenanceWorkNo              
   ,A.WorkOrderId              
   ,B.UserId              
   ,E.employee_name AS [Employee Name]            
   ,E.Employee_ID   AS [Employee ID]            
   ,E.location_code AS [Location Code]        
   ,'Completion' TableName              
   ,'BEMS' AS [Service]               
FROM EngMaintenanceWorkOrderTxn A  WITH (NOLOCK)            
INNER JOIN EngMwoCompletionInfoTxn F  WITH (NOLOCK)            
ON A.WorkOrderId=F.WorkOrderId              
INNER JOIN EngMwoCompletionInfoTxnDet B  WITH (NOLOCK)            
ON F.CompletionInfoId=B.CompletionInfoId              
INNER JOIN EngAsset C  WITH (NOLOCK)            
ON A.AssetId=C.AssetId              
INNER JOIN [10.249.116.8].[eng_ipoh].[DBO].eng_wr_completion_det D  WITH (NOLOCK)            
ON A.MaintenanceWorkNo COLLATE SQL_1xCompat_CP850_CI_AS=D.WR_NO COLLATE SQL_1xCompat_CP850_CI_AS     
AND F.EMPLOYEE_ID COLLATE SQL_1xCompat_CP850_CI_AS=D.EMPLOYEE_ID COLLATE SQL_1xCompat_CP850_CI_AS  
INNER JOIN [10.249.116.8].common.[DBO].eng_emp_master E  WITH (NOLOCK)            
ON D.Employee_ID=E.Employee_ID              
WHERE MIGRATED_DATA=1              
AND B.UserId=387              
) AA              
              
              
SET @COUNT=(SELECT COUNT(*) FROM UserMappingIssue)              
--SELECT @COUNT              
              
IF(@COUNT>0)                    
BEGIN                    
                    
SET @xml = CAST(( SELECT CAST(AssetNo AS VARCHAR(20)) AS 'td',''              
                          ,MaintenanceWorkNo AS 'td',''              
        ,WorkOrderId AS 'td',''              
        ,UserId AS 'td',''              
        ,[Employee Name] AS 'td',''              
        ,[Employee ID] AS 'td',''             
  ,[Location Code] AS 'td',''             
        ,TableName AS 'td',''              
        ,[Service] AS 'td',''              
        ,CAST(CAST(GETDATE() AS DATE) AS VARCHAR(20)) AS 'td'                
FROM UserMappingIssue              
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))                    
                    
                    
                    
SET @BODY ='<html><body>                    
<p>Hi Team,<br><br>Below are the work order which do not have user present in WAIS.       
<br>And as per the logic we only consider locationcode as ''WAC'' from old System.</p>                   
<table border = 1>                     
<tr>                    
<th bgcolor="yellow"> AssetNo </th>               
<th bgcolor="yellow"> MaintenanceWorkNo </th>               
<th bgcolor="yellow"> WorkOrderId </th>              
<th bgcolor="yellow"> UserId </th>              
<th bgcolor="yellow"> EmployeeName </th>              
<th bgcolor="yellow"> EmployeeID </th>              
<th bgcolor="yellow"> LocationCode </th>              
<th bgcolor="yellow"> TableName </th>              
<th bgcolor="yellow"> Service </th>              
<th bgcolor="yellow"> Date </th>              
              
</tr>                    
'                    
                    
SET @BODY = @BODY + @XML +'</table><p style="color:#FF0000";"font-weight: bold">***** System Generated Mail *****</p><br><p>Thanks<br>Siddhant</p></body></html>'                  
              --SELECT @BODY                    
                    
                    
EXEC msdb.dbo.sp_send_dbmail                    
@profile_name = 'Email', -- replace with your SQL Database Mail Profile                     
@body = @body,                    
@body_format ='HTML',                    
@recipients ='murugan@edgenta.com;syahid.wajdi@edgenta.com;aida.nazri@edgenta.com;siddhant@edgenta.com;ainna@edgenta.com', -- replace with your email address                  
--@recipients ='siddhant@edgenta.com',                    
@subject = 'User Not Found In WAIS For BEMS'                     
                    
END                    
ELSE                     
BEGIN                     
                    
SET @BODY = '                    
Hi Team,                    
                    
User Mapped Correctly !!!!!              
                    
Thanks                    
Siddhant                    
'                 
EXEC msdb.dbo.sp_send_dbmail                    
@profile_name = 'Email', -- replace with your SQL Database Mail Profile                     
@body = @body,                    
--@body_format ='HTML',                    
@recipients ='murugan@edgenta.com;syahid.wajdi@edgenta.com;aida.nazri@edgenta.com;siddhant@edgenta.com;ainna@edgenta.com', -- replace with your email address                  
--@recipients ='siddhant@edgenta.com',                    
@subject = 'No Issues For User Mapping In BEMS'                     
                    
                    
END              
END
GO
