
using System;

namespace CP.UETrack.Model
{
    public class EODCaptureAssetFetch
    {
        public int AssetId { get; set; }
        public string AssetNo { get; set; }
        public string AssetDescription { get; set; }
        public int  AssetTypeCodeId { get; set; }
        public string AssetTypeCode { get; set; }
        public string AssetTypeDescription { get; set; }
        public int  UserAreaId { get; set; }
        public string UserAreaCode { get; set; }
        public string UserAreaName { get; set; }
        public int  UserLocationId { get; set; }
        public string UserLocationCode { get; set; }
        public string UserLocationName { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public int? CategorySystemId { get; set; }
        public DateTime? RecordDate { get; set; }
    }
}