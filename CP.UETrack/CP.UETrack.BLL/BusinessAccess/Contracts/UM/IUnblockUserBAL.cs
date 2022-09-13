using CP.UETrack.Model;
using System.Collections.Generic;

namespace CP.UETrack.BLL.BusinessAccess.Interface
{
    public interface IUnblockUserBAL
    {
        UserRegistrationLovs Load();
        bool Save(int UserRegistrationId, out string ErrorMessage);
        bool BlockingList(string userRegistration);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        UMUserRegistration Get(int Id);
        void Delete(int Id);
        UserRegistrationLovs GetUserRoles(int Id);
        UserRegistrationLovs GetLocations(int Id);
       
    }
}
