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
using CP.UETrack.Model.UM;
using CP.UETrack.Model.EMail;
using CP.ASIS.DAL.Helper;
using CP.UETrack.DAL.DataAccess.Contracts;
using CP.UETrack.DAL.DataAccess;
using CP.UETrack.DAL.DataAccess.Implementations.BEMS;

namespace CP.UETrack.DAL.DataAccess
{
   
    public class UserRegistrationDAL : IUserRegistrationDAL
    {
        private readonly string _FileName = nameof(UserRegistrationDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        private IEmailDAL _EmailDAL;
        User_Maping_ID MUserRegistrationId = new User_Maping_ID();      
        CustomerDAL Customer_mapping = new CustomerDAL();
        public UserRegistrationDAL()
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
                var ds1 = new DataSet();
                var ds2 = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
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

                        var da1 = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_GetCustomers";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@UserRegistrationId", _UserSession.UserId);
                        da1.SelectCommand = cmd;
                        da1.Fill(ds1);

                        var da2 = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_GetServices";
                        cmd.Parameters.Clear();
                      //  cmd.Parameters.AddWithValue("@UserRegistrationId", _UserSession.UserId);
                        da2.SelectCommand = cmd;
                        da2.Fill(ds2);

                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0 && ds1.Tables.Count != 0 && ds1.Tables[0].Rows.Count > 0)
                {
                    userRegistrationLovs = new UserRegistrationLovs();
                    userRegistrationLovs.Genders = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                    userRegistrationLovs.UserTypes = dbAccessDAL.GetLovRecords(ds.Tables[1]);
                    userRegistrationLovs.Statuses = dbAccessDAL.GetLovRecords(ds.Tables[2]);
                    //userRegistrationLovs.Customers = dbAccessDAL.GetLovRecords(ds.Tables[3]);
                    userRegistrationLovs.Competancies = dbAccessDAL.GetLovRecords(ds.Tables[4]);
                    userRegistrationLovs.Designations = dbAccessDAL.GetLovRecords(ds.Tables[5]);
                    userRegistrationLovs.Grades = dbAccessDAL.GetLovRecords(ds.Tables[6]);
                    userRegistrationLovs.Specialities = dbAccessDAL.GetLovRecords(ds.Tables[7]);
                    userRegistrationLovs.Deparatments = dbAccessDAL.GetLovRecords(ds.Tables[8]);
                    userRegistrationLovs.AccessLevels = dbAccessDAL.GetLovRecords(ds.Tables[9]);
                    userRegistrationLovs.Nationalities = dbAccessDAL.GetLovRecords(ds.Tables[10]);

                    userRegistrationLovs.Customers = dbAccessDAL.GetLovRecords(ds1.Tables[0]);
                    userRegistrationLovs.UserTypeId = _UserSession.UserTypeId;
                    userRegistrationLovs.Services = dbAccessDAL.GetLovRecords(ds2.Tables[0]);
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
        public UMUserRegistration Save(UMUserRegistration userRegistration)
        {
            Blocks facilitys_ID = new Blocks();
            MasterBlockDAL Get_facilitys_ID = new MasterBlockDAL();
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                var spName = string.Empty;
                var isSave = false;
                if (userRegistration.UserRegistrationId != 0)
                {
                    spName = "UpdateUserRegistration";
                       MUserRegistrationId = Get_User_IDS(userRegistration.UserRegistrationId);
                }
                else
                {
                    spName = "SaveUserRegistration";
                    MUserRegistrationId.BEMS_U_ID = 0;
                    MUserRegistrationId.FEMS_U_ID = 0;
                    isSave = true;
                }
                facilitys_ID = Get_facilitys_ID.GET_Facility_Mapping_IDS(_UserSession.FacilityId);

                DataTable dataTable = new DataTable("UMUserRegistrationType");
                DataTable FEMSdataTable = new DataTable("UMUserRegistrationType");
                DataTable BEMSdataTable = new DataTable("UMUserRegistrationType");
                dataTable.Columns.Add("UserRegistrationId", typeof(int));
                dataTable.Columns.Add("ExistingStaff", typeof(bool));
                dataTable.Columns.Add("StaffName", typeof(string));
                dataTable.Columns.Add("UserName", typeof(string));
                dataTable.Columns.Add("Gender", typeof(int));
                dataTable.Columns.Add("PhoneNumber", typeof(string));
                dataTable.Columns.Add("Email", typeof(string));
                dataTable.Columns.Add("MobileNumber", typeof(string));
                dataTable.Columns.Add("DateJoined", typeof(DateTime));
                dataTable.Columns.Add("DateJoinedUTC", typeof(DateTime));
                dataTable.Columns.Add("UserTypeId", typeof(int));
                dataTable.Columns.Add("Status", typeof(int));
                
                dataTable.Columns.Add("CustomerId", typeof(int));
                dataTable.Columns.Add("StaffMasterId", typeof(int));
                dataTable.Columns.Add("UserId", typeof(int));

                //dataTable.Columns.Add("UserRoleId", typeof(int));
                dataTable.Columns.Add("UserDesignationId", typeof(int));
                dataTable.Columns.Add("UserCompetencyId", typeof(string));
                dataTable.Columns.Add("UserSpecialityId", typeof(string));
                dataTable.Columns.Add("UserGradeId", typeof(int));
                dataTable.Columns.Add("Nationality", typeof(int));
                dataTable.Columns.Add("UserDepartmentId", typeof(int));
                //dataTable.Columns.Add("AccessLevl", typeof(int));userRegistration.AccessLevl, 
                dataTable.Columns.Add("FacilityId", typeof(int));
                dataTable.Columns.Add("Password", typeof(string));

                dataTable.Columns.Add("ContractorId", typeof(int));
                dataTable.Columns.Add("IsCenterPool", typeof(bool));
                dataTable.Columns.Add("LabourCostPerHour", typeof(decimal));
                dataTable.Columns.Add("ServicesID", typeof(int));
                //Adding Employee_ID Column 13/08/2020
                dataTable.Columns.Add("Employee_ID", typeof(string));
                //--------------------------------

                dataTable.Rows.Add(userRegistration.UserRegistrationId, userRegistration.ExistingStaff, 
                    userRegistration.StaffName, userRegistration.UserName, userRegistration.Gender, 
                    userRegistration.PhoneNumber, userRegistration.Email, userRegistration.MobileNumber, 
                    userRegistration.DateJoined, userRegistration.DateJoined, userRegistration.UserTypeId, 
                    userRegistration.Status, userRegistration.CustomerId, userRegistration.StaffMasterId, 
                    _UserSession.UserId, 
                    userRegistration.UserDesignationId, userRegistration.UserCompetencyId, 
                    userRegistration.UserSpecialityId, userRegistration.UserGradeId, userRegistration.Nationality, 
                    userRegistration.UserDepartmentId, _UserSession.FacilityId, 
                    userRegistration.Password, userRegistration.ContractorId, userRegistration.IsCenterPool,
                    userRegistration.LabourCostPerHour,
                    userRegistration.ServicesID, userRegistration.Employee_ID);

                //userRegistration.UserRoleId,

                var dataTable1 = new DataTable("UMUserLocationMstDetType");
                var FEMSdataTable1 = new DataTable("UMUserLocationMstDetType");
                var BEMSdataTable1 = new DataTable("UMUserLocationMstDetType");
                dataTable1.Columns.Add("LocationId", typeof(int));
                dataTable1.Columns.Add("CustomerId", typeof(int));
                dataTable1.Columns.Add("FacilityId", typeof(int));
                dataTable1.Columns.Add("UserRegistrationId", typeof(int));
                dataTable1.Columns.Add("UserRoleId", typeof(int));
                dataTable1.Columns.Add("UserId", typeof(int));
                ///creating fems
                FEMSdataTable1.Columns.Add("LocationId", typeof(int));
                FEMSdataTable1.Columns.Add("CustomerId", typeof(int));
                FEMSdataTable1.Columns.Add("FacilityId", typeof(int));
                FEMSdataTable1.Columns.Add("UserRegistrationId", typeof(int));
                FEMSdataTable1.Columns.Add("UserRoleId", typeof(int));
                FEMSdataTable1.Columns.Add("UserId", typeof(int));
                ///creating Bems
                BEMSdataTable1.Columns.Add("LocationId", typeof(int));
                BEMSdataTable1.Columns.Add("CustomerId", typeof(int));
                BEMSdataTable1.Columns.Add("FacilityId", typeof(int));
                BEMSdataTable1.Columns.Add("UserRegistrationId", typeof(int));
                BEMSdataTable1.Columns.Add("UserRoleId", typeof(int));
                BEMSdataTable1.Columns.Add("UserId", typeof(int));

                //-----
                int CUS_ID = Convert.ToInt32(userRegistration.CustomerId);
                
                Blocks CUS_MPID = Customer_mapping.GET_Customar_Mapping_IDS(CUS_ID);
                foreach (var item in userRegistration.LocationDetails)
                {

                    dataTable1.Rows.Add(item.LocationId, item.CustomerId, item.FacilityId, item.UserRegistrationId, item.UserRoleId, _UserSession.UserId);
                    FEMSdataTable1.Rows.Add(item.LocationId, CUS_MPID.FEMS_B_ID, facilitys_ID.FEMS_B_ID, MUserRegistrationId.FEMS_U_ID, 1, _UserSession.UserId);
                    BEMSdataTable1.Rows.Add(item.LocationId, CUS_MPID.BEMS_B_ID, facilitys_ID.BEMS_B_ID, MUserRegistrationId.BEMS_U_ID, 1, _UserSession.UserId);
                }

                FEMSdataTable = dataTable.Copy();
                FEMSdataTable.Columns.Remove("ServicesID");
                FEMSdataTable.Columns.Remove("Employee_ID");
                BEMSdataTable = FEMSdataTable.Copy();
                FEMSdataTable.Rows[0]["CustomerId"] = CUS_MPID.FEMS_B_ID;
                BEMSdataTable.Rows[0]["CustomerId"] = CUS_MPID.BEMS_B_ID;
                // BEMSdataTable.Rows[0]["UserRegistrationId"] = MPIDS.BEMS_U_ID;
                var ds = new DataSet();
                var Femsds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                var BEMSDBAccessDAL = new MASTERBEMSDBAccessDAL();
                var FEMSDBAccessDAL = new MASTERFEMSDBAccessDAL();
                //------------------get IDS-----/
               
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = spName;
                        if (spName == "UpdateUserRegistration")
                        {                          
                         dataTable.Columns.Remove("ServicesID");

                        }
                        var parameter = new SqlParameter();
                        parameter.ParameterName = "@UserRegistration";
                        parameter.SqlDbType = System.Data.SqlDbType.Structured;
                        parameter.Value = dataTable;
                        cmd.Parameters.Add(parameter);

                        parameter = new SqlParameter();
                        parameter.ParameterName = "@UserLocationDet";
                        parameter.SqlDbType = System.Data.SqlDbType.Structured;
                        parameter.Value = dataTable1;
                        cmd.Parameters.Add(parameter);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    userRegistration.UserRegistrationId = Convert.ToInt32(ds.Tables[0].Rows[0]["UserRegistrationId"]);
                    userRegistration.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                }



                //-----------------------Inserting into other DB--------//
                if (spName == "UpdateUserRegistration")
                {
                    //int CUS_ID =Convert.ToInt32( userRegistration.CustomerId);
                    //MPIDS = Get_User_IDS(userRegistration.UserRegistrationId);
                    //Blocks CUS_MPID = Customer_mapping.GET_Customar_Mapping_IDS(CUS_ID);
                    // FEMSdataTable.Columns["UserRegistrationId"].DefaultValue= MPIDS.FEMS_U_ID;
                    //// FEMSdataTable.Rows["UserRegistrationId"]. = MPIDS.FEMS_U_ID;
                    // FEMSdataTable.Rows[0]["UserRegistrationId"] = MPIDS.FEMS_U_ID;
                    // BEMSdataTable.Rows[0]["UserRegistrationId"] = MPIDS.BEMS_U_ID;
                    //FEMSdataTable.Rows[0]["FacilityId"] =facilitys_ID.FEMS_B_ID;
                    //BEMSdataTable.Rows[0]["FacilityId"] =facilitys_ID.BEMS_B_ID;
                    //FEMSdataTable.Rows[0]["FacilityId"] = CUS_MPID.FEMS_B_ID;
                    //BEMSdataTable.Rows[0]["FacilityId"]= CUS_MPID.BEMS_B_ID;
                   // dataTable.Columns.Remove("ServicesID");


                }
                ds.Clear();
                if (spName != "UpdateUserRegistration")
                {
                    //---------------------------------------------------
                    // if (spName != "UpdateUserRegistration")
                    // {
                   
                        using (SqlConnection con = new SqlConnection(BEMSDBAccessDAL.ConnectionString))
                        {
                            using (SqlCommand cmd = new SqlCommand())
                            {
                                if (spName == "UpdateUserRegistration")
                                {
                                    BEMSdataTable.Rows[0]["UserRegistrationId"] = MUserRegistrationId.BEMS_U_ID;

                                    // BEMSdataTable1.Rows[0]["UserRegistrationId"] = MUserRegistrationId.BEMS_U_ID;
                                }


                                cmd.Connection = con;
                                cmd.CommandType = CommandType.StoredProcedure;
                                cmd.CommandText = spName;

                                var parameter = new SqlParameter();
                                parameter.ParameterName = "@UserRegistration";
                                parameter.SqlDbType = System.Data.SqlDbType.Structured;
                                parameter.Value = BEMSdataTable;
                                cmd.Parameters.Add(parameter);

                                parameter = new SqlParameter();
                                parameter.ParameterName = "@UserLocationDet";
                                parameter.SqlDbType = System.Data.SqlDbType.Structured;
                                parameter.Value = BEMSdataTable1;
                                cmd.Parameters.Add(parameter);

                                var da = new SqlDataAdapter();
                                da.SelectCommand = cmd;
                                da.Fill(ds);
                            }
                        }
                        if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                        {
                            var inerted_ID = Convert.ToInt32(ds.Tables[0].Rows[0]["UserRegistrationId"]);
                            // userRegistration.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                            if (spName != "UpdateUserRegistration")
                            {
                                Update_UserReg_Mapping(userRegistration.UserRegistrationId, inerted_ID, 2);
                            }
                        }

                        ds.Clear();
                   
                    
                        using (SqlConnection con = new SqlConnection(FEMSDBAccessDAL.ConnectionString))
                        {
                            using (SqlCommand cmd = new SqlCommand())
                            {
                                cmd.Connection = con;
                                cmd.CommandType = CommandType.StoredProcedure;
                                cmd.CommandText = spName;
                                if (spName == "UpdateUserRegistration")
                                {
                                    FEMSdataTable.Rows[0]["UserRegistrationId"] = MUserRegistrationId.FEMS_U_ID;

                                    //  FEMSdataTable1.Rows[0]["UserRegistrationId"] = MUserRegistrationId.FEMS_U_ID;
                                }
                                var parameter = new SqlParameter();
                                parameter.ParameterName = "@UserRegistration";
                                parameter.SqlDbType = System.Data.SqlDbType.Structured;
                                parameter.Value = FEMSdataTable;
                                cmd.Parameters.Add(parameter);


                                parameter = new SqlParameter();
                                parameter.ParameterName = "@UserLocationDet";
                                parameter.SqlDbType = System.Data.SqlDbType.Structured;
                                parameter.Value = FEMSdataTable1;
                                cmd.Parameters.Add(parameter);

                                var da = new SqlDataAdapter();
                                da.SelectCommand = cmd;
                                da.Fill(ds);
                            }
                        }
                        if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                        {
                            var inerted_ID = Convert.ToInt32(ds.Tables[0].Rows[0]["UserRegistrationId"]);
                            // userRegistration.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                            if (spName != "UpdateUserRegistration")
                            {
                                Update_UserReg_Mapping(userRegistration.UserRegistrationId, inerted_ID, 1);
                            }
                        }


                        //   }
                        //----END----------------Inserting into other DB--------//
                    
                }
                else
                {

                }
                if (isSave)
                {
                    _EmailDAL.SendUserRegistrationEMail(userRegistration);
                }

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return userRegistration;
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
                        cmd.CommandText = "uspFM_UMUserRegistration_GetAll";

                        cmd.Parameters.AddWithValue("@PageIndex", pageFilter.PageIndex);
                        cmd.Parameters.AddWithValue("@PageSize", pageFilter.PageSize);
                        cmd.Parameters.AddWithValue("@strCondition", pageFilter.QueryWhereCondition);
                        cmd.Parameters.AddWithValue("@strSorting", strOrderBy);
                        cmd.Parameters.AddWithValue("@UserId", _UserSession.UserId);

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
                        cmd.Parameters.AddWithValue("@UserRegistrationId", _UserSession.UserId);
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
                                            StaffName = Convert.ToString(n["StaffName"]),
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

                                            UserDesignationId = n.Field<int>("UserDesignationId"),
                                            Nationality = n.Field<int>("Nationality"),
                                            UserGradeId = n.Field<int>("UserGradeId"),
                                            UserCompetencyId = n.Field<string>("UserCompetencyId"),
                                            UserDepartmentId = n.Field<int>("UserDepartmentId"),
                                            UserSpecialityId = n.Field<string>("UserSpecialityId"),
                                            ContractorId = n.Field<int>("ContractorId"),
                                            ContractorName = n.Field<string>("ContractorName"),
                                            IsCenterPool = n.Field<bool>("IsCenterPool"),
                                            LabourCostPerHour = n.Field<decimal?>("LabourCostPerHour"),
                                            Timestamp = Convert.ToBase64String((byte[])(n["Timestamp"])),
                                            ServicesID = Convert.ToString(n["ServicesID"]),
                                            Employee_ID = Convert.ToString(n["Employee_ID"])
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
        public bool IsUserNameDuplicate(UMUserRegistration userRegistration)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsUserNameDuplicate), Level.Info.ToString());

                var isDuplicate = true;
                string constring = ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ConnectionString;
                using (SqlConnection con = new SqlConnection(constring))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_UMUserRegistration_DuplicateCheck";
                        cmd.Parameters.AddWithValue("@pUserRegistrationId", userRegistration.UserRegistrationId);
                        cmd.Parameters.AddWithValue("@pUserName", userRegistration.UserName);
                        cmd.Parameters.Add("@IsDuplicate", SqlDbType.Bit);
                        cmd.Parameters["@IsDuplicate"].Direction = ParameterDirection.Output;

                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();
                        bool.TryParse(cmd.Parameters["@IsDuplicate"].Value.ToString(), out isDuplicate);
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(IsUserNameDuplicate), Level.Info.ToString());
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
        public bool IsEmailDuplicate(UMUserRegistration userRegistration)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsUserNameDuplicate), Level.Info.ToString());

                var isDuplicate = true;
                string constring = ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ConnectionString;
                using (SqlConnection con = new SqlConnection(constring))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_UMUserRegistration_Email_DuplicateCheck";
                        cmd.Parameters.AddWithValue("@pUserRegistrationId", userRegistration.UserRegistrationId);
                        cmd.Parameters.AddWithValue("@pEmail", userRegistration.Email);
                        cmd.Parameters.Add("@IsDuplicate", SqlDbType.Bit);
                        cmd.Parameters["@IsDuplicate"].Direction = ParameterDirection.Output;

                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();
                        bool.TryParse(cmd.Parameters["@IsDuplicate"].Value.ToString(), out isDuplicate);
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(IsUserNameDuplicate), Level.Info.ToString());
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

        public bool IsEmployeeIdDuplicate(UMUserRegistration userRegistration)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsEmployeeIdDuplicate), Level.Info.ToString());

                var isDuplicate = true;
                string constring = ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ConnectionString;
                using (SqlConnection con = new SqlConnection(constring))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_UMUserRegistration_Employee_DuplicateCheck";
                        cmd.Parameters.AddWithValue("@pUserRegistrationId", userRegistration.UserRegistrationId);
                        cmd.Parameters.AddWithValue("@pEmployeId", userRegistration.Employee_ID);
                        cmd.Parameters.Add("@IsDuplicate", SqlDbType.Bit);
                        cmd.Parameters["@IsDuplicate"].Direction = ParameterDirection.Output;

                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();
                        bool.TryParse(cmd.Parameters["@IsDuplicate"].Value.ToString(), out isDuplicate);
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(IsEmployeeIdDuplicate), Level.Info.ToString());
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
        public bool IsNoOfUsersExceeds(int contractorId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsRecordModified), Level.Info.ToString());

                var numberExceeds = false;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "UspFM_ContractorandVendor_AccessCheck";
                        cmd.Parameters.AddWithValue("@pContractorid", contractorId);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    numberExceeds = Convert.ToBoolean(ds.Tables[0].Rows[0][0]);
                }

                Log4NetLogger.LogExit(_FileName, nameof(IsRecordModified), Level.Info.ToString());
                return numberExceeds;
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
                        cmd.CommandText = "UspFM_UMUserRegistration_Delete";
                        cmd.Parameters.AddWithValue("@pUserRegistrationId", Id);

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
                        cmd.Parameters.AddWithValue("@UserRegistrationId", _UserSession.UserId);
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
        public UserRegistrationLovs GetAllLocations()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAllLocations), Level.Info.ToString());
                var userRegistrationLovs = new UserRegistrationLovs();

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_GetAllFacilities";
                        cmd.Parameters.AddWithValue("@UserRegistrationId", _UserSession.UserId);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    userRegistrationLovs.Locations = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(GetAllLocations), Level.Info.ToString());
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
        public List<object> GetStaffNames()
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
                        cmd.CommandText = "GetStaffNames";
                        //cmd.Parameters.AddWithValue("@Id", Id);
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
                return null;
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
        public void Update_UserReg_Mapping(int Master_UserRegID, int Module_ID, int Module_Type)
        {
            try
            {
                var ds = new DataSet();
                // inserting into Master DB
                var dbAccessDAL = new MASTERDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Master_Update_Master_UserRegID";

                        SqlParameter parameter = new SqlParameter();
                        cmd.Parameters.Add("@Master_UserRegID", SqlDbType.Int).Value = Master_UserRegID;
                        cmd.Parameters.Add("@Module_ID", SqlDbType.Int).Value = Module_ID;
                        cmd.Parameters.Add("@Module_Type", SqlDbType.Int).Value = Module_Type;
                        // cmd.Parameters.Add(parameter);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
            }
            catch (Exception)
            {

                throw;
            }


        }
        public User_Maping_ID Get_User_IDS(int Master_User_IDS)
        {
            User_Maping_ID ULersids = new User_Maping_ID();
            var dss = new DataSet();
            var MasterdbAccessDAL = new MASTERDBAccessDAL();
            using (SqlConnection con = new SqlConnection(MasterdbAccessDAL.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = con;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "Get_MasterServices_byUserId";
                    cmd.Parameters.AddWithValue("@UserID", Master_User_IDS);
                    var da = new SqlDataAdapter();
                    da.SelectCommand = cmd;
                    da.Fill(dss);
                }
            }
            if (dss.Tables.Count != 0)
            {

                ULersids.FEMS_U_ID = Convert.ToInt32(dss.Tables[0].Rows[0]["FEMS"]);
                ULersids.BEMS_U_ID = Convert.ToInt32(dss.Tables[0].Rows[0]["BEMS"]);
            }
            // Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
            return ULersids;
        }

        public class User_Maping_ID
        {
            public int FEMS_U_ID { get; set; }
            public int BEMS_U_ID { get; set; }
        }
    }
}
