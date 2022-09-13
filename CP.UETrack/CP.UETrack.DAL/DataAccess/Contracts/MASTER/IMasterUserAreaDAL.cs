using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
namespace CP.UETrack.DAL.DataAccess
{
    public interface IMasterUserAreaDAL
    {
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        void Delete(int Id, out string ErrorMessage);
        MstLocationUserAreaViewModel Get(int Id);
        MstLocationUserAreaViewModel Save(MstLocationUserAreaViewModel model);
        bool IsUserAreaDuplicate(MstLocationUserAreaViewModel model);
        bool IsRecordModified(MstLocationUserAreaViewModel model);
        bool AreAllLocationsInactive(int userAreaId);
        AreaLovs Load(int id);
    }
}
