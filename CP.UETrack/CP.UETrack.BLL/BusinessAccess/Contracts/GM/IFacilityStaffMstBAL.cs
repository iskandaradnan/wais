using CP.UETrack.Model;

namespace CP.UETrack.BLL.BusinessAccess.Interface
{
    public interface IFacilityStaffMstBAL
    {
        FacilityStaffMstDropdown Load();
        StaffMstViewModel Save(StaffMstViewModel userRole, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        StaffMstViewModel Get(int Id);
        void Delete(int Id, out string ErrorMessage);
    }
}
