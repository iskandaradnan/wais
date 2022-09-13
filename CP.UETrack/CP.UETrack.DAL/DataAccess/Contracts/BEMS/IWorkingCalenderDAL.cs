using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Contracts.BEMS
{
   public  interface IWorkingCalenderDAL
    {
        FMWorkingCalendarSelectListViewModel Load(int Year);
        IEnumerable<MstWorkingCalenderModel> GetWorkingDay(int intYear, int FacilityId);
        MstWorkingCalenderModel Save(MstWorkingCalenderModel WorkingCalendar);
    }
}
