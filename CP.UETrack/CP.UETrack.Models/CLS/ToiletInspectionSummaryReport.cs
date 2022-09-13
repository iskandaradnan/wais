using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.CLS
{
   public class ToiletInspectionSummaryReport
   {       
        public int Month { get; set; }
        public int Year { get; set; }
        public int TotalToiletLocations { get; set; }
        public int TotalDone { get; set; }
        public int TotalNotDone { get; set; }
        public List<ToiletInspectionSummaryReport> ToiletInspReportList { get; set; }
    }
}
