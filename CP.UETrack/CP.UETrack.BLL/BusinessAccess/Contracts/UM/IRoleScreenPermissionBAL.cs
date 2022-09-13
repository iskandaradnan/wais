using CP.UETrack.Model;
using CP.UETrack.Models;
using System.Collections.Generic;

namespace CP.UETrack.BLL.BusinessAccess.Interface
{
    public interface IRoleScreenPermissionBAL
    {
        List<UserRoleType> GetUserRoles();
        List<UMRoleScreenPermission> Fetch(int RoleId, int ModuleId);
        bool Save(RoleScreenPermissions roleScreenPermissions, out string ErrorMessage);
        List<LovValue> GetModules(int UserTypeId);
    }
}
