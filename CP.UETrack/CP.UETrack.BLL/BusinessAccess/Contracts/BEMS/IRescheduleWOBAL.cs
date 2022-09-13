using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.BEMS
{
   public  interface IRescheduleWOBAL
    {
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        RescheduleDropdownValues Load();
        void Delete(int RescheduleWOId);
        RescheduleWOViewModel Get(int RescheduleWOId);
        RescheduleWOViewModel Save(RescheduleWOViewModel Cust, out string ErrorMessage);
        RescheduleWOViewModel FetchWorkorder(RescheduleWOViewModel work);

    }
}
