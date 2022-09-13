using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Models;

namespace CP.UETrack.Model.CLS
{
   public class PeriodicWorkRecordSummaryReport
    {
        public int Month { get; set; }
        public int Year { get; set; }                
        public string UserAreaCode { get; set; }
        public string UserArea { get; set; }
        public string Done { get; set; }
        public string NotDone { get; set; }   
        public List<PeriodicWorkRecordSummaryReport> PeriodicWorkRecordSummaryReportsList { get; set; }
    }
}
