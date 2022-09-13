using CP.UETrack.Model;
using CP.UETrack.Model.LLS;

namespace CP.UETrack.BLL.BusinessAccess.Interface.LLS.Transaction
{
    public interface ILinenRejectReplacementBAL
    {
        LinenRejectReplacementModel Load();
        LinenRejectReplacementModel Save(LinenRejectReplacementModel model, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        LinenRejectReplacementModel Get(int Id);
        void Delete(int Id, out string ErrorMessage);
    }

    
}
