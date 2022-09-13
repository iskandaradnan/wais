using CP.UETrack.Model;
using CP.UETrack.Model.LLS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Contracts.LLS.Transaction
{
    public interface ILinenCondemnationDAL

    {
        LinenConemnationModelLovs Load();
        LinenConemnationModel Save(LinenConemnationModel model, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        LinenConemnationModel Get(int Id);
        bool IsRecordModified(LinenConemnationModel model);
        bool IsLinenCondemnationCodeDuplicate(LinenConemnationModel model);
        void Delete(int Id, out string ErrorMessage);
    }
}
