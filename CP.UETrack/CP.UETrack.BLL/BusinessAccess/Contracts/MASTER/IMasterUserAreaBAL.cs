using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.MASTER
{
    public interface IMasterUserAreaBAL
    {
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        void Delete(int Id, out string ErrorMessage);
        MstLocationUserAreaViewModel Get(int Id);
        MstLocationUserAreaViewModel Save(MstLocationUserAreaViewModel model, out string ErrorMessage);
        AreaLovs Load(int id);
    }
}