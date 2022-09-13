using System.Collections.Generic;

namespace CP.UETrack.DAL.DataAccess.Contracts.Common
{
    public interface IReportCommonDAL
    {
        dynamic GetReportData(string whereCondition, string viewModelName);
        string GetReportDataSet(string spName, Dictionary<string, string> parameters);
    }
}
