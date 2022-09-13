using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.BEMS
{
    public  interface IAssetClassificationBAL
    {
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        GridFilterResult GetAll(SortPaginateFilter pageFilter, int Id);
        GridFilterResult GetAllFEMS(SortPaginateFilter pageFilter);
        AssetClassificationLovs Load();
        void  Delete(int Id, out string ErrorMessage);
        EngAssetClassification Get(int Id);
        EngAssetClassification SaveUpdate(EngAssetClassification model, out string ErrorMessage);
     
    }
}
