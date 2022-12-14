
--ALTER TABLE CRMRequest ADD NCRDescription nvarchar(400)    
--ALTER TABLE CRMRequest ADD Completed_Date datetime    
--ALTER TABLE CRMRequest ADD Completed_By int    
--ALTER TABLE CRMRequest ADD Action_Taken nvarchar(400)    
--ALTER TABLE CRMRequest ADD Validation int    
--ALTER TABLE CRMRequest ADD Justification nvarchar(400)    
--ALTER TABLE CRMRequest ADD Indicators_all nvarchar(40)    
--ALTER TABLE CRMRequest ADD AssetNo nvarchar(40)          
                  
--ALTER TABLE CRMRequest ADD WorkGroup  int  
--ALTER TABLE CRMRequest ADD WasteCategory int  
                  
                    
                    
                    
                                            
                                            
                                              
--sp_helptext 'uspFM_CRMRequest_Save'                                                
                                                
--sp_helptext 'uspFM_CRMRequest_Save'             
      
      
                                              
ALTER PROCEDURE  [dbo].[uspFM_CRMRequest_Save]                                                  
                                                  
   @pCRMDet      udt_CRMRequestDet READONLY,                                                  
   @pCRMRequestId     INT,                                                  
   @pUserId      INT      = NULL,                                                  
   @CustomerId      INT,                                                  
   @FacilityId      INT,                                                  
   @ServiceId      INT,                                                  
   @RequestNo      NVARCHAR(100)   =NULL,                                                  
   @RequestDateTime    DATETIME,                                                  
   @RequestDateTimeUTC    DATETIME,                                                  
   @RequestStatus     INT,                                                  
   @RequestDescription    NVARCHAR(1000)   =NULL,                                                  
   @TypeOfRequest     INT,                                                  
   @Remarks      NVARCHAR(1000)   =NULL,                                                  
   @pModelId      INT  = NULL,                                                  
   @pManufacturerid    INT  = NULL,                                                  
   @pUserAreaId     INT  = NULL,                                                  
   @pUserLocationId    INT  = NULL,                                                  
   @pFlag       NVARCHAR(200)   =NULL,                                                  
   @pTargetDate     DATETIME = NULL,                                                  
   @pRequestedPerson    INT   = NULL,                                                  
   @pRequester      INT   = NULL,                                                  
   @pAssigneeId     INT     = NULL,                                                  
   @pEntryUser      NVARCHAR(200)   =NULL,                                                  
   @CurrDateTime      DATETIME = NULL ,                                                 
   @pServiceName      NVARCHAR(40)   = NULL ,                                              
   @pCRMRequest_PriorityId    INT   = NULL ,                                      
   @pResponce_Date    DATETIME   = NULL ,                                      
   @pCompleted_Date    DATETIME   = NULL ,                                      
   @pCompleted_By    INT   = NULL      ,                              
   ---added for LLS                              
   @presponse_by int =NULL,                              
   @pAction_Taken varchar(200)= NULL,                              
   @pValidation int= NULL,                              
   @pJustification varchar(200)  = NULL  ,                        
   @pIndicators_all varchar(1000)=NULL,                      
   @pNCRDescription varchar(1000)=NULL,                    
    ---added for LLS                    
 @pAssetId int =NULL,                
  @pAssetNo varchar(50) =NULL,              
  ---added for FEMS              
  @pWorkGroup int ,         
  @pWasteCategory int ,
  @pRequested_Date    DATETIME   = NULL
            
AS                                                                                        
                                                  
BEGIN TRY                                                  
                                                  
 DECLARE @mTRANSCOUNT INT = @@TRANCOUNT                              
  DECLARE @mserviceid   INT                                             
 BEGIN TRANSACTION                                                  
                                                  
-- Paramter Validation                                                   
                                             
 SET NOCOUNT ON;                                                  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;                                                  
                                                  
-- Declaration                                 
                                                   
 DECLARE @Table TABLE (ID INT)                                                  
 DECLARE @CurrDate  DATETIME = GETDATE()                                                  
 DECLARE @CurrDateUTC DATETIME = GETUTCDATE()                           
 DECLARE @mServiceName NVARCHAR(40)                                          
 DECLARE @pFacility nvarchar(50)                                    
   SELECT @pFacility = FacilityCode FROM MstLocationFacility WHERE FacilityId= @FacilityId                                        
-- Default Values                                                  
                                                  
                         
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
      
      
      
      
                                                  
  --IF (@ServiceId =1)                                                    
  --BEGIN                                                    
  -- SET @mServiceName = 'F'                                                 
  --END                                                    
  --ELSE                                                    
  --BEGIN                            
  -- IF(@ServiceId =2)                              
