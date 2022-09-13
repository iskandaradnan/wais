using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.Common
{
    public class AsisReportViewModel
    {
        public string connectionStringName { get; set; }
        public CommandType commandType { get; set; }
        public string spName { get; set; }
        public Dictionary<string, object> sqlDictParams { get; set; }
        public DataTable dt { get; set; }
        public string columnName { get; set; }
        public List<string> paraValue { get; set; }
    }
}
