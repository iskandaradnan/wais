USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_ARPDetailsGetAll]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
/*========================================================================================================  
Application Name : UETrack-BEMS                
Version    : 1.0  
Procedure Name  : uspFM_EngAsset_GetAll  
Description   : Get the staff details by passing the staffId.  
Authors    : Dhilip V  
Date    : 05-April-2018  
-----------------------------------------------------------------------------------------------------------  
  
Unit Test:  
EXEC uspFM_EngAsset_GetAll  @PageSize=50,@PageIndex=0,@StrCondition='',@StrSorting=null,@pCustomer=10,@pfacility=10
  
-----------------------------------------------------------------------------------------------------------  
Version History   
-----:------------:---------------------------------------------------------------------------------------  
Init : Date       : Details  
========================================================================================================*/  
  
create PROCEDURE [dbo].[uspFM_ARPDetailsGetAll]  
  
 @PageSize  INT,  
 @PageIndex  INT,  
 @StrCondition NVARCHAR(MAX) = NULL,  
 @StrSorting  NVARCHAR(MAX) = NULL,  
 @pCustomer  INT    = NULL,  
 @pfacility INT    = NULL  
  
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
  
 SET @PageIndex = @PageIndex+1  /* This is for JQ grid implementation */  
  
-- Execution  
  
 
   
 BEGIN  
  
  SET @countQry = 'SELECT @Total = COUNT(1)  
      FROM [EngARP_Details]  
      WHERE [FacilityID] = '+ @pfacility +' AND ' + 'CustomerID = ' + @pCustomer END   
    
  print @countQry;  
    
  EXECUTE sp_executesql @countQry, N' @Total INT OUTPUT', @Total = @TotalRecords OUTPUT  
  --select @TotalRecords as Counts  
    
  SET @qry = 'SELECT [ARPID]
      ,[CustomerID]
      ,[FacilityID]
      ,[BERno]
      ,[ConditionAppraisalNo]
      ,[AssetNo]
      ,[AssetName]
      ,[AssetTypeDescription]
      ,[DepartmentNameID]
      ,[LocationNameID]
      ,[ApplicationDate]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[CreatedDateUTC]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[ModifiedDateUTC]
      ,[Timestamp]
      ,[GuId]
      ,[SelectedProposal]
      ,[Justification]
      ,[BERRemarks]
      ,[ARP_Proposal_ID]
      ,[AssetID]
  FROM [dbo].[EngARP_Details] 
     WHERE [FacilityID] = '+ @pfacility +' AND ' + 'CustomerID = ' + @pCustomer + CAST((@PageSize *  (@PageIndex-1)) AS VARCHAR(500)) + ' ROWS FETCH NEXT '  + CAST(@PageSize AS VARCHAR(100)) + ' ROWS ONLY ' ;  
  print @qry;  
  EXECUTE sp_executesql @qry, N' @TotalRecords INT', @TotalRecords = @TotalRecords  
   
 END  
  

   
TRY  
  
BEGIN CATCH  
  
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
