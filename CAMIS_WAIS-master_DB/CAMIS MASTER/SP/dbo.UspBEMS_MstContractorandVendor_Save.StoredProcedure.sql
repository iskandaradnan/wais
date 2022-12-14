USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspBEMS_MstContractorandVendor_Save]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~              

Application Name	: UETrack              

Version				:               

File Name			:              

Procedure Name		: UspFM_CustomerMst_Save

Author(s) Name(s)	: Praveen N

Date				: 09-03-2018

Purpose				: SP to Save and Update Customer Details

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    

  

EXEC usp_CustomerMst_Get @CustomerId = '1'  





~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   



~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    

Modification History    

Modified from usp_CustomerMst_Save to usp_CustomerMst_Save  By Pravin

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    

SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS    

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~       

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/    			          

	          



CREATE PROCEDURE  [dbo].[UspBEMS_MstContractorandVendor_Save]                           

( 

		@ContractorId		        INT=NULL, 
		@CustomerId					INT=NULL,
		@SSMRegistrationCode	    NVARCHAR(50)=null,
		@ContractorName             NVARCHAR(100)=null,
		@Active                     BIT,
		@Specialization             NVARCHAR(100)=null,
        @Address     	            NVARCHAR(1000)=null,
		@State					    NVARCHAR(100)=null,
        @ContactPerson  		    NVARCHAR(100)=null,
		@Designation			    NVARCHAR(100)=null,
		@Email  		            NVARCHAR(100)=null,
		@ContactNo			        NVARCHAR(30)=null,
		@FaxNo			            NVARCHAR(30)=null,
		@Remarks	                NVARCHAR(1000)=NULL,
        @CreatedBy			        INT=null,
        @UserId			            INT=null,	
	    @Address2					NVARCHAR(1100)=null,
		@Postcode					NVARCHAR(200)=null,
		@Country					NVARCHAR(200)=null,
		@NoOfUserAccess				INT=null,
		@pContactNo				    NVARCHAR(200)=null,
        @ContractorContactInfoUDT	AS	[dbo].[udt_MstContractorandVendorContactInfo] READONLY

)           

AS                                              

BEGIN                                

SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

BEGIN TRY   
	
--begin tran 

	
	DECLARE @Table TABLE (ID INT)

	DECLARE @ContractorIdOut INT
	  IF(@ContractorId = 0 or @ContractorId is null)

	  BEGIN


	        INSERT INTO MstContractorandVendor(
			
             CustomerId
            ,SSMRegistrationCode
            ,ContractorName
            ,ContractorStatus
            ,ContractorType
			,SpecializationDetails
            ,Address
            ,State
            ,FaxNo
            ,Remarks
            ,CreatedBy
            ,CreatedDate
            ,CreatedDateUTC
			,ModifiedBy
			,ModifiedDate
			,ModifiedDateUTC
			,Active
			,Address2
			,Postcode
			,CountryId
			,NoOfUserAccess
			,ContactNo
			)OUTPUT INSERTED.ContractorId INTO @Table

		    VALUES  (@CustomerId,@SSMRegistrationCode, @ContractorName,1, 1,@Specialization,
			         
			         @Address,@State, @FaxNo,@Remarks,
			
			         @UserId, getdate(),getdate(), @UserId, getdate(),getdate(), @Active,
					 @Address2,@Postcode,@Country,@NoOfUserAccess,@pContactNo)

	  Declare  @mContractorId int  = (SELECT	ContractorId	FROM	MstContractorandVendor WHERE	ContractorId IN (SELECT ID FROM @Table))
	  INSERT INTO MstContractorandVendorContactInfo
						(	
							
                           ContractorId
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
								
							@mContractorId,
							Name,
							Designation,
							ContactNo,	
							Email,	
							@UserId,			
							GETDATE(),			
							GETUTCDATE(),		
							@UserId							,			
							GETDATE(),		
							GETUTCDATE()
							
			FROM	@ContractorContactInfoUDT
			WHERE   ISNULL(ContractorContactInfoId,0)=0 and Active=1

    		SELECT ContractorId, [Timestamp],GuId FROM MstContractorandVendor WITH(NOLOCK) WHERE ContractorId IN (SELECT ID FROM @Table)

	

	  END
	  else
	  begin
	      
		    IF EXISTS(SELECT 1 FROM @ContractorContactInfoUDT WHERE Active =0)
			BEGIN
				DELETE FROM MstContractorandVendorContactInfo WHERE ContractorContactInfoId IN (SELECT distinct ContractorContactInfoId FROM @ContractorContactInfoUDT 
			WHERE Active =0 AND ContractorContactInfoId>0)
	       END


	      update MstContractorandVendor set 
		  
       
         --   ContractorStatus=@ContractorStatus
		
            Address=@Address
            ,State=@State
           
			,SpecializationDetails=@Specialization
 
            ,FaxNo=@FaxNo
            ,Remarks=@Remarks
            ,ModifiedBy=@UserId
            ,ModifiedDate=GETDATE()
            ,ModifiedDateUTC=GETDATE(),
			Active=@Active
			,Address2=@Address2
			,Postcode=@Postcode
			,CountryId=@Country
			,NoOfUserAccess=@NoOfUserAccess
			, ContactNo=@pContactNo
			where ContractorId=@ContractorId

				UPDATE CONTACTINFO SET
			     
                   
                    Name              = contactUdt.Name
                   ,Designation       = contactUdt.Designation
                   ,ContactNo		  =	contactUdt.ContactNo
                   ,Email             = contactUdt.Email  
                   ,ModifiedBy		  =	@Userid
                   ,ModifiedDate	  =	GETDATE()
                   ,ModifiedDateUTC	  =	GETDATE()
      
        
               FROM MstContractorandVendorContactInfo CONTACTINFO
			   INNER JOIN @ContractorContactInfoUDT		AS contactUdt on CONTACTINFO.ContractorContactInfoId=contactUdt.ContractorContactInfoId
			   WHERE	ISNULL(contactUdt.ContractorContactInfoId,0)>0 AND contactUdt.Active=1

	
	           
		     INSERT INTO MstContractorandVendorContactInfo
						(	
							
                           ContractorId
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
								
							@ContractorId,
							Name,
							Designation,
							ContactNo,	
							Email,	
							@UserId,			
							GETDATE(),			
							GETUTCDATE(),		
							@UserId							,			
							GETDATE(),		
							GETUTCDATE()
							
			FROM	@ContractorContactInfoUDT
			WHERE   ISNULL(ContractorContactInfoId,0)=0 and Active=1



			SELECT ContractorId, [Timestamp],GuId FROM MstContractorandVendor WITH(NOLOCK) WHERE ContractorId =@ContractorId
	         
	  end 
	
 --COMMIT TRAN
END TRY

BEGIN CATCH



insert into ErrorLog(Spname,ErrorMessage,createddate)

		values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())


--ROLLBACK TRAN
END CATCH

SET NOCOUNT OFF

END
GO
