using System;
using System.Linq;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using UETrack.DAL;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using CP.UETrack.Models;
using CP.UETrack.DAL.DataAccess.Contracts;

namespace CP.UETrack.DAL.DataAccess
{

    public class UnblockUserDAL : IUnblockUserDAL
    {
        private readonly string _FileName = nameof(UnblockUserDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        private IEmailDAL _EmailDAL;
        public UnblockUserDAL()
        {
            _EmailDAL = new EmailDAL();
        }
        public UserRegistrationLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                UserRegistrationLovs userRegistrationLovs = null;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown_Others";
                        cmd.Parameters.AddWithValue("@pTableName", "UserReg");
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    userRegistrationLovs = new UserRegistrationLovs();
                    userRegistrationLovs.Genders = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                    userRegistrationLovs.UserTypes = dbAccessDAL.GetLovRecords(ds.Tables[1]);
                    userRegistrationLovs.Statuses = dbAccessDAL.GetLovRecords(ds.Tables[2]);
                    userRegistrationLovs.Customers = dbAccessDAL.GetLovRecords(ds.Tables[3]);

                    //userRegistrationLovs.UserRoles = dbAccessDAL.GetLovRecords(ds.Tables[4]);
                    userRegistrationLovs.Competancies = dbAccessDAL.GetLovRecords(ds.Tables[4]);
                    userRegistrationLovs.Designations = dbAccessDAL.GetLovRecords(ds.Tables[5]);
                    userRegistrationLovs.Grades = dbAccessDAL.GetLovRecords(ds.Tables[6]);
                    userRegistrationLovs.Specialities = dbAccessDAL.GetLovRecords(ds.Tables[7]);
                    userRegistrationLovs.Deparatments = dbAccessDAL.GetLovRecords(ds.Tables[8]);
                    userRegistrationLovs.AccessLevels = dbAccessDAL.GetLovRecords(ds.Tables[9]);
                    userRegistrationLovs.Nationalities = dbAccessDAL.GetLovRecords(ds.Tables[10]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return userRegistrationLovs;
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
        public bool Save(int UserRegistrationId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                var spName = "uspFM_ResetInvalidAttempts_Save";
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = spName;
                        cmd.Parameters.AddWithValue("@pUserRegistrationId", UserRegistrationId);

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

                //var QueryCondition = pageFilter.QueryWhereCondition;
                //var strCondition = string.Empty;
                //if (string.IsNullOrEmpty(QueryCondition))
                //{
                //    strCondition = "FacilityId = " + _UserSession.FacilityId.ToString();
                //}
                //else
                //{
                //    strCondition = QueryCondition + " AND FacilityId = " + _UserSession.FacilityId.ToString();
                //}

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "GetAllBlockedUsers";

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
        public UMUserRegistration Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                UMUserRegistration userRegistration = null;
                
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "GetUserRegistration";
                        cmd.Parameters.AddWithValue("@Id", Id);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0 && ds.Tables[1].Rows.Count > 0 
                    && ds.Tables[2].Rows.Count > 0 && ds.Tables[3].Rows.Count > 0)
                {
                    userRegistration = (from n in ds.Tables[0].AsEnumerable()
                                         select new UMUserRegistration
                                         {
                                             StaffName= Convert.ToString(n["StaffName"]),
                                             UserName = Convert.ToString(n["UserName"]),
                                             Gender = Convert.ToInt32(n["Gender"]),
                                             PhoneNumber = Convert.ToString(n["PhoneNumber"]),
                                             Email = Convert.ToString(n["Email"]),
                                             DateJoined = Convert.ToDateTime(n["DateJoined"]),
                                             CustomerId = n.Field<int?>("CustomerId"),
                                             MobileNumber = Convert.ToString(n["MobileNumber"]),
                                             ExistingStaff = Convert.ToBoolean(n["ExistingStaff"]),
                                             UserTypeId = Convert.ToInt32(n["UserTypeId"]),
                                             Status = Convert.ToInt32(n["Status"]),

                                             //AccessLevl = n.Field<int>("AccessLevel"),
                                             //UserRoleId = n.Field<int>("UserRoleId"),
                                             UserDesignationId = n.Field<int>("UserDesignationId"),
                                             Nationality = n.Field<int>("Nationality"),
                                             UserGradeId = n.Field<int>("UserGradeId"),
                                             UserCompetencyId = n.Field<string>("UserCompetencyId"),
                                             UserDepartmentId = n.Field<int>("UserDepartmentId"),
                                             UserSpecialityId = n.Field<string>("UserSpecialityId"),
                                             ContractorId = n.Field<int>("ContractorId"),
                                             ContractorName = n.Field<string>("ContractorName"),
                                             IsCenterPool = n.Field<bool>("IsCenterPool"),

                                             Timestamp = Convert.ToBase64String((byte[])(n["Timestamp"]))
                                         }).FirstOrDefault();

                    userRegistration.LocationRole = (from n in ds.Tables[1].AsEnumerable()
                                                        select new LovSelected
                                                        {
                                                            LovId = Convert.ToInt32(n["FacilityId"]),
                                                            FieldValue = Convert.ToString(n["FacilityName"]),
                                                            IsSelected = false,
                                                            UserRoleId = Convert.ToInt32(n["UserRoleId"]),
                                                        }).ToList();

                    userRegistration.AllLocations = dbAccessDAL.GetLovRecords(ds.Tables[2]);
                    
                    userRegistration.LeftLocations = (from n in ds.Tables[2].AsEnumerable()
                                                      select new LovSelectedVisible
                                                      {
                                                          LovId = Convert.ToInt32(n["LovId"]),
                                                          FieldValue = Convert.ToString(n["FieldValue"]),
                                                          IsSelected = false,
                                                          IsVisible = false
                                                      }).ToList();

                    foreach (var item in userRegistration.LeftLocations)
                    {
                        var itemExists = false;
                        foreach (var item1 in userRegistration.LocationRole)
                        {
                            if (item.LovId == item1.LovId) itemExists = true;
                        }
                        if (!itemExists) item.IsVisible = true;
                    }
                    userRegistration.UserRoles = (from n in ds.Tables[3].AsEnumerable()
                                                  select new LovValue
                                                  {
                                                      LovId = Convert.ToInt32(n["LovId"]),
                                                      FieldValue = Convert.ToString(n["FieldValue"])
                                                  }).ToList();

                    int distinctCount = userRegistration.LocationRole.Select(x => x.UserRoleId).Distinct().Count();
                    if (distinctCount != 1) userRegistration.SelectedUserRole = "null";
                    else userRegistration.SelectedUserRole = userRegistration.LocationRole[0].UserRoleId.ToString();
                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return userRegistration;
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
        public bool IsRecordModified(UMUserRegistration userRegistration)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsRecordModified), Level.Info.ToString());

                var recordModifed = false;
                
                if(userRegistration.UserRegistrationId != 0)
                {
                    var ds = new DataSet();
                    string constring = ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ConnectionString;
                    using (SqlConnection con = new SqlConnection(constring))
                    {
                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.Connection = con;
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.CommandText = "GetUserRegistrationTimestamp";
                            cmd.Parameters.AddWithValue("@Id", userRegistration.UserRegistrationId);
                            var da = new SqlDataAdapter();
                            da.SelectCommand = cmd;
                            da.Fill(ds);
                        }
                    }
                    if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        var timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                        if (timestamp != userRegistration.Timestamp)
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
                        cmd.CommandText = "DeleteUserRegistration";
                        cmd.Parameters.AddWithValue("@Id", Id);

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
        public UserRegistrationLovs GetUserRoles(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetUserRoles), Level.Info.ToString());
                var userRegistrationLovs = new UserRegistrationLovs();

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "GetUserRoles";
                        cmd.Parameters.AddWithValue("@Id", Id);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    userRegistrationLovs.UserRoles = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(GetUserRoles), Level.Info.ToString());
                return userRegistrationLovs;
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
        public UserRegistrationLovs GetLocations(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetLocations), Level.Info.ToString());
                var userRegistrationLovs = new UserRegistrationLovs();

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "GetLocations";
                        cmd.Parameters.AddWithValue("@Id", Id);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    userRegistrationLovs.Locations = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(GetLocations), Level.Info.ToString());
                return userRegistrationLovs;
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
        public bool BlockingList(string userRegistration)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(BlockingList), Level.Info.ToString());

                var spName = "UspFM_UnBlockUser_GetById";
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = spName;
                        cmd.Parameters.AddWithValue("@pUserRegistrationId", userRegistration);

                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();
                    }
                }

                _EmailDAL.SendUnblockUserEMail(userRegistration);

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
    }
}
