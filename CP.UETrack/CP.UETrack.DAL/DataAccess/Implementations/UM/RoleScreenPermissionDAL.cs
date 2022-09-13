using CP.UETrack.Model;
using System;
using System.Linq;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.UETrack.Models;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using UETrack.DAL;
using CP.UETrack.DAL.DataAccess.Implementation;
using System.Collections.Generic;

namespace CP.UETrack.DAL.DataAccess
{

    public class RoleScreenPermissionDAL : IRoleScreenPermissionDAL
    {
        private readonly string _FileName = nameof(RoleScreenPermissionDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public List<UserRoleType> GetUserRoles()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetUserRoles), Level.Info.ToString());
                List<UserRoleType> userRoleType = null;

                var ds = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "GetAllUserRoles";
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    userRoleType = (from n in ds.Tables[0].AsEnumerable()
                                    select new UserRoleType
                                    {
                                        LovId = Convert.ToInt32(n["LovId"]),
                                        FieldValue = Convert.ToString(n["FieldValue"]),
                                        UserType = Convert.ToString(n["UserType"]),
                                        UserTypeId = Convert.ToInt32(n["UserTypeId"])
                                    }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(GetUserRoles), Level.Info.ToString());
                return userRoleType;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception)
            {
                throw;
            }
        }
        public List<UMRoleScreenPermission> Fetch(int RoleId, int ModuleId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Fetch), Level.Info.ToString());
                List<UMRoleScreenPermission> roleScreenPermissions = null;

                var ds = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "FetchRoleScreenPermission";
                        cmd.Parameters.AddWithValue("@Id", RoleId);
                        cmd.Parameters.AddWithValue("@pModuleId", ModuleId);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    roleScreenPermissions = (from n in ds.Tables[0].AsEnumerable()
                                            select new UMRoleScreenPermission
                                            {
                                                ScreenRoleId = Convert.ToInt32(n["ScreenRoleId"]),
                                                ScreenId = Convert.ToInt32(n["ScreenId"]),
                                                UMUserRoleId = RoleId,
                                                ScreenDescription = Convert.ToString(n["ScreenDescription"]),
                                                Permissions = Convert.ToString(n["Permissions"]),
                                                ScreenPermissions = Convert.ToString(n["ScreenPermissions"])
                                            }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(Fetch), Level.Info.ToString());
                return roleScreenPermissions;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception)
            {
                throw;
            }
        }
        public bool Save(RoleScreenPermissions roleScreenPermissions)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                var dataTable = new DataTable("UMUserLocationMstDetType");
                dataTable.Columns.Add("ScreenId", typeof(int));
                dataTable.Columns.Add("UMUserRoleId", typeof(int));
                dataTable.Columns.Add("Permissions", typeof(string));
                dataTable.Columns.Add("UserId", typeof(int));

                foreach (var item in roleScreenPermissions.roleScreenPermissions)
                {
                    dataTable.Rows.Add(item.ScreenId, item.UMUserRoleId, item.Permissions, _UserSession.UserId);
                }

                var dbAccessDAL = new MASTERDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "SaveRoleScreenPermission";

                        var parameter = new SqlParameter();
                        parameter.ParameterName = "@RoleScreenPermissions";
                        parameter.SqlDbType = System.Data.SqlDbType.Structured;
                        parameter.Value = dataTable;
                        cmd.Parameters.Add(parameter);

                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();
                    }
                }
                
                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return true;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception)
            {
                throw;
            }
        }
        public List<LovValue> GetModules(int UserTypeId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Fetch), Level.Info.ToString());
                List<LovValue> modules = null;

                var ds = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_UMModules_GetUserTypeId";
                        cmd.Parameters.AddWithValue("@pUserTypeId", UserTypeId);
                       
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    modules = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(Fetch), Level.Info.ToString());
                return modules;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception)
            {
                throw;
            }
        }
        public bool IsUserRoleActive(int UserRoleId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                var isActive = true;
                var dbAccessDAL = new MASTERDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_UMRole_GetByStatus";
                        cmd.Parameters.AddWithValue("@pUserRoleId", UserRoleId);
                        
                        cmd.Parameters.Add("@IsActive", SqlDbType.Bit);
                        cmd.Parameters["@IsActive"].Direction = ParameterDirection.Output;

                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();
                        bool.TryParse(cmd.Parameters["@IsActive"].Value.ToString(), out isActive);
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return isActive;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception)
            {
                throw;
            }
        }
    }
}
