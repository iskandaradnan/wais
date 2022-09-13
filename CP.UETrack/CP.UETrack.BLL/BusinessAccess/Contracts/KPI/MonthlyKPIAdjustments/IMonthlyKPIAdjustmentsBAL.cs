using CP.UETrack.Model;
using System.Collections.Generic;

namespace CP.UETrack.BLL.BusinessAccess.Interface
{
    public interface IMonthlyKPIAdjustmentsBAL
    {
        MonthlyKPIAdjustmentsLovs Load();
        MonthlyKPIAdjustments Save(MonthlyKPIAdjustments monthlyKPIAdjustments, out string ErrorMessage);
        List<MonthlyKPIAdjustmentFetchResult> FetchRecords(MonthlyKPIAdjustments monthlyKPIAdjustments, out string ErrorMessage);
        List<KPIGenerationDemertis> GetPostDemeritPoints(KPIGenerationFetch KpiGenerationFetch);
    }
}
