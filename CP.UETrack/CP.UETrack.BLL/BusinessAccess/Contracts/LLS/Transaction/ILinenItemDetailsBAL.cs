using CP.UETrack.Model;
using CP.UETrack.Model.LLS;

namespace CP.UETrack.BLL.BusinessAccess.Interface.LLS.Transaction
{
    public interface ILinenItemDetailsBAL
    {
        LinenItemDetailsModelLovs Load();
        LinenItemDetailsModel Save(LinenItemDetailsModel model, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        LinenItemDetailsModel Get(int Id);
        void Delete(int Id, out string ErrorMessage);
    }

    
}
