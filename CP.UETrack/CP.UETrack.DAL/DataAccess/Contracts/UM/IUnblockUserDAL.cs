using CP.UETrack.Model;
using CP.UETrack.Models;
using System;
using System.Collections.Generic;
namespace CP.UETrack.DAL.DataAccess
{
    public interface IUnblockUserDAL
    {
        UserRegistrationLovs Load();
        bool Save(int UserRegistrationId);
        bool BlockingList(string userRegistration);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        UMUserRegistration Get(int Id);
        bool IsRecordModified(UMUserRegistration userRegistration);
        void Delete(int Id);
        UserRegistrationLovs GetUserRoles(int Id);
        UserRegistrationLovs GetLocations(int Id);
    }
}


