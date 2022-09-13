namespace CP.UETrack.Model
{
    public class UserActionPermissions
    {
        public int userRegistrationId { get; set; }
        public string UserName { get; set; }
        public int UMUserRoleId { get; set; }
        public string UserRoleName { get; set; }
        public int ScreenPageId { get; set; }
        public string ControllerName { get; set; }
        public int ActionPermissionId { get; set; }
        public string ActionPermissionName { get; set; }
        public int FacilityId { get; set; }
        public int Moduleid { get; set; }
        public string ModuleName { get; set; }
    }
    public class ScreenPermissions
    {
        public int ActionPermissionId { get; set; }
        public string ActionPermissionName { get; set; }
        public int ScreenPageId { get; set; }
        public string UserRoleName { get; set; }
    }
}

