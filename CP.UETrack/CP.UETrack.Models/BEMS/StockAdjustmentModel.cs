using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.BEMS
{
    public class StockAdjustmentModel
    {
        public int StockAdjustmentId { get; set; }
        public int StockAdjustmentDetId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public string FacilityCode { get; set; }
        public string FacilityName { get; set; }
        public int ServiceId { get; set; }
        public int Year { get; set; }
        public string Month { get; set; }
        public string StockAdjustmentNo { get; set; }
        public DateTime AdjustmentDate { get; set; }
        public string ItemDescription { get; set; }
        public string BinNo { get; set; }
        public DateTime AdjustmentDateUTC { get; set; }
        public string PartCategory { get; set; }
        public int ApprovalStatus { get; set; }
        public string ApprovalStatusValue { get; set; }
        public string ApprovedBy { get; set; }
        public DateTime? ApprovedDate { get; set; }
        public DateTime? ApprovedDateUTC { get; set; }        
        public DateTime CreatedDate { get; set; }
        public string Timestamp { get; set; }
        public bool isAdjustmentDateNull { get; set; }
        public bool isApprovedDateNull { get; set; }
        public bool Submitted { get; set; }
        public bool Approved { get; set; }
        public bool Rejected { get; set; }
        public int NotificationId { get; set; }
        public int TemplateId { get; set; }
        public List<ItemStockAdjustmentList> StockAdjustmentGridList { get; set; }
    }

    public class ItemStockAdjustmentList
    {
        public int ItemId { get; set; }
        public string PartNo { get; set; }
        public string PartDescription { get; set; }
        public string ItemCode { get; set; }
        public string ItemDescription { get; set; }
        public string BinNo { get; set; }
        public int StockAdjustmentDetId { get; set; }
        public int StockAdjustmentId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int ServiceId { get; set; }        
        public string StockAdjustmentNo { get; set; }
        public DateTime AdjustmentDate { get; set; }
        public DateTime AdjustmentDateUTC { get; set; }
        public int ApprovalStatus { get; set; }
        public string ApprovedBy { get; set; }
        public DateTime ApprovedDate { get; set; }
        public DateTime ApprovedDateUTC { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
        public string FacilityCode { get; set; }
        public string FacilityName { get; set; }        
        public int StockUpdateId { get; set; }
        public int StockUpdateDetId { get; set; }
        public int SparePartsId { get; set; }
        public decimal QuantityFacility { get; set; }
        public decimal PhysicalQuantity { get; set; }
        public decimal Variance { get; set; }
        public decimal AdjustedQuantity { get; set; }
        public decimal Cost { get; set; }
        public decimal PurchaseCost { get; set; }
        public string InvoiceNo { get; set; }
        public string VendorName { get; set; }
        public string Remarks { get; set; }
        public string Timestamp { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }       
        public int PageSize { get; set; }        
        public int TotalPages { get; set; }
        public bool IsDeleted { get; set; }

    }
    
}
