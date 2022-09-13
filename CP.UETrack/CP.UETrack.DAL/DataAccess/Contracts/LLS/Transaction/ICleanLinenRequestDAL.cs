using CP.UETrack.Model;
using CP.UETrack.Model.LLS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Contracts.LLS
{
   public interface ICleanLinenRequestDAL
    {
        CleanLinenRequestModelLovs Load();
        CleanLinenRequestModel Save(CleanLinenRequestModel model, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        CleanLinenRequestModel Get(int Id);
        bool IsUserAreaCodeDuplicate(CleanLinenRequestModel userRole);
        bool IsRecordModified(CleanLinenRequestModel userRole);
        void Delete(int Id, out string ErrorMessage);
    }
}
