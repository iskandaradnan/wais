using CP.UETrack.Model;
using CP.UETrack.Model.LLS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Contracts.LLS
{
    public interface IDriverDetailsDAL
    {
        DriverDetailsModelLovs Load();
        DriverDetailsModel Save(DriverDetailsModel model, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        DriverDetailsModel Get(int Id);
        bool IsDriverCodeDuplicate(DriverDetailsModel userRole);
        bool IsRecordModified(DriverDetailsModel userRole);
        void Delete(int Id, out string ErrorMessage);
    }
}
 