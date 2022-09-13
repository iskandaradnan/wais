using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using CP.UETrack.Model.ICT;
using System.Collections.Generic;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.BEMS
{
    public interface IScheduleGenerationBAL
    {
        ScheduleGenerationLovs Load();
        bool Delete(int Id);
        ScheduleGenerationModel Get(int Id);
        List<workorde_week> getby_year(int Id,int WorkGroup, int week, int serviceId, int typeofplanner);
        
        ScheduleGenerationModel Fetch(int Service, int WorkGroup, int Year, string TOP, string StartDate, string EndDate, int WeekNo, string Type, string UserAreaId, string UserLocationId, int pagesize, int pageindex);
        ScheduleGenerationModel GetWeekNo(int Service, int WorkGroup, int Year, int TOP);
        ScheduleGenerationModel Save(ScheduleGenerationModel model, out string ErrorMessage);
       // GridFilterResult GetAll(SortPaginateFilter paginationFilter);

        List<EngScheduleGenerationFileJobViewModel> GetPrintList(EngPpmScheduleGenTxnViewModel schedule);
        List<EngPpmPrintlist> PrintPDF(EngPpmScheduleGenTxnViewModel schedule);
    }
}
