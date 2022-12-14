USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspBEMS_EngAssetTypeCodeStandardTasks_GetHistory]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~              
Application Name	: ASIS              
Version				:               
File Name			:              
Procedure Name		: UspBEMS_EngAssetTypeCodeStandardTasks_Get
Author(s) Name(s)	: Praveen N
Date				: 27-02-2017
Purpose				: SP to Get Customer details
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
  
EXEC [UspBEMS_EngAssetTypeCodeStandardTasks_Get] @Id=16
EXEC uspFM_EngAssetTypeCodeStandardTasksDet_GetByAssetTypeCodeId  @pAssetTypeCodeId=4

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   
Request Type: 973,974,975,976,977,978,979,980,983 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
Modification History    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/    			          
	          

CREATE PROCEDURE  [dbo].[UspBEMS_EngAssetTypeCodeStandardTasks_GetHistory]                           
( 
		@pStandardTaskId			        INT 
		  
)           
AS                                              
BEGIN                                
SET NOCOUNT ON 
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @mAssetTypeCodeId INT

BEGIN TRY


	SELECT	 a.StandardTaskId
			,hist.StandardTaskDetId
			,det.TaskCode
			,det.TaskDescription
			
			,hist.EffectiveFrom
			,hist.EffectiveFromUTC
			,det.Active
			,hist.Status
			, (case when hist.Status = 1 then 'Active' else 'Inactive' end )StatusName
		
	FROM	EngAssetTypeCodeStandardTasks A 
			INNER JOIN EngAssetTypeCodeStandardTasksDet det on a.StandardTaskId= det.StandardTaskId
			INNER JOIN EngAssetTypeCodeStandardTasksHistoryDet hist on det.StandardTaskDetId= hist.StandardTaskDetId

		
		
	WHERE	A.StandardTaskId	= @pStandardTaskId -- and det.Active=1
	
END TRY
BEGIN CATCH

insert into ErrorLog(Spname,ErrorMessage,createddate)
		values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())

END CATCH
SET NOCOUNT OFF
END
GO
