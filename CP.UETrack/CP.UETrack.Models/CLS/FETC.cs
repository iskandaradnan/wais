using CP.UETrack.Model.Common;
using CP.UETrack.Models;
using System;
using System.Collections.Generic;

namespace CP.UETrack.Model.CLS
{
    public class FETC
    {
        public int FETCId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public string ItemCode { get; set; }
        public string ItemDescription { get; set; }
        public string ItemType { get; set; }
        public int Status { get; set; }
        public int Quantity { get; set; }
        public string GridStatus { get; set; }
        public DateTime EffectiveFrom { get; set; }
        public DateTime? EffectiveTo { get; set; }
        public List<FETC> AutoGenerate { get; set; }
        public List<Attachment> AttachmentList { get; set; }
    }


    public class FETCDropdown
    { 
        public List<LovValue> FacilityStatusLovs { get; set; }
        public List<LovValue> ItemTypeLovs { get; set; }
    }
}
