USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspBEMS_EngAssetClassification_Save]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~            

Application Name	: UETrack              
Version				:               
File Name			:              
Procedure Name		: UspBEMS_EngAssetClassification_Save
Author(s) Name(s)	: Praveen N
Date				: 09-03-2018
Purpose				: SP to Save and Update Customer Details
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
EXEC UspBEMS_EngAssetClassification_Save @AssetClassificationId = 0,  @AssetClassification='Classify',@AssetClassificationCode=null,@ServiceId=2,@Active=1,
@Remarks='',@UserId=1
SELECT * FROM EngAssetClassification
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    

Modification History    
Modified from usp_CustomerMst_Save to usp_CustomerMst_Save  By Pravin
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/    			          

CREATE PROCEDURE  [dbo].[UspBEMS_EngAssetClassification_Save]                           

( 

		@AssetClassificationId		  INT=NULL, 
		@AssetClassification		  NVARCHAR(150)=null,
		@AssetClassificationCode	  NVARCHAR(150)=null,		
		@ServiceId                    INT=null,
		@Active					       bit,
		@Remarks	                  NVARCHAR(1200)=NULL,       
        @UserId			            INT=null,
		@Servicename				NVARCHAR(150)=null
)
	 

AS                                              

BEGIN                                

SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

BEGIN TRY   
	

	DECLARE @Table TABLE (ID INT)

	DECLARE @ContractorIdOut INT
	  IF(@AssetClassificationId = 0 or @AssetClassificationId is null)

	  BEGIN

	DECLARE @pOutParam NVARCHAR(50),@mMonth INT,@mYear INT, @mPrimaryId INT
	SET @mMonth	=	MONTH(GETDATE())
	SET @mYear	=	YEAR(GETDATE())

	EXEC [uspFM_GenerateDocumentNumber] @pFlag='EngAssetClassification',@pCustomerId=null,@pFacilityId=null,@Defaultkey=@Servicename,@pModuleName=@Servicename,@pMonth=@mMonth,@pYear=@mYear,@pOutParam=@pOutParam OUTPUT
	SELECT @AssetClassificationCode=@pOutParam

	        INSERT INTO EngAssetClassification(		          
            ServiceId
           ,AssetClassificationCode
           ,AssetClassificationDescription
           ,Remarks
           ,CreatedBy
           ,CreatedDate
           ,CreatedDateUTC
           ,Active
		   ,ModifiedBy
		   ,ModifiedDate
		   ,ModifiedDateUTC

			)OUTPUT INSERTED.AssetClassificationId INTO @Table

		    VALUES  (@ServiceId,@AssetClassificationCode, @AssetClassification,@Remarks, @UserId,
			         
			         getdate(),getdate(), @Active ,@UserId,
			         
			         getdate(),getdate())

	

    		SELECT AssetClassificationId, [Timestamp] FROM EngAssetClassification WHERE AssetClassificationId IN (SELECT ID FROM @Table)

	

	  END
	  else
	  begin

	      update EngAssetClassification set 
		  
           
          
             Remarks=@Remarks
            ,ModifiedBy=@UserId
            ,ModifiedDate=GETDATE()
            ,ModifiedDateUTC=GETDATE(),
			Active=@Active
			where AssetClassificationId=@AssetClassificationId

			SELECT AssetClassificationId, [Timestamp] FROM EngAssetClassification WHERE AssetClassificationId =@AssetClassificationId
	         
	  end 
	

END TRY

BEGIN CATCH



insert into ErrorLog(Spname,ErrorMessage,createddate)

		values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate());
	THROW;



END CATCH

SET NOCOUNT OFF

END
GO
