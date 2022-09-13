using CP.UETrack.Model.CLS;
using CP.UETrack.Model;
using System.Collections.Generic;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.CLS
{
    public interface IWeekCalendarBAL
    {
        WeekCalendar Save(List<WeekCalendar> lstWeekCalendar, out string ErrorMessage);
        List<WeekCalendar> LoadStartDateEndDate(WeekCalendar model, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        List<WeekCalendar> Get(WeekCalendar model);
    }
}
