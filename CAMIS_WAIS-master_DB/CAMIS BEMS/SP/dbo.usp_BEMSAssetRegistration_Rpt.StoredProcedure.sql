USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[usp_BEMSAssetRegistration_Rpt]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Application Name	: UE-Track
Version				:
File Name			:
Procedure Name		: uspFM_CRMRequest_Rpt
Author(s) Name(s)	: Krishna S
Date				: 28/12/2018
Purpose				: SP to Check Service Request
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
EXEC usp_BEMSAssetRegistration_Rpt @Facility_Id= 1
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~         
Modification History        
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS        
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~           
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/       
CREATE PROCEDURE  [dbo].[usp_BEMSAssetRegistration_Rpt](  
			@Facility_Id		INT	= null,  
			@AssetCategory		INT	= null,  
			@AssetStatus		varchar(200)	= null,  
			@Typecode			VARCHAR(50)	= '',
			@VariationStatus	INT	= null,
			@Level				VARCHAR(100) = NULL
 )  
AS  
BEGIN  
  
SET NOCOUNT ON    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
  
BEGIN TRY
/*
EXEC usp_BEMSAssetRegistration_Rpt @Facility_Id= 1, @AssetStatus= 1, @AssetCategory = 73, @Typecode = 1057 , @VariationStatus = 125
*/

DECLARE @FacilityNameParam	NVARCHAR(512),
@AssetCategoryParam			NVARCHAR(512), 
@TypecodeParam				NVARCHAR(512),
@VariationStatusParam		NVARCHAR(512)

if(@AssetStatus = 'null')
begin 
  set @AssetStatus= null
 end 



IF(ISNULL(@Facility_Id,'') <> '')
BEGIN 
	SELECT @FacilityNameParam = FacilityName FROM MstLocationFacility where FacilityId = @Facility_Id
END

IF(ISNULL(@AssetCategory,'') <> '')
BEGIN 
	SELECT @AssetCategoryParam = FieldValue FROM FMLovMst where lovid = @AssetCategory
END

IF(ISNULL(@Typecode,'') <> '')
BEGIN 
	SELECT @TypecodeParam = AssetTypeCode FROM EngAssetTypeCode where AssetTypeCodeId = @Typecode
END

IF(ISNULL(@VariationStatus,'') <> '')
BEGIN 
	SELECT @VariationStatusParam = FieldValue FROM FMLovMst where lovid = @VariationStatus
END

SELECT 
EA.AssetId, EA.CustomerId, MC.CustomerName, MC.CustomerCode, EA.FacilityId, MLF.FacilityName,EA.AssetNo, 
AssetDescription,EA.Model AS Modelid, EASM.Model AS ModelName, EA.Manufacturer as ManufacturerId, 
MANF.Manufacturer as ManufacturerName, EA.AssetTypeCodeId, EATC.AssetTypeCode, EATC.AssetTypeDescription
, ETC.AssetCategoryLovId, ASSCAT.FieldValue AS AssetCategoryName, ETC.VariationStatus, VARS.FieldValue AS VariationStatusName
, CONT.FieldValue AS ContractTypeName, EA.ContractType, 


Realtimestat.FieldValue AS RealTimeStatus, 



 CAST(CAST((DATEDIFF(m, ETC.PurchaseDate, GETDATE())/12) AS VARCHAR) + '.' +   
    CASE WHEN DATEDIFF(m, ETC.PurchaseDate, GETDATE())%12 = 0 THEN '1'   
      ELSE cast((abs(DATEDIFF(m, ETC.PurchaseDate, GETDATE())%12))   
    AS VARCHAR) END as NUMERIC(24,1))



 AS AgeYears,
CASE WHEN EA.Active = 1 THEN 'Active' WHEN EA.Active = 2 THEN 'Inactive' END AS AssetStatus
, ISNULL(CASE WHEN @AssetStatus = 1 THEN 'Active' WHEN @AssetStatus = 2 THEN 'Inactive' END,'') AS AssetStatusParam
, ISNULL(@FacilityNameParam,'')		AS FacilityNameParam
, ISNULL(@AssetCategoryParam,'')	AS AssetCategoryParam
, ISNULL(@TypecodeParam,'')			AS TypecodeParam
, ISNULL(@VariationStatusParam,'')	AS VariationStatusParam

FROM	EngTestingandCommissioningTxn as ETC WITH (NOLOCK) 
INNER JOIN	ENGASSET AS EA WITH (NOLOCK) ON	EA.ASSETID = ETC.ASSETID
INNER JOIN	MstLocationFacility AS MLF WITH (NOLOCK) ON MLF.FACILITYID = ETC.FACILITYID
INNER JOIN	MstCustomer AS MC WITH (NOLOCK) ON MC.CUSTOMERID= ETC.CUSTOMERID
INNER JOIN	EngAssetStandardizationModel AS EASM WITH (NOLOCK) ON EASM.Modelid= EA.Model
INNER JOIN	EngAssetStandardizationManufacturer AS MANF WITH (NOLOCK) ON MANF.ManufacturerId= EA.Manufacturer
INNER JOIN	EngAssetTypeCode AS EATC WITH (NOLOCK) ON EATC.AssetTypeCodeId = EA.AssetTypeCodeId
INNER JOIN	FMLovMst AS ASSCAT WITH (NOLOCK) ON ASSCAT.lovid = ETC.AssetCategoryLovId
INNER JOIN	FMLovMst AS VARS WITH (NOLOCK) ON VARS.lovid = ETC.VariationStatus
INNER JOIN	FMLovMst AS CONT WITH (NOLOCK) ON CONT.lovid = EA.ContractType
left JOIN	FMLovMst AS Realtimestat WITH (NOLOCK) ON Realtimestat.lovid = EA.RealTimeStatusLovId
WHERE	((EA.FACILITYID = @Facility_Id) OR (@Facility_Id IS NULL) OR (@Facility_Id = ''))
AND		((EA.ASSETTYPECODEID =@Typecode) OR (@Typecode IS NULL) OR (@Typecode = ''))
AND		((ETC.VariationStatus = @VariationStatus) or (@VariationStatus is null) or (@VariationStatus = ''))
AND		((ETC.AssetCategoryLovId = @AssetCategory) OR (@AssetCategory IS NULL) OR (@AssetCategory = ''))
and		((EA.Active = @AssetStatus) OR (@AssetStatus IS NULL) OR (@AssetStatus = ''))


END TRY    
BEGIN CATCH    
    
 insert into ErrorLog(Spname,ErrorMessage,createddate)    
 values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())    
  
END CATCH    
  
SET NOCOUNT OFF    
  
END
GO
