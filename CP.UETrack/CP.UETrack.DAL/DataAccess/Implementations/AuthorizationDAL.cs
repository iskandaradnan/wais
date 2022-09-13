using CP.Framework.Data;
using CP.UETrack.DAL.Model;
using CP.UETrack.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;

namespace CP.UETrack.DAL.DataAccess
{
    public class AuthorizationDAL : IAuthorizationDAL
    {
        #region "Public variable declaration"

        Log4NetLogger log = new Log4NetLogger();

        #endregion
        public AuthorizationDAL()
        {

        }
        public AuthUser GetDatabaseUserRolesPermissions(AuthUser authuser)
        {
            throw new NotImplementedException();
        }

        public AuthenticatedUser GetDatabaseUserRolesPermissions(AuthenticatedUser authenticatedUser)
        {
            try
            {
                //using (var context = new ASISWebDatabaseEntities())
                //{
                //    var userReg = context.AsisUserRegistrations.
                //                             FirstOrDefault(u => u.UserName == authenticatedUser.Username && !u.IsDeleted);

                //    var userRegistrationId = userReg.UserRegistrationId;

                //    if (userReg.UserTypeId == 3156)
                //        authenticatedUser.isBPK = true;

                //    if (userReg.UserTypeId == 3157)
                //        authenticatedUser.isStateEngr = true;

                //    var roleMappingsListEntity = (from n in context.AsisUserLocationMstDets
                //                                  where n.UserRegistrationId == userRegistrationId
                //                                  && !n.IsDeleted
                //                                  select new UserRoleMapping
                //                                  {
                //                                      UserId = userRegistrationId,
                //                                      RoleId =  (int)n.UserRoleId,
                //                                      HospitalId = n.HospitalId
                //                                  }).ToList();

                //    var actionList = (from n in context.UMActions
                //                      where !n.IsDeleted
                //                      orderby n.ActionPermissionId
                //                      select new 
                //                      {
                //                          ActionPermissionId = n.ActionPermissionId,
                //                          Name = n.Name
                //                      }).ToList();

                //    var distinctUserRoles = (from n in context.AsisUserLocationMstDets
                //                             where n.UserRegistrationId == userRegistrationId
                //                             && !n.IsDeleted
                //                             select n.UserRoleId).Distinct().ToList();

                //    var roleScreenPermissions = (from n in context.UMRoleScreenPermissions
                //                                  join m in context.UMMenus
                //                                  on n.ScreenPageId equals m.MenuId
                //                                  join o in context.AsisServices
                //                                  on m.ServiceID equals o.ServiceID
                //                                  where !n.IsDeleted && !m.IsDeleted &&
                //                                  distinctUserRoles.Contains(n.UMUserRoleId)
                //                                  select new RoleScreenPermissionMapping
                //                                  {
                //                                      RoleId = n.UMUserRoleId,
                //                                      ScreenId = n.ScreenPageId,
                //                                      ControllerName = m.ControllerName,
                //                                      ServiceKey = o.ServiceKey,
                //                                      Permissions = n.Permissions,
                //                                      PageURL = m.PageURL
                //                                  }).Distinct().ToList();

                //    //authenticatedUser.ActionList = actionList;
                //    authenticatedUser.RoleScreenPermissions = roleScreenPermissions;
                //    authenticatedUser.UserRoles = roleMappingsListEntity;

                //    //var roleMappingList = new List<UserRoleMapping>();
                //    //UserRoleMapping roleMapping;
                //    ////var i = 0;

                //    //foreach (var roleMap in roleMappingsListEntity)
                //    //{
                //    //    //i++;

                //    //    var roleScreenMappingList1 = (from n in context.UMRoleScreenPermissions
                //    //                                  join m in context.UMMenus
                //    //                                  on n.ScreenPageId equals m.MenuId
                //    //                                  join o in context.AsisServices
                //    //                                  on m.ServiceID equals o.ServiceID
                //    //                                  where !n.IsDeleted && !m.IsDeleted &&
                //    //                                  n.UMUserRoleId == roleMap.RoleId
                //    //                                  select new RoleScreenPermissionMapping
                //    //                                  {
                //    //                                      RoleId = n.UMUserRoleId,
                //    //                                      ScreenId = n.ScreenPageId,
                //    //                                      ControllerName = m.ControllerName,
                //    //                                      ServiceKey = o.ServiceKey,
                //    //                                      Permissions = n.Permissions,
                //    //                                      PageURL = m.PageURL
                //    //                                  }).Distinct().ToList();

                //    //    var roleScreenMappingList = new List<RoleScreenPermissionMapping>();
                //    //    foreach (var screen in roleScreenMappingList1)
                //    //    {
                //    //        var permissions = screen.Permissions.ToCharArray();
                //    //        for (int i = 0; i < actionList.Count(); i++)
                //    //        {
                //    //            if (i < permissions.Length)
                //    //                if (permissions[i] == '1')
                //    //                {
                //    //                    roleScreenMappingList.Add(new RoleScreenPermissionMapping
                //    //                    {
                //    //                        RoleId = screen.RoleId,
                //    //                        ScreenId = screen.ScreenId,
                //    //                        ControllerName = screen.ControllerName,
                //    //                        ServiceKey = screen.ServiceKey,
                //    //                        Permissions = actionList[i].Name,
                //    //                        PageURL = screen.PageURL
                //    //                    });
                //    //                    //break;
                //    //                }
                //    //        }
                //    //    }

                //    //    roleMapping = new UserRoleMapping
                //    //    {
                //    //        RoleId = (int)roleMap.RoleId,
                //    //        HospitalId = roleMap.HospitalId,
                //    //        UserId = userRegistrationId,
                //    //        RoleScreenPermission = roleScreenMappingList
                //    //    };
                //    //    roleMappingList.Add(roleMapping);
                //    //}
                //    //authenticatedUser.UserRoles = roleMappingList;
                //}
            }
            catch (Exception ex)
            {
                log.LogMessage("An error has occured because of exception", Level.Info);
                throw new DALException(ex);
            }

            return null;
        }

