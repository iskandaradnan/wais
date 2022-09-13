using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.MASTER
{
    public interface IMasterUserLocationBAL
    {
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        void Delete(int Id, out string ErrorMessage);
        MstLocationUserLocation Get(int Id);
        MstLocationUserLocation Save(MstLocationUserLocation model, out string ErrorMessage);

        MstLocationUserLocationLovs Load(int Id);

    }
}
