
using CP.UETrack.Model;
using CP.UETrack.Model.UM;
using CP.UETrack.Models;
using System;
using System.Collections.Generic;
namespace CP.UETrack.DAL.DataAccess
{
    public interface IRoleScreenPermissionDAL
    {
        List<UserRoleType> GetUserRoles();
        List<UMRoleScreenPermission> Fetch(int RoleId, int ModuleId);
        bool Save(RoleScreenPermissions roleScreenPermissions);
        List<LovValue> GetModules(int UserTypeId);
        bool IsUserRoleActive(int UserRoleId);
    }
}


