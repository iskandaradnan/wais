using CP.UETrack.Model;
using CP.UETrack.Model.LLS;

namespace CP.UETrack.BLL.BusinessAccess.Interface.LLS.Transaction
{
    public interface ICleanLinenDespatchBAL
    {
        CleanLinenDespatchModelLovs Load();
        CleanLinenDespatchModel Save(CleanLinenDespatchModel model, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        CleanLinenDespatchModel Get(int Id);
        void Delete(int Id, out string ErrorMessage);
    }

    
}
