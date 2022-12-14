         
            
ALTER PROCEDURE  [dbo].[uspFM_CRMRequest_Save_Master]                
                
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
   @pServiceName      NVARCHAR(40)   = NULL   ,              
   @DocumentNumber_master     NVARCHAR(200)   = NULL,            
   @pCRMRequest_PriorityId INT= NULL  ,          
   @pMaster_CRMRequestId INT= NULL,      
     @pWorkGroup int,      
 @pWasteCategory int    
  ,
  @pRequested_Date    DATETIME   = NULL
AS                                                              
                
BEGIN TRY                
                
 DECLARE @mTRANSCOUNT INT = @@TRANCOUNT                
 BEGIN TRANSACTION                
                
-- Paramter Validation                 
                
 SET NOCOUNT ON;                
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;                
                
-- Declaration                
                 
 DECLARE @Table TABLE (ID INT)                
 DECLARE @CurrDate  DATETIME = GETDATE()                
 DECLARE @CurrDateUTC DATETIME = GETUTCDATE()             
 DECLARE @psCRMRequestId  INT              
             
-- Default Values                
                
                
-- Execution                
                
    IF(isnull(@pCRMRequestId,0)= 0 OR @pCRMRequestId='')                
   BEGIN                
                
 DECLARE @pOutParam NVARCHAR(50),@mMonth INT,@mYear INT, @mPrimaryId INT                
 SET @mMonth = MONTH(@RequestDateTime)                
 SET @mYear = YEAR(@RequestDateTime)                
              
 EXEC [uspFM_GenerateDocumentNumber_Master_child] @DocumentNumber_master=@DocumentNumber_master,@pFlag='CRMRequest',@pCustomerId=@CustomerId,@pFacilityId=@FacilityId,@Defaultkey='CRM',@pModuleName=@pServiceName,@pMonth=@mMonth,@pYear=@mYear,@pOutParam=@pOutParam         
 OUTPUT                
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
     CRMRequest_PriorityId  ,          
  Master_CRMRequestId ,      
   WorkGroup ,      
   WasteCategory,Requested_Date      
                           )OUTPUT INSERTED.CRMRequestId INTO @Table                
     VALUES     (                
           @CustomerId,                
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
           @pRequester,            
     @pCRMRequest_PriorityId  ,          
  @pMaster_CRMRequestId,      
   @pWorkGroup,      
   @pWasteCategory,@pRequested_Date    
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
         AssigneeId         = @pAssigneeId,            
   CRMRequest_PriorityId=@pCRMRequest_PriorityId,       
    WorkGroup=@pWorkGroup,       
   WasteCategory= @pWasteCategory,      
         StatusValue         = case when (@pEntryUser='FM' and (@TypeOfRequest = 132 or @TypeOfRequest = 135)) then  StatusValue                
                        when (@pEntryUser='Req' and Not (@TypeOfRequest = 132 or @TypeOfRequest = 135)) then StatusValue                
                       else Null end                
      WHERE CRMRequestId =   @pCRMRequestId                
                
                
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
                
 IF (isnull(@pFlag,'')='Approve'  and isnull(@TypeOfRequest,0)!=375)                
 BEGIN                
                
                
  --UPDATE CRMRequest SET RequestStatus =141,                
  --      ModifiedBy = @pUserId,                
  --      ModifiedDate = @CurrDate,                
  --      ModifiedDateUTC=@CurrDateUTC                
  --WHERE CRMRequestId = @pCRMRequestId                 
                
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
  
  