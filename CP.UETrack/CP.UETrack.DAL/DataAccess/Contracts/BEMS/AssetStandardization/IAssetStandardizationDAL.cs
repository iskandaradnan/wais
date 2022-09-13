using CP.UETrack.Model;

namespace CP.UETrack.DAL.DataAccess
{
    public interface IAssetStandardizationDAL
    {
        AssetStandardizationLovs Load();
        AssetStandardization Save(AssetStandardization assetStandardization, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        AssetStandardization Get(int Id);
        void Delete(int Id, out string ErrorMessage);
        bool IsManufacturerModelDuplicate(AssetStandardization assetStandardization);
        bool IsManufacturerDuplicate(AssetStandardization assetStandardization);
        bool IsModelDuplicate(AssetStandardization assetStandardization);
    }
}