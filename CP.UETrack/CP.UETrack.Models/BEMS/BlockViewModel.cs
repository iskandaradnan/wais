using System;

namespace CP.UETrack.Model
{
    public class BlockMstViewModel
    {
        public string HiddenId { get; set; }
        public int BlockId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public string FacilityName { get; set; }
        public string BlockCode { get; set; }
        public string BlockName { get; set; }
        public string ShortName { get; set; }
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
        public int BEMS { get; set; }
        public int FEMS { get; set; }
        public int CLS { get; set; }
        public int LLS { get; set; }
        public int HWMS { get; set; }
    }
    public class Blocks
    {
        public int FEMS_B_ID { get; set; }
        public int BEMS_B_ID { get; set; }
        public int CLS_B_ID { get; set; }
        public int LLS_B_ID { get; set; }
        public int HWMS_B_ID { get; set; }
    }
}
