using CP.UETrack.Model;
using CP.UETrack.Model.CLS;
using System.Collections.Generic;

namespace CP.UETrack.DAL.DataAccess.Contracts.CLS
{
    public interface IDeptAreaDetailsDAL
    {
        DeptAreaDetailsDropdown Load();

        DeptAreaDetails Save(DeptAreaDetails _deptAreaDetails, out string ErrorMessage);

        Receptacles SaveReceptacles(Receptacles _receptacles, out string ErrorMessage);

        DailyCleaningSchedule SaveDailyClean(DailyCleaningSchedule _dailyCleaning, out string ErrorMessage);

        PeriodicWorkSchedule SavePeriodicWork(PeriodicWorkSchedule _periodicWorkSchedule, out string ErrorMessage);

        List<Toilet> SaveToilet(List<Toilet> _lsttoilet, out string ErrorMessage);        

        Dispenser SaveDispenser(Dispenser _dispenser, out string ErrorMessage);

        List<VariationDetails> SaveVariationDetails(List<VariationDetails> _lstVariationDetails, out string ErrorMessage);

        GridFilterResult GetAll(SortPaginateFilter pageFilter);

        DeptAreaDetails Get(int Id);

        DeptAreaDetails UserAreaCodeFetch(DeptAreaDetails deptArea);

    }
}
