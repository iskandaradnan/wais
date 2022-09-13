using CP.UETrack.Model;
using CP.UETrack.Model.LLS;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.LLS.Master
{
   public interface ICentralCleanLinenStoreBAL
    {
        CentralCleanLinenStoreModelLovs Load();
        CentralCleanLinenStoreModel Save(CentralCleanLinenStoreModel model, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        CentralCleanLinenStoreModel Get(int Id);
        void Delete(int Id, out string ErrorMessage);
    }
}
