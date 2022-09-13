using CP.UETrack.Model;
using CP.UETrack.Model.LLS;

namespace CP.UETrack.BLL.BusinessAccess.Interface.LLS.Master
{
    public interface IDepartmentDetailsBAL
    {
        DepartmentDetailsModelLovs Load();
        DepartmentDetailsModel Save(DepartmentDetailsModel model, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        DepartmentDetailsModel Get(int Id/*, int pagesize, int pageindex*/);
        string CheckUserAreaCode(string Id);

       void Delete(int Id, out string ErrorMessage);
        DepartmentDetailsModel LinenItemSave(DepartmentDetailsModel model, out string ErrorMessage);
    }


}
