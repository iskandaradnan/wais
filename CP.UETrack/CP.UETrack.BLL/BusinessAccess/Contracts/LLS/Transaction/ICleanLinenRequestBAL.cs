using CP.UETrack.Model;
using CP.UETrack.Model.LLS;

namespace CP.UETrack.BLL.BusinessAccess.Interface.LLS.Transaction
{
    public interface ICleanLinenRequestBAL
    {
        CleanLinenRequestModelLovs Load();
        CleanLinenRequestModel Save(CleanLinenRequestModel model, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        CleanLinenRequestModel Get(int Id);
        void Delete(int Id, out string ErrorMessage);
    }

    
}
