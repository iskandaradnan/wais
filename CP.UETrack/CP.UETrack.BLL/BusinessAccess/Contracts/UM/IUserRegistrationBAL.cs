using CP.UETrack.Model;
using System.Collections.Generic;

namespace CP.UETrack.BLL.BusinessAccess.Interface
{
    public interface IUserRegistrationBAL
    {
        UserRegistrationLovs Load();
        UMUserRegistration Save(UMUserRegistration userRegistration, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        UMUserRegistration Get(int Id);
        void Delete(int Id, out string ErrorMessage);
        UserRegistrationLovs GetUserRoles(int Id);
        UserRegistrationLovs GetLocations(int Id);
        UserRegistrationLovs GetAllLocations();
        List<object> GetStaffNames();
    }
}
