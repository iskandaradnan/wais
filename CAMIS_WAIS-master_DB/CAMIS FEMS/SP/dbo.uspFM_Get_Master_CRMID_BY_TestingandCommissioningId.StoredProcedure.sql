USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_Get_Master_CRMID_BY_TestingandCommissioningId]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE  [dbo].[uspFM_Get_Master_CRMID_BY_TestingandCommissioningId]   
 @pTestingandCommissioningDetId        INT    
 AS                                                    
      
BEGIN TRY     
DECLARE @mTRANSCOUNT INT = @@TRANCOUNT      
-- Default Values      
 SET @pTestingandCommissioningDetId  = (select TestingandCommissioningId from EngTestingandCommissioningTxnDet where TestingandCommissioningDetId= @pTestingandCommissioningDetId   )
 SET @pTestingandCommissioningDetId  = (select CRMRequestId from EngTestingandCommissioningTxn where TestingandCommissioningId= @pTestingandCommissioningDetId)
select Master_CRMRequestId from CRMRequest where CRMRequestId=@pTestingandCommissioningDetId

 END TRY      
      
BEGIN CATCH      
      
 IF @mTRANSCOUNT = 0      
        BEGIN      
            ROLLBACK TRAN      
        END      
      
 INSERT INTO ErrorLog(      
    Spname,      
    ErrorMessage,      
    createddate)      
 VALUES(  OBJECT_NAME(@@PROCID),      
    'Error_line: '+CONVERT(VARCHAR(10), error_line())+' - '+error_message(),      
    getdate()      
     );      
     throw;      
      
END CATCH
GO
