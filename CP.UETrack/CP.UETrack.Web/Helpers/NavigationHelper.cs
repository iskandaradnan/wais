namespace CP.UETrack.Application.Web.Helper
{
    using System.Collections.Generic;
    using System.Web.Mvc;
    using System.Text;
    using System;
    using Model.Enum;
    using System.Linq;
    using Model;
    using Framework.Common.StateManagement;
    using Newtonsoft.Json;
    using global::UETrack.Application.Web.Helpers;
    using System.Threading.Tasks;
    using System.Web;
    using Model.Common;

    public class MenuDetails
    {
        ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        public List<Menus> CompleteList;
        public async Task<List<Menus>> GetAllMenuItemsByUserAndService(bool isTreeFormat = true)
        {
            var _result = new List<Menus>();
            _result = null;
            //_result = (List<Menus>)_sessionProvider.Get("AllMenu");

            if (_result == null)
            {
                var result = await RestHelper.ApiGet("navigationhelper/GetAllMenuItems");
                if (result.StatusCode == System.Net.HttpStatusCode.OK)
                {
                    var jsonString = await result.Content.ReadAsStringAsync();
                    _result = JsonConvert.DeserializeObject<List<Menus>>(jsonString);
                    //_sessionProvider.Set("AllMenu", _result);
                }
            }
            if (_result != null)
            {
                CompleteList = _result.OrderBy(a => a.ParentMenuID).ThenBy(a => a.SequenceNo).ToList();
                if (isTreeFormat)
                {
                    return ToTree(_result.OrderBy(a => a.ParentMenuID).ThenBy(a => a.SequenceNo).ToList());
                }
            }
            if (CompleteList == null)
            {
                CompleteList = new List<Menus>();
            }

            return CompleteList;
        }
        private List<Menus> ToTree(List<Menus> list)
        {
            var allMenu = new List<Menus>();
            var incommingMenu = new List<Menus>();
            foreach (var root in list)
            {
                root.SubMenus = new List<Menus>();
                incommingMenu.Add(root);
            }
            //if (list == null) throw new ArgumentNullException(nameof(list));
            var rootList = list.Where(x => x.ParentMenuID == 0);
            //if (rootList == null) throw new InvalidOperationException("root == null");
            foreach (var root in rootList)
            {
                PopulateChildren(root, incommingMenu);
                allMenu.Add(root);
            }
            return allMenu;
        }
        private void PopulateChildren(Menus node, List<Menus> all)
        {
            var childs = all.Where(x => x.ParentMenuID.Equals(node.MenuId)).ToList();
            foreach (var item in childs)
            {
                node.SubMenus.Add(item);
            }
            foreach (var item in childs)
                all.Remove(item);

            foreach (var item in childs)
                PopulateChildren(item, all);
        }

    }

    public static class NavigationHelper
    {
        static MenuDetails _menuDetails;
        static string appRootUrl = GetAppRootFolder();
        static string forgotPasswordController = "forgotpassword";
        static string changePasswordController = "changepassword";
        static string unAuthorized = "unauthorised";

        public static MvcHtmlString BuildMenu(this HtmlHelper helper, string ControllerName, object ServiceName)
        {
            try
            {
                var ModuleId = 0;
                _menuDetails = new MenuDetails();
                MODULE outval;
                if (ServiceName != null)
                {
                    foreach (string enumValue in Enum.GetNames(typeof(MODULE)))
                    {
                        if (enumValue.ToString().ToUpper().Equals(ServiceName.ToString().ToUpper()))
                        {
                            Enum.TryParse<MODULE>(ServiceName.ToString().ToUpper(), true, out outval);
                            ModuleId = (int)outval;
                            break;
                        }
                    }
                }

                var menu = _menuDetails.GetAllMenuItemsByUserAndService().Result;
                var Completemenu = _menuDetails.CompleteList;
                var menuString = @"<a href=""#"" class=""back_track""><img src=""/images/new/menu-btn.svg""></a>";
                Completemenu.Sort((menu1, menu2) => menu1.SequenceNo.CompareTo(menu2.SequenceNo));
                menuString += BuildStringMenu(helper, menu, GetCurrentPathAsList(Completemenu, ControllerName), ControllerName, 0);
                UpdateServiceDetails(ModuleId);
                UpdateMenuDetails(ControllerName, Completemenu, ModuleId);
                //menuString2 += @"<a href=""#"" class=""back_track""><i class=""fa fa-arrow-circle-left""></i></a>";
                return new MvcHtmlString(menuString);
            }
            catch (Exception ex)
            {
                return new MvcHtmlString("");
            }
        }


        public static void UpdateServiceDetails(int ServiceId)
        {
            try
            {

                var _sessionProvider = SessionProviderFactory.GetSessionProvider();
                var userDetails = (UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel));
                if (userDetails != null)
                {
                    userDetails.ModuleId = ServiceId;
                    _sessionProvider.Set(nameof(UserDetailsModel), userDetails);
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }

        public static void UpdateMenuDetails(string ControllerName, List<Menus> Menu, int ModuleId)
        {
            try
            {

                var _sessionProvider = SessionProviderFactory.GetSessionProvider();
                var userDetails = (UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel));
                if (userDetails != null)
                {
                    if (Menu != null && Menu.Count() > 0)
                    {
                        userDetails.MenuId = (Menu.Where(x => x.ControllerName.ToUpper() == ControllerName.ToUpper() && x.ServiceID == ModuleId).FirstOrDefault()) == null ? 0 : (Menu.Where(x => x.ControllerName.ToUpper() == ControllerName.ToUpper() && x.ServiceID == ModuleId).FirstOrDefault().MenuId);
                    }

                    _sessionProvider.Set(nameof(UserDetailsModel), userDetails);
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }
        private static string BuildStringMenu(HtmlHelper helper, List<Menus> menu, Dictionary<int, string> path, string ControllerName, int Count)
        {
            Count++;
            var sb = new StringBuilder();
            if ((menu != null) && (menu.Count > 0))
            {
                var exist = false;
                var position = 0;
                if (path != null)
                {
                    foreach (var item in menu)
                    {
                        position++;
                        if (path.ContainsKey((int)item.MenuId))
                        {
                            exist = true;
                            break;
                        }

                    }
                }
                if (exist)
                {
                    if (Count == 1)
                        sb.Append("<ul class=\"tree_menu mt30\">");
                    else
                        sb.Append("<ul class=\"sub_menu list-unstyled\">");
                }
                else
                {
                    if (Count == 1)
                        sb.Append("<ul class=\"tree_menu mt30\">");
                    else
                        sb.Append("<ul class=\"sub_menu list-unstyled\">");
                }
                foreach (var item in menu)
                {
                    if (path.ContainsKey((int)item.MenuId))
                    {
                        sb.Append("<li>");
                    }
                    else
                    {
                        sb.Append("<li>");
                    }

                    if ((item.SubMenus != null) && (item.SubMenus.Count > 0))
                    {
                        //if (item.MenuName == "MASTER")
                        //{
                        //    sb.Append("<a href=\"#\"><span class=\"side_bar_icon\"><i class=\"fa fa-star\"></i></span><span>" + item.MenuName + @"</span><span class=""side_bar_dropdown""><i class=""fa fa-plus-square-o""></i></span></a>");
                        //}

                        if (item.MenuName == "Dashboard")
                        {
                            sb.Append("<a href=\"#\"><span class=\"side_bar_icon\"><i class=\"fa fa-tachometer\"></i></span><span>" + item.MenuName + @"</a>");
                        }
                        else if (item.MenuName == "User Management")
                        {
                            sb.Append("<a href=\"#\"><span class=\"side_bar_icon\"><i class=\"fa fa-user\"></i></span><span>" + item.MenuName + @"</span><span class=""side_bar_dropdown""><i class=""fa fa-plus-square-o""></i></span></a>");
                        }
                        else if (item.MenuName == "General Master")
                        {
                            sb.Append("<a href=\"#\"><span class=\"side_bar_icon\"><i class=\"fa fa-clipboard\"></i></span><span>" + item.MenuName + @"</span><span class=""side_bar_dropdown""><i class=""fa fa-plus-square-o""></i></span></a>");
                        }
                        else if (item.MenuName == "BEMS")
                        {
                            sb.Append("<a href=\"#\"><span class=\"side_bar_icon\"><i class=\"fa fa-cubes\"></i></span><span>" + item.MenuName + @"</span><span class=""side_bar_dropdown""><i class=""fa fa-plus-square-o""></i></span></a>");
                        }
                        else if (item.MenuName == "FEMS")
                        {
                            sb.Append("<a href=\"#\"><span class=\"side_bar_icon\"><i class=\"fa fa-cubes\"></i></span><span>" + item.MenuName + @"</span><span class=""side_bar_dropdown""><i class=""fa fa-plus-square-o""></i></span></a>");
                        }
                        else if (item.MenuName == "CLS")
                        {
                            sb.Append("<a href=\"#\"><span class=\"side_bar_icon\"><i class=\"fa fa-adjust\"></i></span><span>" + item.MenuName + @"</span><span class=""side_bar_dropdown""><i class=""fa fa-plus-square-o""></i></span></a>");
                        }
                        else if (item.MenuName == "HWMS")
                        {
                            sb.Append("<a href=\"#\"><span class=\"side_bar_icon\"><i class=\"fa fa-check\"></i></i></span><span>" + item.MenuName + @"</span><span class=""side_bar_dropdown""><i class=""fa fa-plus-square-o""></i></span></a>");
                        }
                        else if (item.MenuName == "BIS")
                        {
                            sb.Append("<a href=\"#\"><span class=\"side_bar_icon\"><i class=\"fa fa-bolt\"></i></span><span>" + item.MenuName + @"</span><span class=""side_bar_dropdown""><i class=""fa fa-plus-square-o""></i></span></a>");
                        }
                        else if (item.MenuName == "LLS")
                        {
                            sb.Append("<a href=\"#\"><span class=\"side_bar_icon\"><i class=\"fa fa-star\"></i></span><span>" + item.MenuName + @"</span><span class=""side_bar_dropdown""><i class=""fa fa-plus-square-o""></i></span></a>");
                        }
                        //else if (item.MenuName == "QAP")
                        //{
                        //    sb.Append("<a href=\"#\"><span class=\"side_bar_icon\"><i class=\"fa fa-check\"></i></span><span>" + item.MenuName + @"</span><span class=""side_bar_dropdown""><i class=""fa fa-plus-square-o""></i></span></a>");
                        //}
                        //else if (item.MenuName == "KPI")
                        //{
                        //    sb.Append("<a href=\"#\"><span class=\"side_bar_icon\"><i class=\"fa fa-pie-chart\"></i></span><span>" + item.MenuName + @"</span><span class=""side_bar_dropdown""><i class=""fa fa-plus-square-o""></i></span></a>");
                        //}
                        else if (item.MenuName == "HPBS")
                        {
                            sb.Append("<a href=\"#\"><span class=\"side_bar_icon\"><i class=\"fa fa-adjust\"></i></span><span>" + item.MenuName + @"</span><span class=""side_bar_dropdown""><i class=""fa fa-plus-square-o""></i></span></a>");
                        }
                        else if (item.MenuName == "UCS")
                        {
                            sb.Append("<a href=\"#\"><span class=\"side_bar_icon\"><i class=\"fa fa-adjust\"></i></span><span>" + item.MenuName + @"</span><span class=""side_bar_dropdown""><i class=""fa fa-plus-square-o""></i></span></a>");
                        }
                        else if (item.MenuName == "FMS")
                        {
                            sb.Append("<a href=\"#\"><span class=\"side_bar_icon\"><i class=\"fa fa-adjust\"></i></span><span>" + item.MenuName + @"</span><span class=""side_bar_dropdown""><i class=""fa fa-plus-square-o""></i></span></a>");
                        }
                        else if (item.MenuName == "TDIS")
                        {
                            sb.Append("<a href=\"#\"><span class=\"side_bar_icon\"><i class=\"fa fa-adjust\"></i></span><span>" + item.MenuName + @"</span><span class=""side_bar_dropdown""><i class=""fa fa-plus-square-o""></i></span></a>");
                        }
                        else if (item.MenuName == "RFID")
                        {
                            sb.Append("<a href=\"#\"><span class=\"side_bar_icon\"><i class=\"fa fa-adjust\"></i></span><span>" + item.MenuName + @"</span><span class=""side_bar_dropdown""><i class=""fa fa-plus-square-o""></i></span></a>");
                        }
                        //else if (item.MenuName == "VM")
                        //{
                        //    sb.Append("<a href=\"#\"><span class=\"side_bar_icon\"><i class=\"fa fa-line-chart\"></i></span><span>" + item.MenuName + @"</span><span class=""side_bar_dropdown""><i class=""fa fa-plus-square-o""></i></span></a>");
                        //}
                        //else if (item.MenuName == "ER")
                        //{
                        //    sb.Append("<a href=\"#\"><span class=\"side_bar_icon\"><i class=\"fa fa-line-chart\"></i></span><span>" + item.MenuName + @"</span><span class=""side_bar_dropdown""><i class=""fa fa-plus-square-o""></i></span></a>");
                        //}
                        //else if (item.MenuName == "Report")
                        //{
                        //    sb.Append("<a href=\"#\"><span class=\"side_bar_icon\"><i class=\"fa fa-file-text-o fa-1\"></i></span><span>" + item.MenuName + @"</span><span class=""side_bar_dropdown""><i class=""fa fa-plus-square-o""></i></span></a>");
                        //}
                        //else if (item.MenuName == "Smart Assign")
                        //{
                        //    sb.Append("<a href=\"#\"><span class=\"side_bar_icon\"><i class=\"fa fa-tags\"></i></span><span>" + item.MenuName + @"</span><span class=""side_bar_dropdown""><i class=""fa fa-plus-square-o""></i></span></a>");
                        //}
                        else
                        {
                            //if (item.MenuName == "Master")
                            //{
                            //    sb.Append("<a href=\"#\"><span class=\"side_bar_icon tree_lvl_1_icon\"><i class=\"fa fa-star\"></i></span><span>" + item.MenuName + @"</span><span class=""side_bar_dropdown""><i class=""fa fa-plus-square-o""></i></span></a>");
                            //}
                            //else 
                            //if (item.MenuName == "Transaction")
                            //{
                            //    sb.Append("<a href=\"#\"><span class=\"side_bar_icon tree_lvl_1_icon\"><i class=\"fa fa-money\"></i></span><span>" + item.MenuName + @"</span><span class=""side_bar_dropdown""><i class=""fa fa-plus-square-o""></i></span></a>");
                            //}
                            //else
                            //{
                            sb.Append("<a href=\"#\"><span>" + item.MenuName + @"</span><span class=""side_bar_dropdown""><i class=""fa fa-plus-square-o""></i></span></a>");
                            //}
                        }

                    }
                    else
                    {
                        if (string.Equals(ControllerName, item.ControllerName, StringComparison.OrdinalIgnoreCase))
                        {

                            sb.Append("<a href=\"" + appRootUrl + item.URL.ToLower() + "\"><span>" + item.MenuName + @"</span><span class=""side_bar_dropdown""></a>");//Page Menu
                            SessionProviderFactory.GetSessionProvider().Set("CurrentMenuName", item.MenuName);
                        }
                        else
                        {
                            sb.Append("<a href=\"" + appRootUrl + item.URL.ToLower() + "\"><span>" + item.MenuName + @"</span><span class=""side_bar_dropdown""></a>");//Page Menu
                        }
                    }
                    if ((item.SubMenus != null) && (item.SubMenus.Count > 0))
                    {
                        item.SubMenus.Sort((menu1, menu2) => menu1.SequenceNo.CompareTo(menu2.SequenceNo));
                        sb.Append(BuildStringMenu(helper, item.SubMenus, path, ControllerName, Count));
                    }
                    sb.Append("</li>");
                }
                sb.Append("</ul>");
            }
            return (sb.ToString());
        }
        static string GetAppRootFolder()
        {
            var appRootFolder = HttpContext.Current.Request.ApplicationPath.ToLower();
            if (!appRootFolder.EndsWith("/", StringComparison.Ordinal))
            {
                appRootFolder += "/";
            }
            return appRootFolder;
        }
        private static Dictionary<int, string> GetCurrentPathAsList(List<Menus> menu, string ControllerName)
        {
            Dictionary<int, string> result = null;
            if (menu != null)
            {
                var index = menu.Distinct().ToDictionary(r => r.MenuId);
                Func<Menus, IEnumerable<Menus>> traverseUp = null;
                traverseUp = r =>
                {
                    var rs = new[] { r, };
                    if (r.ParentMenuID == 0)
                    {
                        return rs;
                    }
                    else
                    {
                        return traverseUp(index[(int)r.ParentMenuID]).Concat(rs);
                    }
                };
                var current = menu.FirstOrDefault(i => i.ControllerName.ToLower() == ControllerName.ToLower());
                var breadcrumb = string.Empty;
                if (current != null)
                {
                    //result = traverseUp(current).Select(r => r.MenuName);
                    result = traverseUp(current).Distinct().ToDictionary(x => (int)x.MenuId, y => y.MenuName);
                }
            }
            if (result == null)
                return new Dictionary<int, string>();
            return result;
        }
        public static MvcHtmlString StaffName(this HtmlHelper helper)
        {
            try
            {
                var _sessionProvider = SessionProviderFactory.GetSessionProvider();
                var _result = (UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel));
                var StaffName = "";
                if (_result != null)
                {
                    StaffName = _result.StaffName;
                }

                return new MvcHtmlString(StaffName);
            }
            catch (Exception ex)
            {
                return new MvcHtmlString("");
            }
        }
        public static MvcHtmlString BindActionPermissionValues(this HtmlHelper helper, string ControllerName, string Username, string service)
        {
            if (ControllerName.ToLower() == forgotPasswordController || ControllerName.ToLower().Contains(changePasswordController)
                || ControllerName.ToLower() == unAuthorized)
            {
                return null;
            }
            var actionList = new List<ScreenPermissions>();
            var ActionPermissionItems = new List<UserActionPermissions>();

            var userDetails = new SessionHelper().UserSession();

            if (userDetails == null)
            {
                return null;
            }
            var cacheProvider = new DefaultCacheProvider();

            var cacheName = CacheKey.UserRoleData.ToString() + "_" + Username;
            if (cacheProvider.Get(cacheName) as IEnumerable<UserActionPermissions> != null)
            {
                ActionPermissionItems = (cacheProvider.Get(cacheName) as IEnumerable<UserActionPermissions>).ToList();
            }
            else
            {
                ActionPermissionItems = SetAndGetUserPermissionsCacheData().Result;
            }
            var facilityId = userDetails.FacilityId;

            if (ActionPermissionItems != null && ActionPermissionItems.Count() > 0)
            {
                // this If condition additionally added for Asset Meta Data submenu in GM because that formsare come under BEMS in URL so for rights enabling purpose, we hardcoded here as "GM" Module
                var pageurl = "";
                if (ControllerName == "assetclassification" || ControllerName == "typecodedetails" || ControllerName == "assetstandardization" || ControllerName == "ppmchecklist")
                {
                     pageurl =  "GM/" + ControllerName.ToUpper();
                }
                else if (ControllerName == "bemsber1application" || ControllerName == "bemsber2application")
                {
                    pageurl = service.ToUpper() + "/" + ControllerName.Replace("bems", "").ToUpper();
                }
                else if (ControllerName == "femsber1application" || ControllerName == "femsber2application")
                {
                    pageurl = service.ToUpper() + "/" + ControllerName.Replace("fems", "").ToUpper();
                }
                else
                { 
                     pageurl = service.ToUpper() + "/" + ControllerName.ToUpper();
                }
                if (ActionPermissionItems != null)
                {
                    //try
                    //{
                    if (facilityId != 0)
                    {
                        // for username ***uemguest** login comment below code & checking only facilityId
                        //actionList = (from AV in ActionPermissionItems.Where(s => s.ControllerName.ToLower() == ControllerName.ToLower() && s.FacilityId == facilityId)
                        //actionList = (from AV in ActionPermissionItems.Where(s => s.FacilityId == facilityId)
                        //              select new ScreenPermissions
                        //              {
                        //                  ActionPermissionId = AV.ActionPermissionId,
                        //                  ActionPermissionName = AV.ActionPermissionName
                        //              }).Distinct().ToList();
                        actionList = (from AV in ActionPermissionItems.Where(s => s.FacilityId == facilityId && /*s.ControllerName.ToUpper()== ControllerName.ToUpper() && s.ModuleName.ToUpper()==service.ToUpper()*/
                                     s.ModuleName.ToUpper() + "/" + s.ControllerName.ToUpper() == pageurl)
                                      select new ScreenPermissions
                                      {
                                          ActionPermissionId = AV.ActionPermissionId,
                                          ActionPermissionName = AV.ActionPermissionName,
                                          ScreenPageId = AV.ScreenPageId,
                                          UserRoleName = AV.UserRoleName
                                      }).Distinct().ToList();
                    }
                    else
                    {
                        actionList = (from AV in ActionPermissionItems.Where(s => s.ControllerName.ToLower() == ControllerName.ToLower())
                                      select new ScreenPermissions
                                      {
                                          ActionPermissionId = AV.ActionPermissionId,
                                          ActionPermissionName = AV.ActionPermissionName
                                      }).Distinct().ToList();
                    }
                    //}
                    //catch(Exception ex)
                    //{

                    //}
                    //finally
                    //{

                    //}

                }
            }

            var ActionPermissionjsonData = JsonConvert.SerializeObject(actionList);
            return new MvcHtmlString(ActionPermissionjsonData);
        }
        public static async Task<List<UserActionPermissions>> SetAndGetUserPermissionsCacheData()
        {
            var userDetails = new SessionHelper().UserSession();
            if (userDetails == null)
                return null;

            var cacheProvider = new DefaultCacheProvider();
            IEnumerable<UserActionPermissions> cacheData = null;

            var result = await RestHelper.ApiGet(string.Format("navigationhelper/actionpermissioncacheddata"));
            IEnumerable<UserActionPermissions> model = null;
            if (result.StatusCode == System.Net.HttpStatusCode.OK)
            {
                var cacheName = CacheKey.UserRoleData.ToString() + "_" + userDetails.UserName;
                var jsonString = await result.Content.ReadAsStringAsync();
                model = JsonConvert.DeserializeObject<IEnumerable<UserActionPermissions>>(jsonString);
                cacheProvider.Clear(cacheName);
                cacheProvider.Set(cacheName, model);
                cacheData = model as IEnumerable<UserActionPermissions>;
            }

            return cacheData.ToList();
        }
        public static void ClearUserPermissionsCacheData(string userName)
        {
            //var userId = await getUserRegistrationId(userName);
            var cacheProvider = new DefaultCacheProvider();

            var cacheName = CacheKey.UserRoleData.ToString() + "_" + userName;
            cacheProvider.Clear(cacheName);
            cacheProvider.Set(cacheName, new UserActionPermissions());
        }


        //public static async Task<MvcHtmlString> GetThemeColor(this HtmlHelper helper)
        //{
        //    try
        //    {
        //        var _sessionProvider = SessionProviderFactory.GetSessionProvider();
        //        var _result = (UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel));
        //        var themecolor = "";
        //        var themecolorid = 0;
        //        if (_result != null)
        //        {
        //            themecolor = _result.ThemeColorName;
        //            themecolorid = _result.ThemeColorId;
        //        }
        //        if (themecolorid == 0)
        //        {
        //            var result = await RestHelper.ApiGet("navigationhelper/GetThemeColor");
        //            if (result.StatusCode == System.Net.HttpStatusCode.OK)
        //            {
        //                var jsonString = await result.Content.ReadAsStringAsync();
        //                var newResult = JsonConvert.DeserializeObject<UserDetailsModel>(jsonString);
        //                themecolor = newResult.ThemeColorName;
        //                themecolorid = newResult.ThemeColorId;
        //            }

        //        }
        //        return new MvcHtmlString(themecolor);
        //    }
        //    catch (Exception ex)
        //    {
        //        return new MvcHtmlString("");
        //    }
        //}

        public static async Task<int> GetThemeColor(this HtmlHelper helper)
        {
            try
            {
                var _sessionProvider = SessionProviderFactory.GetSessionProvider();
                var _result = (UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel));
                var themecolor = "";
                var themecolorid = 0;
                if (_result != null)
                {
                    themecolor = _result.ThemeColorName;
                    themecolorid = _result.ThemeColorId;
                }
                if (themecolorid == 0)
                {
                    var result = await RestHelper.ApiGet("navigationhelper/GetThemeColor");
                    if (result.StatusCode == System.Net.HttpStatusCode.OK)
                    {
                        var jsonString = await result.Content.ReadAsStringAsync();
                        var newResult = JsonConvert.DeserializeObject<UserDetailsModel>(jsonString);
                        themecolor = newResult.ThemeColorName;
                        themecolorid = newResult.ThemeColorId;
                    }

                }
                return (themecolorid);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}