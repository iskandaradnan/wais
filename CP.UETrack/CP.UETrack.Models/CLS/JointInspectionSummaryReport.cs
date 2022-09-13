using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Models;

namespace CP.UETrack.Model.CLS
{
   public class JointInspectionSummaryReport
   {
        public int Month { get; set; }
        public int Year { get; set; }        
        public int No { get; set; }
        public string UserAreaCode { get; set; }
        public string UserAreaName { get; set; }
        public int InspectionScheduled { get; set; }
        public int Compliance { get; set; }
        public int NonCompliance { get; set; }
        public int TotalRatings { get; set; }
        public int NoOfUserLocationsInspected { get; set; }
        public List<JointInspectionSummaryReport> JISummaryReportsList { get; set; }
   }
   
}
