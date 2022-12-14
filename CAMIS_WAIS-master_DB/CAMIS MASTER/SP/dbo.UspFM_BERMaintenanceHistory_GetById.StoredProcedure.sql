USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_BERMaintenanceHistory_GetById]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_BERMaintenanceHistory_GetById
Description			: To Get the data from table EngMaintenanceWorkOrderTxn using the Primary Key id
Authors				: Balaji M S
Date				: 11-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_BERMaintenanceHistory_GetById] @pApplicationId=222
select * from BERApplicationTxn
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_BERMaintenanceHistory_GetById]                           
--  @pUserId			INT	=	NULL,
  @pApplicationId	INT

AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	declare @ContractorCost decimal(30,2)

	select @ContractorCost= isnull( sum(case when  B.ApplicationDate>=ContractEndDate then  ContractOutdet.ContractValue else
						     ( ContractOutdet.ContractValue/(datediff(dd,cast( ContractstartDate as date), cast( ContractendDate as date))+1)) *((datediff(dd,cast(ContractstartDate as date), cast(ContractendDate as date))+1)-	 datediff(dd,cast(ApplicationDate as date),cast(ContractEndDate as date)))
						   end ),0)  from  EngContractOutRegisterDet		AS ContractOutdet	
	join		BERApplicationTxn B					on ContractOutdet.AssetId = b.AssetId
	join		EngContractOutRegister  ContractOut on ContractOutdet.ContractId=ContractOut.ContractId
	where 	 ApplicationId =@pApplicationId
	and     ContractstartDate<= ApplicationDate  
	
	
	

    SELECT	BERApplication.ApplicationId						AS ApplicationId,
			BERApplication.BERno								AS BERno,
			BERApplication.ApplicationDate						AS ApplicationDate,
			MaintenanceWorkOrder.MaintenanceWorkNo				AS MaintenanceWorkNo,
			MaintenanceWorkOrder.MaintenanceWorkDateTime		AS MaintenanceWorkDateTime,
			MaintenanceWorkOrder.MaintenanceWorkCategory		AS MaintenanceWorkCategoryId,
			MaintenanceCategory.FieldValue						AS MaintenanceWorkCategory,
			--MaintenanceCategory.FieldValue						AS MaintenanceCategoryValue,
			MaintenanceWorkOrder.MaintenanceWorkType			AS MaintenanceWorkTypeId,
			MaintenanceType.FieldValue							AS MaintenanceWorkType,
		--	MaintenanceType.FieldValue							AS MaintenanceTypeValue,
			--MwoCompletionInfo.DowntimeHours					AS DowntimeHoursMin,
			
			cast(case when len(cast(cast(DowntimeHours / 60.0 as int) as nvarchar(50)))<2 then right('00'+cast(cast(DowntimeHours / 60.0 as int) as nvarchar(50)),2) 
				ELse cast(cast(DowntimeHours / 60.0 as int) as nvarchar(50)) end  +'.'+right('00'+cast(cast(DowntimeHours % 60.0 as int)as varchar(50)),2) as numeric(24,2)) as DowntimeHoursMin,

			ISNULL(SUM(PartReplacement.LabourCost),0)			AS LabourCost,
			ISNULL(SUM(PartReplacement.Cost),0)		AS SparePartCost,
			@ContractorCost										AS ContractorCost,
			ISNULL(MwoCompletionInfo.VendorCost,0)				AS VendorCost,
			ISNULL(SUM(PartReplacement.LabourCost),0) +	ISNULL(SUM(PartReplacement.Cost),0) +ISNULL(MwoCompletionInfo.VendorCost,0) as TotalCost
	FROM	BERApplicationTxn									AS BERApplication			WITH(NOLOCK)
			INNER JOIN EngMaintenanceWorkOrderTxn				AS MaintenanceWorkOrder		WITH(NOLOCK)		ON BERApplication.AssetId						= MaintenanceWorkOrder.AssetId
			left JOIN EngMwoCompletionInfoTxn					AS MwoCompletionInfo		WITH(NOLOCK)		ON MaintenanceWorkOrder.WorkOrderId				= MwoCompletionInfo.WorkOrderId
			LEFT  JOIN EngMwoPartReplacementTxn					AS PartReplacement			WITH(NOLOCK)		ON MaintenanceWorkOrder.WorkOrderId				= PartReplacement.WorkOrderId		
			left JOIN FMLovMst									AS MaintenanceCategory		WITH(NOLOCK)		ON MaintenanceWorkOrder.MaintenanceWorkCategory	= MaintenanceCategory.LovId
			left JOIN FMLovMst									AS MaintenanceType			WITH(NOLOCK)		ON MaintenanceWorkOrder.MaintenanceWorkType		= MaintenanceType.LovId

			

	WHERE	BERApplication.ApplicationId = @pApplicationId 
	and   year(MaintenanceWorkDateTime) = year(getdate())
	GROUP BY

	BERApplication.ApplicationId,		
	BERApplication.BERno		,				
	BERApplication.ApplicationDate			,	
	MaintenanceWorkOrder.MaintenanceWorkNo	,	
	MaintenanceWorkOrder.MaintenanceWorkDateTime,
	MaintenanceWorkOrder.MaintenanceWorkCategory,
	MaintenanceCategory.FieldValue				,
	MaintenanceWorkOrder.MaintenanceWorkType	,
	MaintenanceType.FieldValue					,
	MwoCompletionInfo.DowntimeHours		,
	MwoCompletionInfo.VendorCost	



END TRY

BEGIN CATCH

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   )

END CATCH
GO
