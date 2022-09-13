using CP.UETrack.Model.VM;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Contracts.VM
{
    public interface IVMDashboardDAL
    {
        VMDashboardTypeDropdown Load();
        VMDashboardModel Get(int Year);
        VMDashboardModel GetDate(int Year, int Month);
    }
}
