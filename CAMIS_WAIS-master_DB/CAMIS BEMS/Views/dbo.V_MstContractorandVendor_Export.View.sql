USE [UetrackBemsdbPreProd]
GO
/****** Object:  View [dbo].[V_MstContractorandVendor_Export]    Script Date: 20-09-2021 17:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[V_MstContractorandVendor_Export]

AS

	SELECT	DISTINCT Customer.CustomerName,

			Vendor.CustomerId,

			Vendor.SSMRegistrationCode,

			Vendor.ContractorName,



			Vendor.Active			AS	[StatusValue],

			CASE WHEN Vendor.Active=1 THEN 'Active'

				 ELSE 'Inactive' 

				 END						AS	[Status],

			--VendorSpecial.AssetClassificationDescription	AS	[SpecializationDetails],

			
				stuff((select ',' +VendorSpecial.AssetClassificationDescription from  SplitString(Vendor.SpecializationDetails,',') Specialization

					LEFT JOIN  EngAssetClassification				AS	VendorSpecial	WITH(NOLOCK)	ON Specialization.item	=	VendorSpecial.AssetClassificationId
					FOR XML PATH('')  ),1,1,'') [SpecializationDetails],



			Vendor.Address as Address1,

			Vendor.Address2 as Address2,

			Vendor.PostCode,

			Vendor.State,

			--Vendor.Country,

			LovCountry.FieldValue	AS	Country,

			Vendor.FaxNo,

			Vendor.NoOfUserAccess,

			CASE 

			     WHEN Vendor.ContactNo = '0' then ''

				 when Vendor.ContactNo is null then ''

				 else Vendor.ContactNo end 

			

			  As PhoneNumber,

			Vendor.Remarks,

			VendorInfo.Name,

		    VendorInfo.Designation,

			VendorInfo.ContactNo,

			VendorInfo.Email,

			Vendor.ModifiedDateUTC

			FROM	MstContractorandVendor							AS	Vendor			WITH(NOLOCK)

					INNER JOIN MstCustomer							AS	Customer		WITH(NOLOCK)	ON	Vendor.CustomerId	=	Customer.CustomerId

					LEFT JOIN MstContractorandVendorContactInfo		AS VendorInfo		WITH(NOLOCK)	ON	VendorInfo.ContractorId	=	Vendor.ContractorId

					--OUTER APPLY SplitString(Vendor.SpecializationDetails,',') Specialization

					--LEFT JOIN  EngAssetClassification				AS	VendorSpecial	WITH(NOLOCK)	ON Specialization.id	=	VendorSpecial.AssetClassificationId

					LEFT JOIN  FMLovMst								AS	LovCountry		WITH(NOLOCK)	ON Vendor.CountryId		=	LovCountry.LovId
GO
