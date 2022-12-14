using CP.UETrack.Model.QAP;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.QAP
{
    public interface IQAPDashboardBAL
    {
        QAPDashboardTypeDropdown Load();
        QAPDashboardModel Get(int Year);
        QAPDashboardModel GetLineChart(int Month);
    }
}
