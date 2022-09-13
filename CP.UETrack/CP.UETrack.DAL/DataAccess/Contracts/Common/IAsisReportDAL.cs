using CP.UETrack.Model.Common;
using System.Collections.Generic;
using System.Data;

namespace CP.UETrack.DAL.DataAccess.Contracts.Common
{
    public interface IAsisReportDAL
    {
        AsisReportViewModel ExecuteDataSet(AsisReportViewModel rVM);
        AsisReportViewModel GetDataTableForDdl(AsisReportViewModel rVM);
        AsisReportViewModel GetSqlParmsList(AsisReportViewModel rVM);
    }
}
