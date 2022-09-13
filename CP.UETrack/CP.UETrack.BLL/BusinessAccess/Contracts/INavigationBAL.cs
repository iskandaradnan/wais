namespace CP.UETrack.BLL.BusinessAccess.Interface
{
    using Model;
    using System.Collections.Generic;

    public interface INavigationBAL
    {
        List<Menus> GetAllMenuItems();
        List<UserActionPermissions> ActionPermissionCachedData();
        UserDetailsModel GetThemeColor();
    }
}
