USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngLicenseandCertificateExpiry_CRMRequestCreation]    Script Date: 21-01-2022 12:55:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


      
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
    
      
/*========================================================================================================      
Application Name : UETrack-BEMS                    
Version    : 1.0      
Procedure Name  : UspFM_EngLicenseandCertificateExpiry_CRMRequestCreation      
Description   : To Get the License Expired data from table EngLicenseandCertificateTxn and Create NCR in CRM Request      
Authors    : Balaganesh      
Date    : 21-Jan-2022      
-----------------------------------------------------------------------------------------------------------      
      
Unit Test:      
EXEC [UspFM_EngLicenseandCertificateExpiry_CRMRequestCreation]      
SELECT * FROM EngLicenseandCertificateTxn      
-----------------------------------------------------------------------------------------------------------      
Version History       
-----:------------:---------------------------------------------------------------------------------------      
Init : Date       : Details      
    
========================================================================================================*/      
      
DROP PROCEDURE  [dbo].[UspFM_EngLicenseandCertificateExpiry_CRMRequestCreation]   
GO
CREATE PROCEDURE  [dbo].[UspFM_EngLicenseandCertificateExpiry_CRMRequestCreation]                                 
         
      
AS                                                    
      
BEGIN TRY      
  
  DECLARE @mTRANSCOUNT INT = @@TRANCOUNT                
 BEGIN TRANSACTION                
            

 SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;      
 
Declare @PreMonthStart date
Declare @PreMonthEnd date
select @PreMonthStart = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0) 
select @PreMonthEnd = DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1)

Declare @Count int
Declare @Min int
Declare @Max int
SET @Count = (select count(LicenseNo) from EngLicenseandCertificateTxn where ExpireDate between @PreMonthStart and @PreMonthEnd and cast(LicenseId as nvarchar(10)) not in (select RequestDescription from [UetrackMasterdbPreProd].[dbo].CRMRequest where RequestDescription is not null))

IF @Count>0
BEGIN
	select ROW_NUMBER() OVER (ORDER BY Licenseid) as RowNo,LicenseId,LicenseNo into #License from EngLicenseandCertificateTxn where ExpireDate between @PreMonthStart and @PreMonthEnd and cast(LicenseId as nvarchar(10)) not in (select RequestDescription from [UetrackMasterdbPreProd].[dbo].CRMRequest where RequestDescription is not null)
