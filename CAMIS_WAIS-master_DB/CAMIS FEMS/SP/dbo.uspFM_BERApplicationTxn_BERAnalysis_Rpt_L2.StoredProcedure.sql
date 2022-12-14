USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_BERApplicationTxn_BERAnalysis_Rpt_L2]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
/*========================================================================================================  
Application Name : UETrack-BEMS                
Version    : 1.0  
Procedure Name  : [uspFM_BERApplicationTxn_BERAnalysis_Rpt_L1]   
Description   : Get the BER Analysis Report(Level1)  
Authors    : Ganesan S  
Date    : 13-June-2018  
-----------------------------------------------------------------------------------------------------------  
  
Unit Test:  
exec [uspFM_BERApplicationTxn_BERAnalysis_Rpt_L2] @FacilityId = 1,  @From_Date = '01/01/2015', @To_Date= '01/01/2019'

-----:------------:---------------------------------------------------------------------------------------  
Init : Date       : Details  
========================================================================================================*/  
CREATE  PROCEDURE [dbo].[uspFM_BERApplicationTxn_BERAnalysis_Rpt_L2]                                    
(          
		@From_Date  VARCHAR(100) = '',      
		@To_Date	VARCHAR(100) = ''  ,   
		@FacilityId	int  ='',  
		@Level		INT  =''         
 )             
AS                                                
BEGIN   
  
SET NOCOUNT ON  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
BEGIN TRY  
    
                              
   select  1 as SNo,   
   ber.BERno,  
            Asset.AssetNo,  
   Asset.AssetDescription,  
            Ber.BERStatus   AS BERStatus,  
   BERStatus.FieldValue    AS BERStatusValue   
   ,ber.ModifiedDate       AS BERStatusDate,  
   2 as DaysPending ,   
   RequestorStaff.StaffName RequestorName,   
   RequestorStaffDes.Designation RequestorDesignation,
   fac.FacilityName
   from BERApplicationTxn ber
     -- inner join MstCustomer cust on cust.CustomerId= ber.CustomerId  
   inner join MstLocationFacility fac on fac.FacilityId= ber.FacilityId  
   LEFT  JOIN  EngAsset AS Asset    WITH(NOLOCK) ON ber.AssetId    = Asset.AssetId  
   --left join EngTestingandCommissioningTxnDet   AS  Test        WITH(NOLOCK) ON Asset.TestingandCommissioningDetId   = Test.TestingandCommissioningDetId             
   --inner join  EngTestingandCommissioningTxn  as te      WITH(NOLOCK) ON    te.TestingandCommissioningId=test.TestingandCommissioningId  
   --left join  MstContractorandVendor    as Contractor     WITH(NOLOCK) ON te.ContractorId=Contractor.ContractorId  
   LEFT  JOIN FMLovMst        AS BERStatus   WITH(NOLOCK) ON ber.BERStatus    = BERStatus.LovId  
   LEFT  JOIN UMUserRegistration      AS RequestorStaff  WITH(NOLOCK) ON ber.RequestorUserId  = RequestorStaff.UserRegistrationId  
   LEFT  JOIN UserDesignation       AS RequestorStaffDes WITH(NOLOCK) ON RequestorStaff.UserDesignationId  = RequestorStaffDes.UserDesignationId  
    where   
     ((ber.FacilityId = @FacilityId) OR (@FacilityId IS NULL) OR (@FacilityId = ''))     

  
END TRY  
BEGIN CATCH  
  
insert into ErrorLog(Spname,ErrorMessage,createddate)  
  values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())  
  
END CATCH  
SET NOCOUNT OFF  
  
  
END
GO
