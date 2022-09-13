
namespace CP.UETrack.Model
{
    public class AssetQRCodePrintFetchModel
    {
        public int  AssetId { get; set; }
        public string AssetNo { get; set; }
        public string AssetDescription { get; set; }
        public string UserAreaName { get; set; }
        public string UserLocationName { get; set; }
        public int AssetTypeCodeId { get; set; }
        public int  UserAreaId { get; set; }
        public int UserLocationId { get; set; }
        public string AssetTypeCode { get; set; }
        public string Manufacturer { get; set; }
        public string Model { get; set; }
        public string ContractType { get; set; }
        public string AssetQRCode { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
    }
}