SET @Min = (select min(RowNo) from #License)
SET @Max = (select max(RowNo) from #License)

WHILE @Min<=@Max
BEGIN
Declare   @pCRMRequestId   INT                
Declare   @pUserId      INT              
Declare   @CustomerId      INT               
Declare   @FacilityId      INT                
Declare   @ServiceId      INT                               
Declare   @RequestDateTime    DATETIME              
Declare   @RequestDateTimeUTC    DATETIME                
Declare   @RequestStatus     INT                
Declare   @RequestDescription    NVARCHAR(1000)                  
Declare   @TypeOfRequest     INT                
Declare   @Remarks      NVARCHAR(1000)                                                         
Declare   @pRequester      INT                            
Declare   @pEntryUser      NVARCHAR(200)                               
Declare   @pCRMRequest_PriorityId    INT     
Declare    @pWorkGroup int   
Declare    @pWasteCategory int  
Declare   @CurrDateTime    DATETIME  
Declare    @pIndicators_all  varchar(1000)  
Declare    @pAssetId  int  
Declare    @pAssetNo  varchar(50)

-- Declaration                                 
                                                   
 DECLARE @Table TABLE (ID INT)                                                  
 DECLARE @CurrDate  DATETIME = GETDATE()                                                  
 DECLARE @CurrDateUTC DATETIME = GETUTCDATE()                           
 DECLARE @mServiceName NVARCHAR(40)                                          
 DECLARE @pFacility nvarchar(50)       
 DECLARE @RequestNo      NVARCHAR(100) =NULL
 DECLARE @NCRDescription   NVARCHAR(100)
 DECLARE @pOutParam NVARCHAR(50),@mMonth INT,@mYear INT, @mPrimaryId INT 
 SET   @FacilityId    =144     
 SELECT @pFacility = FacilityCode FROM [UetrackMasterdbPreProd].[dbo].MstLocationFacility WHERE FacilityId= @FacilityId    

SET   @pCRMRequestId  =0                
SET   @pUserId   =19              
SET   @CustomerId   =157                          
SET   @ServiceId    =2                                
SET   @RequestDateTime    =GETDATE()              
SET   @RequestDateTimeUTC   =GETUTCDATE()
SET   @RequestStatus  =139               
SET   @RequestDescription  =(select LicenseId from #License where RowNo=@Min)                  
SET   @NCRDescription  =(select'NCR For Expired License No - '+LicenseNo from #License where RowNo=@Min)                  
SET   @TypeOfRequest   =10020                
SET   @Remarks    = 'NCR For License Expired'                                                            
SET   @pRequester = (select UserRegistrationId from UetrackMasterdbPreProd..UMUserRegistration where StaffName like '%System%')                                  
SET   @pEntryUser   ='Req'                              
SET   @pCRMRequest_PriorityId =0     
SET   @pWorkGroup =0   
SET   @pWasteCategory =0
SET   @CurrDateTime =GETDATE()     
SET   @pIndicators_all =  '5'
SET   @pAssetId = (select top 1 AssetId from EngLicenseandCertificateTxnDet where LicenseId=(select LicenseId from #License where RowNo=@Min))
SET   @pAssetNo = (select top 1 AssetNo from EngAsset where AssetId=@pAssetId)


--EXEC [UetrackMasterdbPreProd].[dbo].[uspFM_CRMRequest_Save]  @pCRMRequestId,@pUserId,@CustomerId,@FacilityId,@ServiceId,@RequestDateTime,@RequestDateTimeUTC,
--@RequestStatus,@RequestDescription,@TypeOfRequest,@Remarks,@pRequester,@pEntryUser,@pCRMRequest_PriorityId,@pWorkGroup,@pWasteCategory,@pIndicators_all,@pAssetId

-- Execution                                            
IF(@ServiceId=1)      
BEGIN       
SET @mServiceName = 'F'                                                 
END      
IF(@ServiceId=2)      
BEGIN       
SET @mServiceName = 'B'                                                 
END      
IF(@ServiceId=3)      
BEGIN       
SET @mServiceName = 'C'                                                 
END      
IF(@ServiceId=4)      
BEGIN       
SET @mServiceName = 'L'                                                 
END      
IF(@ServiceId=5)      
BEGIN       
SET @mServiceName = 'H'                                                 
END 

 SET @mMonth = MONTH(@RequestDateTime)                                                  
 SET @mYear = YEAR(@RequestDateTime)                                
 --new added                                                 
  set @pFacility='CRM'+@pFacility+'/'+@mServiceName
  
 EXEC [UetrackMasterdbPreProd].[dbo].[uspFM_GenerateDocumentNumber] @pFlag='CRMRequest',@pCustomerId=@CustomerId,@pFacilityId=@FacilityId,@Defaultkey=@pFacility,@pModuleName=@mServiceName,@pMonth=@mMonth,@pYear=@mYear,@pOutParam=@pOutParam OUTPUT                                        
     
 SELECT @RequestNo=@pOutParam                                                  
                                                  
           INSERT INTO [UetrackMasterdbPreProd].[dbo].CRMRequest(                                                  
           CustomerId,                                                  
           FacilityId,                                                  
           ServiceId,                                          
           RequestNo,                                                  
           RequestDateTime,                                                  
           RequestDateTimeUTC,                                                  
           RequestStatus,                                                  
           RequestDescription,                                                  
           TypeOfRequest,                                                  
           Remarks,                                                  
           CreatedBy,                                                  
           CreatedDate,                                                  
           CreatedDateUTC,                                                  
           ModifiedBy,                                                  
           ModifiedDate,                                                  
           ModifiedDateUTC,                                                  
           IsWorkOrder ,                                                  
           ModelId,                                                  
           ManufacturerId,                                 
           UserAreaId,                                                  
           UserLocationId,                                            
           TargetDate,                                                  
           RequestedPerson,                           
           Requester,                                              
     CRMRequest_PriorityId,                      
   Indicators_all,                      
  NCRDescription,                   
  AssetId,                 
  AssetNo,                
  Responce_Date,                                          
  Completed_Date,                                      
  Completed_By,              
  WorkGroup,        
  WasteCategory,
  Requested_Date
                                             
                           )OUTPUT INSERTED.CRMRequestId INTO @Table                                                  
     VALUES     ( @CustomerId,                                                  
           @FacilityId,                                                  
          @ServiceId,                                                  
           @RequestNo,                                                  
           @RequestDateTime,                                                  
			@RequestDateTimeUTC,                                                  
           @RequestStatus,                                                  
           @RequestDescription,                                              
           @TypeOfRequest,                                                  
           @Remarks,                                                  
           @pUserId,                                                  
           @CurrDate,                                                  
           @CurrDateUTC,                                                  
           @pUserId,                                                  
           @CurrDate,                                                  
           @CurrDateUTC,                                                  
           0,                       
           NULL,                     
           NULL,                                                  
           NULL,                                                  
           NULL,                                                  
           NULL,                         
           NULL,                                                  
           @pRequester ,                                              
     @pCRMRequest_PriorityId ,                      
  @pIndicators_all,                      
  @NCRDescription,                      
      @pAssetId,                 
   @pAssetNo,                
  NULL,                                          
  NULL,                                      
  NULL,              
  @pWorkGroup,        
@pWasteCategory  
,NULL
 )           
                    
     SELECT @mPrimaryId = CRMRequestId FROM [UetrackMasterdbPreProd].[dbo].CRMRequest WHERE CRMRequestId IN (SELECT max(ID) FROM @Table)                                                  
                                                  
     INSERT INTO [UetrackMasterdbPreProd].[dbo].CRMRequestDet ( CRMRequestId,                                                  
            AssetId,                                                  
            CreatedBy,                                                  
            CreatedDate,                                                
            CreatedDateUTC,                                                  
            ModifiedBy,                                                  
            ModifiedDate,                                                  
            ModifiedDateUTC                                                  
              )                                                  
                                                  
       Values (  @mPrimaryId,                                                  
           @pAssetId,                                                  
           @pUserId,                                                  
           @CurrDate,                                                  
           @CurrDateUTC,                                                  
       @pUserId,                                                  
           @CurrDate,                                                  
           @CurrDateUTC                                                  
			   )                                                 
                                                  
 INSERT INTO [UetrackMasterdbPreProd].[dbo].CRMRequestRemarksHistory ( CRMRequestId                                                  
           ,Remarks                                                  
           ,DoneBy                                                  
           ,DoneDate                                                  
           ,DoneDateUTC                                                  
           ,RequestStatus                                                  
           ,RequestStatusValue                              
           ,CreatedBy                                                  
           ,CreatedDate                                                  
           ,CreatedDateUTC                                                  
           ,ModifiedBy                                                  
           ,ModifiedDate                                                  
           ,ModifiedDateUTC                           
                                               
          )                                                  
        VALUES ( @mPrimaryId,                                                  
           @Remarks,                                                  
           @pUserId,                                                  
           @RequestDateTime,                                                  
           @RequestDateTimeUTC,                                                  
           @RequestStatus,                                                  
           'Submit',                                                  
           @pUserId,                                                  
           @CurrDate,                                                  
           @CurrDateUTC,                                                  
           @pUserId,                                                  
           @CurrDate,                                                  
           @CurrDateUTC                                                  
          )                   
                                              

SET @Min=@Min+1;
END --WHILE END
END

  IF @mTRANSCOUNT = 0                
        BEGIN                
          COMMIT TRANSACTION                
        END                   
       

END TRY      
      
BEGIN CATCH      
      
	   IF @mTRANSCOUNT = 0                
        BEGIN                
            ROLLBACK TRANSACTION                
        END   

 INSERT INTO ErrorLog(      
    Spname,      
    ErrorMessage,      
    createddate)      
 VALUES(  OBJECT_NAME(@@PROCID),      
    'Error_line: '+CONVERT(VARCHAR(10), error_line())+' - '+error_message(),      
    getdate()      
     )      
      
END CATCH



