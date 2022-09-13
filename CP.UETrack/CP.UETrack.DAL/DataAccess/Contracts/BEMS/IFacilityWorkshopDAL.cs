using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;

namespace CP.UETrack.DAL.DataAccess.Contracts.BEMS
{
    public interface IFacilityWorkshopDAL
    {
        FacilityWorkshopDropdown Load();
        FacilityWorkshop Save(FacilityWorkshop Facility, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        FacilityWorkshop Get(int Id, int pagesize, int pageindex);
        //bool IsRoleDuplicate(FacilityWorkshop Facility);
        bool IsRecordModified(FacilityWorkshop Facility);
        bool Delete(int Id);
    }
}
