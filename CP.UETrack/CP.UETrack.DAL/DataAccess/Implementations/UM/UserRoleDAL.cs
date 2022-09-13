using CP.UETrack.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.UETrack.Models;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using UETrack.DAL;
using System.Dynamic;
using CP.UETrack.DAL.DataAccess.Implementation;

namespace CP.UETrack.DAL.DataAccess
{
   
    public class UserRoleDAL : IUserRoleDAL
    {
        private readonly string _FileName = nameof(UserRoleDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public UserRoleLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                UserRoleLovs userRoleLovs = null;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "GetUserRoleLovs";
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    userRoleLovs = new UserRoleLovs();
                    userRoleLovs.UserTypeIds = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                    userRoleLovs.Statuses = dbAccessDAL.GetLovRecords(ds.Tables[1]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return userRoleLovs;
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
        public UMUserRole Save(UMUserRole userRole)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                var spName = string.Empty;
                if (userRole.UMUserRoleId != 0)
                {
                    spName = "UpdateUserRole";
                }
                else
                {
                    spName = "SaveUserRole";
                }

                DataTable dataTable = new DataTable("UMUserRoleType");
                dataTable.Columns.Add("UMUserRoleId", typeof(int));
                dataTable.Columns.Add("UserTypeId", typeof(int));
                dataTable.Columns.Add("Name", typeof(string));
                dataTable.Columns.Add("Status", typeof(int));
                dataTable.Columns.Add("Remarks", typeof(string));
                dataTable.Columns.Add("UserId", typeof(int));

                dataTable.Rows.Add(userRole.UMUserRoleId, userRole.UserTypeId, userRole.Name,  userRole.Status, userRole.Remarks, _UserSession.UserId);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = spName;

                        SqlParameter parameter = new SqlParameter();
                        parameter.ParameterName = "@UserRole";
                        parameter.SqlDbType = System.Data.SqlDbType.Structured;
                        parameter.Value = dataTable;
                        cmd.Parameters.Add(parameter);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    userRole.UMUserRoleId = Convert.ToInt32(ds.Tables[0].Rows[0]["UMUserRoleId"]);
                    userRole.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                }

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return userRole;
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
                        cmd.CommandText = "uspFM_UMUserRole_GetAll";

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
                //return userRoles;
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
        public UMUserRole Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                UMUserRole userRole = null;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "GetUserRole";
                        cmd.Parameters.AddWithValue("@Id", Id);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    userRole = (from n in ds.Tables[0].AsEnumerable()
                                         select new UMUserRole
                                         {
                                             UMUserRoleId = Id,
                                             Name = Convert.ToString(n["Name"]),
                                             UserTypeId = Convert.ToInt32(n["UserTypeId"]),
                                             Status = Convert.ToInt32(n["Status"]),
                                             Remarks = Convert.ToString(n["Remarks"]),
                                             Timestamp = Convert.ToBase64String((byte[])(n["Timestamp"]))
                                         }).FirstOrDefault();
                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return userRole;
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
        public bool IsRoleDuplicate(UMUserRole userRole)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsRoleDuplicate), Level.Info.ToString());

                var isDuplicate = true;
                string constring = ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ConnectionString;
                using (SqlConnection con = new SqlConnection(constring))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "IsRoleDuplicate";
                        cmd.Parameters.AddWithValue("@Id", userRole.UMUserRoleId);
                        cmd.Parameters.AddWithValue("@Name", userRole.Name);
                        cmd.Parameters.Add("@IsDuplicate", SqlDbType.Bit);
                        cmd.Parameters["@IsDuplicate"].Direction = ParameterDirection.Output;
                        
                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();
                        bool.TryParse(cmd.Parameters["@IsDuplicate"].Value.ToString(), out isDuplicate);
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(IsRoleDuplicate), Level.Info.ToString());
                return isDuplicate;
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
        public bool IsRoleReferenced(UMUserRole userRole)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsRoleReferenced), Level.Info.ToString());

                var isReferenced = true;
                string constring = ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ConnectionString;
                using (SqlConnection con = new SqlConnection(constring))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_UMUserRole_ReferredUserCheck";
                        cmd.Parameters.AddWithValue("@pUMUserRoleId", userRole.UMUserRoleId);
                        cmd.Parameters.Add("@IsReferenced", SqlDbType.Bit);
                        cmd.Parameters["@IsReferenced"].Direction = ParameterDirection.Output;

                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();
                        bool.TryParse(cmd.Parameters["@IsReferenced"].Value.ToString(), out isReferenced);
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(IsRoleReferenced), Level.Info.ToString());
                return isReferenced;
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
        public bool IsRecordModified(UMUserRole userRole)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsRecordModified), Level.Info.ToString());

                var recordModifed = false;
                
                if(userRole.UMUserRoleId != 0)
                {
                    var ds = new DataSet();
                    string constring = ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ConnectionString;
                    using (SqlConnection con = new SqlConnection(constring))
                    {
                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.Connection = con;
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.CommandText = "GetUserRoleTimestamp";
                            cmd.Parameters.AddWithValue("@Id", userRole.UMUserRoleId);
                            var da = new SqlDataAdapter();
                            da.SelectCommand = cmd;
                            da.Fill(ds);
                        }
                    }
                    if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        var timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                        if (timestamp != userRole.Timestamp)
                        {
                            recordModifed = true;
                        }
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(IsRecordModified), Level.Info.ToString());
                return recordModifed;
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
        public void Delete(int Id, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
                ErrorMessage = string.Empty;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_UMUserRole_Delete";
                        cmd.Parameters.AddWithValue("@pUMUserRoleId", Id);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    ErrorMessage = Convert.ToString(ds.Tables[0].Rows[0]["ErrorMessage"]);
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
        public GridFilterResult Export(SortPaginateFilter pageFilter, string ExportType)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Export), Level.Info.ToString());
                var LocationType = 0;
               
                    /*Checking for Location Type And Valid Laundry */

                   
                    var sColumnNames = string.Empty;
                    var sHeaderNames = string.Empty;
                    //var totalList = string.IsNullOrEmpty(pageFilter.WhereCondition) ? context.Set(Type.GetType(DomainEntity)).AsNoTracking() : context.Set(Type.GetType(DomainEntity)).Where(pageFilter.WhereCondition).AsNoTracking();
                    //var orderedList = totalList.OrderBy(pageFilter.SortColumn + " " + pageFilter.SortOrder).AsEnumerable().ToList();
                    //var filterResult = new GridFilterResult
                    //{
                    //    RecordsList = orderedList,
                    //    TotalRecords = totalList.Count(),

                    //};
                    
                    //filterResult.Column_Names = sColumnNames;
                    //filterResult.Header_Names = sHeaderNames;

                    Log4NetLogger.LogExit(_FileName, nameof(Export), Level.Info.ToString());
                //return filterResult;
                return null;
                
            }
            catch (DALException dalException)
            {
                throw new DALException(dalException);
            }
            catch (Exception ex)
            {
                throw new DALException(ex);
            }
        }
    }
}
