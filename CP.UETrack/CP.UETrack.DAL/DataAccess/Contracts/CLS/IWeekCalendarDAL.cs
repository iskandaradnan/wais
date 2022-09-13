using CP.UETrack.Model;
using CP.UETrack.Model.CLS;
using System.Collections.Generic;

namespace CP.UETrack.DAL.DataAccess.Contracts.CLS
{
    public interface IWeekCalendarDAL
    {
        WeekCalendar Save(List<WeekCalendar> lstWeekCalender, out string ErrorMessage);

        List<WeekCalendar> LoadStartDateEndDate(WeekCalendar model, out string ErrorMessage);

        GridFilterResult GetAll(SortPaginateFilter pageFilter);

        List<WeekCalendar> Get(WeekCalendar model);
    }
}
