using CP.UETrack.Model.KPI;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.KPI
{
    public interface IKPIDashboardBAL
    {
        KPIDashboardTypeDropdown Load();
        KPIDashboardModel Get(int Year);
        KPIDashboardModel GetDate(int Year, int Month);
    }
}
