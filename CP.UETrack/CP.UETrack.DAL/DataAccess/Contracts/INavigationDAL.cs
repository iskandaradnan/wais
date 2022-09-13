namespace CP.UETrack.DAL.DataAccess
{
    using CP.UETrack.Model;
    using System;
    using System.Collections.Generic;

    public interface INavigationDAL
    {
        List<Menus> GetAllMenuItems();
        List<UserActionPermissions> ActionPermissionCachedData();
        UserDetailsModel GetThemeColor();
    }
}


