using CP.UETrack.Model;
using CP.UETrack.Model.LLS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Contracts.LLS
{
   public interface ICleanLinenDespatchDAL
    {
        CleanLinenDespatchModelLovs Load();
        CleanLinenDespatchModel Save(CleanLinenDespatchModel model, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        CleanLinenDespatchModel Get(int Id);
        bool IsCleanLinenDespatchDuplicate(CleanLinenDespatchModel model);
        bool IsRecordModified(CleanLinenDespatchModel model);
        void Delete(int Id, out string ErrorMessage);
    }
}
