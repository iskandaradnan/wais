USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspBEMS_EngAssetTypeCodeStandardTasks_Save]    Script Date: 20-09-2021 16:56:52 ******/
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


CREATE PROCEDURE  [dbo].[UspBEMS_EngAssetTypeCodeStandardTasks_Save]                           

( 
         @StandardTasksDetTable EngAssetTypeCodeStandardTasksType Readonly , 
         @WorkGroupId	    INT=NULL,		
         @StandardTaskId		INT=NULL,
         @AssetTypeCodeId INT=NULL,
	     @ServiceId INT=NULL,
		 @UserId INT=NULL
)           

AS                                              

BEGIN                                

SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

BEGIN 

    TRY   

	
	DECLARE @Table TABLE (ID INT)
	  IF(@StandardTaskId = 0 OR @StandardTaskId = null )

	  BEGIN
	        INSERT INTO EngAssetTypeCodeStandardTasks
	         (     		 
			
                ServiceId
               ,WorkGroupId
               ,AssetTypeCodeId
               ,CreatedBy
               ,CreatedDate
               ,CreatedDateUTC
			   ,ModifiedBy
			   ,ModifiedDate
			   ,ModifiedDateUTC
               

        )OUTPUT INSERTED.StandardTaskId INTO @Table
		values (@ServiceId,@WorkGroupId,@AssetTypeCodeId,@UserId, getdate(), getdate(),@UserId, getdate(), getdate())


		set @StandardTaskId =(	SELECT StandardTaskId FROM EngAssetTypeCodeStandardTasks WHERE StandardTaskId IN (SELECT ID FROM @Table))

		INSERT INTO EngAssetTypeCodeStandardTasksDet
	         (      
			 
                 StandardTaskId
                 ,TaskCode
                 ,TaskDescription
                 ,ModelId
                 ,PPMId
                 ,OGWI
                 ,EffectiveFrom
                 ,EffectiveFromUTC
                 ,CreatedBy
                 ,CreatedDate
                 ,CreatedDateUTC
                 
                 ,Active
                 ,Status

               

        )

	 SELECT @StandardTaskId, TaskCode, TaskDescription ,ModelId  ,PPMId
            ,OGWI, EffectiveFrom,getdate(), @UserId,
			 getdate(),  getdate(), Active, Status
			 
	from @StandardTasksDetTable
	




    SELECT StandardTaskId, Timestamp FROM EngAssetTypeCodeStandardTasks WHERE StandardTaskId IN (SELECT ID FROM @Table)


	 

	  END

	ELSE

	 BEGIN


	   update EngAssetTypeCodeStandardTasks set

	     
               WorkGroupId=@WorkGroupId

               ,ModifiedBy=@UserId
               ,ModifiedDate=getdate()
               ,ModifiedDateUTC=GETDATE()
			   where StandardTaskId= @StandardTaskId



	 
	   INSERT INTO EngAssetTypeCodeStandardTasksHistoryDet
	         (     
                  StandardTaskDetId
                 ,StandardTaskId
                 ,Status
                 ,EffectiveFrom
                 ,EffectiveFromUTC
                 ,CreatedBy
                 ,CreatedDate
                 ,CreatedDateUTC
                 ,ModifiedBy
                 ,ModifiedDate
                 ,ModifiedDateUTC

        )

		select a.StandardTaskDetId, a.StandardTaskId, a.Status, a.EffectiveFrom,a.EffectiveFromUTC, a.CreatedBy,a.CreatedDate,
		a.CreatedDateUTC, a.ModifiedBy,a.ModifiedDate, a.ModifiedDateUTC from EngAssetTypeCodeStandardTasksDet a 
		inner join @StandardTasksDetTable b on a.StandardTaskDetId = b.StandardTaskDetId   
		where a.Status <> b.Status


      Update A set 

A.TaskDescription = b.TaskDescription
,A.ModelId=b.ModelId
,A.PPMId=b.PPMId
,A.OGWI=b.OGWI
,A.EffectiveFrom= b.EffectiveFrom
,A.EffectiveFromUTC= getdate()
,A.ModifiedBy=@UserId
,A.ModifiedDate=GETDATE()
,A.ModifiedDateUTC=getdate()

,A.Active=b.Active
,A.Status=b.Status
	  from EngAssetTypeCodeStandardTasksDet a 
   inner join @StandardTasksDetTable b on a.StandardTaskDetId	 = b.StandardTaskDetId
   where a.StandardTaskId=   @StandardTaskId and ISNULL(a.StandardTaskDetId,0)>0

 --  INSERT INTO EngAssetTypeCodeStandardTasksDet
	--         (      
			 
 --                StandardTaskId
 --                ,TaskCode
 --                ,TaskDescription
 --                ,ModelId
 --                ,PPMId
 --                ,OGWI
 --                ,EffectiveFrom
 --                ,EffectiveFromUTC
 --                ,CreatedBy
 --                ,CreatedDate
 --                ,CreatedDateUTC
                 
 --                ,Active
 --                ,Status

               

 --       )

	-- SELECT @StandardTaskId, TaskCode, TaskDescription ,ModelId  ,PPMId
 --           ,OGWI, EffectiveFrom,getdate(), @UserId,
	--		 getdate(),  getdate(), Active, Status
			 
	--from @StandardTasksDetTable
	-- where ISNULL(StandardTaskDetId,0)=0


	  




SELECT StandardTaskId, Timestamp FROM EngAssetTypeCodeStandardTasks WHERE StandardTaskId =@StandardTaskId
		
      END

END TRY

BEGIN CATCH



insert into ErrorLog(Spname,ErrorMessage,createddate)

		values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())



END CATCH

SET NOCOUNT OFF

END
GO
