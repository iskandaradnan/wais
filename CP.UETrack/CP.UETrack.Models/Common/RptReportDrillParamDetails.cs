using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.Common
{
    public class RptReportDrillParamDetails
    {
        public int DrillParamId { get; set; }
        public string ReportKeyId { get; set; }
        public int LevelKeyId { get; set; }
        public int DrillKeyId { get; set; }
        public int DrillParamKeyId { get; set; }
        public string DrillThroughColumnName { get; set; }
        public string ParentSpName { get; set; }
        public string DrillThroughParamName { get; set; }
        public Nullable<bool> IsFieldParam { get; set; }
        public Nullable<bool> IsDiffDrillParam { get; set; }
        public Nullable<bool> HasAliasName { get; set; }
        public string AliasName { get; set; }
    }
}
