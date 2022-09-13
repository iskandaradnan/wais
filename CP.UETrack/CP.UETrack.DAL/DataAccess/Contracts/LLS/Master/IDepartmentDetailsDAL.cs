using CP.UETrack.Model;
using CP.UETrack.Model.LLS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Contracts.LLS
{
   public interface IDepartmentDetailsDAL
    {
        DepartmentDetailsModelLovs Load();
        DepartmentDetailsModel Save(DepartmentDetailsModel model, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        DepartmentDetailsModel Get(int Id/*, int pagesize, int pageindex*/);
        void Delete(int Id, out string ErrorMessage);
        bool IsUserAreaDuplicate(DepartmentDetailsModel model);
        bool IsRecordModified(DepartmentDetailsModel model);
        bool AreAllLocationsInactive(int userAreaId);
        DepartmentDetailsModel LinenItemSave(DepartmentDetailsModel model, out string ErrorMessage);
        
    }
}
