using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CP.UETrack.Model.HWMS
{
    public class CRMReport
    {        
        public int Month { get; set; }
        public int Year { get; set; }       
        public string RequestNo { get; set; }
        public string RequestType { get; set; }
        public string RequestDate { get; set; }
        public string RequestDetails { get; set; }
        public string UserArea { get; set; }
        public string Requester { get; set; }
        public string TypeOfRequest { get; set; }
        public string Status { get; set; }
        public string Completion { get; set; }
        public string Ageing { get; set; }

        public List<CRMReport> CRMReportList { get; set; }

    }
}