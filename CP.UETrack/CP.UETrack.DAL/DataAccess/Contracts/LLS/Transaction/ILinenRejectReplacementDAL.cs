using CP.UETrack.Model;
using CP.UETrack.Model.LLS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Contracts.LLS.Transaction
{
   public interface ILinenRejectReplacementDAL
    {
        LinenRejectReplacementModel Load();
        LinenRejectReplacementModel Save(LinenRejectReplacementModel model, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        LinenRejectReplacementModel Get(int Id);
        bool IsLinenRejectReplacementDuplicate(LinenRejectReplacementModel model);
        bool IsRecordModified(LinenRejectReplacementModel model);
        void Delete(int Id, out string ErrorMessage);
    }
}
