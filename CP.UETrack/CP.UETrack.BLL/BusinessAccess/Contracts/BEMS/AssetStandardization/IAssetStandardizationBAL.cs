using CP.UETrack.Model;

namespace CP.UETrack.BLL.BusinessAccess.Interface
{
    public interface IAssetStandardizationBAL
    {
        AssetStandardizationLovs Load();
        AssetStandardization Save(AssetStandardization assetStandardization, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        AssetStandardization Get(int Id);
        void Delete(int Id, out string ErrorMessage);
    }
}
