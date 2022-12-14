USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_BERApplicationTxn_BERCertificate_Rpt]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*========================================================================================================

Application Name	: UETrack-BEMS              

Version				: 1.0

Procedure Name		: [uspFM_BERApplicationTxn_BERCertificate_Rpt] 

Description			: Get the BER Certificate Printout Form 

Authors				: Ganesan S

Date				: 31-May-2018

-----------------------------------------------------------------------------------------------------------



Unit Test:

exec [uspFM_BERApplicationTxn_BERCertificate_Rpt] @app_id=88

-----------------------------------------------------------------------------------------------------------

Version History 

-----:------------:---------------------------------------------------------------------------------------

Init : Date       : Details

========================================================================================================*/









CREATE  PROCEDURE [dbo].[uspFM_BERApplicationTxn_BERCertificate_Rpt]                                  

(                                              

     @app_id            VARCHAR(100)

	  

 )           

AS                                          

BEGIN   TRY                             

SET NOCOUNT ON;

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;



Select 

Distinct

		BER1.BERno as [BER_NO],

		Format(BER1.ApplicationDate,'dd-MMM-yyyy') as ApplicationDate,

		DBO.udf_DisplayHospitalName(BER1.FacilityId) as FacilityName,

		Faci.FacilityCode as FacilityCode,

		Asset.AssetNo as [Asset_No],

		Asset.AssetDescription as [Asset_Description],

		Locn.UserLocationCode as [User_Location_Code],

		Locn.UserLocationName as [User_Location_Name],

		Asset.Manufacturer,

		Asset.Model,

		Asset.MainSupplier as [Supplier_Name],

		Asset.PurchaseCostRM as [Purchase_Cost],

		Asset.PurchaseDate as [Purchase_Date],

		BER1.EstimatedRepairCost as [Estimated_Repair_Cost],

		BER1.ValueAfterRepair as [After_Repair_Value],

		BER1.CurrentValue as [Current_Value],

		BER1.EstDurUsgAfterRepair as [Estimated_Duration_Of_Usage_After_Repair],

		--BER1.FreqDamSincPurchased as [Frequency_of_Breakdown_Since_Purchased],

		--BER1.TotalCostImprovement as [Total_Cost_on_Improvement],

		Staff.StaffName as [Requestor_Name],

		Design.Designation,

		Lov1.FieldValue as [BER2TechnicalCondition],

		BER1.BER2RepairedWell,

		Lov1.FieldValue as [BER2SafeReliable],

		Lov1.FieldValue as [BER2EstimateLifeTime],

		Case 

			When BER1.BER2Syor=1 then 'The asset can be repaired and is safe to use.'

			When BER1.BER2Syor=2 then 'The asset is beyond economical repair. However, it can be used and maintained until condemned.'

			When BER1.BER2Syor=3 then 'The asset is beyond economical repair. It must be decommissioned immediately due to safety reason and/or major breakdown.'

			When BER1.BER2Syor=4 then 'These assets are in good condition and safe to use. These assets can be transferred.'

		Else '' End as Recommendations,

		BER1.BER2Remarks as [Remarks],

		Staff1.StaffName as [Applicant_Name],

		Design1.Designation as Position

		From BERApplicationTxn Ber1 inner join  MstLocationFacility Faci on BER1.FacilityId=Faci.FacilityId

		inner join EngAsset Asset on Asset.AssetId=BER1.AssetId

		inner join MstLocationUserLocation Locn on Locn.UserLocationId=Asset.UserLocationId

		left join EngAssetStandardizationManufacturer Manu on Manu.ManufacturerId=Asset.Manufacturer

		left join EngAssetStandardizationModel Model on Model.ModelId=Asset.Model

		left join UMUserRegistration Staff on Staff.UserRegistrationId=BER1.RequestorUserId

		left join UserDesignation Design on Design.UserDesignationId=Staff.UserDesignationId

		inner join FMLovMst Lov1 on Lov1.LovId=BER1.BER2TechnicalCondition

		inner join FMLovMst Lov2 on Lov2.LovId=BER1.BER2SafeReliable

		inner join FMLovMst Lov3 on Lov3.LovId=BER1.BER2EstimateLifeTime

		left join UMUserRegistration Staff1 on Staff1.UserRegistrationId=BER1.ApplicantUserId

		left join UserDesignation Design1 on Design1.UserDesignationId=Staff1.UserDesignationId

		Where BERStatus=206 and 

		ApplicationId=@app_id





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