        //public AuthenticatedUser GetDatabaseUserRolesPermissions(AuthenticatedUser authenticatedUser)
        //{
        //    try
        //    {
        //        using (var context = new ASISWebDatabaseEntities())
        //        {
        //            var userReg = context.AsisUserRegistrations.
        //                                     FirstOrDefault(u => u.UserName == authenticatedUser.Username && !u.IsDeleted);

        //            var userRegistrationId = userReg.UserRegistrationId;
        //            var isSysAdmin = false;// userReg.IsSystemUser;

        //            if (isSysAdmin == true)
        //            {
        //                var allScreenPages = (from n in context.UMMenus
        //                                      join m in context.AsisServices
        //                                      on n.ServiceID equals m.ServiceID
        //                                      where !n.IsDeleted && n.PageURL != null
        //                                      select new
        //                                      {
        //                                          ScreenId = n.MenuId,
        //                                          ControllerName = n.ControllerName,
        //                                          ServiceKey1 = m.ServiceKey
        //                                      }).ToList();

        //                var roleScreenMappingList = new List<RoleScreenPermissionMapping>();

        //                foreach (var screenPage in allScreenPages)
        //                {
        //                    roleScreenMappingList.Add(new RoleScreenPermissionMapping
        //                    {
        //                        RoleId = 0,
        //                        ScreenId = screenPage.ScreenId,
        //                        ControllerName = screenPage.ControllerName,
        //                        ServiceKey = screenPage.ServiceKey1
        //                    });
        //                }
        //                var roleMappingList = new List<UserRoleMapping>();

        //                roleMappingList.Add(new UserRoleMapping
        //                {
        //                    RoleId = 0,
        //                    UserId = userRegistrationId,
        //                    RoleScreenPermission = roleScreenMappingList
        //                });

