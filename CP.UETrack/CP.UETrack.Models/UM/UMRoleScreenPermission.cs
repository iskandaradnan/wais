using CP.UETrack.Models;
using System;
using System.Collections.Generic;

namespace CP.UETrack.Model
{
    public class UMRoleScreenPermission
    {
        public int ScreenRoleId { get; set; }
        public int ScreenId { get; set; }
        public int UMUserRoleId { get; set; }
        public string Permissions { get; set; }
        public string Timestamp { get; set; }
        public string ScreenDescription { get; set; }
        public string ScreenPermissions { get; set; }
    }
    public class RoleScreenPermissions
    {
        public List<UMRoleScreenPermission> roleScreenPermissions { get; set; }
    }
    public class UserRoleType
    {
        public int LovId { get; set; }
        public string FieldValue { get; set; }
        public int UserTypeId { get; set; }
        public string UserType { get; set; }
    }
}
