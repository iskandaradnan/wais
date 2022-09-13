namespace CP.UETrack.Model
{
    public class SoftwareDetails
    {
        public int AssetSoftwareId { get; set; }
        public int AssetId { get; set; }
        public string SoftwareVersion { get; set; }
        public string SoftwareKey { get; set; }
        public int IsDeleted { get; set; }
    }
}
