USE [UetrackFemsdbPreProd]
GO
/****** Object:  View [dbo].[V_EngContractOutRegister]    Script Date: 20-09-2021 16:54:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[V_EngContractOutRegister]
AS
	SELECT	DISTINCT ContractOutReg.ContractId,
			ContractOutReg.CustomerId,
			Customer.CustomerName,
			ContractOutReg.FacilityId,
			Facility.FacilityName,
			ContractOutReg.ContractNo,
			ContractorandVendor.SSMRegistrationCode AS ContractorCode,
			ContractorandVendor.ContractorName,
			ContactInfo.ContactNo,
			ContractOutReg.ContractStartDate,
			ContractOutReg.ContractEndDate,
			--LovStatus.FieldValue					AS Status,
			CASE	WHEN GETDATE() > ContractOutReg.ContractEndDate THEN 'Inactive'
					ELSE 'Active'
			END										AS StatusVal,	
		--	Asset.AssetNo	,
			ContractOutReg.ModifiedDateUTC
	FROM	EngContractOutRegister							AS ContractOutReg		WITH(NOLOCK) 
			--outer apply (select top 1 AssetId from  EngContractOutRegisterDet		a  WITH(NOLOCK)			where ContractOutReg.ContractId	 = a.ContractId )		AS ContractOutRegisterDet		
			--left JOIN  EngContractOutRegisterHistory			AS ContractOutRegisterHistory	WITH(NOLOCK)	ON ContractOutReg.ContractId				= ContractOutRegisterHistory.ContractId
			--left JOIN  EngContractOutRegisterAssetHistory		AS AssetHistory					WITH(NOLOCK)	ON ContractOutRegisterHistory.ContractHistoryId	= AssetHistory.ContractHistoryId
			--outer apply (select top 1 AssetNo from 	EngAsset	a WITH(NOLOCK)	 where  ContractOutRegisterDet.AssetId			= a.AssetId )							AS Asset						
			INNER JOIN MstCustomer							AS	Customer			WITH(NOLOCK)	ON ContractOutReg.CustomerId			=	Customer.CustomerId
			INNER JOIN MstLocationFacility					AS	Facility			WITH(NOLOCK)	ON ContractOutReg.FacilityId			=	Facility.FacilityId
			INNER JOIN MstContractorandVendor				AS	ContractorandVendor	WITH(NOLOCK)	ON ContractOutReg.ContractorId			=	ContractorandVendor.ContractorId
			LEFT JOIN FMLovMst								AS	LovStatus			WITH(NOLOCK)	ON ContractOutReg.Status				=	LovStatus.LovId
			outer apply (select top 1  a.ContactNo  from MstContractorandVendorContactInfo 	a 	WITH(NOLOCK)	 where ContractorandVendor.ContractorId		=	a.ContractorId ) AS	ContactInfo
GO
