using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.Common
{
    public class RptReportMultiParameters
    {
        public int MultiParameId { get; set; }
        public string ReportKeyId { get; set; }
        public int LevelKeyId { get; set; }
        public int ParamKeyId { get; set; }
        public int MultiParamKeyId { get; set; }
        public string ParentSpName { get; set; }
        public string MultiParamConditionName { get; set; }
        public string MultiParamConditionValue { get; set; }
        public Nullable<bool> HasSessionValue { get; set; }
        public string SessionProperty { get; set; }
    }
}
