
using System;

namespace CP.UETrack.Model
{
    public class CRMRequestType
    {
        public int LovId { get; set; }
        public string CRMrequesttype { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
    }
    public class CRMWorkorderRequestFetch
    {
        public int  CRMRequestId { get; set; }
        public string RequestNo { get; set; }
        public DateTime RequestDateTime { get; set; }
        public int TypeOfRequest { get; set; }
        public string TypeOfRequestValue { get; set; }
        public DateTime ModifiedDateUTC { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
    }
}