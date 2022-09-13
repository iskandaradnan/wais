using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;

namespace CP.UETrack.DAL.DataAccess.Contracts.BEMS
{
    public interface IFacilityDAL
    {
        FacilityLovs Load();
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        void  Delete(int facilityId, out string ErrorMessage);
        MstLocationFacilityViewModel Get(int Customerid);
        MstLocationFacilityViewModel Save(MstLocationFacilityViewModel Cust);
        bool IsRecordModified(MstLocationFacilityViewModel Customer);
        bool IsFacilityCodeDuplicate(MstLocationFacilityViewModel facility);
        FacilityVariation AddVariation(FacilityVariation obj);
    }
}
