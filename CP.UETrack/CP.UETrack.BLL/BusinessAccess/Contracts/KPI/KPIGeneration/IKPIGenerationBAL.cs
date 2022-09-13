
using CP.UETrack.Model;
using System.Collections.Generic;

namespace CP.UETrack.BLL.BusinessAccess.Interface
{
    public interface IKPIGenerationBAL
    {
        KPIGenerationLovs Load();
        MonthlyServiceFeeFetch GetMonthlyServiceFee(MonthlyServiceFeeFetch serviceFeeFetch);
        KPIGeneration Save(KPIGeneration kpiGeneration, out string ErrorMessage);
        GridFilterResult GetAll(KPIGenerationFetch kpiGenerationFetch);
        List<KPIGenerationRecord> GetAllRecords(KPIGenerationFetch kpiGenerationFetch);
        List<KPIGenerationDemertis> GetDemeritPoints(KPIGenerationFetch KpiGenerationFetch);
        List<KPIGenerationDemertis> GetDeductionValues(KPIGenerationFetch KpiGenerationFetch);
        void Delete(int Id);
    }
}
