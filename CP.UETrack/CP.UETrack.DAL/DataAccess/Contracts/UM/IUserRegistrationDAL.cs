using CP.UETrack.Model;
using CP.UETrack.Models;
using System;
using System.Collections.Generic;
namespace CP.UETrack.DAL.DataAccess
{
    public interface IUserRegistrationDAL
    {
        UserRegistrationLovs Load();
        UMUserRegistration Save(UMUserRegistration userRegistration);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        UMUserRegistration Get(int Id);
        bool IsRecordModified(UMUserRegistration userRegistration);
        bool IsUserNameDuplicate(UMUserRegistration userRegistration);
        bool IsEmailDuplicate(UMUserRegistration userRegistration);

        bool IsEmployeeIdDuplicate(UMUserRegistration userRegistration);
        bool IsNoOfUsersExceeds(int contractorId);
        void Delete(int Id, out string ErrorMessage);
        UserRegistrationLovs GetUserRoles(int Id);
        UserRegistrationLovs GetLocations(int Id);
        UserRegistrationLovs GetAllLocations();
        List<object> GetStaffNames();
    }
}


