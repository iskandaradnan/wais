using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CP.UETrack.Model.HWMS
{
    public class SafetyDataSheetReport
    {
        public int Month { get; set; }
        public int Year { get; set; }
        public string ChemicalName { get; set; }
        public string DocumentNo { get; set; }
        public string DocumentDate { get; set; }
        public string Category { get; set; }
        public string AreaOfApplication { get; set; }

        public List<SafetyDataSheetReport> SafetyDataSheetReportList { get; set; }

    }
}