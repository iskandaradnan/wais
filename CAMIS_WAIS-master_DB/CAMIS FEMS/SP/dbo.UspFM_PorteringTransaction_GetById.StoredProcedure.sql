USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_PorteringTransaction_GetById]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_PorteringTransaction_GetById
Description			: To Get the data from table PorteringTransaction using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_PorteringTransaction_GetById] @pPorteringId=351

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_PorteringTransaction_GetById]                           
 -- @pUserId				INT	=	NULL,
  @pPorteringId			INT


AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	
	DECLARE @mCustomerId INT
	DECLARE @mFacilityId INT,@mBlockId INT,@mLevelId INT
	DECLARE @mUserLocationId INT,@mUserAreaId INT

	IF(ISNULL(@pPorteringId,0) = 0) RETURN

	SELECT	Portering.PorteringId								AS PorteringId,
			Portering.FromCustomerId							AS FromCustomerId,
			FromCustomer.CustomerName							AS FromCustomerName,
			Portering.FromFacilityId							AS FromFacilityId,
			FromFacility.FacilityName							AS FromFacilityName,
			Portering.FromBlockId								AS FromBlockId,
			FromBlock.BlockName									AS FromBlockName,
			Portering.FromLevelId								AS FromLevelId,
			FromLevel.LevelName									AS FromLevelName,
			Portering.FromUserAreaId							AS FromUserAreaId,
			FromUserArea.UserAreaCode							AS FromUserAreaCode,
			FromUserArea.UserAreaName							AS FromUserAreaName,
			Portering.FromUserLocationId						AS FromUserLocationId,
			FromUserLocation.UserLocationCode					AS FromUserLocationCode,
			FromUserLocation.UserLocationName					AS FromUserLocationName,
			Portering.RequestorId								AS RequestorId,
			RequestorStaff.StaffName							AS RequestorName,
		    RequestorDesignation.Designation					AS RequestorDesignation,
		
			Portering.RequestTypeLovId							AS RequestTypeLovId,
		--	RequestTypeLov.FieldValue							AS RequestTypeLovValue,
			Portering.MovementCategory							AS MovementCategory,
			MovementCategory.FieldValue							AS MovementCategoryValue,
			Portering.ModeOfTransport							AS ModeOfTransport,
			ModeOfTransport.FieldValue							AS ModeOfTransportValue,
			Portering.ToCustomerId								AS ToCustomerId,
			ToCustomer.CustomerName								AS ToCustomerName,
			Portering.ToFacilityId								AS ToFacilityId,
			ToFacility.FacilityName								AS ToFacilityName,
			Portering.ToBlockId									AS ToBlockId,
			ToBlock.BlockName									AS ToBlockName,
			ToBlock.BlockCode									AS ToBlockCode,
			Portering.ToLevelId									AS ToLevelId,
			ToLevel.LevelName									AS ToLevelName,
			tolevel.LevelCode									AS ToLevelCode,
			Portering.ToUserAreaId								AS ToUserAreaId,
			ToUserArea.UserAreaCode								AS ToUserAreaCode,
			ToUserArea.UserAreaName								AS ToUserAreaName,
			Portering.ToUserLocationId							AS ToUserLocationId,
			ToUserLocation.UserLocationCode						AS ToUserLocationCode,
			ToUserLocation.UserLocationName						AS ToUserLocationName,
			Portering.AssignPorterId							AS AssignPorterId,
			PorterStaff.StaffName								AS AssignPorterName,
			Portering.ConsignmentNo								AS ConsignmentNo,
			Portering.PorteringStatus							AS PorteringStatus,
			PorteringStatus.FieldValue							AS PorteringStatusValue,
			Portering.ReceivedBy								AS ReceivedBy,
			ReceivedBy.StaffName								AS ReceivedByValue,
			ReceivedDesignation.Designation                     AS ReceivedByPosition,
			Portering.CurrentWorkFlowId							AS CurrentWorkFlowId,
			Portering.Remarks									AS Remarks,
			Portering.AssetId									AS AssetId,
			Asset.AssetNo										AS AssetNo,
			Portering.PorteringDate								AS PorteringDate,
			Portering.PorteringNo								AS PorteringNo,
			Portering.[Timestamp]								AS [Timestamp],
			Portering.SupplierLovId								AS SupplierLovId,
			Portering.SupplierId,
			Portering.CourierName, 
			Portering.ConsignmentDate,
			Portering.WorkOrderId,
			Portering.ScanAsset,
			Portering.WFStatusApprovedDate,
			WorkOrder.MaintenanceWorkNo,
			Portering.LoanerTestEquipmentBookingId,
	        --Asset.CompanyStaffId								as LocationInchargeId,
			Portering.GuId
	FROM	PorteringTransaction								AS Portering
			INNER JOIN	MstCustomer								AS FromCustomer				WITH(NOLOCK)	ON Portering.FromCustomerId			= FromCustomer.CustomerId
			INNER JOIN  MstLocationFacility						AS FromFacility				WITH(NOLOCK)	ON Portering.FromFacilityId			= FromFacility.FacilityId
			INNER JOIN  MstLocationBlock						AS FromBlock				WITH(NOLOCK)	ON Portering.FromBlockId			= FromBlock.BlockId
			INNER JOIN  MstLocationLevel						AS FromLevel				WITH(NOLOCK)	ON Portering.FromLevelId			= FromLevel.LevelId
			INNER JOIN  MstLocationUserArea						AS FromUserArea				WITH(NOLOCK)	ON Portering.FromUserAreaId			= FromUserArea.UserAreaId
			INNER JOIN  MstLocationUserLocation					AS FromUserLocation			WITH(NOLOCK)	ON Portering.FromUserLocationId		= FromUserLocation.UserLocationId
			LEFT  JOIN  UMUserRegistration						AS RequestorStaff			WITH(NOLOCK)	ON Portering.RequestorId			= RequestorStaff.UserRegistrationId
			LEFT  JOIN  userDesignation							AS RequestorDesignation		WITH(NOLOCK)	ON RequestorStaff.UserDesignationId	= RequestorDesignation.UserDesignationId
			--INNER JOIN  FMLovMst								AS RequestTypeLov			WITH(NOLOCK)	ON Portering.RequestTypeLovId		= RequestTypeLov.LovId
			INNER JOIN  FMLovMst								AS MovementCategory			WITH(NOLOCK)	ON Portering.MovementCategory		= MovementCategory.LovId	
			INNER JOIN  FMLovMst								AS ModeOfTransport			WITH(NOLOCK)	ON Portering.ModeOfTransport		= ModeOfTransport.LovId
			INNER JOIN	MstCustomer								AS ToCustomer				WITH(NOLOCK)	ON Portering.ToCustomerId			= ToCustomer.CustomerId
			LEFT JOIN  MstLocationFacility						AS ToFacility				WITH(NOLOCK)	ON Portering.ToFacilityId			= ToFacility.FacilityId
			LEFT JOIN  MstLocationBlock							AS ToBlock					WITH(NOLOCK)	ON Portering.ToBlockId				= ToBlock.BlockId
			LEFT JOIN  MstLocationLevel							AS ToLevel					WITH(NOLOCK)	ON Portering.ToLevelId				= ToLevel.LevelId
			LEFT JOIN  MstLocationUserArea						AS ToUserArea				WITH(NOLOCK)	ON Portering.ToUserAreaId			= ToUserArea.UserAreaId
			LEFT JOIN  MstLocationUserLocation					AS ToUserLocation			WITH(NOLOCK)	ON Portering.ToUserLocationId		= ToUserLocation.UserLocationId
			LEFT  JOIN  FMLovMst								AS PorteringStatus			WITH(NOLOCK)	ON Portering.PorteringStatus		= PorteringStatus.LovId
			LEFT  JOIN  UMUserRegistration						AS ReceivedBy				WITH(NOLOCK)	ON Portering.ReceivedBy				= ReceivedBy.UserRegistrationId
			
			LEFT  JOIN  userDesignation							AS ReceivedDesignation		WITH(NOLOCK)	ON ReceivedBy.UserDesignationId	= ReceivedDesignation.UserDesignationId
			
			LEFT  JOIN  EngAsset								AS Asset					WITH(NOLOCK)	ON Portering.AssetId				= Asset.AssetId
			LEFT  JOIN  EngMaintenanceWorkOrderTxn				AS WorkOrder				WITH(NOLOCK)	ON Portering.WorkOrderId			= WorkOrder.WorkOrderId
			LEFT  JOIN  UMUserRegistration						AS PorterStaff		     	WITH(NOLOCK)	ON Portering.AssignPorterId			= PorterStaff.UserRegistrationId
		

           --  LEFT  JOIN  UMUserRegistration						AS PorterCreated		    WITH(NOLOCK)	ON Portering.CreatedBy			    = PorterCreated.UserRegistrationId

	WHERE	Portering.PorteringId = @pPorteringId
	ORDER BY Portering.ModifiedDate desc

	

	declare @mMovementCategory Int = (select top 1  MovementCategory from PorteringTransaction where PorteringId = @pPorteringId)

    IF(@mMovementCategory = 242 )
	BEGIN
			SELECT	SupplierWarranty.SupplierWarrantyId		AS	LovId,0 IsDefault,
				   --LovCategory.FieldValue					AS	CategoryLovName,
			       --MstContractor.SSMRegistrationCode		AS	SSMRegistrationCode,
		           	MstContractor.ContractorName			AS	FieldValue
 			FROM	EngAssetSupplierWarranty				AS	SupplierWarranty	WITH(NOLOCK)
			INNER JOIN	EngAsset					AS	Asset				WITH(NOLOCK)	ON Asset.AssetId					=	SupplierWarranty.AssetId
			INNER JOIN	MstContractorandVendor		AS	MstContractor		WITH(NOLOCK)	ON SupplierWarranty.ContractorId	=	MstContractor.ContractorId
			INNER JOIN	FMLovMst					AS	LovCategory			WITH(NOLOCK)	ON SupplierWarranty.Category		=	LovCategory.LovId
	WHERE	SupplierWarranty.Category	=(select SupplierLovId from PorteringTransaction where PorteringId = @pPorteringId)	
			AND Asset.AssetId	=	(select AssetId from PorteringTransaction where PorteringId = @pPorteringId)
	END 
	ELSE 
	BEGIN
	     	SELECT	@mCustomerId	=	FromCustomerId ,
			@mFacilityId	=	ToFacilityId,
			@mBlockId		=	ToBlockId,
			@mLevelId		=	ToLevelId,
			@mUserAreaId	=	ToUserAreaId,
			@mUserLocationId = ToUserLocationId FROM PorteringTransaction where PorteringId=@pPorteringId

			SELECT * FROM (
				SELECT	FacilityId				AS	LovId, 0 IsDefault,
						FacilityName			AS	FieldValue,
						'MstLocationFacility'	AS	LovKey		
				FROM MstLocationFacility WHERE CustomerId =	@mCustomerId
			
				UNION
			
				SELECT	BlockId				AS	LovId,0 IsDefault,
						BlockName			AS	FieldValue,
						'MstLocationBlock'	AS	LovKey	
				FROM MstLocationBlock WHERE FacilityId =	@mFacilityId
			
				UNION
			
				SELECT	LevelId				AS	LovId, 0 IsDefault,
						LevelName			AS	FieldValue,
						'MstLocationLevel'	AS	LovKey	
				FROM MstLocationLevel WHERE BlockId =	@mBlockId
			
				UNION
			
				SELECT	UserAreaId				AS	LovId, 0 IsDefault,
						UserAreaName			AS	FieldValue,
						'MstLocationUserArea'	AS	LovKey		
				FROM MstLocationUserArea WHERE LevelId =	@mLevelId
			
				UNION
			
				SELECT	UserLocationId				AS	LovId, 0 IsDefault,
						UserLocationName			AS	FieldValue,
						'MstLocationUserLocation'	AS	LovKey		
				FROM MstLocationUserLocation WHERE UserAreaId =	@mUserAreaId
				) Sub ORDER BY LovKey ASC
			
	END 



	Declare @BookingId int = ( 	select LoanerTestEquipmentBookingId from  PorteringTransaction a 	where a.PorteringId= @pPorteringId)
	
	if(isnull(@BookingId, 0) <> 0 )
	begin
	        	select b.CompanyStaffId LocationInchargeId, userr.StaffName LocationInchargeName from  PorteringTransaction a 	
				inner join EngAsset b on a.assetid=b.AssetId
				left join UMUserRegistration userr  on b.CompanyStaffId =userr.UserRegistrationId
				  
				where a.PorteringId= @pPorteringId   
	end 

	






	



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
