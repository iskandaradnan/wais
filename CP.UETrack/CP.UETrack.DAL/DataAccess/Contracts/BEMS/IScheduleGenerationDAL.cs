using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using CP.UETrack.Model.ICT;
using System.Collections.Generic;

namespace CP.UETrack.DAL.DataAccess.Contracts.BEMS
{
    public interface IScheduleGenerationDAL
    {       
        ScheduleGenerationLovs Load();
        bool Delete(int Id);
        ScheduleGenerationModel Get(int Id);
        List<workorde_week> getby_year(int Id,int WorkGroup, int week, int serviceId, int typeofplanner);
        ScheduleGenerationModel Save(ScheduleGenerationModel model);
        ScheduleGenerationModel Fetch(int Service, int WorkGroup, int Year, string TOP, string StartDate, string EndDate, int WeekNo, string Type, string UserAreaId, string UserLocationId, int pagesize, int pageindex);
        ScheduleGenerationModel GetWeekNo(int Service, int WorkGroup, int Year, int TOP);

        bool IsRecordModified(ScheduleGenerationModel model);

        List<EngScheduleGenerationFileJobViewModel> GetPrintList(EngPpmScheduleGenTxnViewModel schedule);
        List<EngPpmPrintlist> PrintPDF(EngPpmScheduleGenTxnViewModel schedule);
    }
}
