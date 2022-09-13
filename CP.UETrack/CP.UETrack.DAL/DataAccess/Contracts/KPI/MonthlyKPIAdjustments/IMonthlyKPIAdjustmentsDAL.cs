using CP.UETrack.Model;
using System.Collections.Generic;

namespace CP.UETrack.DAL.DataAccess
{
    public interface IMonthlyKPIAdjustmentsDAL
    {
        MonthlyKPIAdjustmentsLovs Load();
        MonthlyKPIAdjustments Save(MonthlyKPIAdjustments monthlyKPIAdjustments, out string ErrorMessage);
        List<MonthlyKPIAdjustmentFetchResult> FetchRecords(MonthlyKPIAdjustments monthlyKPIAdjustments, out string ErrorMessage);
        List<KPIGenerationDemertis> GetPostDemeritPoints(KPIGenerationFetch KpiGenerationFetch);
    }
}