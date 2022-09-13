using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.BEMS
{
    public class VaritableDetailsList
    {
        public List<Varabledetails> detailsList { get; set; }
        public List<LovValue> YesNoList { get; set; }
    }
    public class Varabledetails//: varabledetailsEntity
    {
        public int TestingandCommissioningId { get; set; }
        public Nullable<decimal> PurchaseProjectCost { get; set; }
        public DateTime? VariationDate { get; set; }
        public DateTime? StopServiceDate { get; set; }// ServiceStopDate
        public DateTime? StartServiceDate { get; set; }
        public DateTime? CommissioningDate { get; set; }
        public DateTime? WarrantyEndDate { get; set; }
        public int? VariationMonth { get; set; }
        public int? VariationYear { get; set; }
        public string VariationStatusName { get; set; }
        public string Fetchkey { get; set; }
        public string VariationApprovedStatusLovName { get; set; }
        public int VariationId { get; set; }
        public string SNFDocumentNo { get; set; }
        public int AssetId { get; set; }
        public int? AssetClassification { get; set; }
        public int VariationStatus { get; set; }
        public int? VariationStatusLovId { get; set; }
        public int? VariationApprovedStatusLovId { get; set; }
        public int? WarrantyDuration { get; set; }
        public DateTime? WarrantyStartDate { get; set; }
        public string MainSupplierCode { get; set; }
        public string MainSupplierName { get; set; }
        public string ContractLPONo { get; set; }
        public List<LovValue> YesNoList { get; set; }
        public bool? AuthorizedStatus { get; set; }
        public int AuthorizedStatusForVariation { get; set; }
        public string VariationMonthName { get; set; }
    }

    public class VariationSaveEntity
    {
        public List<variationsaveList> SaveList { get; set; }
    }
    public class variationsaveList : BaseViewModel
    {

        public int VariationId { get; set; }
        public string SNFDocumentNo { get; set; }
        public DateTime? SnfDate { get; set; }
        public int AssetId { get; set; }
        public int? AssetClassification { get; set; }
        public int VariationStatus { get; set; }
        public Nullable<decimal> PurchaseProjectCost { get; set; }
        public DateTime? VariationDate { get; set; }
        public DateTime? VariationDateUTC { get; set; }
        public DateTime? StopServiceDate { get; set; }// ServiceStopDate
        public DateTime? StartServiceDate { get; set; }
        public DateTime? CommissioningDate { get; set; }
        public int? WarrantyDurationMonth { get; set; }
        public DateTime? WarrantyStartDate { get; set; }
        public DateTime? WarrantyEndDate { get; set; }
        public int? VariationApprovedStatus { get; set; }
        public string Remarks { get; set; }
        public bool? AuthorizedStatus { get; set; }
        public bool? AssetOldVariationData { get; set; }
        public int? VariationWFStatus { get; set; }
        public DateTime? PurchaseDate { get; set; }
        public decimal? VariationPurchaseCost { get; set; }
        public decimal? ContractCost { get; set; }
        public string ContractLpoNo { get; set; }
        public string MainSupplierCode { get; set; }
        public string MainSupplierName { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime? VariationRaisedDate { get; set; }
        public int? AuthorizedStatusForVariation { get; set; }
    }
}