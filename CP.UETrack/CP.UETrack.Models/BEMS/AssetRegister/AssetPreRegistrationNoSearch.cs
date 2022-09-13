
using System;

namespace CP.UETrack.Model
{
    public class AssetPreRegistrationNoSearch
    {
        public int TestingandCommissioningId { get; set; }
        public int TestingandCommissioningDetId { get; set; }
        public string AssetPreRegistrationNo { get; set; }
        public DateTime TandCDate { get; set; }
        public DateTime? ServiceStartDate { get; set; }
        public string PurchaseOrderNo { get; set; }
        public DateTime? PurchaseDate { get; set; }
        public decimal? PurchaseCost { get; set; }
        public DateTime? WarrantyStartDate { get; set; }
        public DateTime? WarrantyEndDate { get; set; }
        public int? WarrantyDuration { get; set; }
        public string MainSupplierName { get; set; }
        public int AssetClassificationId { get; set; }
        public decimal? AssetAge { get; set; }
        public decimal? YearsInService { get; set; }
        public int AssetTypeCodeId { get; set; }
        public string AssetTypeCode { get; set; }
        public string AssetTypeDescription { get; set; }
        public string AssetNo { get; set; }
        public int Model { get; set; }
        public string ModelName { get; set; }
        public int Manufacturer { get; set; }
        public string ManufacturerName { get; set; }
        public int IsLoaner { get; set; }

        public int? AssetCategoryLovId { get; set; }
        public string SerialNo { get; set; }
        public int? UserLocationId { get; set; }
        public string UserLocationCode { get; set; }
        public string UserLocationName { get; set; }
        public string CurrentAreaCode { get; set; }
        public string CurrentAreaName { get; set; }
        public int? UserAreaId { get; set; }
        public string UserAreaCode { get; set; }
        public string UserAreaName { get; set; }
        public int? LevelId { get; set; }
        public string LevelCode { get; set; }
        public string LevelName { get; set; }
        public int? BlockId { get; set; }
        public string BlockCode { get; set; }
        public string BlockName { get; set; }
        public int? InstalledLocationCodeId { get; set; }
        public string InstalledLocationCode { get; set; }
        public string InstalledLocationName { get; set; }
        public int? PpmPlannerId { get; set; }
        public int? RiPlannerId { get; set; }
        public int? OtherPlannerId { get; set; }
        public int? ExpectedLifeSpan { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
    }
}