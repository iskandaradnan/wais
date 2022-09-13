using CP.UETrack.Model.Common;
using System.Collections.Generic;
using System.Data;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.Common
{
    public interface IAsisReportBLL
    {
        AsisReportViewModel ExecuteDataSet(AsisReportViewModel rVM);
        AsisReportViewModel GetDataTableForDdl(AsisReportViewModel rVM);
        AsisReportViewModel GetSqlParmsList(AsisReportViewModel rVM);
    }
}
