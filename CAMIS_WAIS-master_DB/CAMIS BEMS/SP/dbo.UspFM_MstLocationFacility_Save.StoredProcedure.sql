USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_MstLocationFacility_Save]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~              

Application Name	: UETrack              

Version				:               

File Name			:              

Procedure Name		: UspFM_MstLocationFacility_Save

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


CREATE PROCEDURE  [dbo].[UspFM_MstLocationFacility_Save]                           

( 

      @FacilityId       INT=NULL, 
	  @CustomerId       INT=NULL, 
	  @FacilityName     NVARCHAR(200)=null,
	  @FacilityCode     NVARCHAR(100)=null,
	  @Address			NVARCHAR(1500)=null,
	  @Latitude			NuMERIC(14,8)=null,
	  @Longitude		NuMERIC(14,8)=null,
	  @ActiveFrom		DATETIME=null, 
	  @ActiveFromUTC	DATETIME=null, 
	  @ActiveTo			DATETIME=null, 
	  @ActiveToUTC		DATETIME=null, 
	  @UserID			INT=null  ,
	  @Address2				    NVARCHAR(1010)=null,
      @Postcode				    NVARCHAR(10)=null,
      @State				        NVARCHAR(200)=null,
      @Country				    NVARCHAR(200)=null,
      @ContractPeriodInMonths      NuMERIC(10,2)=null,
      @pInitialProjectCost        NuMERIC(24,2)=null, 
	  @WeeklyHoliday            VARCHAR(100)=null,
	  @MonthlyServiceFee       NuMERIC(10,2)=null, 
	  @TypeOfNomenclature			 INT=NULL,
	  @pLogo						VARBINARY(max) = null,
	  @pFacilityImage				VARBINARY(max) = null,
	  @pContactNo				    NVARCHAR(200)=null,
	  @pFaxNo				        NVARCHAR(200)=null,
	  @pWarrantyRenewalNoticeDays	int	= null,
	  @ContactInfoUDT		AS	[dbo].[udt_MstLocationFacilityContactInfo] READONLY		
	  
)           

AS                                              

BEGIN                                

SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

