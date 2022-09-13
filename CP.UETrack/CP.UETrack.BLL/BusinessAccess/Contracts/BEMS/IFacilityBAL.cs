using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.BEMS
{
    public  interface IFacilityBAL
    {
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        FacilityLovs Load();
        void Delete(int facilityId, out string ErrorMessage);
        MstLocationFacilityViewModel Get(int FacilityId);
        MstLocationFacilityViewModel Save(MstLocationFacilityViewModel Cust, out string ErrorMessage);
        FacilityVariation AddVariation(FacilityVariation obj);
    }
}
