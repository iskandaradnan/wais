using System;

namespace CP.UETrack.Model
{
    public class AssetStatusDetails
    {
        public string AssetStatus { get; set; }
        public string SNFNumber { get; set; }
        public string VariationStatus { get; set; }
        public DateTime? SNFRaisedDate { get; set; }
        public DateTime? ServiceStartDate { get; set; }
        public DateTime? ServiceEndDate { get; set; }
    }
}
