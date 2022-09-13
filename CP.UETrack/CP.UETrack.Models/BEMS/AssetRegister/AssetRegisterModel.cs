using CP.UETrack.Models;
using System;
using System.Collections.Generic;

namespace CP.UETrack.Model.BEMS.AssetRegister
{
    public class AssetRegisterModel
    {
        public string HiddenId { get; set; }
        public int AssetId { get; set; }
        public int NotificationId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int ServiceId { get; set; }
        public string AssetNo { get; set; }
        public int? TestingandCommissioningDetId { get; set; }
        public string AssetPreRegistrationNo { get; set; }
        public int AssetTypeCodeId { get; set; }
        public string AssetTypeCode { get; set; }
        public string AssetTypeDescription { get; set; }
        public int? AssetClassification { get; set; }
        public string AssetClassificationName { get; set; }
        public string AssetDescription { get; set; }
        public int WorkGroupId { get; set; }
        public DateTime CommissioningDate { get; set; }
        public int? AssetParentId { get; set; }
        public string ParentAssetNo { get; set; }
        public DateTime ServiceStartDate { get; set; }
        public DateTime? EffectiveDate { get; set; }
        public int? ExpectedLifespan { get; set; }
        public int? RealTimeStatusLovId { get; set; }
        public int? AssetStatusLovId { get; set; }
        public decimal? AssetAge { get; set; }
        public decimal? YearsInService { get; set; }
        public decimal? OperatingHours { get; set; }

        public int? TransferModeLovId { get; set; }
        public string TransferUserLocation { get; set; }
        public DateTime? TransferDate { get; set; }
        public int? OtherTransferTypeLovId { get; set; }
        public DateTime? OtherTransferDate { get; set; }
        public int? OtherFacilityId { get; set; }
        public string OtherSpecify { get; set; }
        public string OtherPreviousAssetNo { get; set; }

        public int UserLocationId { get; set; }
        public int UserAreaId { get; set; }
        public string UserLocationCode { get; set; }
        public string UserLocationName { get; set; }
        public string CurrentAreaCode { get; set; }
        public string CurrentAreaName { get; set; }
        public string UserAreaCode { get; set; }
        public string UserAreaName { get; set; }
        public int Manufacturer { get; set; }
        public string ManufacturerName { get; set; }
        public string CurrentLocationName { get; set; }
        public string NamePlateManufacturer { get; set; }
        public int Model { get; set; }
        public string ModelName { get; set; }
        public int AppliedPartTypeLovId { get; set; }
        public string AppliedPartTypeName { get; set; }
        public int? EquipmentClassLovId { get; set; }
        public int? Specification { get; set; }
        public string SerialNo { get; set; }
        public string MainSupplier { get; set; }
        public DateTime? ManufacturingDate { get; set; }
        public int? PowerSpecification { get; set; }
        public decimal? PowerSpecificationWatt { get; set; }
        public decimal? PowerSpecificationAmpere { get; set; }
        public decimal? Volt { get; set; }
        public int PpmPlannerId { get; set; }
        public int RiPlannerId { get; set; }
        public int OtherPlannerId { get; set; }
        public string ChassisNo { get; set; }
        public string EngineNo { get; set; }

        public string LastSchduledWorkOrderNo { get; set; }
        public DateTime? LastSchduledWorkOrderDateTime { get; set; }
        public decimal? SchduledDowntimeHoursMin { get; set; }
        public decimal? SchduledTotDowntimeHoursMinYTD { get; set; }
        public string LastUnSchduledWorkOrderNo { get; set; }
        public DateTime? LastUnSchduledWorkOrderDateTime { get; set; }
        public decimal? UnSchduledDowntimeHoursMin { get; set; }
        //public decimal? UnSchduledTotDowntimeHoursMinYTD { get; set; }
        public int? DefectList { get; set; }

        public decimal? PurchaseCostRM { get; set; }
        public DateTime? PurchaseDate { get; set; }
        public int? PurchaseCategory { get; set; }
        public decimal? WarrantyDuration { get; set; }
        public DateTime? WarrantyStartDate { get; set; }
        public DateTime? WarrantyEndDate { get; set; }
        public decimal? CumulativePartCost { get; set; }
        public decimal? CumulativeLabourCost { get; set; }
        public decimal? CumulativeContractCost { get; set; }

        public DateTime? DisposalApprovalDate { get; set; }
        public DateTime? DisposedDate { get; set; }
        public string DisposedBy { get; set; }
        public string DisposeMethod { get; set; }

