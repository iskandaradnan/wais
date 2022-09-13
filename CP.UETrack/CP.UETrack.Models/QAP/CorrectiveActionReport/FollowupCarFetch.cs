
using System;

namespace CP.UETrack.Model
{
    public class FollowupCarFetch
    {
        public int CarId { get; set; }
        public string CARNumber { get; set; }
        public DateTime? FromDate { get; set; }
        public DateTime? ToDate { get; set; }
        public string CarIdOriginal { get; set; }
        public int IndicatorId { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
    }
}