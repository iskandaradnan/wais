using CP.UETrack.Model;
using CP.UETrack.Model.LLS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Contracts.LLS.Transaction
{
   public interface ILinenRepairDAL
    {
        LinenRepairModel Load();
        LinenRepairModel Save(LinenRepairModel model, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        LinenRepairModel Get(int Id);

        bool IsLinenRepairDuplicate(LinenRepairModel userRole);
        bool IsRecordModified(LinenRepairModel userRole);
        void Delete(int Id, out string ErrorMessage);
    }
}
