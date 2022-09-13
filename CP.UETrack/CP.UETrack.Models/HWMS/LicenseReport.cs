using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CP.UETrack.Model.HWMS
{
    public class LicenseReport
    {        
        public string LicenseNo { get; set; }
        public string LicenseDescription { get; set; }
        public string LicenseType { get; set; }
        public List<LicenseReport> LicenseReportList { get; set; }

    }

    public class ReportsDropdown
    {
        public List<LovValue> YearLovs { get; set; }
        public List<LovValue> MonthLovs { get; set; }
        public List<LovValue> RequestType  { get; set; }
        public List<LovValue> WasteCategory { get; set; }
    }
}