        public string QRCode { get; set; }
        public string Timestamp { get; set; }
        public bool? IsLoaner { get; set; }
        public int? TypeOfAsset { get; set; }
        public List<LovValue> AssetSpecifications { get; set; }
        public List<SoftwareDetails> SoftwareDetails { get; set; }

        public int? RiskRating { get; set; }
        public string TransferFacilityName { get; set; }
        public string TransferRemarks { get; set; }
        public string PreviousAssetNo { get; set; }
        public string PurchaseOrderNo { get; set; }
        public int InstalledLocationId { get; set; }
        public string InstalledLocationCode { get; set; }
        public string InstalledLocationName { get; set; }
        public string SoftwareVersion { get; set; }
        public string SoftwareKey { get; set; }
        public string LevelName { get; set; }
        public string LevelCode { get; set; }
        public string BlockName { get; set; }
        public string BlockCode { get; set; }
        public int? TransferMode { get; set; }
        public decimal? MainsFuseRating { get; set; }
        public decimal? CalculatedFeeDW { get; set; }
        public decimal? CalculatedFeePW { get; set; }
        public decimal? TotalWarrantyDownTime { get; set; }
        public string AuthorizationName { get; set; }
        public string AssetWorkingStatusValue { get; set; }
        public int Authorization { get; set; }
        public string AuthorizationStatus { get; set; }
        public string ErrorMessage { get; set; }
        public int? RunningHoursCapture { get; set; }
        public int? ContractType { get; set; }
        public string ContractTypeName { get; set; }
        public int? CompanyStaffId { get; set; }
        public string CompanyStaffName { get; set; }
        public string Hosptial { get; set; }
        public string RequestorName { get; set; }
        //  public DateTime? RequestDateTime { get; set; }
        public DateTime? TargetDate { get; set; }
        public string RequestDescription { get; set; }
        public string Remarks { get; set; }
        public string Assignee { get; set; }
        public int RequestorId { get; set; }
        public int AssigneeId { get; set; }
        public string Asset_Name { get; set; }
        public string Item_Code { get; set; }
        public string Item_Description { get; set; }
        public string Package_Code { get; set; }
        public string Package_Description { get; set; }
        public int Asset_Category { get; set; }
        public string Work_Group { get; set; }
        public string WorkGroup { get; set; }
        //--------------------//Added by Pranay For Print Button.....//
        //public string ServicesID { get; set; }
        public string Country { get; set; }
        public string ContractorName { get; set; }
        public string ClassType { get; set; }
        //public string ChasisNo { get; set; }
        public string ContactPerson { get; set; }
        public string MobileNo { get; set; }
        public string Address { get; set; }
        public string ContactNo { get; set; }
        public string PPMCheckList { get; set; }
        public int BatchNo { get; set; }
        

    }






    public class AssetRegisterChildAsset
    {
        public int AssetId { get; set; }
        public int AssetParentId { get; set; }
        public int ServiceId { get; set; }
        public string ServiceName { get; set; }
        public string AssetNo { get; set; }
        public string AssetDescription { get; set; }
        public string AssetTypeDescription { get; set; }
        public int AssetTypeCodeId { get; set; }
        public string AssetTypeCode { get; set; }
        public int ManufacturerId { get; set; }
        public string ManufacturerName { get; set; }
        public int ModelId { get; set; }
        public string ModelName { get; set; }
        public string AssetStatus { get; set; }
    }

    public class AssetRegisterAccessoriesMstModel
    {
        public List<AssetRegisterAccessoriesDetModel> AssetRegisterAccessoriesDetModel { get; set; }
        public int AssetId { get; set; }

    }

    public class AssetRegisterAccessoriesDetModel
    {
        public int AccessoriesId { get; set; }
        public int AssetId { get; set; }
        public string AccessoriesDescription { get; set; }
        public string SerialNo { get; set; }
        // public int ManufacturerId { get; set; }
        public string ManufacturerName { get; set; }
        //  public int ModelId { get; set; }
        public string ModelName { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int TotalPages { get; set; }
        public int LastPageIndex { get; set; }
        public bool IsDeleted { get; set; }
        public string FileName { get; set; }
        public string DocumentTitle { get; set; }
        public string DocumentExtension { get; set; }
        public string ContentType { get; set; }
        public string ContentAsBase64String { get; set; }
        public string DocumentGuId { get; set; }
        public string FilePath { get; set; }
        public string GuId { get; set; }
        public string DocumentRemarks { get; set; }

    }


