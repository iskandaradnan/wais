USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_CustomerMst_Save]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
    
    
    
    
    
    
    
    
    
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                  
    
Application Name : UETrack                  
    
Version    :                   
    
File Name   :                  
    
Procedure Name  : UspFM_CustomerMst_Save    
    
Author(s) Name(s) : Praveen N    
    
Date    : 09-03-2018    
    
Purpose    : SP to Save and Update Customer Details    
    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        
    
      
    
EXEC usp_CustomerMst_Get @CustomerId = '1'      
    
declare @CustomerContactInfoUDT  [udt_MstCustomerContactInfo]    
insert into @CustomerContactInfoUDT (Name,Designation,ContactNo,Email)values    
('aaa','naaa','6575675','dsgdfg'),    
('aaa','naaa','6575675','dsgdfg')    
    
EXEC [UspFM_CustomerMst_Save] @CustomerId=0,@CustomerName='AAA',@CustomerCode='AAA',@Address='ergdfg',@Latitude=11.22,@Longitude=231,@ActiveFromDate='2018-06-28 20:29:31.277'    
 ,@ActiveFromDateUTC='2018-06-28 20:29:31.277',@ActiveToDate='2018-06-28 20:29:31.277',@ActiveToDateUTC='2018-06-28 20:29:31.277',@Userid=2,@ContactNo='fsdg'    
 ,@Address2 ='cdbgfdh',@Postcode='dfhfgjh',@State='ergtrg'  ,@Country='wetert',@ContractPeriodInYears=56,@TypeOfContractLovId  =2,@CustomerContactInfoUDT=@CustomerContactInfoUDT    
    
    
    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
    
    
    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        
    
Modification History        
    
Modified from usp_CustomerMst_Save to usp_CustomerMst_Save  By Pravin    
    
    
    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        
    
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS        
    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~           
MODIFIED: CUSTOMERTYPE    
BY PRANAY    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/                     
     
   CREATE PROCEDURE  [dbo].[UspFM_CustomerMst_Save]                               
    
(     
        @CustomerType    NVARCHAR(150)=null,    
  @CustomerId           INT=NULL,     
  @CustomerName               NVARCHAR(200)=null,    
  @CustomerCode               NVARCHAR(200)=null,    
  @Address        NVARCHAR(1010)=null,    
        @Latitude        NuMERIC(14,8)=null,    
  @Longitude        NuMERIC(14,8)=null,    
        @ActiveFromDate       DATETIME=null,     
  @ActiveFromDateUTC          DATETIME=null,     
     @ActiveToDate       DATETIME=null,     
  @ActiveToDateUTC   DATETIME=null,    
  @Userid                     INT = null,    
  --@ContactNo                  NVARCHAR(100)=null,    
  @Address2        NVARCHAR(1010)=null,    
  @Postcode        NVARCHAR(10)=null,    
  @State            NVARCHAR(200)=null,    
  @Country        NVARCHAR(200)=null,    
  @ContractPeriodInYears      NuMERIC(10,2)=null,    
  --@TypeOfContractLovId        INT = null,      
  @pLogo      VARBINARY(max) = null,    
  @pContactNo        NVARCHAR(200)=null,    
  @pFaxNo            NVARCHAR(200)=null,    
  @pRemarks        NVARCHAR(1200)=null,    
        @pActive     BIT ,    
      
    
  @pCustomerImage    VARBINARY(max) = null,    
        @CustomerContactInfoUDT  AS [dbo].[udt_MstCustomerContactInfo] READONLY    
    
      
    
)               
    
AS                                                  
    
BEGIN                                    
    
SET NOCOUNT ON    
    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
    
