using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;

namespace CP.UETrack.DAL.DataAccess.Contracts.BEMS
{
    public  interface IAssetClassificationDAL
    {
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        GridFilterResult GetAll( SortPaginateFilter pageFilter, int Id);
        GridFilterResult GetAllFEMS(SortPaginateFilter pageFilter);
        AssetClassificationLovs Load();
        void  Delete(int Id, out string ErrorMessage);
        EngAssetClassification Get(int Id);
        EngAssetClassification SaveUpdate(EngAssetClassification model);
        bool IsClassificationCodeDuplicate(EngAssetClassification model);
        bool IsRecordModified(EngAssetClassification model);
    }
}
