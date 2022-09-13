using System;

namespace CP.UETrack.Model
{
    public class LevelMstViewModel
    {
        public string HiddenId { get; set; }
        public int LevelId { get; set; }
        public int CustomerId { get; set; }
        public int BlockId { get; set; }
        public int FacilityId { get; set; }
        public string FacilityName { get; set; }
        public string LevelCode { get; set; }
        public string LevelName { get; set; }
        public string ShortName { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
        public string Timestamp { get; set; }
        public int Active { get; set; }
        public bool BuiltIn { get; set; }
        public string BlockCode { get; set; }
        public string BlockName { get; set; }
    }
}
