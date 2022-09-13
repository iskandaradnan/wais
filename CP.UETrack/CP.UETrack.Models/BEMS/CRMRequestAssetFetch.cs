
namespace CP.UETrack.Model
{
    public class CRMRequestAssetFetch
    {
        public int AssetId { get; set; }
        public string AssetNo { get; set; }
        public string AssetDescription { get; set; }
        public int ModelId { get; set; }
        public string Model { get; set; }
        public int ManufacturerId { get; set; }
        public string Manufacturer { get; set; }

        public string SoftwareVersion { get; set; }
        public string SoftwareKey { get; set; }
        public string SerialNo { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
    }
}