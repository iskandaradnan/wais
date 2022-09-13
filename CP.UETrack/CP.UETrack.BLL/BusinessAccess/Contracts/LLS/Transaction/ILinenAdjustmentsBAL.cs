using CP.UETrack.Model;
using CP.UETrack.Model.LLS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.LLS.Transaction
{
   public interface ILinenAdjustmentsBAL
    {
        LinenAdjustmentsModelLovs Load();
        LinenAdjustmentsModel Save(LinenAdjustmentsModel model, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        LinenAdjustmentsModel Get(int Id);
        void Delete(int Id, out string ErrorMessage);
    }
}
