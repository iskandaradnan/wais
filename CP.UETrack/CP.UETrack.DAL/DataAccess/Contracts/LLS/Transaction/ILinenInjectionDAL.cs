using CP.UETrack.Model;
using CP.UETrack.Model.LLS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Contracts.LLS.Transaction
{
   public interface ILinenInjectionDAL
    {
        LinenInjectionModel Load();
        LinenConemnationModel Save(LinenConemnationModel model, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        LinenInjectionModel Get(int Id);
        bool IsLinenInjectionDuplicate(LinenConemnationModel model);
        bool IsRecordModified(LinenInjectionModel userRole);
        void Delete(int Id, out string ErrorMessage);
    }
}
