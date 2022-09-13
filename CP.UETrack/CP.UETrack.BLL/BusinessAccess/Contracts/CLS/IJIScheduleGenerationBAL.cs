using CP.UETrack.Model.CLS;
using CP.UETrack.Model;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.CLS
{
    public interface IJIScheduleGenerationBAL
    {
        JIDropdowns Load();
        JIDropdowns GetYear();
        JIDropdowns GetMonth(int Year);
        JIDropdowns GetWeek(string YearMonth);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        JIScheduleGeneration Get(int Id);
        JIScheduleGeneration UserFetch(JIScheduleGeneration jISchedule);
        JIScheduleGeneration Save(JIScheduleGeneration userRole, out string ErrorMessage);
       
    }
}
