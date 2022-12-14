USE [UetrackBemsdbPreProd]
GO
/****** Object:  View [dbo].[V_EngContractOutRegister_Export]    Script Date: 20-09-2021 17:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[V_EngContractOutRegister_Export]
AS
	SELECT	ContractOutReg.CustomerId,
			Customer.CustomerName,
			ContractOutReg.FacilityId,
			Facility.FacilityCode,
			Facility.FacilityName,
			Service.ServiceKey,
			ContractOutReg.ContractNo,
			ContractorandVendor.SSMRegistrationCode AS ContractorCode,
			ContractorandVendor.ContractorName,
			Cast(ContractOutReg.ContractStartDate as date) 	AS	ContractStartDate,
			cast(ContractOutReg.ContractEndDate as date) 	AS	ContractEndDate,
			ContactInfo.Name as ResponsiblePerson,
			ContractOutReg.AResponsiblePerson as AlternateResponsiblePerson,
			ContactInfo.Designation as ResponsibleDesignation,
			ContractOutReg.APersonDesignation as AlternatePersonDesignation,
			ContactInfo.ContactNo,
			ContractorandVendor.FaxNo,
			ContactInfo.Email,
			(SELECT SUM(Z.ContractValue) FROM EngContractOutRegisterDet Z WHERE Z.ContractId = ContractOutReg.ContractId) AS ContractSum,
			--LovStatus.FieldValue							AS Status,
			CASE	WHEN GETDATE() > ContractEndDate THEN 'Inactive'
					ELSE 'Active'
			END										AS StatusVal,
			NotificationForInspection,
			ContractOutReg.ScopeofWork,
			ContractOutReg.Remarks,
			Asset.AssetNo,
			TypeCode.AssetTypeDescription,
			ContractType.FieldValue as ContractType,
			ContractOutRegDet.ContractValue,
			ContractOutReg.ModifiedDateUTC
	FROM	EngContractOutRegister						AS	ContractOutReg		WITH(NOLOCK) 
			INNER JOIN EngContractOutRegisterDet		AS	ContractOutRegDet	WITH(NOLOCK)	ON ContractOutReg.ContractId		=	ContractOutRegDet.ContractId
			INNER JOIN MstService						AS	Service				WITH(NOLOCK)	ON ContractOutReg.ServiceId			=	Service.ServiceId
			INNER JOIN MstCustomer						AS	Customer			WITH(NOLOCK)	ON ContractOutReg.CustomerId		=	Customer.CustomerId
			INNER JOIN MstLocationFacility				AS	Facility			WITH(NOLOCK)	ON ContractOutReg.FacilityId		=	Facility.FacilityId
			INNER JOIN MstContractorandVendor			AS	ContractorandVendor	WITH(NOLOCK)	ON ContractOutReg.ContractorId		=	ContractorandVendor.ContractorId
			LEFT JOIN FMLovMst							AS	LovStatus			WITH(NOLOCK)	ON ContractOutReg.Status			=	LovStatus.LovId
			LEFT JOIN EngAsset							AS	Asset				WITH(NOLOCK)	ON ContractOutRegDet.AssetId		=	Asset.AssetId
			LEFT JOIN EngAssetTypeCode					AS	TypeCode			WITH(NOLOCK)	ON Asset.AssetTypeCodeId			=	TypeCode.AssetTypeCodeId
			LEFT JOIN FMLovMst							AS	ContractType		WITH(NOLOCK)	ON ContractOutRegDet.ContractType	=	ContractType.LovId
			OUTER APPLY (SELECT TOP 1 ContractorId,ContactNo,Name,Designation,Email FROM MstContractorandVendorContactInfo dET WHERE ContractorandVendor.ContractorId=dET.ContractorId) AS ContactInfo
GO
