using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.VM
{
   public class SNFEntity: BaseViewModel
    {
        public int AssetId { get; set; }
        public int TestingandCommissioningId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public string TandCDocumentNo { get; set; }
        public DateTime TandCDate { get; set; }
        public int TandCType { get; set; }
        public int? AssetTypeCodeId { get; set; }
        public string AssetTypeCode { get; set; }
        public string AssetTypeDescription { get; set; }
        public int TandCStatus { get; set; }
        public string AssetPreRegistrationNo { get; set; }
        public string TandCStatusName { get; set; }
        public int? TestingandCommissioningDetId { get; set; }
        public DateTime? TandCCompletedDate { get; set; }
        public DateTime? HandoverDate { get; set; }
        public decimal? PurchaseCost { get; set; }
        public DateTime? PurchaseDate { get; set; }
        public int? PurchaseCategory { get; set; }
        public string SNFRemarks { get; set; }
        public DateTime? ServiceStartDate { get; set; }
        public DateTime? ServiceEndDate { get; set; }
        public string MainSupplierCode { get; set; }
        public string MainSupplierName { get; set; }
        public string ContractLPONo { get; set; }
        public int VariationStatus { get; set; }
        public string TandCContractorRepresentative { get; set; }
        public int FmsCustomerRepresentativeId { get; set; }
        public string CustomerRepresentativeName { get; set; }
        public int FmsFacilityRepresentativeId { get; set; }
        public string FacilityRepresentativeName { get; set; }
        public int? UserAreaId { get; set; }
        public int? UserLocationId { get; set; }
        public string Remarks { get; set; }
        public int UserId { get; set; }
        public int? WarrantyDuration { get; set; }
        public DateTime? WarrantyStartDate { get; set; }
        public DateTime? WarrantyEndDate { get; set; }
        public int? WarrantyStatus { get; set; }
        public int? Status { get; set; }
        public string SNFNo { get; set; }
        public string AssetNo { get; set; }
        public int? AssetNoId { get; set; }
        public bool IsLoaner { get; set; }
    }

    public class LovEntity
    {
        public List<LovValue> VariationStatus { get; set; }
        
        public List<LovValue> YesNoValues { get; set; }
    }
    public class SNFAssetFetchEntity :BaseViewModel
    {
        public int AssetId { get; set; }
        public string AssetNo { get; set; }
        public string AssetDescription { get; set; }
        public DateTime? PurchaseDate { get; set; }
        public decimal? PurchaseCostRM { get; set; }
        public DateTime ServiceStartDate { get; set; }
        public DateTime? WarrantyStartDate { get; set; }
        public DateTime? WarrantyEndDate { get; set; }
        public decimal? WarrantyDuration { get; set; }
        public string WarrantyStatus { get; set; }
       
        public string MainSupplierCode { get; set; }
        public string MainSupplier { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
    }

    public class SNFGetallEntity
    {

        public int TestingandCommissioningId { get; set; }
        public string SNFNo { get; set; }
        public DateTime SNFDate { get; set; }
        public string AssetNo { get; set; }
        public string VariationStatus { get; set; }
        public int TotalRecords { get; set; }
        public string Status { get; set; }
    }
}
