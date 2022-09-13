using CP.UETrack.Model;
using CP.UETrack.Model.LLS;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.LLS.Master
{
   public  interface ILinenItemDetailsBAL
    {
        LinenItemDetailsModelLovs Load();
        LinenItemDetailsModel Save(LinenItemDetailsModel model, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        LinenItemDetailsModel Get(int Id);
        void Delete(int Id, out string ErrorMessage);
    }
}
