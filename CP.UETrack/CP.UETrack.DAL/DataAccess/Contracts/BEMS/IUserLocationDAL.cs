using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;

namespace CP.UETrack.DAL.DataAccess.Contracts.BEMS
{
    public  interface IUserLocationDAL
    {
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        // AssetClassificationLovs Load();
        void Delete(int Id, out string ErrorMessage);
        MstLocationUserLocation Get(int Id);
        MstLocationUserLocation Save(MstLocationUserLocation model);
        bool IsUserLocationCodeDuplicate(MstLocationUserLocation model);
        bool IsRecordModified(MstLocationUserLocation model);
        MstLocationUserLocationLovs Load(int Id);
    }
}