        //                authenticatedUser.UserRoles = roleMappingList;
        //                authenticatedUser.IsSysAdmin = true;
        //            }
        //            else
        //            {
        //                if (userReg.UserTypeId == 3156)
        //                    authenticatedUser.isBPK = true;

        //                if (userReg.UserTypeId == 3157)
        //                    authenticatedUser.isStateEngr = true;

        //                //var roleMappingsListEntity = context.AsisUserLocationMstDets.
        //                //                             Where(u => u.UserRegistrationId == userRegistrationId 
        //                //                             && !u.IsDeleted).ToList();

        //                var roleMappingsListEntity = (from n in context.AsisUserLocationMstDets
        //                                              where n.UserRegistrationId == userRegistrationId
        //                                              && !n.IsDeleted
        //                                              select new { n.UserRoleId, n.HospitalId }).ToList();

        //                var roleMappingList = new List<UserRoleMapping>();
        //                UserRoleMapping roleMapping;
        //                //var i = 0;

        //                var actionList = (from n in context.UMActions
        //                                  where !n.IsDeleted
        //                                  orderby n.ActionPermissionId
        //                                  select new ActionDataViewModel
        //                                  {
        //                                      ActionPermissionId = n.ActionPermissionId,
        //                                      Name = n.Name
        //                                  }).ToList();

        //                foreach (var roleMap in roleMappingsListEntity)
        //                {
        //                    //i++;

        //                    var roleScreenMappingList1 = (from n in context.UMRoleScreenPermissions
        //                                                 join m in context.UMMenus
        //                                                 on n.ScreenPageId equals m.MenuId
        //                                                 join o in context.AsisServices
        //                                                 on m.ServiceID equals o.ServiceID
        //                                                 where !n.IsDeleted && !m.IsDeleted &&
        //                                                 n.UMUserRoleId == roleMap.UserRoleId
        //                                                 select new RoleScreenPermissionMapping
        //                                                 {
        //                                                     RoleId = n.UMUserRoleId,
        //                                                     ScreenId = n.ScreenPageId,
        //                                                     ControllerName = m.ControllerName,
        //                                                     ServiceKey = o.ServiceKey,
        //                                                     Permissions = n.Permissions,
        //                                                     PageURL = m.PageURL
        //                                                 }).Distinct().ToList();

        //                    var roleScreenMappingList = new List<RoleScreenPermissionMapping>();
        //                    foreach (var screen in roleScreenMappingList1)
        //                    {
        //                        var permissions = screen.Permissions.ToCharArray();
        //                        for (int i = 0; i < actionList.Count(); i++)
        //                        {
        //                            if (i < permissions.Length)
        //                                if (permissions[i] == '1')
        //                                {
        //                                    roleScreenMappingList.Add(new RoleScreenPermissionMapping
        //                                    {
        //                                        RoleId = screen.RoleId,
        //                                        ScreenId = screen.ScreenId,
        //                                        ControllerName = screen.ControllerName,
        //                                        ServiceKey = screen.ServiceKey,
        //                                        Permissions = actionList[i].Name,
        //                                        PageURL = screen.PageURL
        //                                    });
        //                                    //break;
        //                                }
        //                        }
        //                    }

        //                    roleMapping = new UserRoleMapping
        //                    {
        //                        RoleId = (int)roleMap.UserRoleId,
        //                        HospitalId = roleMap.HospitalId,
        //                        UserId = userRegistrationId,
        //                        RoleScreenPermission = roleScreenMappingList
        //                    };
        //                    roleMappingList.Add(roleMapping);
        //                }
        //                authenticatedUser.UserRoles = roleMappingList;
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        log.LogMessage("An error has occured because of exception", Level.Info);
        //        throw new DALException(ex);
        //    }

        //    return authenticatedUser;
        //}
    }
}