--  BEGIN                                                    
  -- SET @mServiceName = 'B'                                                 
  --END                               
  --IF(@ServiceId =3)                              
  --  BEGIN                                                    
  -- SET @mServiceName = 'C'                                                 
  --END      
  --IF(@ServiceId =4)                              
  --  BEGIN                                                    
  -- SET @mServiceName = 'L'                                                 
  --END      
  -- ELSE                                              
  -- BEGIN                                                    
  -- SET @mServiceName = 'H'                                                 
  --END                                              
  --END                                                   
    IF(isnull(@pCRMRequestId,0)= 0 OR @pCRMRequestId='')                                                  
   BEGIN                                                  
                                           
 DECLARE @pOutParam NVARCHAR(50),@mMonth INT,@mYear INT, @mPrimaryId INT                                      
 SET @mMonth = MONTH(@RequestDateTime)                                                  
 SET @mYear = YEAR(@RequestDateTime)                                
 --new added                                                 
  set @pFacility='CRM'+@pFacility+'/'+@mServiceName                                    
 EXEC [uspFM_GenerateDocumentNumber] @pFlag='CRMRequest',@pCustomerId=@CustomerId,@pFacilityId=@FacilityId,@Defaultkey=@pFacility,@pModuleName=@mServiceName,@pMonth=@mMonth,@pYear=@mYear,@pOutParam=@pOutParam OUTPUT                                        
 
     
      
       
           
 SELECT @RequestNo=@pOutParam                                                  
                                                  
           INSERT INTO CRMRequest(                                                  
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
     VALUES     (                                                 @CustomerId,                                                  
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
           @pModelId,                     
           @pManufacturerId,                                                  
           @pUserAreaId,                                                  
           @pUserLocationId,                                                  
           @PTargetDate,                         
           @pRequestedPerson,                                                  
           @pRequester ,                                              
     @pCRMRequest_PriorityId ,                      
  @pIndicators_all,                      
  @pNCRDescription,                      
      @pAssetId,                 
   @pAssetNo,                
  @pResponce_Date,                                          
  @pCompleted_Date,                                      
  @pCompleted_By,              
  @pWorkGroup,        
@pWasteCategory  
,@pRequested_Date
          )           
                                
     SELECT @mPrimaryId = CRMRequestId FROM CRMRequest WHERE CRMRequestId IN (SELECT ID FROM @Table)                                                  
                                                  
     INSERT INTO CRMRequestDet ( CRMRequestId,                                                  
            AssetId,                                                  
            CreatedBy,                                                  
            CreatedDate,                                                
            CreatedDateUTC,                                                  
            ModifiedBy,                                                  
            ModifiedDate,                                                  
            ModifiedDateUTC                                                  
              )                                                  
                                                  
        SELECT  @mPrimaryId,                                                  
           AssetId,                                                  
           @pUserId,                                                  
           @CurrDate,                                                  
           @CurrDateUTC,                                                  
       @pUserId,                                                  
           @CurrDate,                                                  
           @CurrDateUTC                                                  
        FROM @pCRMDet                                      
        WHERE ISNULL(CRMRequestDetId,0)=0                                                  
                                                  
 INSERT INTO CRMRequestRemarksHistory ( CRMRequestId                                                  
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
                                                  
                                                  
          SELECT    CRMRequestId,                                                  
          [Timestamp],                                                  
          GuId,                                                  
          RequestNo                                                  
       FROM     CRMRequest                  
       WHERE    CRMRequestId IN (SELECT ID FROM @Table)                                                  
                                                   
  END                                      
  ELSE                                                  
   BEGIN                                                  
    IF (@TypeOfRequest=10020)                       
                       
BEGIN                      
UPDATE CRMRequest SET                                                  
         CustomerId         = @CustomerId,                                                  
         FacilityId         = @FacilityId,                                                  
         ServiceId         = @ServiceId,                                                  
         --RequestNo         = @RequestNo,                                                  
     RequestDateTime        = @RequestDateTime,                                                  
         RequestDateTimeUTC       = @RequestDateTimeUTC,                                                  
         RequestStatus        = @RequestStatus,                                                  
         RequestDescription       = @RequestDescription,                                                  
         TypeOfRequest        = @TypeOfRequest,                                                  
         Remarks          = @Remarks,                            
         ModifiedBy         = @pUserId,                                                  
         ModifiedDate        = @CurrDate,                                                  
         ModifiedDateUTC        = @CurrDateUTC,                                                  
         ModelId          = @pModelId,                                                  
         Manufacturerid        = @pManufacturerid,                                                  
         UserAreaId         = @pUserAreaId,                                                  
         UserLocationId        = @pUserLocationId,                                                  
         TargetDate         = @pTargetDate,                                                  
         RequestedPerson        = @pRequestedPerson,                                                  
         Requester         = @pRequester,                                               
         CRMRequest_PriorityId=@pCRMRequest_PriorityId,                       
         AssigneeId         = @pAssigneeId,                                       
         Responce_Date =@pResponce_Date,                       
 Completed_Date=@pCompleted_Date,                                      
         Completed_By =@pCompleted_By,               
   WorkGroup=@pWorkGroup,Requested_Date=@pRequested_Date,              
   WasteCategory=@pWasteCategory,        
         StatusValue         = case when (@pEntryUser='FM' and (@TypeOfRequest = 132 or @TypeOfRequest = 135)) then  StatusValue                                                  
                        when (@pEntryUser='Req' and Not (@TypeOfRequest = 132 or @TypeOfRequest = 135)) then StatusValue                                                  
   else Null end                          
      WHERE CRMRequestId =   @pCRMRequestId                                                  
                                                  
                           
       END                            
  ELSE                            
    BEGIN                      
  UPDATE CRMRequest SET                                                  
         CustomerId         = @CustomerId,                                                  
         FacilityId         = @FacilityId,                                                  
         ServiceId         = @ServiceId,                                                  
         --RequestNo         = @RequestNo,                                 
     RequestDateTime        = @RequestDateTime,                                                  
         RequestDateTimeUTC       = @RequestDateTimeUTC,                                                  
         RequestStatus        = @RequestStatus,                                                  
   RequestDescription       = @RequestDescription,                                                  
         TypeOfRequest        = @TypeOfRequest,                                                  
         Remarks          = @Remarks,                            
         ModifiedBy         = @pUserId,                   
         ModifiedDate        = @CurrDate,                                                  
         ModifiedDateUTC        = @CurrDateUTC,                                                  
         ModelId          = @pModelId,                                                  
         Manufacturerid        = @pManufacturerid,                                                  
         UserAreaId         = @pUserAreaId,                                                  
         UserLocationId        = @pUserLocationId,                                                  
         TargetDate         = @pTargetDate,                                                  
         RequestedPerson        = @pRequestedPerson,                                                
         Requester         = @pRequester,                                               
      CRMRequest_PriorityId=@pCRMRequest_PriorityId,                       
         AssigneeId         = @pAssigneeId,                                       
           Responce_Date =@pResponce_Date,                       
  Indicators_all= @pIndicators_all,                      
  Completed_Date=@pCompleted_Date,                                      
  Completed_By =@pCompleted_By,               
  WorkGroup=@pWorkGroup,              
  WasteCategory=@pWasteCategory,Requested_Date=@pRequested_Date,        
         StatusValue         = case when (@pEntryUser='FM' and (@TypeOfRequest = 132 or @TypeOfRequest = 135)) then  StatusValue                                                  
                        when (@pEntryUser='Req' and Not (@TypeOfRequest = 132 or @TypeOfRequest = 135)) then StatusValue                                                  
                       else Null end                                                  
      WHERE CRMRequestId =   @pCRMRequestId                                                  
                                                  
                           
  END                
                        
                       
                                     
           INSERT INTO CRMRequestDet ( CRMRequestId,                                                  
            AssetId,                                                  
            CreatedBy,                                                  
            CreatedDate,                                                  
            CreatedDateUTC,                                                  
            ModifiedBy,                                                  
            ModifiedDate,                                                  
            ModifiedDateUTC                                                  
              )                       
           
        SELECT  @pCRMRequestId,                                                  
           AssetId,                                                  
           @pUserId,                                                  
           @CurrDate,                                                  
           @CurrDateUTC,                                                  
           @pUserId,                                                  
           @CurrDate,                                                  
           @CurrDateUTC                                                  
        FROM @pCRMDet                                                  
WHERE ISNULL(CRMRequestDetId,0)=0                                                  
  -- IF(isnull(@pFlag,'')='Approve' and isnull(@TypeOfRequest,0)=10021)                                      
      --   BEGIN                                       
  -- UPDATE CRMRequest SET requestst='Closed' where CRMRequestId=@pCRMRequestId                                      
  --  END                                          
                                          
      
 IF (isnull(@pFlag,'')='Approve' and isnull(@TypeOfRequest,0)!=375)                                                  
 BEGIN                              
                                                 
     set @mserviceid=(select ServiceId from CRMRequest WHERE CRMRequestId = @pCRMRequestId   )                            
 IF (@mserviceid=4)                       
                       
BEGIN                                            
                              
   UPDATE CRMRequest SET RequestStatus =142,                                                  
        ModifiedBy = @pUserId,                                                  
        ModifiedDate = @CurrDate,                                                  
        ModifiedDateUTC=@CurrDateUTC ,                            
      Action_Taken=@pAction_Taken,                            
   [Validation]=@pValidation,                            
   Justification=@pJustification ,                        
   Indicators_all=@pIndicators_all,              
   WorkGroup=@pWorkGroup      ,        
  WasteCategory=@pWasteCategory        
                                                
  WHERE CRMRequestId = @pCRMRequestId and @TypeOfRequest=10021                      
  END                            
  ELSE                            
    BEGIN               UPDATE CRMRequest SET RequestStatus =142,                                                  
        ModifiedBy = @pUserId,                                                  
        ModifiedDate = @CurrDate,                                                  
        ModifiedDateUTC=@CurrDateUTC      ,                            
    Action_Taken=@pAction_Taken,                            
   [Validation]=@pValidation,                            
   Justification=@pJustification  ,                        
   Indicators_all=@pIndicators_all,              
   WorkGroup=@pWorkGroup      ,        
   WasteCategory=@pWasteCategory        
  WHERE CRMRequestId = @pCRMRequestId  and   @TypeOfRequest=10021                                               
  END                                              
             
  --------srinu NCR                    
       set @mserviceid=(select ServiceId from CRMRequest WHERE CRMRequestId = @pCRMRequestId   )                            
 IF (@mserviceid=4)                       
                       
BEGIN                                       
                              
   UPDATE CRMRequest SET RequestStatus =142,                                                  
        ModifiedBy = @pUserId,                                                  
        ModifiedDate = @CurrDate,                                                  
        ModifiedDateUTC=@CurrDateUTC ,                
      Action_Taken=@pAction_Taken,                     
   Completed_Date=@pCompleted_Date,                                      
  Completed_By =@pCompleted_By,              
  WorkGroup=@pWorkGroup      ,        
  WasteCategory=@pWasteCategory        
   --[Validation]=@pValidation,                            
   --Justification=@pJustification                         
  -- Indicators_all=@pIndicators_all                      
                      
                                                
  WHERE CRMRequestId = @pCRMRequestId and @TypeOfRequest=10020                      
  END                            
  ELSE                            
    BEGIN                             
  UPDATE CRMRequest SET RequestStatus =142,                                                  
        ModifiedBy = @pUserId,                                                  
        ModifiedDate = @CurrDate,                                    
        ModifiedDateUTC=@CurrDateUTC ,                            
        Action_Taken=@pAction_Taken,                     
     Completed_Date=@pCompleted_Date,                                      
        Completed_By =@pCompleted_By,              
  WorkGroup=@pWorkGroup      ,        
  WasteCategory=@pWasteCategory        
  WHERE CRMRequestId = @pCRMRequestId  and   @TypeOfRequest=10020                                               
  END                     
                    
                                                  
  IF NOT EXISTS (SELECT * FROM CRMRequestRemarksHistory WHERE CRMRequestId = @pCRMRequestId AND RequestStatusValue='Closed' AND Remarks = @Remarks)                                                  
                                                  
  BEGIN                                                  
 INSERT INTO CRMRequestRemarksHistory ( CRMRequestId                        
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
        VALUES ( @pCRMRequestId,                                                  
           @Remarks,                                                  
           @pUserId,                                                  
           --@CurrDate,                                                  
           @CurrDateTime,                                          
           @CurrDateUTC,                                                  
           --140,                                                  
           @RequestStatus,                                                  
           'Closed',                          
           @pUserId,                                                  
           @CurrDate,                                                  
 @CurrDateUTC,                                                  
           @pUserId,                                                  
           @CurrDate,                                                  
           @CurrDateUTC                                                  
          )                                                  
  END                                 
                                                  
 END                                                  
 ELSE                                                  
 BEGIN                                                  
                                                    
  INSERT INTO CRMRequestRemarksHistory ( CRMRequestId                                                  
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
        VALUES ( @pCRMRequestId,                                             
           @Remarks,                                                  
           @pUserId,                                                  
           --@CurrDate,                                                  
           @CurrDateTime,                                                  
       @CurrDateUTC,                                                  
           --140,                        
           @RequestStatus,                                                  
           'In Progress',                                                  
           @pUserId,                                                  
           @CurrDate,                                                  
           @CurrDateUTC,                                                  
           @pUserId,                                                  
           @CurrDate,                                                  
           @CurrDateUTC                                                  
          )                                                  
                                                  
 END                                                  
                                                  
           SELECT   CRMRequestId,                                                  
          [Timestamp],                
          GuId,                                                  
          RequestNo                                                  
       FROM     CRMRequest                                         
       WHERE    CRMRequestId = @pCRMRequestId                                                  
                                                  
END                                                  
                                                  
 IF @mTRANSCOUNT = 0                                                  
        BEGIN                                              
            COMMIT TRANSACTION                                                  
        END                                                     
                                                  
                                   
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
    @CurrDate                                                  
     );          
     THROW;                                                  
                                        
END CATCH