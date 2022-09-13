using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.BEMS
{
    public interface IUserLocationBAL
    {
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        void Delete(int Id, out string ErrorMessage);
        MstLocationUserLocation Get(int Id);
        MstLocationUserLocation Save(MstLocationUserLocation model, out string ErrorMessage);

        MstLocationUserLocationLovs Load(int Id);

    }
}
