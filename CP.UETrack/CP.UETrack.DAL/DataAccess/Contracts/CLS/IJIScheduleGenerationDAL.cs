using CP.UETrack.Model;
using CP.UETrack.Model.CLS;

namespace CP.UETrack.DAL.DataAccess.Contracts.CLS
{
    public interface IJIScheduleGenerationDAL
    {
        JIDropdowns Load();
        JIDropdowns GetYear();
        JIDropdowns GetMonth(int Year);
        JIDropdowns GetWeek(string YearMonth);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        JIScheduleGeneration Get(int Id);
        JIScheduleGeneration UserFetch(JIScheduleGeneration jISchedule);
        JIScheduleGeneration Save(JIScheduleGeneration block, out string ErrorMessage);
      
        

    
    }
}
