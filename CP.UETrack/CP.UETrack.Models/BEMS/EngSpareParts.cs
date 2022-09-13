using CP.UETrack.Models;
using System;
using System.Collections.Generic;

namespace CP.UETrack.Model.BEMS
{
    public class EngSpareParts
    {
        public string DocumentGuId { get; set; }
        public int DocumentId { get; set; }
        public string HiddenId { get; set; }
        public EngSpareParts()
        {
            BrandId = null;
        }
        public int SparePartsId { get; set; }
        public int ServiceId { get; set; }
        public int ItemId { get; set; }
        public string ItemCode { get; set; }
        public string ItemDescription { get; set; }
        public string AssetTypeDescription { get; set; }
        public string PartNo { get; set; }
        public decimal EstimatedLifeSpan { get; set; }
        public string PartDescription { get; set; }
        public int AssetTypeCodeId { get; set; }
        public string AssetTypeCode { get; set; }

        public int ManufacturerId { get; set; }
        public string ManufacturerName { get; set; }
        public int? BrandId { get; set; }
        public int ModelId { get; set; }
        public string ModelName { get; set; }
        public int UnitOfMeasurement { get; set; }
        public int SparePartType { get; set; }
        public int Location { get; set; }
        public string Specify { get; set; }
        public int PartCategory { get; set; }
        public decimal MinLevel { get; set; }
        public decimal? MaxLevel { get; set; }
        public decimal? MinPrice { get; set; }
        public decimal? MaxPrice { get; set; }

        public int Status { get; set; }

        public string ImagePath1 { get; set; }
        public string ImagePath2 { get; set; }
        public string ImagePath3 { get; set; }
        public string ImagePath4 { get; set; }
        public string ImagePath5 { get; set; }
        public string ImagePath6 { get; set; }
        public string VideoPath { get; set; }
        public DateTime CreatedDate { get; set; }
        public string Timestamp { get; set; }
        public bool Active { get; set; }
        public string PartCategoryName { get; set; }
        public string StatusValue { get; set; }
        public string CurrentStockLevel { get; set; }

        public int? Image1DocumentId { get; set; }
        public int? Image2DocumentId { get; set; }
        public int? Image3DocumentId { get; set; }
        public int? Image4DocumentId { get; set; }
        public int? Image5DocumentId { get; set; }
        public int? Image6DocumentId { get; set; }
        public int? VideoDocumentId { get; set; }
        public int PartSourceId { get; set; }
        public int LifespanOptionsId { get; set; }
        public string PartSource { get; set; }
    }


    public class EngSparePartsLovs
    {
        public List<LovValue> LifespanOptionsList { get; set; }
        public List<LovValue> ServiceList { get; set; }
        public List<LovValue> SparePartSourceLovs { get; set; }
        public List<LovValue> SparePartStockLocationLovs { get; set; }
        public List<LovValue> StatusLovs { get; set; }
        public List<LovValue> StockTypeLovs { get; set; }
        public List<LovValue> UnitofMeasurementLovs { get; set; }
        public List<LovValue> YesNoLovs { get; set; }
    }
}
