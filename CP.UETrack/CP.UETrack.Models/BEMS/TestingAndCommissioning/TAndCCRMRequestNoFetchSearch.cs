using System;

namespace CP.UETrack.Model
{
    public class TAndCCRMRequestNoFetchSearch
    {
        public int CRMRequestId { get; set; }
        public string RequestNo { get; set; }
        public int CRMRequesterId { get; set; }
        public string RequesterEmail { get; set; }
        public string RequestDescription { get; set; }
        public DateTime RequestDate { get; set; }
        public DateTime TargetDate { get; set; }
        public int UserLocationId  { get; set; }
        public string UserLocationName { get; set; }
        public int UserAreaId { get; set; }
        public string UserAreaName  { get; set; }
        public string LevelName { get; set; }
        public string BlockName { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
    }
}