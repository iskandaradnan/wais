using CP.UETrack.Model;

namespace CP.UETrack.BLL.BusinessAccess.Interface
{
    public interface IAssetInformationBAL
    {
        BlockFacilityDropdown Load();
        AssetInformationViewModel Save(AssetInformationViewModel userRole, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        AssetInformationViewModel Get(int Id, int AssetInfoType);
        void Delete(int Id, int AssetInfoType);
    }
}
