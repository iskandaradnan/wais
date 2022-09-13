using UETrack.Application.Web.Helpers;
using CP.UETrack.Model;
using CP.Framework.Common.Logging;
using CP.Framework.Common.StateManagement;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using CP.UETrack.Model.Enum;

namespace CP.UETrack.Application.Web.Helper
{
    public static class AuthorizationServiceHelperNew
    {
        private static Log4NetLogger log = new Log4NetLogger();
        
        public static bool HasPermission(string controllerName, string actionName)
        {
            var isAuthorized = false;
            var cacheProvider = new DefaultCacheProvider();
            var userDetails = new SessionHelper().UserSession();
            var ActionPermissionItems = new List<UserActionPermissions>();

            var cacheName = CacheKey.UserRoleData.ToString() + "_" + userDetails.UserName;
            if (cacheProvider.Get(cacheName) as IEnumerable<UserActionPermissions> != null)
            {
                ActionPermissionItems = (cacheProvider.Get(cacheName) as IEnumerable<UserActionPermissions>).ToList();
            }
            var facilityId = userDetails.FacilityId;
            if (facilityId != 0)
            {
                ActionPermissionItems = (from AV in ActionPermissionItems.Where(s => s.ControllerName.ToLower() == controllerName.ToLower() 
                                         && s.FacilityId == facilityId && (s.ActionPermissionName.ToLower() == actionName.ToLower() || actionName == "Index"))
                              select new UserActionPermissions
                              {
                                  ActionPermissionId = AV.ActionPermissionId,
                                  ActionPermissionName = AV.ActionPermissionName
                              }).Distinct().ToList();
            }
            isAuthorized = ActionPermissionItems.Count > 0;
            return isAuthorized;
        }
    }
}
