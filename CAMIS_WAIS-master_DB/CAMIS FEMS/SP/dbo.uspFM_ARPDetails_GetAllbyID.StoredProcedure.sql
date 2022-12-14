USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_ARPDetails_GetAllbyID]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
/*========================================================================================================    
Application Name : UETrack-BEMS                  
Version    : 1.0    
Procedure Name  : [uspFM_ARPDetails_GetAll]    
Description   : Get the [uspFM_ARPDetails_GetAll] ARP details    
Authors    : Srinivas  
Date    : 29-Nov-2019    
-----------------------------------------------------------------------------------------------------------    
    
Unit Test:    
EXEC uspFM_BERApplicationTxnBER2_GetAll  @PageSize=10,@PageIndex=0,@StrCondition='AssetNo=''''',@StrSorting=null    
EXEC uspFM_ARPDetails_GetAllbyID  @pArpid=4   
  select * from EngARP_Details  
-----------------------------------------------------------------------------------------------------------    
Version History     
-----:------------:---------------------------------------------------------------------------------------    
Init : Date       : Details    
========================================================================================================*/    
  
CREATE PROCEDURE [dbo].[uspFM_ARPDetails_GetAllbyID]    
    -- Add the parameters for the stored procedure here    
    @pArpid int    
        
AS     
    
BEGIN TRY  
    -- SET NOCOUNT ON added to prevent extra result sets from    
    -- interfering with SELECT statements.    
    SET NOCOUNT ON;    
    
    Select EngARP_Details.ARPID,BERno,ConditionAppraisalNo, AssetNo,AssetName,AssetTypeDescription,DepartmentNameID,LocationNameID,BERRemarks,EngARP_Propsal.PROP_ID,EngARP_Propsal.Model,EngARP_Propsal.Brand,  
 EngARP_Propsal.Manufacturer,EngARP_Propsal.EstimationPrice,  
 EngARP_Propsal.SupplierName,EngARP_Propsal.ContactNo From EngARP_Details   LEFT JOIN EngARP_Propsal  
ON EngARP_Details.ARPID = EngARP_Propsal.ARPID   
    where EngARP_Details.ARPID =@pArpid order by PROP_ID  
            
END TRY    
    
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
