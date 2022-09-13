using CP.UETrack.Model;
using CP.UETrack.Model.LLS;

namespace CP.UETrack.BLL.BusinessAccess.Interface.LLS.Transaction
{
    public interface ILinenRepairBAL
    {
        LinenRepairModel Load();
        LinenRepairModel Save(LinenRepairModel model, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        LinenRepairModel Get(int Id);
        void Delete(int Id, out string ErrorMessage);
    }

    
}
