using CP.UETrack.Model;
using CP.UETrack.Model.VM;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Contracts.VM
{
   public interface IVMMonthClosingDAL
    {
        MCLovEntity Load();
        FetchMonthClosingDetails Get(FetchMonthClosingDetails entity);
        VMMonthClosingEntity MonthClose(VMMonthClosingEntity Entity);
        GridFilterResult Getall(GetallEntity pageFilter);
    }
}
