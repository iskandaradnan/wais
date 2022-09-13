using CP.UETrack.Models;
using System;
using System.Collections.Generic;

namespace CP.UETrack.Model.BEMS
{
    public class EngAssetClassification
    {
        public int AssetClassificationId { get; set; }
        public string AssetClassification { get; set; }
        public string AssetClassificationCode { get; set; }
        public int ServiceId { get; set; }
        public string Remarks { get; set; }   
        public string Timestamp { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
        public bool Active { get; set; }
        public bool BuiltIn { get; set; }
        public string AssetClassificationDescription { get; set; }

    }
    public class AssetClassificationLovs
    {
        public List<LovValue> ServiceList { get; set; }
        public List<LovValue> StatusList { get; set; }
        public List<LovValue> Services { get; set; }
    }
}
