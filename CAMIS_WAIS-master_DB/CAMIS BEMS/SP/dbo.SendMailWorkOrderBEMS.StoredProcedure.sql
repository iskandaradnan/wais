USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SendMailWorkOrderBEMS]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
          
--EXEC SendMailWorkOrderBEMS          
          
          
CREATE PROCEDURE [dbo].[SendMailWorkOrderBEMS]          
AS          
          
BEGIN          
          
DECLARE @XML NVARCHAR(MAX)          
DECLARE @BODY NVARCHAR(MAX)          
DECLARE @COUNT INT          
          
SET @COUNT=(SELECT COUNT(*) FROM EngMaintenanceWorkOrderTxn WHERE CAST(CreatedDate AS DATE)=CAST(GETDATE() AS DATE) AND MIGRATED_DATA=1)           
--SELECT @COUNT          
          
          
IF(@COUNT>0)          
BEGIN          
          
SET @xml = CAST(( SELECT CAST(@COUNT AS VARCHAR(20)) AS 'td','','BEMS' AS 'td','', CAST(CAST(GETDATE() AS DATE) AS VARCHAR(20)) AS 'td'          
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))          
          
          
          
SET @BODY ='<html><body>          
<p>Hi Team,<br><br>Below is the status for work order migration <br></p>           
<table border = 1>           
<tr>          
<th> Count </th> <th> ServiceName </th> <th> DateMigrated </th></tr>          
'          
          
SET @BODY = @BODY + @XML +'</table><p>Thanks<br>Siddhant</p></body></html>'          
          
--SELECT @BODY          
          
          
EXEC msdb.dbo.sp_send_dbmail          
@profile_name = 'Email', -- replace with your SQL Database Mail Profile           
@body = @body,          
@body_format ='HTML',          
@recipients ='murugan@edgenta.com;aida.nazri@edgenta.com;ainna@edgenta.com;siddhant@edgenta.com;syahid.wajdi@edgenta.com', -- replace with your email address          
--@recipients ='siddhant@edgenta.com',          
@subject = 'Work Order MigrationStatus'           
          
END          
ELSE           
BEGIN           
          
SET @BODY = '          
Hi Team,          
          
No WorkOrder Migrated on '+CAST(CAST(GETDATE() AS DATE) AS VARCHAR(20))+'          
          
Thanks          
Siddhant          
'           
EXEC msdb.dbo.sp_send_dbmail          
@profile_name = 'Email', -- replace with your SQL Database Mail Profile           
@body = @body,          
--@body_format ='HTML',          
@recipients ='murugan@edgenta.com;aida.nazri@edgenta.com;ainna@edgenta.com;siddhant@edgenta.com;syahid.wajdi@edgenta.com', -- replace with your email address          
--@recipients ='siddhant@edgenta.com',          
@subject = 'No Work Order Migration for BEMS'           
          
          
END          
          
END
GO
