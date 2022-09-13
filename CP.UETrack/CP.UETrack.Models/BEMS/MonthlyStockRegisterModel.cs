using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.BEMS
{
    public class MonthlyStockRegisterModel
    {
        public int MonthlyStockId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public string FacilityCode { get; set; }
        public string FacilityName { get; set; }
        public string BinNo { get; set; }
        public int ServiceId { get; set; }
        public int SparePartsId { get; set; }
        public string SparePartTypeName { get; set; }
        public int Month { get; set; }
        public int Year { get; set; }
        public string PartNo { get; set; }
        public string PartDescription { get; set; }
        public string ItemCode { get; set; }
        public string ItemDescription { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
        public string Timestamp { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public int PageSize { get; set; }
        public int TotalPages { get; set; }
        public bool IsDeleted { get; set; }
        public List<ItemMonthlyStockRegisterList> MonthlyStockRegisterListData { get; set; }
        public List<ItemMonthlyStockRegisterModal> MonthlyStockRegisterModalData { get; set; }

    }
    
    public class MonthlyStockRegisterTypeDropdown
    {   
        public List<LovValue> SparePartTypedata { get; set; }
        public List<LovValue> MonthListTypedata { get; set; }
        public List<LovValue> Years { get; set; }
        public int CurrentYear { get; set; }        

    }

    public class ItemMonthlyStockRegisterList
    {
        public int MonthlyStockDetId{ get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int ServiceId { get; set; }
        public int SparePartsId { get; set; }
        public int MonthlyStockId { get; set; }
        public int StockUpdateId { get; set; }
        public string FacilityCode { get; set; }
        public string FacilityName { get; set; }
        public string BinNo { get; set; }
        public int Month { get; set; }
        public int Year { get; set; }
        public string PartNo { get; set; }
        public string PartDescription { get; set; }
        public string ItemCode { get; set; }
        public string ItemDescription { get; set; }
        public string UOM { get; set; }
        public decimal MinimumLevel { get; set; }
        public string SparePartTypeName { get; set; }
        public int SparePartType { get; set; }
        public decimal CurrentQuantity { get; set; }
        public decimal ClosingMonthQuantity { get; set; }
        public string Remarks { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
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

    public class ItemMonthlyStockRegisterModal
    {
        public int Month { get; set; }
        public int Year { get; set; }
        public int SparePartsId { get; set; }
        public string PartNo { get; set; }
        public string PartDescription { get; set; }
        public decimal CurrentQuantity { get; set; }
        public decimal Cost { get; set; }
        public decimal PurchaseCost { get; set; }
        public string InvoiceNo { get; set; }
        public string VendorName { get; set; }
        public string Remarks { get; set; }
        public string FacilityCode { get; set; }
        public string FacilityName { get; set; }
        public string BinNo { get; set; }
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
