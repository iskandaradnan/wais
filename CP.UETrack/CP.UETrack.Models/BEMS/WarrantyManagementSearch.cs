
using System;

namespace CP.UETrack.Model
{
    public class WarrantyManagementSearch
    {
        public int  AssetId { get; set; }
        public string AssetNo { get; set; }
        public string TnCRefNo { get; set; }
        public string AssetClassification { get; set; }
        public string TypeCode { get; set; }
        public string AssetDescription { get; set; }
        public DateTime WarrantyStartDate { get; set; }
        public DateTime WarrantyEndDate { get; set; }
        public int WarrantyPeriod { get; set; }
        public decimal PurchaseCost { get; set; }
        public decimal DWFee { get; set; }
        public decimal PWFee { get; set; }
        public int WarrantyDownTime { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
    }
}