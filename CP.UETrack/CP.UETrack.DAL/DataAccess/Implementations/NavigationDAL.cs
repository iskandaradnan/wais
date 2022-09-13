using CP.UETrack.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.UETrack.Model.Enum;
using System.Data.SqlClient;
using System.Data;
using UETrack.DAL;
using System.Configuration;

namespace CP.UETrack.DAL.DataAccess
{
    public class NavigationDAL : INavigationDAL
    {
        private readonly string _FileName = nameof(UserRoleDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public List<Menus> GetAllMenuItems()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAllMenuItems), Level.Info.ToString());
            List<Menus> allMenu = null;

            var _resultmenu = new Menus();
            try
            {
                var facilityId = _UserSession.FacilityId;
                
                var ds = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_GetMenus";
                        cmd.Parameters.AddWithValue("@Id", _UserSession.UserId);
                        if (facilityId == 0)
                        {
                            cmd.Parameters.AddWithValue("@pFacilityId", "");
                        }
                        else
                        {
                            cmd.Parameters.AddWithValue("@pFacilityId", facilityId);
                        }
                        
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    allMenu = (from n in ds.Tables[0].AsEnumerable()
                               select new Menus
                               {
                                   MenuId = Convert.ToInt32(n["ScreenId"]),
                                   MenuName = Convert.ToString(n["ScreenName"]),
                                   URL = Convert.ToString(n["PageURL"]),
                                   ParentMenuID = Convert.ToInt32(n["ParentMenuId"]),
                                   SequenceNo = Convert.ToInt32(n["SequenceNo"]),
                                   ControllerName = Convert.ToString(n["ControllerName"])
                               }).ToList();
                }
                    if (_UserSession.AccessLevel == 4)
                    {
                        foreach (var x in allMenu)
                        {
                            string Firstpart = null;
                            string SecondPart = null;
                            if (x.URL != "")
                            {
                                string[] words = x.URL.Split('/');
                                Firstpart = words[0];
                                SecondPart = "external_" + words[1];
                                x.URL = Firstpart + "/" + SecondPart;
                                x.ControllerName = SecondPart;
                            }
                         
                        }
                    }
            
                

                //foreach(var x in allMenu)
                //{
                //    var tempcontroller = x.ControllerName;
                //    x.URL = "bems" + "/" + "external_" + tempcontroller;
                //}
                Log4NetLogger.LogExit(_FileName, nameof(GetAllMenuItems), Level.Info.ToString());
                return allMenu;
                
            }
            catch (Exception ex)
            {
                throw;
            }
        }
        public List<UserActionPermissions> ActionPermissionCachedData()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(ActionPermissionCachedData), Level.Info.ToString());

            try
            {
                var searchResult = new List<UserActionPermissions>();

                var username = _UserSession.UserName;
                var userId = _UserSession.UserId;

                var ds = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_UMRoleScreenPermission_GetByUserRegistrationId";
                        cmd.Parameters.AddWithValue("@pUserRegistrationId", _UserSession.UserId);
                        
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    searchResult = (from n in ds.Tables[0].AsEnumerable()
                               select new UserActionPermissions
                               {
                                   userRegistrationId = userId,
                                   UserName = username,
                                   FacilityId = n.Field<int>("FacilityId"),
                                   UMUserRoleId = n.Field<int>("UMUserRoleId"),
                                   UserRoleName = n.Field<string>("UserRoleName"),
                                   ScreenPageId = n.Field<int>("ScreenPageId"),
                                   ControllerName = n.Field<string>("ControllerName"),
                                   ActionPermissionId = n.Field<int>("ActionPermissionId"),
                                   ActionPermissionName = n.Field<string>("ActionPermissionName"),
                                   Moduleid = n.Field<int>("ModuleId"),
                                   ModuleName = n.Field<string>("ModuleName")
                               }).ToList();
                }
                if (_UserSession.AccessLevel == 4)
                {
                    foreach (var x in searchResult)
                    {
                            var SecondPart = "external_" + x.ControllerName;
                            x.ControllerName = SecondPart;
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(ActionPermissionCachedData), Level.Info.ToString());

                return searchResult;
            }
            catch (Exception ex)
            {
                throw;
            }
        }
        public List<UserActionPermissions> ActionPermissionData()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(ActionPermissionData), Level.Info.ToString());

            try
            {
                var searchResult = new List<UserActionPermissions>();

                var username = _UserSession.UserName;
                var userId = _UserSession.UserId;

                var ds = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_UMRoleScreenPermission_GetByUserRegistrationId_MenuId";
                        cmd.Parameters.AddWithValue("@pUserRegistrationId", _UserSession.UserId);
                        cmd.Parameters.AddWithValue("@Screenid", _UserSession.MenuId);


                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    searchResult = (from n in ds.Tables[0].AsEnumerable()
                                    select new UserActionPermissions
                                    {
                                        userRegistrationId = userId,
                                        UserName = username,
                                        FacilityId = n.Field<int>("FacilityId"),
                                        UMUserRoleId = n.Field<int>("UMUserRoleId"),
                                        UserRoleName = n.Field<string>("UserRoleName"),
                                        ScreenPageId = n.Field<int>("ScreenPageId"),
                                        ControllerName = n.Field<string>("ControllerName"),
                                        ActionPermissionId = n.Field<int>("ActionPermissionId"),
                                        ActionPermissionName = n.Field<string>("ActionPermissionName")
                                    }).ToList();
                }
                if (_UserSession.AccessLevel == 4)
                {
                    foreach (var x in searchResult)
                    {
                        var SecondPart = "external_" + x.ControllerName;
                        x.ControllerName = SecondPart;
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(ActionPermissionData), Level.Info.ToString());

                return searchResult;
            }
            catch (Exception ex)
            {
                throw;
            }
        }
        public UserDetailsModel GetThemeColor()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetThemeColor), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new MASTERDBAccessDAL();
                var entity = new UserDetailsModel();

                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();

                parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));               

                DataTable dt1 = dbAccessDAL.GetMASTERDataTable("uspFM_GMNavigationHelper_GetByCustomerId", parameters, DataSetparameters);
                if (dt1 != null && dt1.Rows.Count > 0)
                {
                    entity.CustomerId = _UserSession.CustomerId;
                    entity.CustomerName = dt1.Rows[0]["CustomerName"].ToString();
                    entity.ThemeColorId = Convert.ToInt32(dt1.Rows[0]["ThemeColorId"]);
                    entity.ThemeColorName = dt1.Rows[0]["ThemeColorName"].ToString();                    
                }               
                Log4NetLogger.LogExit(_FileName, nameof(GetThemeColor), Level.Info.ToString());
                return entity;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}