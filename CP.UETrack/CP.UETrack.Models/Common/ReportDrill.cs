using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.Common
{
    public class ReportDrill
    {
        public int DrillThroughId { get; set; }
        public string ReportKeyId { get; set; }
        public int LevelKeyId { get; set; }
        public int DrillKeyId { get; set; }
        public string ParentSpName { get; set; }
        public Nullable<int> ParentSpRecordSetIndex { get; set; }
        public string DrillThroughColumnName { get; set; }
        public Nullable<bool> IsVisible { get; set; }
        public string DrillThroughReportName { get; set; }
        public Nullable<bool> IsDiffDrillParam { get; set; }
        public Nullable<bool> HasDrillParam { get; set; }
        public List<ReportDrillMultiParameters> ReportDrillMultiParameters { get; set; }
    }
}
