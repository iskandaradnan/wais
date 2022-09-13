
using System;

namespace CP.UETrack.Model
{
    public class TestingAndCommissioning
    {
        public int TestingandCommissioningId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int ServiceId { get; set; }
        public string TandCDocumentNo { get; set; }
        public DateTime? RequestDate { get; set; }
        public DateTime TandCDate { get; set; }
        public int AssetCategoryLovId { get; set; }
        public int? CRMRequestId { get; set; }
        public int CRMRequesterId { get; set; }
        public int NotificationId { get; set; }
        public string CRMRequestNo { get; set; }
        public string RequestNo { get; set; }
        public string RequesterEmail { get; set; }
        public string AssetCategory { get; set; }
        public int? AssetTypeCodeId { get; set; }
        public string AssetTypeCode { get; set; }
        public string AssetTypeDescription { get; set; }
        public int TandCStatus { get; set; }
        public int ModelId { get; set; }
        public string Model { get; set; }
        public int ManufacturerId { get; set; }
        public string Manufacturer { get; set; }
        public string SerialNo { get; set; }
        public string AssetNoOld { get; set; }
        public string AssetNo { get; set; }
        public string PONo { get; set; }
        public int UserLocationId { get; set; }
        public string UserLocationName { get; set; }
        public int UserAreaId { get; set; }
        public string UserAreaName { get; set; }
        public string LevelName { get; set; }
        public string BlockName { get; set; }
        public string AssetPreRegistrationNo { get; set; }
        public string TandCStatusName { get; set; }
        public int? TestingandCommissioningDetId { get; set; }
        public DateTime? TandCCompletedDate { get; set; }
        public DateTime? HandoverDate { get; set; }
        public DateTime RequiredCompletionDate { get; set; }
        public string PurchaseOrderNo { get; set; }
        public decimal? PurchaseCost { get; set; }
        public DateTime? PurchaseDate { get; set; }
        public int? PurchaseCategory { get; set; }
        public string SNFRemarks { get; set; }
        public DateTime? ServiceStartDate { get; set; }
        public DateTime? ServiceEndDate { get; set; }
        public int? ContractorId { get; set; }
        public string MainSupplierCode { get; set; }
        public string MainSupplierName { get; set; }
        public string ContractLPONo { get; set; }
        public int VariationStatus { get; set; }
        public string TandCContractorRepresentative { get; set; }
        public int FmsCustomerRepresentativeId { get; set; }
        public string CustomerRepresentativeName { get; set; }
        public int FmsFacilityRepresentativeId { get; set; }
        public string FacilityRepresentativeName { get; set; }
        public int UserDesignationId { get; set; }
        public int? DesignationId { get; set; }
        public string Designation { get; set; }
        public string Remarks { get; set; }
        public int UserId { get; set; }
        public int? WarrantyDuration { get; set; }
        public DateTime? WarrantyStartDate { get; set; }
        public DateTime? WarrantyEndDate { get; set; }
        public int? WarrantyStatus { get; set; }
        public int? Status { get; set; }
        public string Timestamp { get; set; }
        public string QRCode { get; set; }
        public string StatusName { get; set; }
        public string HiddenId { get; set; }
        public bool? IsUsed { get; set; }
        public string ApprovalRemarks { get; set; }
        public string RejectRemarks { get; set; }
        public string TypeOfService { get; set; }
        public string BatchNo { get; set; }
    }

    public class TAndCSNF
    {
        public int TestingandCommissioningId { get; set; }
        public string TandCDocumentNo { get; set; }
        public string PurchaseOrderNo { get; set; }
        public decimal? PurchaseCost { get; set; }
        public DateTime? PurchaseDate { get; set; }
        public string ContractLPONo { get; set; }
        public DateTime? TandCCompletedDate { get; set; }
        public DateTime? ServiceStartDate { get; set; }
        public DateTime? ServiceEndDate { get; set; }
        public int ContractorId { get; set; }
        public string MainSupplierCode { get; set; }
        public string MainSupplierName { get; set; }
        public DateTime? WarrantyStartDate { get; set; }
        public int? WarrantyDuration { get; set; }
        public DateTime? WarrantyEndDate { get; set; }
        public string SNFRemarks { get; set; }
        public int? Status { get; set; }
        public int UserId { get; set; }
        public string Timestamp { get; set; }
        public string StatusName { get; set; }
        public int? WarrantyStatus { get; set; }
    }
}