using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.Common
{
    public class ReportEntity
    {
        public string BackToSpName { get; set; }
        public string ConnectionStringName { get; set; }
        public string CurrentReportHeading { get; set; }
        public int CurrentReportID { get; set; }
        public List<ReportDrill> DrillThroughEntity { get; set; }
        public string ExcelPath { get; set; }
        public List<ReportParameters> ParamEntity { get; set; }
        public string ParamSheetName { get; set; }
        public int ParentReportID { get; set; }
        public string SpName { get; set; }
        public string SpNameWithOutPrefix { get; set; }
        public SqlParameter[] SqlParamArray { get; set; }
    }
}
