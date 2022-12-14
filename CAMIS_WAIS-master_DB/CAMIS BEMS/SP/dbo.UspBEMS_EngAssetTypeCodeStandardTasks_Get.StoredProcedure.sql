USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspBEMS_EngAssetTypeCodeStandardTasks_Get]    Script Date: 20-09-2021 17:05:50 ******/
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
	          

CREATE PROCEDURE  [dbo].[UspBEMS_EngAssetTypeCodeStandardTasks_Get]                           
( 
		@Id			        INT 
		  
)           
AS                                              
BEGIN                                
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @mAssetTypeCodeId INT

BEGIN TRY

    SELECT       StandardTask.StandardTaskId,
                 StandardTask.ServiceId 
				,Service.ServiceKey ServiceName
                ,StandardTask.WorkGroupId
				,WorkGroup.WorkGroupDescription	AS WorkGroupName
				,StandardTask.AssetTypeCodeId
			    ,TypeCode.AssetTypeCode
				,TypeCode.AssetTypeDescription
                ,StandardTask.Timestamp
               , StandardTask.Active
   FROM EngAssetTypeCodeStandardTasks StandardTask 
   INNER JOIN MstService Service on StandardTask.ServiceId= Service.ServiceId 
   INNER JOIN EngAssetTypeCode AS	TypeCode on StandardTask.AssetTypeCodeId= TypeCode.AssetTypeCodeId
   INNER JOIN EngAssetWorkGroup	AS	WorkGroup ON	StandardTask.WorkGroupId	=	WorkGroup.WorkGroupId 
   WHERE StandardTask.StandardTaskId=@Id and StandardTask.Active = 1

 SET @mAssetTypeCodeId = (SELECT  AssetTypeCodeId FROM EngAssetTypeCodeStandardTasks WHERE StandardTaskId=@Id )

	SELECT	a.StandardTaskId
			,det.StandardTaskDetId
			,det.TaskCode
			,det.TaskDescription
			,det.ModelId
			,StdModel.Model	AS Model
			,Service.ServiceKey	AS ServiceName
			, a.ServiceId
			,OGWI
			,det.PPMId
			,det.EffectiveFrom
			,det.EffectiveFromUTC
			,det.Active
			,det.Status
			,PPMRegister.PPMChecklistNo
			,PpmHistory.DocumentId
			,PpmHistory.DocumentTitle
			,PpmHistory.FileName
	FROM	EngAssetTypeCodeStandardTasks A 
			INNER JOIN EngAssetTypeCodeStandardTasksDet det on a.StandardTaskId= det.StandardTaskId
			INNER JOIN EngAssetStandardizationModel	AS	StdModel ON det.ModelId	=	StdModel.ModelId
			INNER JOIN MstService	AS	Service ON A.ServiceId	=	Service.ServiceId
			INNER JOIN EngPPMRegisterMst AS PPMRegister ON det.PPMId	=	PPMRegister.PPMId
			OUTER APPLY (SELECT	TOP 1 His.DocumentId,FMDoc.FileName,FMDoc.DocumentTitle
			FROM	EngPPMRegisterHistoryMst AS His 
					INNER JOIN FMDocument AS FMDoc ON His.DocumentId=FMDoc.DocumentId
			WHERE PPMId	=	PPMRegister.PPMId 
			ORDER BY His.ModifiedDate DESC) PpmHistory
	WHERE	DET.StandardTaskId	= @Id and det.Active=1



	--UNION	
	--SELECT	ISNULL(det.StandardTaskId,0) AS StandardTaskId
	--		,ISNULL(det.StandardTaskDetId,0) AS StandardTaskDetId
	--		,a.BemsTaskCode
	--		,det.TaskDescription
	--		,a.ModelId
	--		,StdModel.Model	AS Model
	--		,Service.ServiceKey	AS ServiceName
	--		, a.ServiceId
	--		,OGWI
	--		,a.PPMId
	--		,det.EffectiveFrom
	--		,det.EffectiveFromUTC
	--	--	,det.Active
	--	    ,A.Active
	--		,isnull(det.Status,1)Status
	--		,a.PPMChecklistNo
	--FROM	EngPPMRegisterMst A  
	--		INNER JOIN MstService	AS	Service ON A.ServiceId	=	Service.ServiceId 
	--		LEFT  JOIN EngAssetTypeCodeStandardTasksDet det on a.PPMId= det.PPMId   AND DET.StandardTaskId=@Id
	--		LEFT JOIN EngAssetStandardizationModel	AS	StdModel ON a.ModelId	=	StdModel.ModelId
	--WHERE	det.PPMId IS NULL AND A.Active=1 AND
	-- A.AssetTypeCodeId = @mAssetTypeCodeId
	  
END TRY
BEGIN CATCH

insert into ErrorLog(Spname,ErrorMessage,createddate)
		values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())

END CATCH
SET NOCOUNT OFF
END
GO
