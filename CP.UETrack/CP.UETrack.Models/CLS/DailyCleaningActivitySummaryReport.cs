using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.CLS
{
    public class DailyCleaningActivitySummaryReport
    {       
        public int Month { get; set; }
        public int Year { get; set; }       
        public int No { get; set; }
        public string UserAreaCode { get; set; }
        public string UserArea { get; set; }
        public int A1 { get; set; }
        public int A2 { get; set; }
        public int A3 { get; set; }
        public int A4 { get; set; }
        public int A5 { get; set; }
        public int B1 { get; set; }
        public int C1 { get; set; }
        public int D1 { get; set; }
        public int D2 { get; set; }
        public int D3 { get; set; }
        public int D4 { get; set; }
        public int E1 { get; set; }
        public List<DailyCleaningActivitySummaryReport> DailyCleaningActivitySummaryReportFetchList { get; set; }
    }
}
