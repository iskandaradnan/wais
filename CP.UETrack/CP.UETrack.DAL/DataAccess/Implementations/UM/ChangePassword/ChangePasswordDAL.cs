using CP.UETrack.Model;
using System;
using System.Linq;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using System.Data;
using System.Data.SqlClient;
using UETrack.DAL;
using CP.UETrack.DAL.DataAccess.Implementation;

namespace CP.UETrack.DAL.DataAccess
{
    public class ChangePasswordDAL : IChangePasswordDAL
    {
        private readonly string _FileName = nameof(ChangePasswordDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public ChangePasswordLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var changePasswordLovs = new ChangePasswordLovs { UserName = _UserSession.UserName};
                
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return changePasswordLovs;
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
        public ChangePassword IsAuthenticated(ChangePassword changePassword)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());

                changePassword.IsAuthenticated = false;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_UMValidateUser_GetById";

                        SqlParameter parameter = new SqlParameter();
                        cmd.Parameters.AddWithValue("@pUserName", changePassword.UserName);
                        cmd.Parameters.AddWithValue("@pPassword", changePassword.Password);
                        
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }

                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    changePassword.IsAuthenticated = Convert.ToBoolean(ds.Tables[0].Rows[0]["IsAuthenticated"]);
                    changePassword.UserId = Convert.ToInt32(ds.Tables[0].Rows[0]["UserId"]);
                }

                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return changePassword;
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
        public ChangePassword Save(ChangePassword changePassword, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        if (changePassword.IsFromLink)
                        {
                            cmd.CommandText = "uspFM_UserChangePassword_Save";

                            SqlParameter parameter = new SqlParameter();
                            cmd.Parameters.AddWithValue("@pUserName", changePassword.UserName);
                            cmd.Parameters.AddWithValue("@pNewPassword", changePassword.NewPassword);
                        }
                        else {
                            cmd.CommandText = "uspFM_UMChangePassword_Save";

                            SqlParameter parameter = new SqlParameter();
                            cmd.Parameters.AddWithValue("@pUserRegistrationId", _UserSession.UserId);
                            cmd.Parameters.AddWithValue("@pNewPassword", changePassword.NewPassword);
                            cmd.Parameters.AddWithValue("@pUserId", _UserSession.UserId);
                        }
               
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
               
                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return changePassword;
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
        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                GridFilterResult filterResult = null;

                var multipleOrderBy = pageFilter.SortColumn.Split(',');
                var strOrderBy = string.Empty;
                foreach (var order in multipleOrderBy)
                {
                    strOrderBy += order + " " + pageFilter.SortOrder + ",";
                }
                if (!string.IsNullOrEmpty(strOrderBy))
                {
                    strOrderBy = strOrderBy.TrimEnd(',');
                }

                strOrderBy = string.IsNullOrEmpty(strOrderBy) ? pageFilter.SortColumn + " " + pageFilter.SortOrder : strOrderBy;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Test_GetAll";

                        cmd.Parameters.AddWithValue("@PageIndex", pageFilter.PageIndex);
                        cmd.Parameters.AddWithValue("@PageSize", pageFilter.PageSize);
                        cmd.Parameters.AddWithValue("@strCondition", pageFilter.QueryWhereCondition);
                        cmd.Parameters.AddWithValue("@strSorting", strOrderBy);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalRecords"]);
                    var totalPages = (int)Math.Ceiling((float)totalRecords / (float)pageFilter.Rows);

                    var commonDAL = new CommonDAL();
                    var currentPageList = commonDAL.ToDynamicList(ds.Tables[0]);
                    filterResult = new GridFilterResult
                    {
                        TotalRecords = totalRecords,
                        TotalPages = totalPages,
                        RecordsList = currentPageList,
                        CurrentPage = pageFilter.Page
                    };
                }
                Log4NetLogger.LogExit(_FileName, nameof(GetAll), Level.Info.ToString());
                return filterResult;
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
        public ChangePassword Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                ChangePassword changePassword = null;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Test_GetById";
                        cmd.Parameters.AddWithValue("@pUserRegistrationId", Id);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    changePassword = (from n in ds.Tables[0].AsEnumerable()
                                      select new ChangePassword
                                      {

                                          UserRegistrationId = Convert.ToInt32((n["UserRegistrationId"])),
                                          UserName = Convert.ToString((n["UserName"])),
                                          OldPassword = Convert.ToString((n["OldPassword"])),
                                          NewPassword = Convert.ToString((n["NewPassword"])),
                                          Timestamp = Convert.ToBase64String((byte[])(n["Timestamp"])),
                                      }).FirstOrDefault();
                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return changePassword;
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
        public void Delete(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());

                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Test_Delete";
                        cmd.Parameters.AddWithValue("@pUserRegistrationId", Id);

                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(Delete), Level.Info.ToString());
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
        public bool IsOldPasswordValid(ChangePassword changePassword)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsOldPasswordValid), Level.Info.ToString());
                var isValid = false;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "UspFM_UMUserRegistrationUPChecking_GetById";
                        cmd.Parameters.AddWithValue("@pUserRegistrationId", _UserSession.UserId);
                        cmd.Parameters.AddWithValue("@pPassword", changePassword.OldPassword);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    isValid = Convert.ToBoolean(ds.Tables[0].Rows[0][0]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(IsOldPasswordValid), Level.Info.ToString());
                return isValid;
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