    public class AssetRegisterContractorVendor
    {
        public string FacilityName { get; set; }
        public string ContractNo { get; set; }
        public string ContractorType { get; set; }
        public string ContractorName { get; set; }
        public DateTime ContractStartDate { get; set; }
        public DateTime ContractEndDate { get; set; }
        public string Status { get; set; }
        public string ContractValue { get; set; }
    }

    public class AssetRegisterUpload
    {
        public int AssetId { get; set; }
        public string contentAsBase64String { get; set; }
        public string contentType { get; set; }
        public string fileResponseName { get; set; }
    }

    public class AssetRegisterImport
    {
        public string Hospital { get; set; }
        public string Service { get; set; }
        public string AssetNo { get; set; }
        public string TypeCode { get; set; }
        public string AssetDescription { get; set; }
        public string ClassificationCode { get; set; }
        public string RequesterName { get; set; }
        public string TargetDate { get; set; }
        public string RequestDescription { get; set; }
        public string Remarks { get; set; }
        public string Assignee { get; set; }
        public string TnCDate { get; set; }
        public string TnCCompletedDate { get; set; }
        public string VariationStatus { get; set; }
        public string HandOverDate { get; set; }
        public string CompanyRepresentative { get; set; }
        public string FacilityRepresentative { get; set; }
        public string AssetPreRegistrationNo { get; set; }
        public string ContractTypeName { get; set; }
        public string UserDepartment { get; set; }
        public string DepartmentName { get; set; }
        public string LocationNo { get; set; }
        public string LocationName { get; set; }
        public string Model { get; set; }
        public string SerialNo { get; set; }
        public string Manufacturer { get; set; }
        public decimal? PurchaseCost { get; set; }
        public string PurchaseOrderNo { get; set; }
        public string PurchaseDate { get; set; }
        public string ServiceStatrtDate { get; set; }
        public string WarrantyStartDate { get; set; }
        public string WarrantyDuration { get; set; }
        public string WarrantyRemarks { get; set; }
        public string CommissioningDate { get; set; }
        public decimal? CumulativePartsCost { get; set; }
        public string Vendor { get; set; }
        public string TelephoneNo { get; set; }
        public string FaxNo { get; set; }
        public string Email { get; set; }
        public decimal? AssetAge { get; set; }
    }


    public class AssetRegisterUploadModel
    {
        public int CRMRequestId { get; set; }
        public string AccessFlag { get; set; }
        public string RequestNo { get; set; }
        public string HiddenId { get; set; }
        public int AssetId { get; set; }
        public int NotificationId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int ServiceId { get; set; }
        public string AssetNo { get; set; }
        public int? TestingandCommissioningDetId { get; set; }
        public int TestingandCommissioningId { get; set; }
        public string AssetPreRegistrationNo { get; set; }
        public int AssetTypeCodeId { get; set; }
        public string AssetTypeCode { get; set; }
        public string AssetTypeDescription { get; set; }
        public int? AssetClassification { get; set; }
        public string AssetClassificationName { get; set; }
        public string AssetDescription { get; set; }
        public int WorkGroupId { get; set; }
        public DateTime CommissioningDate { get; set; }
        public int? AssetParentId { get; set; }
        public string ParentAssetNo { get; set; }
        public DateTime? ServiceStartDate { get; set; }
        public DateTime? EffectiveDate { get; set; }
        public int? ExpectedLifespan { get; set; }
        public int? RealTimeStatusLovId { get; set; }
        public int? AssetStatusLovId { get; set; }
        public decimal? AssetAge { get; set; }
        public decimal? YearsInService { get; set; }
        public decimal? OperatingHours { get; set; }

        public int? TransferModeLovId { get; set; }
        public string TransferUserLocation { get; set; }
        public DateTime? TransferDate { get; set; }
        public int? OtherTransferTypeLovId { get; set; }
        public DateTime? OtherTransferDate { get; set; }
        public int? OtherFacilityId { get; set; }
        public string OtherSpecify { get; set; }
        public string OtherPreviousAssetNo { get; set; }

        public int UserLocationId { get; set; }
        public int UserAreaId { get; set; }
        public string UserLocationCode { get; set; }
        public string UserLocationName { get; set; }
        public string CurrentAreaCode { get; set; }
        public string CurrentAreaName { get; set; }
        public string UserAreaCode { get; set; }
        public string UserAreaName { get; set; }
        public int Manufacturer { get; set; }
        public string ManufacturerName { get; set; }
        public string CurrentLocationName { get; set; }
        public string NamePlateManufacturer { get; set; }
        public int Model { get; set; }
        public string ModelName { get; set; }
        public int AppliedPartTypeLovId { get; set; }
        public string AppliedPartTypeName { get; set; }
        public int? EquipmentClassLovId { get; set; }
        public int? Specification { get; set; }
        public string SerialNo { get; set; }
        public string MainSupplier { get; set; }
        public DateTime? ManufacturingDate { get; set; }
        public int? PowerSpecification { get; set; }
        public decimal? PowerSpecificationWatt { get; set; }
        public decimal? PowerSpecificationAmpere { get; set; }
        public decimal? Volt { get; set; }
        public int PpmPlannerId { get; set; }
        public int RiPlannerId { get; set; }
        public int OtherPlannerId { get; set; }

