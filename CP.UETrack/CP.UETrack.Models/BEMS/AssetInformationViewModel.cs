using System;

namespace CP.UETrack.Model
{
    public class AssetInformationViewModel
    {
        public int AssetInfoId { get; set; }
        public int AssetInfoType { get; set; }
        public string AssetInfoValue { get; set; }
        public string AssetInfoTypeName { get; set; }
        
        //public string Manufacturer { get; set; }
        //public int ManufacturerId { get; set; }
        //public string Make { get; set; }
        //public int MakeId { get; set; }
        //public string Brand { get; set; }
        //public int BrandId { get; set; }
        //public string Model { get; set; }
        //public int ModelId { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public DateTime ActiveFromDate { get; set; }
        public DateTime ActiveFromDateUTC { get; set; }
        public DateTime ActiveToDate { get; set; }
        public DateTime ActiveToDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
        public string Timestamp { get; set; }
        public int Active { get; set; }
        public bool BuiltIn { get; set; }
    }
}
