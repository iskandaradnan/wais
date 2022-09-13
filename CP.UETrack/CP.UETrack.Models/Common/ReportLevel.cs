using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.Common
{
    public class ReportLevel
    {
        public int LevelId { get; set; }
        public string ReportKeyId { get; set; }
        public int LevelKeyId { get; set; }
        public Nullable<int> ParentLevelId { get; set; }
        public string SpName { get; set; }
        public string ReportDataSourceName { get; set; }
        public string ReportDataProvider { get; set; }
        public string ReportConnectionString { get; set; }
        public string QueryCommandText { get; set; }
        public Nullable<bool> IsReportHasParam { get; set; }
        public bool IsReportHasDrillThrough { get; set; }
        public string ReportPath { get; set; }
        public Nullable<bool> IsGenerated { get; set; }
        public string ReportHeading { get; set; }
    }
}
