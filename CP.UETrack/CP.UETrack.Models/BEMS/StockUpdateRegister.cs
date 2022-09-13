using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.BEMS
{
   public class StockUpdateRegister
    {
        public int StockUpdateId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public string FacilityCode { get; set; }
        public string FacilityName { get; set; }
        public int ServiceId { get; set; }
        public string StockUpdateNo { get; set; }
        public string Location { get; set; }
        public int LocationId { get; set; }
        public string BinNo { get; set; }
        public DateTime Date { get; set; }
        public DateTime DateUTC { get; set; }
        public decimal? TotalCost { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int? ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
        public string Timestamp { get; set; }
        public DateTime? DateUpload { get; set; }
        public int? SparePartsId { get; set; }
        public int? ItemId { get; set; }
       
        public List<ItemMstFetchEntity> ItemMstFetchEntityList { get; set; }
        public string ErrorMessage { get; set; }
        public decimal Cost { get; set; }


    }
   
    public class StockUpdateRegisterGetallEntity
    {
        public int StockUpdateId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public DateTime Date { get; set; }
        public int Year { get; set; }
        public int ItemId { get; set; }
        public string Location { get; set; }
        public int LocationId { get; set; }
        public string BinNo { get; set; }
        public string ItemNo { get; set; }
        public string ItemDescription { get; set; }
        public int SparePartsId { get; set; }
        public string PartNo { get; set; }
        public string PartDescription { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
        public string Status { get; set; }
        public string StockUpdateNo { get; set; }

    }

    public class ItemMstFetchEntity
    {
        public int ItemId { get; set; }
        public int StockUpdateId { get; set; }
        public int StockUpdateDetId { get; set; }
        public string Timestamp { get; set; }
        public string Partno { get; set; }
        public decimal? TotalCost { get; set; }
        public string PartDescription { get; set; }
        public string ItemCode { get; set; }
        public string ItemDescription { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int TotalPages { get; set; }
        public int LastPageIndex { get; set; }
        public int SparePartsId { get; set; }
        public int SparePartType { get; set; }
        public string SparePartTypeName { get; set; }
        public int EstimatedLifeSpanId { get; set; }
        public decimal? EstimatedLifeSpan { get; set; }
        public string EstimatedLifeSpanOption { get; set; }
        public DateTime? EstimatedLifeSpanExpiryDate { get; set; }
        public string EstimatedLifeSpanType { get; set; }
        public string PartSource { get; set; }
        public DateTime? StockExpDate { get; set; }
        public DateTime? StockExpiryDateUTC { get; set; }
        public decimal Quantity { get; set; }
        public decimal Cost { get; set; }
        public decimal PurchaseCost { get; set; }
        public string InvoiceNo { get; set; }
        public string Remarks { get; set; }
        public bool IsDeleted { get; set; }
        public string VendorName { get; set; }
        public bool IsDeleteReference { get; set; }
        public int? LifeSpanOptionId { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int? ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
        public bool IsExpirydate { get; set; }
        public string Location { get; set; }
        public int LocationId { get; set; }
        public string BinNo { get; set; }
    }


    public class Dropdownentity
    {

        public List<LovValue> SparepartTypeList { get; set; }
        public List<LovValue> SparepartLocationList { get; set; }
        
    }

    public class Upload
    {
        public string contentAsBase64String { get; set; }
        public string contentType { get; set; }
        public string fileResponseName { get; set; }
        public int StockUpdateId { get; set; }
        public List<ItemMstFetchEntity> ItemMstFetchEntityList { get; set; }
    }

    public class ExportModel
    {
       // public string StockUpdateNo { get; set; }
       // public string Date { get; set; }
        //public string Year { get; set; }
      //  public string TotalSparePartCost { get; set; }
      //  public string FacilityCode { get; set; }
       // public string FacilityName { get; set; }       
        public string PartNo { get; set; }
        public string PartDescription { get; set; }
        public string SparePartType { get; set; }
        public string Location { get; set; }
        public string ItemCode { get; set; }
        public string ItemDescription { get; set; }        
        public string PartSource { get; set; }
        public string LifeSpanOptions { get; set; }       
        public string EstimatedLifeSpan { get; set; }
        public string ExpiryDate { get; set; }
        public string Quantity { get; set; }
        public string PurchaseCost { get; set; }
        public string Cost { get; set; }        
        public string InvoiceNo { get; set; }
        public string VendorName { get; set; }
        public string BinNo { get; set; }
        public string Remarks { get; set; }       
       
    } 

    
}