BEGIN     
    
    TRY       
    
     
 DECLARE @Table TABLE (ID INT)    
   IF(@CustomerId = 0 or @CustomerId is null)    
    
   BEGIN    
    
        DECLARE @CUSTOMERCOUNT INT = (SELECT COUNT(1) FROM MstCustomer WHERE CustomerName= @CustomerName AND Active= 1 )    
    
     IF(@CUSTOMERCOUNT = 0 )    
     BEGIN    
             DECLARE @pOutParam NVARCHAR(50),@mMonth INT,@mYear INT, @mPrimaryId INT    
  SET @mMonth = MONTH(GETDATE())    
  SET @mYear = YEAR(GETDATE())    
    
 EXEC [uspFM_GenerateDocumentNumber] @pFlag='MstCustomer',@pCustomerId=null,@pFacilityId=null,@Defaultkey='CUS',@pModuleName='BEMS',@pMonth=@mMonth,@pYear=@mYear,@pOutParam=@pOutParam OUTPUT    
 SELECT @CustomerCode=@pOutParam    
    
         INSERT INTO MstCustomer(CustomerName,CustomerCode, [Address], Longitude,Latitude                 
    
     ,ActiveFromDate,ActiveFromDateUTC,ActiveToDate,ActiveToDateUTC,CreatedBy,    
      CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC,    
      Address2    
              ,Postcode    
     ,State    
              ,Country    
              ,ContractPeriodInYears    
     ,CustomerType    
            --  ,TypeOfContractLovId    
     ,Logo    
     ,CustomerImage    
     ,ContactNo    
     ,FaxNo    
     ,Remarks    
     ,Active     
     )OUTPUT INSERTED.CustomerId INTO @Table    
    
            VALUES  (@CustomerName,     
      @CustomerCode,     
      --(SELECT 'CUST' +  ISNULL(CAST(MAX(RIGHT(CustomerCode,4)) + 1 AS NVARCHAR(50)),1000) FROM MstCustomer) ,    
      @Address,@Longitude,@Latitude    
    
             ,@ActiveFromDate    
       ,@ActiveFromDateUTC    
       ,@ActiveToDate    
       ,@ActiveToDateUTC    
       ,@Userid    
       ,getdate()    
       ,getdate()    
       , @Userid    
       , GETDATE()    
       , getdate(),    
         @Address2    
         ,@Postcode    
         ,@State    
         ,@Country    
         ,@ContractPeriodInYears    
         ,@CustomerType    
       --  ,@TypeOfContractLovId    
         ,@pLogo    
         ,@pCustomerImage    
         ,@pContactNo    
         ,@pFaxNo    
         ,@pRemarks    
         ,@pActive)    
    
         Declare  @mCustomerId int  = (SELECT CustomerId FROM MstCustomer WHERE CustomerId IN (SELECT ID FROM @Table))    
          
        INSERT INTO MstCustomerContactInfo    
      (     
           
                           CustomerId    
                          ,Name    
                          ,Designation    
                          ,ContactNo    
                          ,Email    
                          ,CreatedBy    
                          ,CreatedDate    
                          ,CreatedDateUTC    
                          ,ModifiedBy    
                          ,ModifiedDate    
                          ,ModifiedDateUTC    
           ,Active    
    
      )           
   SELECT      
            
       @mCustomerId,    
       Name,    
       Designation,    
       ContactNo,     
       Email,     
       @UserId,       
       GETDATE(),       
       GETUTCDATE(),      
       @UserId       ,       
       GETDATE(),      
       GETUTCDATE(),    
       1    
           
   FROM @CustomerContactInfoUDT    
   WHERE   ISNULL(CustomerContactInfoId,0)=0 and Active=1    
         
   SELECT CustomerId,GuId,'' ErrorMessage FROM MstCustomer WHERE CustomerId IN (SELECT ID FROM @Table)    
    END     
    else     
    begin    
          SELECT  0 CustomerId,'Customer Name Already Exists' ErrorMessage    
    end     
    
    
    
    
    
        
      
    
   END    
    
  ELSE    
    
   BEGIN    
    
         IF EXISTS(SELECT 1 FROM @CustomerContactInfoUDT WHERE Active =0)    
   BEGIN    
    DELETE FROM MstCustomerContactInfo WHERE CustomerContactInfoId IN (SELECT distinct CustomerContactInfoId FROM @CustomerContactInfoUDT     
   WHERE Active =0 AND CustomerContactInfoId>0)    
   END    
    
    
    DECLARE    @mTypeofContract NVARCHAR(1000)    
    DECLARE    @mLastUpdatedBy NVARCHAR(1000)    
        
    SET     @mLastUpdatedBy = (SELECT a.StaffName FROM UMUserRegistration  A INNER JOIN MstCustomer B on A.UserRegistrationId = B.ModifiedBy WHERE B.CustomerId =@CustomerId )     
    insert into [FmHistory](TableName,TableGuid,TableRowData,ModifiedDate,ModifiedUTCDate)    
    select 'MstCustomer',GuId,(SELECT Customer.Address,isnull(Customer.Address2,'') as Address2,Customer.Postcode as PostCode,Customer.State,Customer.Country,Customer.Latitude,Customer.Longitude,null as [Active From Date]    
    ,null as [Active To Date]    
    ,Customer.ContractPeriodInYears as [Contract Period In Years],@mLastUpdatedBy as [Last Updated By],Customer.ModifiedDate as [Last Update On]    
      FROM MstCustomer Customer    
    where Customer.CustomerId =@CustomerId      
    and Not ( isnull(Customer.Address,'') = isnull(@Address,'')     
       and isnull(Customer.Address2,'')=isnull(@Address2,'')    
        and isnull(Customer.Postcode,'')=isnull(@Postcode,'')    
         and isnull(Customer.State,'')=isnull(@State,'')    
          and isnull(Customer.Country,'')=isnull(@Country,'')    
        and isnull(Customer.Latitude,'')=isnull(@Latitude,'')    
        and isnull(Customer.Longitude,'')=isnull(@Longitude,'')    
         
        )    
    FOR JSON AUTO),GETDATE(),GETUTCDATE() from MstCustomer Customer1 where CustomerId =@CustomerId    
    and Not ( isnull(Customer1.Address,'') = isnull(@Address,'')     
       and isnull(Customer1.Address2,'')=isnull(@Address2,'')    
        and isnull(Customer1.Postcode,'')=isnull(@Postcode,'')    
         and isnull(Customer1.State,'')=isnull(@State,'')    
          and isnull(Customer1.Country,'')=isnull(@Country,'')    
        and isnull(Customer1.Latitude,'')=isnull(@Latitude,'')    
        and isnull(Customer1.Longitude,'')=isnull(@Longitude,'')    
           
        )    
    
        UPDATE MstCustomer     
    
     SET         
    
    [Address]=@Address    
    ,Longitude=@Longitude    
    ,Latitude=@Latitude     
       
    ,ActiveFromDate= @ActiveFromDate    
    ,ActiveFromDateUTC= @ActiveFromDateUTC    
    ,ActiveToDate=@ActiveToDate    
    ,ActiveToDateUTC=@ActiveToDateUTC    
    ,ModifiedBy=@Userid    
    ,ModifiedDate=getdate(),    
        ModifiedDateUTC=GETDATE()    
       ,Address2=@Address2    
             ,Postcode=@Postcode    
            ,State=@State    
            ,Country=@Country    
            ,ContractPeriodInYears=@ContractPeriodInYears    
           -- ,TypeOfContractLovId=@TypeOfContractLovId    
   ,Logo=@pLogo    
   ,CustomerImage=@pCustomerImage    
   ,ContactNo=@pContactNo    
   ,FaxNo=@pFaxNo    
   ,Remarks=@pRemarks    
   ,Active=@pActive   
   ,CustomerType=@CustomerType  
     
  WHERE     
       CustomerId= @CustomerId    
    
    SELECT CustomerId, '' ErrorMessage,GuId FROM MstCustomer WHERE CustomerId =@CustomerId    
    
    
  -- IF EXISTS(SELECT 1 FROM @CustomerContactInfoUDT WHERE Active =0)    
  --BEGIN    
  -- DELETE FROM MstCustomerContactInfo WHERE CustomerContactInfoId IN (SELECT CustomerContactInfoId FROM @CustomerContactInfoUDT     
  -- WHERE Active =0 AND CustomerContactInfoId>0)    
  --END    
    
    
   UPDATE CONTACTINFO SET    
            
                       
                    Name              = contactUdt.Name    
                   ,Designation       = contactUdt.Designation    
                   ,ContactNo    = contactUdt.ContactNo    
                   ,Email             = contactUdt.Email      
                   ,ModifiedBy    = @Userid    
                   ,ModifiedDate   = GETDATE()    
                   ,ModifiedDateUTC   = GETDATE()    
          
            
               FROM MstCustomerContactInfo CONTACTINFO    
      INNER JOIN @CustomerContactInfoUDT  AS contactUdt on CONTACTINFO.CustomerContactInfoId=contactUdt.CustomerContactInfoId    
      WHERE ISNULL(contactUdt.CustomerContactInfoId,0)>0 AND contactUdt.Active=1    
    
     
                
        INSERT INTO MstCustomerContactInfo    
      (     
           
                           CustomerId    
                          ,Name    
                          ,Designation    
           ,ContactNo    
                          ,Email    
                          ,CreatedBy    
                          ,CreatedDate    
                          ,CreatedDateUTC    
,ModifiedBy    
                          ,ModifiedDate    
                          ,ModifiedDateUTC    
    
    
      )           
   SELECT      
            
       @CustomerId,    
       Name,    
       Designation,    
       ContactNo,     
       Email,     
       @UserId,       
       GETDATE(),       
       GETUTCDATE(),      
       @UserId       ,       
       GETDATE(),      
       GETUTCDATE()    
           
   FROM @CustomerContactInfoUDT    
   WHERE   ISNULL(CustomerContactInfoId,0)=0 and Active=1    
       
      END    
    
       
    
    
    
      
    
END TRY    
    
BEGIN CATCH    
    
    
    
insert into ErrorLog(Spname,ErrorMessage,createddate)    
    
  values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())    
    
    
    
END CATCH    
    
SET NOCOUNT OFF    
    
END
GO
