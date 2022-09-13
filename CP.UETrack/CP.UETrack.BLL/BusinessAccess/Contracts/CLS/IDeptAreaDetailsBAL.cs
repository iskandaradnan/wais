using CP.UETrack.Model;
using CP.UETrack.Model.CLS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.CLS
{
    public interface IDeptAreaDetailsBAL
    {
        DeptAreaDetailsDropdown Load();
        DeptAreaDetails Save(DeptAreaDetails userRole, out string ErrorMessage);
        Receptacles SaveRecp(Receptacles model, out string ErrorMessage);
        DailyCleaningSchedule SaveDailyClean(DailyCleaningSchedule dailyCleaning, out string ErrorMessage);
        PeriodicWorkSchedule SavePeriodicWork(PeriodicWorkSchedule _periodicWorkSchedule, out string ErrorMessage);
        List<Toilet> SaveToilet(List<Toilet> _lsttoilet, out string ErrorMessage);
        Dispenser SaveDispenser(Dispenser dispenser, out string ErrorMessage);
        List<VariationDetails> SaveVariationDetails(List<VariationDetails> _lstVariationDetails, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        DeptAreaDetails Get(int Id);
        DeptAreaDetails UserAreaCodeFetch(DeptAreaDetails deptArea);
        
    }
}
