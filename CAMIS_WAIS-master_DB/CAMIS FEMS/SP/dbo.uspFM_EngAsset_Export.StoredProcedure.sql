USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAsset_Export]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngAsset_Export
Description			: To export the asset details
Authors				: Dhilip V
Date				: 19-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngAsset_Export  @StrCondition='',@StrSorting=null,@pUserId=37,@pAccessLevel=308

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE [dbo].[uspFM_EngAsset_Export]

	@StrCondition	NVARCHAR(MAX) = NULL,
	@StrSorting		NVARCHAR(MAX) = NULL,
	@pUserId		INT				= NULL,
	@pAccessLevel	INT				= NULL
AS 

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;



-- Declaration
	DECLARE @countQry	NVARCHAR(MAX);
	DECLARE @qry		NVARCHAR(MAX);
	DECLARE @condition	VARCHAR(MAX);
	DECLARE @TotalRecords INT;

-- Default Values


-- Execution

/*
SET @countQry =	'SELECT @Total = COUNT(1)
				FROM [V_EngAsset_Export]
				WHERE 1 = 1 ' 
				+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' AND '+ REPLACE(ISNULL(@strCondition,''),'WHERE',' AND ')  END  

print @countQry;

EXECUTE sp_executesql @countQry, N' @Total INT OUTPUT', @Total = @TotalRecords OUTPUT
*/


IF(ISNULL(@pAccessLevel,0)=308)
	
	BEGIN
		SET @qry = 'SELECT	AssetNo
							,AssetPreRegistrationNo
							,AssetTypeCode
							,AssetTypeDescription
							,AssetClassification
							,AssetDescription
							,CommissioningDate
							,ParentAssetNo
							,ServiceStartDate
							,EffectiveDate
							,ExpectedLifespan
							,AssetStatus
							,AssetAge
							,YearsInService
							,RealTimeStatus
							,OperatingHours
							,AssetTransferMode
							,TransferToUserLocationName
							,TransferDateWithIn
							--,TransferType
							--,SNFNo
							,TransferDate
							,State
							,FacilityName
							,IfOtherSpecify
							,PreviousAssetNo
							,UserLocationCode AS LocationCode
							,UserLocationName AS LocationName
							,UserAreaCode AS AreaCode
							,UserAreaName AS AreaName
							,Model
							,Manufacturer
							,NamePlateManufacturer
							,AppliedPartType
							,EquipmentClass
							,Specification
							,SerialNumber
							,RiskRating
							,MainSupplier
							,ManufacturingDate
							,Softwarekey
							,SoftwareVersion
							,PowerSpecification
							,PowerSpecificationWatt
							,PowerSpecificationAmpere
							,Volt
							,PPM
							,[RoutineInspection(RI)Flag]
							,Calibration
							,LastScheduledWorkOrderNo
							,LastScheduledWorkOrderDate
							,[LastBrakdown/EmergencyWorkOrderNo]
							,[LastBrakdown/EmergencyWorkOrderDate]
							,[ScheduledDowntime(YTD)]
							,[UnscheduledDowntime(YTD)]
							,[TotalDowntime(YTD)]
							,DefectCount
							,PurchaseCostRM
							,PurchaseCategory
							,PurchaseDate
							,[WarrantyDuration(Month)]
							,WarrantyStartDate
							,WarrantyEndDate
							,CumulativePartCost
							,CumulativeLabourCost
							,CumulativeContractCost
							,DisposalApprovalDate
							,DisposedDate
							,DisposedBy
							,DisposeMethod
							,[AuthorizationStatus]
							,ContractType  as ContractType
							,AssetWorkingStatusValue as AssetWorkingStatus
							,StaffName as CompanyStaff
					FROM [V_EngAsset_Export]
					WHERE 1 = 1 AND' + ' UserRegistrationId = ' + cast(@pUserId as nvarchar(10))
					+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
					+ ' ' + ' ORDER BY ' +  ISNULL(@strSorting,'[V_EngAsset_Export].ModifiedDateUTC DESC')
		
		print @qry;
		EXECUTE sp_executesql @qry, N' @TotalRecords INT', @TotalRecords = @TotalRecords
	END

	ELSE

	BEGIN
		SET @qry = 'SELECT	AssetNo
							,AssetPreRegistrationNo
							,AssetTypeCode
							,AssetTypeDescription
							,AssetClassification
							,AssetDescription
							,CommissioningDate
							,ParentAssetNo
							,ServiceStartDate
							,EffectiveDate
							,ExpectedLifespan
							,AssetStatus
							,AssetAge
							,YearsInService
							,RealTimeStatus
							,OperatingHours
							,AssetTransferMode
							,TransferToUserLocationName
							,TransferDateWithIn
							--,TransferType
							--,SNFNo
							,TransferDate
							,State
							,FacilityName
							,IfOtherSpecify
							,PreviousAssetNo
							,UserLocationCode AS LocationCode
							,UserLocationName AS LocationName
							,UserAreaCode	AS AreaCode
							,UserAreaName	AS AreaName
							,Model
							,Manufacturer
							,NamePlateManufacturer
							,AppliedPartType
							,EquipmentClass
							,Specification
							,SerialNumber
							,RiskRating
							,MainSupplier
							,ManufacturingDate
							,Softwarekey
							,SoftwareVersion
							,PowerSpecification
							,PowerSpecificationWatt
							,PowerSpecificationAmpere
							,Volt
							,PPM
							,[RoutineInspection(RI)Flag]
							,Calibration
							,LastScheduledWorkOrderNo
							,LastScheduledWorkOrderDate
							,[LastBrakdown/EmergencyWorkOrderNo]
							,[LastBrakdown/EmergencyWorkOrderDate]
							,[ScheduledDowntime(YTD)]
							,[UnscheduledDowntime(YTD)]
							,[TotalDowntime(YTD)]
							,DefectCount
							,PurchaseCostRM
							,PurchaseCategory
							,PurchaseDate
							,[WarrantyDuration(Month)]
							,WarrantyStartDate
							,WarrantyEndDate
							,CumulativePartCost
							,CumulativeLabourCost
							,CumulativeContractCost
							,DisposalApprovalDate
							,DisposedDate
							,DisposedBy
							,DisposeMethod
							,[AuthorizationStatus]
							,ContractType  as ContractType
							,AssetWorkingStatusValue as AssetWorkingStatus
							,StaffName as CompanyStaff
					FROM [V_EngAsset_Export]
					WHERE 1 = 1 '
					+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
					+ ' ' + ' ORDER BY ' +  ISNULL(@strSorting,'[V_EngAsset_Export].ModifiedDateUTC DESC')
		
		print @qry;
		EXECUTE sp_executesql @qry, N' @TotalRecords INT', @TotalRecords = @TotalRecords
	END
		
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
