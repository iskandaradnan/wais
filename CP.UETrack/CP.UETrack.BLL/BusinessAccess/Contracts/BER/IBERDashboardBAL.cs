using CP.UETrack.Model.BER;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.BER
{
    public interface IBERDashboardBAL
    {
        BERDashboard Load();
        BERDashboard LoadGrid(int pagesize, int pageindex);
    }
}
