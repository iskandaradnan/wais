USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_CRMRequest_Export]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
    
/*========================================================================================================    
Application Name : UETrack-BEMS                  
Version    : 1.0    
Procedure Name  : uspFM_CRMRequest_Export    
Description   : Get the Location Block details    
Authors    : Dhilip V    
Date    : 24-April-2018    
-----------------------------------------------------------------------------------------------------------    
    
Unit Test:    
EXEC uspFM_CRMRequest_Export  @StrCondition='FacilityId=''1''',@StrSorting=null    
    
-----------------------------------------------------------------------------------------------------------    
Version History     
-----:------------:---------------------------------------------------------------------------------------    
Init : Date       : Details    
========================================================================================================*/    
    
CREATE PROCEDURE [dbo].[uspFM_CRMRequest_Export]    
    
 @StrCondition NVARCHAR(MAX)  = NULL,    
 @StrSorting  NVARCHAR(MAX)  = NULL    
    
AS     
    
BEGIN TRY    
    
-- Paramter Validation     
    
 SET NOCOUNT ON;     
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;    
    
    
-- Declaration    
 DECLARE @countQry NVARCHAR(MAX);    
 DECLARE @qry  NVARCHAR(MAX);    
 DECLARE @condition VARCHAR(MAX);    
 DECLARE @TotalRecords INT;    
    
-- Default Values    
    
    
-- Execution    
    
SET @qry = 'SELECT    
      ServiceType
     ,RequestNo AS   [RequestNo.]      
     ,FORMAT(RequestDateTime,''dd-MMM-yyyy hh:mm'') AS [RequestDate /Time]    
     ,ReqStaff AS Requester    
     ,TypeOfRequestval AS RequestType
	 ,CRMRequest_PriorityStatus as Priority
	 ,AssessmentDetails
     ,RequestStatusValue AS RequestStatus    
     ,Model    
     ,Manufacturer    
     ,UserAreaCode AS AreaCode    
     ,UserAreaName AS AreaName    
     ,UserLocationCode AS LocationCode    
     ,UserLocationName AS LocationName  
	 ,WorkGroup
     ,AssetNo AS [AssetNo.]    
     ,SerialNo AS [SerialNo.]    
     ,SoftwareVersion     
     ,FORMAT(TargetDate,''dd-MMM-yyyy'') AS TargetDate        
    
     ,Assignee  
	 ,NCRDescription as NonConformanceDescription
	 ,ResponseBY as ResponseBy
	 ,FORMAT(Responce_Date,''dd-MMM-yyyy hh:mm'') AS  [Response Date / Time]
	 ,Action_Taken as ActionTaken
     ,Remarks    
     ,RequestDescription  
  ,Completed_By as CompletedBy   
  ,FORMAT(CompletedDateTime,''dd-MMM-yyyy hh:mm'') AS  [Completed Date / Time]  
   FROM [V_CRMRequest_Export]    
   WHERE 1 = 1 '     
   + '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END      
   + ' ' + ' ORDER BY ' +  ISNULL(@strSorting,'[V_CRMRequest_Export].ModifiedDateUTC DESC')    
    
PRINT @qry;    
    
EXECUTE sp_executesql @qry, N' @TotalRecords INT', @TotalRecords = @TotalRecords    
     
END TRY    
    
BEGIN CATCH    
    
throw    
 INSERT INTO ErrorLog(    
    Spname,    
    ErrorMessage,    
    createddate)    
 VALUES(  OBJECT_NAME(@@PROCID),    
    'Error_line: '+CONVERT(VARCHAR(10), error_line())+' - '+error_message(),    
    getdate()    
     )    
    
END CATCH
GO
