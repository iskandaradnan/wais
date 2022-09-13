using CP.UETrack.Model;
using CP.UETrack.Model.HWMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.HWMS
{
    public interface IDailyTemperatureLogBAL
    {
        DailyDropDowns Load();
        DailyTemperatureLog Save(DailyTemperatureLog userRole, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        DailyTemperatureLog Get(int Id);
        DailyTemperatureLog Get(string YearMonth);
    }
}
