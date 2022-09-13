using System;

namespace CP.UETrack.Model
{
    public class AssetRegister
    {
        public int AssetId { get; set; }
        public string AssetNo { get; set; }
        public string AssetNoOld { get; set; }
        public string AssetTypeCode { get; set; }
        public string AssetTypeDescription { get; set; }
        public string UserLocationCode { get; set; }
        public string UserAreaName { get; set; }
        public string UserLocationName { get; set; }
        public string CurrentLocationCode { get; set; }
        public string CurrentLocationName { get; set; }
        public string Manufacturer { get; set; }
        public string Model { get; set; }
        public string Active { get; set; }
        public string Authorization { get; set; }
        public string VariationStatus { get; set; }
        public string ModifiedDateUTC { get; set; }
	    public string CustomerName { get; set; }
        public int FacilityId { get; set; }
        public string FacilityName { get; set; }
        public bool? IsLoaner { get; set; }
        public string AssetClassificationCode { get; set; }
        public string AssetClassification { get; set; }
        public string AuthorizationStatus { get; set; }
        public string SerialNumber { get; set; }
        public string ContractType { get; set; }
    }
}
