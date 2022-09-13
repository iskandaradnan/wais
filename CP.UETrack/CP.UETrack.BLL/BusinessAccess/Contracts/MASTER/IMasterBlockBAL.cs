using CP.UETrack.Model;

namespace CP.UETrack.BLL.BusinessAccess.Interface
{
    public interface IMasterBlockBAL
    {
        BlockFacilityDropdown Load();
        BlockMstViewModel Save(BlockMstViewModel userRole, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        BlockMstViewModel Get(int Id);
        void Delete(int Id, out string ErrorMessage);
    }
}
