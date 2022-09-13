using System;
namespace CP.UETrack.Model
{
    public class StockAdjustmentFetchModel
    {
        public int  StockAdjustmentId { get; set; }
        public int  StockAdjustmentDetId { get; set; }
        public string  PartNo { get; set; }
        public string PartDescription { get; set; }
        public int PartCategory { get; set; }
        public string ItemCode { get; set; }
        public string ItemDescription { get; set; }
        public string BinNo { get; set; }
        public int  SparePartsId { get; set; }
        public string SparePartTypeName { get; set; }
        public decimal QuantityFacility { get; set; }
        public int StockUpdateDetId { get; set; }
        public decimal Cost { get; set; }
        public decimal PurchaseCost { get; set; }
        public string InvoiceNo { get; set; }
        public string VendorName { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
    }
}