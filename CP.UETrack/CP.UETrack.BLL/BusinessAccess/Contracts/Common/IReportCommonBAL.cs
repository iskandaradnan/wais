using System.Collections.Generic;

namespace CP.UETrack.BLL.BusinessAccess.Contract
{
    public interface IReportCommonBAL
    {
        dynamic GetReportData(string whereCondition, string viewModelName);
        string GetReportDataSet(string spName, Dictionary<string, string> parameters);
    }
}
