using CP.UETrack.Model;
namespace CP.UETrack.DAL.DataAccess
{
    public interface IFEMSBlockDAL
    {
        BlockFacilityDropdown Load();
        BlockMstViewModel Save(BlockMstViewModel block, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        BlockMstViewModel Get(int Id);
        bool IsBlockCodeDuplicate(BlockMstViewModel userRole);
        bool IsRecordModified(BlockMstViewModel userRole);
        void Delete(int Id, out string ErrorMessage);
    }
}


