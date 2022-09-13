using CP.UETrack.Model;

namespace CP.UETrack.BLL.BusinessAccess.Interface
{
    public interface ILevelBAL
    {
        LevelFacilityBlockDropdown Load();
        LevelMstViewModel Save(LevelMstViewModel userRole, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        LevelMstViewModel Get(int Id);
        LevelFacilityBlockDropdown GetBlockData(int levelFacilityId);
        void Delete(int Id);
    }
   
}
