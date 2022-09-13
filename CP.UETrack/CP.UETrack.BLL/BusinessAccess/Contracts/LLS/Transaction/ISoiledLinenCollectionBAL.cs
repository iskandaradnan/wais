using CP.UETrack.Model;
using CP.UETrack.Model.LLS;


namespace CP.UETrack.BLL.BusinessAccess.Contracts.LLS.Transaction
{
    public interface ISoiledLinenCollectionBAL
    {
        SoiledLinenCollectionModelLovs Load();
        soildLinencollectionsModel Save(soildLinencollectionsModel model, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        //soildLinencollectionsModel GetBySchedule(soildLinencollectionsModel model, out string ErrorMessage);
        soildLinencollectionsModel Get(int Id);
        //soildLinencollectionsModel GetBy(soildLinencollectionsModel model);
        void Delete(int Id, out string ErrorMessage);
    }


}
