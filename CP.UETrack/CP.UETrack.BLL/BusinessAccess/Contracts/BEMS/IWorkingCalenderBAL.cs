using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.BEMS
{
    public interface IWorkingCalenderBAL
    {
        FMWorkingCalendarSelectListViewModel Load(int Year);
        IEnumerable<MstWorkingCalenderModel> GetWorkingDay(int intYear, int FacilityId);
        MstWorkingCalenderModel Save(MstWorkingCalenderModel WorkingCalendar, out string ErrorMessage);
    }
}
