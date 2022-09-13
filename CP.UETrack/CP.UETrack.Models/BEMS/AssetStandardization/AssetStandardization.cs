
using System;

namespace CP.UETrack.Model
{
    public class AssetStandardization
    {
        public int AssetStandardizationId { get; set; }
        public int AssetTypeCodeId { get; set; }
        public string AssetTypeCode { get; set; }
        public string AssetTypeDescription { get; set; }
        public int ServiceId { get; set; }
        public string Service { get; set; }
        public int ManufacturerId { get; set; }
        public string Manufacturer { get; set; }
        public int ModelId { get; set; }
        public string Model { get; set; }
        public int StatusId { get; set; }
        public string Status { get; set; }
        public int UserId { get; set; }
        public string Timestamp { get; set; }
        public int PageIndex { get; set; }
        public int PageSize { get; set; }
    }
}