BEGIN 

   TRY   

	
	DECLARE @Table TABLE (ID INT)
	  IF(@FacilityId = 0 OR @FacilityId = null )

	  BEGIN

	DECLARE @pOutParam NVARCHAR(50),@mMonth INT,@mYear INT, @mPrimaryId INT
	SET @mMonth	=	MONTH(GETDATE())
	SET @mYear	=	YEAR(GETDATE())

	EXEC [uspFM_GenerateDocumentNumber] @pFlag='MstLocationFacility',@pCustomerId=null,@pFacilityId=null,@Defaultkey='FAC',@pModuleName='BEMS',@pMonth=@mMonth,@pYear=@mYear,@pOutParam=@pOutParam OUTPUT
	--SELECT @FacilityCode=@pOutParam

	        INSERT INTO [MstLocationFacility](
			                     CustomerId
                                 ,FacilityName
                                 ,FacilityCode
                                 ,Address
                                 ,Latitude
                                 ,Longitude
                                 
                                 ,ActiveFrom
                                 ,ActiveFromUTC
                                 ,ActiveTo
                                 ,ActiveToUTC
                                 
                                 ,CreatedBy
                                 ,CreatedDate
                                 ,CreatedDateUTC
								 ,ModifiedBy
								 ,ModifiedDate
								 ,ModifiedDateUTC
								 ,WeeklyHoliday
								 ,Address2
                                 ,Postcode
                                 ,State
                                 ,Country
                                 ,ContractPeriodInMonths
                                 ,InitialProjectCost
                                 ,MonthlyServiceFee
								 ,TypeOfNomenclature
								-- ,LifeExpectancy
								 ,Logo
								 ,FacilityImage
								 ,ContactNo
								 ,FaxNo
								 ,WarrantyRenewalNoticeDays
						)OUTPUT INSERTED.FacilityId INTO @Table

		          VALUES  (   
				                 @CustomerId, 
				                 @FacilityName,
								 @FacilityCode,
								 --(SELECT 'Facility' +  ISNULL(CAST(MAX(RIGHT(FacilityCode,3)) + 1 AS NVARCHAR(50)),1000) FROM [MstLocationFacility]) ,
								  @Address,
								  @Longitude,
								  @Latitude
								   
				                 ,@ActiveFrom,@ActiveFrom,@ActiveTo, @ActiveTo,@UserID,getdate(),getdate() ,@UserID,getdate(),getdate()
								 ,@WeeklyHoliday
								 ,@Address2
							     ,@Postcode
						         ,@State
						         ,@Country
						         ,@ContractPeriodInMonths
						         ,@pInitialProjectCost
								 ,@MonthlyServiceFee
								 ,@TypeOfNomenclature
								-- ,@LifeExpectancy
								 ,@pLogo
								 ,@pFacilityImage
								 ,@pContactNo
						         ,@pFaxNo
								 ,@pWarrantyRenewalNoticeDays)
        Declare  @mFacilityId int  = (SELECT	FacilityId	FROM	MstLocationFacility WHERE	FacilityId IN (SELECT ID FROM @Table))

		declare @mUserRoleId int

		select @mUserRoleId=UMUserRoleId  from umuserrole where usertypeid=5   --superuser

		insert into UMUserLocationMstDet (CustomerId,FacilityId,UserRegistrationId,UserRoleId,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC,Active,BuiltIn)
		select @CustomerId,@mFacilityId,UserRegistrationId,@mUserRoleId,@UserID,getdate(),getutcdate() ,@UserID,getdate(),getutcdate(),1,1
		from UMUserRegistration   where usertypeid=5  
		and @mFacilityId is not null
		

	
	             INSERT INTO MstLocationFacilityContactInfo
						(	
							
                         --  FacilityContactInfoId
                            CustomerId
                           ,FacilityId
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
								
							CustomerId,
						    @mFacilityId,
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
							
			FROM	@ContactInfoUDT
			WHERE   ISNULL(FacilityContactInfoId,0)=0 and Active=1
    	
		SELECT FacilityId, [Timestamp],GuId FROM [MstLocationFacility] WHERE FacilityId IN (SELECT ID FROM @Table)
	 

	  END

	ELSE

	  BEGIN

	   IF EXISTS(SELECT 1 FROM @ContactInfoUDT WHERE Active =0)
			BEGIN
				DELETE FROM MstLocationFacilityContactInfo WHERE FacilityContactInfoId IN (SELECT distinct FacilityContactInfoId FROM @ContactInfoUDT 
			WHERE Active =0 AND FacilityContactInfoId>0)
	 END



	  DECLARE	   @mTypeofContract NVARCHAR(1000)
	  DECLARE      @mLastUpdatedBy NVARCHAR(1000)
		  --SET		   @mTypeofContract = (SELECT a.FieldValue FROM FMLovMst  A INNER JOIN MstLocationFacility B on A.LovId = B.TypeOfContractLovId  WHERE B.FacilityId = @FacilityId)
	  SET		   @mLastUpdatedBy = (SELECT a.StaffName FROM UMUserRegistration  A INNER JOIN MstLocationFacility B on A.UserRegistrationId = B.ModifiedBy WHERE B.FacilityId =@FacilityId )	
	  insert into [FmHistory](TableName,TableGuid,TableRowData,ModifiedDate,ModifiedUTCDate)
	  select 'MstLocationFacility',GuId,(SELECT Facility.Address,isnull(Facility.Address2,'') as Address2,Facility.Postcode,Facility.State,Facility.Country,Facility.Latitude,Facility.Longitude,
	  Facility.ActiveFrom,Facility.ActiveTo,Facility.ContractPeriodInMonths,Facility.MonthlyServiceFee AS [CurrentMonthlyServiceFee(RM)],@mLastUpdatedBy as LastUpdatedBy,Facility.ModifiedDate as LastUpdateOn
	  FROM MstLocationFacility Facility
	  where Facility.FacilityId =@FacilityId
	  FOR JSON AUTO),GETDATE(),GETUTCDATE() from MstLocationFacility Facility1 where FacilityId =@FacilityId
	  	and Not ( isnull(Facility1.Address,'') = isnull(@Address,'') 
					and isnull(Facility1.Address2,'')=isnull(@Address2,'')
					and isnull(Facility1.Postcode,'')=isnull(@Postcode,'')
					and isnull(Facility1.State,'')=isnull(@State,'')
					and isnull(Facility1.Country,'')=isnull(@Country,'')
					and isnull(Facility1.Latitude,'')=isnull(@Latitude,'')
					and isnull(Facility1.Longitude,'')=isnull(@Longitude,'')
						and isnull(Facility1.ContractPeriodInMonths,'')=isnull(@ContractPeriodInMonths,'')
					 )



	     declare @ContractValueChanged int = (select count(1) from MstLocationFacility where FacilityId= @FacilityId and ContractPeriodInMonths = @ContractPeriodInMonths)

	       UPDATE [MstLocationFacility] 

		   SET

		      Address=@Address,
			  Latitude=@Latitude
			 ,Longitude=@Longitude
			 ,ActiveFrom= @ActiveFrom
			 ,ActiveTo=@ActiveTo
			 ,ModifiedBy=@UserID
			 ,ModifiedDate=getdate()
			 ,ModifiedDateUTC=GETDATE()
			 ,Address2=@Address2
             ,Postcode=@Postcode
             ,State=@State
             ,Country=@Country
             ,ContractPeriodInMonths=@ContractPeriodInMonths
             ,MonthlyServiceFee=@MonthlyServiceFee
             ,InitialProjectCost=@pInitialProjectCost
			 ,TypeOfNomenclature=@TypeOfNomenclature
			,WeeklyHoliday=@WeeklyHoliday
			,Logo=@pLogo
			,FacilityImage=@pFacilityImage
			,ContactNo=@pContactNo
			,FaxNo=@pFaxNo
			,WarrantyRenewalNoticeDays = @pWarrantyRenewalNoticeDays
			
		WHERE 

		     FacilityId= @FacilityId


			 if(@ContractValueChanged = 0 )
			 begin
			    
	            UPDATE [MstLocationFacility]  SET IsContractPeriodChanged = 1 where  FacilityId= @FacilityId
			 end 
			 else
			 begin
			 UPDATE [MstLocationFacility]  SET IsContractPeriodChanged = 0 where  FacilityId= @FacilityId
			 end 



			 	UPDATE CONTACTINFO SET
			     
                   
                    Name              = contactUdt.Name
                   ,Designation       = contactUdt.Designation
                   ,ContactNo		  =	contactUdt.ContactNo
                   ,Email             = contactUdt.Email  
                   ,ModifiedBy		  =	@Userid
                   ,ModifiedDate	  =	GETDATE()
                   ,ModifiedDateUTC	  =	GETDATE()
      
        
               FROM MstLocationFacilityContactInfo CONTACTINFO
			   INNER JOIN @ContactInfoUDT AS contactUdt on CONTACTINFO.FacilityContactInfoId=contactUdt.FacilityContactInfoId
			   WHERE	ISNULL(contactUdt.FacilityContactInfoId,0)>0 AND contactUdt.Active=1


			    INSERT INTO MstLocationFacilityContactInfo
						(	
							
                         --  FacilityContactInfoId
                            CustomerId
                           ,FacilityId
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
								
							CustomerId,
						    @FacilityId,
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
							
			FROM	@ContactInfoUDT
			WHERE   ISNULL(FacilityContactInfoId,0)=0 and Active=1

			 SELECT FacilityId, [Timestamp],GuId FROM [MstLocationFacility] WHERE FacilityId =@FacilityId
      END

   


  

END TRY

BEGIN CATCH



insert into ErrorLog(Spname,ErrorMessage,createddate)

		values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())



END CATCH

SET NOCOUNT OFF

END
GO
