using CP.UETrack.Model.FetchModels;
using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.HWMS
{
   public class WeighingSummaryReport
   {
        public int Year { get; set; }
        public int Month { get; set; }
        public string WasteCategory { get; set; }
        public string ConsignmentNo { get; set; }
        public string TotalWeight { get; set; }
        public string NoofBins { get; set; }
        public string Date { get; set; }
        public List<WeighingSummaryReport> WeighingSummaryReportList { get; set; }

    }
}