        public string LastSchduledWorkOrderNo { get; set; }
        public DateTime? LastSchduledWorkOrderDateTime { get; set; }
        public decimal? SchduledDowntimeHoursMin { get; set; }
        public decimal? SchduledTotDowntimeHoursMinYTD { get; set; }
        public string LastUnSchduledWorkOrderNo { get; set; }
        public DateTime? LastUnSchduledWorkOrderDateTime { get; set; }
        public decimal? UnSchduledDowntimeHoursMin { get; set; }
        //public decimal? UnSchduledTotDowntimeHoursMinYTD { get; set; }
        public int? DefectList { get; set; }

        public decimal? PurchaseCostRM { get; set; }
        public DateTime? PurchaseDate { get; set; }
        public int? PurchaseCategory { get; set; }
        public decimal? WarrantyDuration { get; set; }
        public DateTime? WarrantyStartDate { get; set; }
        public DateTime? WarrantyEndDate { get; set; }
        public decimal? CumulativePartCost { get; set; }
        public decimal? CumulativeLabourCost { get; set; }
        public decimal? CumulativeContractCost { get; set; }

        public DateTime? DisposalApprovalDate { get; set; }
        public DateTime? DisposedDate { get; set; }
        public string DisposedBy { get; set; }
        public string DisposeMethod { get; set; }

        public string QRCode { get; set; }
        public string Timestamp { get; set; }
        public bool? IsLoaner { get; set; }
        public int? TypeOfAsset { get; set; }
        public List<LovValue> AssetSpecifications { get; set; }
        public List<SoftwareDetails> SoftwareDetails { get; set; }

        public int? RiskRating { get; set; }
        public string TransferFacilityName { get; set; }
        public string TransferRemarks { get; set; }
        public string PreviousAssetNo { get; set; }
        public string PurchaseOrderNo { get; set; }
        public int InstalledLocationId { get; set; }
        public string InstalledLocationCode { get; set; }
        public string InstalledLocationName { get; set; }
        public string SoftwareVersion { get; set; }
        public string SoftwareKey { get; set; }
        public string LevelName { get; set; }
        public string LevelCode { get; set; }
        public string BlockName { get; set; }
        public string BlockCode { get; set; }
        public int? TransferMode { get; set; }
        public decimal? MainsFuseRating { get; set; }
        public decimal? CalculatedFeeDW { get; set; }
        public decimal? CalculatedFeePW { get; set; }
        public decimal? TotalWarrantyDownTime { get; set; }
        public string AuthorizationName { get; set; }
        public string AssetWorkingStatusValue { get; set; }
        public int Authorization { get; set; }
        public string AuthorizationStatus { get; set; }
        public string ErrorMessage { get; set; }
        public int? RunningHoursCapture { get; set; }
        public int? ContractType { get; set; }
        public string ContractTypeName { get; set; }
        public int? CompanyStaffId { get; set; }
        public string CompanyStaffName { get; set; }
        public string Hosptial { get; set; }
        public string RequestorName { get; set; }
        //  public DateTime? RequestDateTime { get; set; }
        public DateTime? TargetDate { get; set; }
        public string RequestDescription { get; set; }
        public string Remarks { get; set; }
        public string Assignee { get; set; }
        public int RequestorId { get; set; }
        public int AssigneeId { get; set; }


        //TandC 
        public DateTime? TandCDate { get; set; }
        public DateTime? TandCCompletedDate { get; set; }
        public string VariationStatus { get; set; }
        public DateTime? HandOverDate { get; set; }
        public string CompanyRepresentative { get; set; }
        public int CompanyRepresentativeId { get; set; }
        public string FacilityRepresentative { get; set; }
        public int FacilityRepresentativeId { get; set; }
        public int VariationStatusId { get; set; }
        public string WarrantyRemarks { get; set; }
        public string TandCRemarks { get; set; }
        public string VendorName { get; set; }
        public string VendorCode { get; set; }
        public int? ContractorId { get; set; }
    }
}

