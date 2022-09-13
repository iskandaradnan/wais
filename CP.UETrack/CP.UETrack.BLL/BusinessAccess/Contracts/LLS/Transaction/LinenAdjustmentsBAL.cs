using CP.UETrack.Model;
using CP.UETrack.Model.LLS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.LLS.Transaction
{
   public  interface LinenAdjustmentsBAL
    {
        CleanLinenDespatchModelLovs Load();
        CleanLinenDespatchModel Save(LinenAdjustmentsModel model, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        CleanLinenDespatchModel Get(int Id);
        void Delete(int Id, out string ErrorMessage);
    }
}
