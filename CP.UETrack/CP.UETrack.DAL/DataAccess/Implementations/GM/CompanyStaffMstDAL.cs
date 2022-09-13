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
   
    public class CompanyStaffMstDAL : ICompanyStaffMstDAL
    {
        private readonly string _FileName = nameof(CompanyStaffMstDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public CompanyStaffMstDAL()
        {

        }
        public CompanyStaffMstDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                CompanyStaffMstDropdown CompanyStaffMstDropdown = null;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown_Others";
                        cmd.Parameters.AddWithValue("@pTablename", "MstStaff");
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                            CompanyStaffMstDropdown = new CompanyStaffMstDropdown();
                            CompanyStaffMstDropdown.RoleData = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                            CompanyStaffMstDropdown.CompetencyData = dbAccessDAL.GetLovRecords(ds.Tables[1]);
                            CompanyStaffMstDropdown.GradeData = dbAccessDAL.GetLovRecords(ds.Tables[3]);
                            CompanyStaffMstDropdown.SpecialityData = dbAccessDAL.GetLovRecords(ds.Tables[4]);
                        }

                        ds.Clear();
                        cmd.CommandText = "uspFM_Dropdown";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pLovKey", "EmployeeType");
                        da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                            CompanyStaffMstDropdown.EmployeeTypeData = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }

                        ds.Clear();
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pLovKey", "CommonGender");
                        da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                            CompanyStaffMstDropdown.GenderData = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }

                        ds.Clear();
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pLovKey", "NationalityValue");
                        da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                            CompanyStaffMstDropdown.NationalityData = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }

                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return CompanyStaffMstDropdown;
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
        public StaffMstViewModel Save(StaffMstViewModel CompanyStaffMst)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "UspFM_MstStaff_Save";
                        cmd.Parameters.AddWithValue("@pStaffMasterId", CompanyStaffMst.StaffMasterId);
                        cmd.Parameters.AddWithValue("@pCustomerId", _UserSession.UserId);
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);
                        cmd.Parameters.AddWithValue("@pUserRegistrationId", _UserSession.UserId);
                        cmd.Parameters.AddWithValue("@pAccessLevel", 9);
                        cmd.Parameters.AddWithValue("@pStaffEmployeeId", CompanyStaffMst.StaffEmployeeId);
                        cmd.Parameters.AddWithValue("@pStaffName", CompanyStaffMst.StaffName);
                        cmd.Parameters.AddWithValue("@pStaffRoleId", CompanyStaffMst.UMUserRoleId);
                        //cmd.Parameters.AddWithValue("@pDesignationId", 1);
                        cmd.Parameters.AddWithValue("@pStaffCompetencyId", CompanyStaffMst.StaffCompetencyId);
                        cmd.Parameters.AddWithValue("@pStaffSpecialityId", CompanyStaffMst.StaffSpecialityId);
                        if (CompanyStaffMst.GradeId == null)
                            cmd.Parameters.AddWithValue("@pStaffGraded",  DBNull.Value);
                        else
                            cmd.Parameters.AddWithValue("@pStaffGraded", CompanyStaffMst.GradeId);
                        //cmd.Parameters.AddWithValue("@pPersonalIdentityTypeLovId", CompanyStaffMst.PersonalIdentityTypeLovId);
                        //cmd.Parameters.AddWithValue("@pPersonalUniqueId", CompanyStaffMst.PersonalUniqueId);
                        cmd.Parameters.AddWithValue("@pEmployeeTypeLovId", CompanyStaffMst.EmployeeTypeLovId);
                        cmd.Parameters.AddWithValue("@pIsEmployeeShared", CompanyStaffMst.IsEmployeeShared);
                        cmd.Parameters.AddWithValue("@pGender", CompanyStaffMst.GenderLovId);
                        cmd.Parameters.AddWithValue("@pNationality", CompanyStaffMst.NationalityLovId);
                        cmd.Parameters.AddWithValue("@pEmail", CompanyStaffMst.Email);
                        cmd.Parameters.AddWithValue("@pActive", CompanyStaffMst.Status);
                        cmd.Parameters.AddWithValue("@pContactNo", CompanyStaffMst.ContactNo);
                        cmd.Parameters.AddWithValue("@pBuiltIn", 1);
                        cmd.Parameters.AddWithValue("@pCreatedBy", _UserSession.UserId);
                        cmd.Parameters.AddWithValue("@pModifiedBy", _UserSession.UserId);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0)
                {
                    CompanyStaffMst.StaffMasterId = Convert.ToInt32(ds.Tables[0].Rows[0]["StaffMasterId"]);
                    CompanyStaffMst.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                }

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return CompanyStaffMst;
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
                        cmd.CommandText = "uspFM_MstStaff_Company_GetAll";

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
                //return Blocks;
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
        public StaffMstViewModel Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                StaffMstViewModel CompanyStaffMst = null;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "UspFM_MstStaff_GetById";
                        cmd.Parameters.AddWithValue("@pStaffMasterId", Id);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0)
                {
                    CompanyStaffMst = (from n in ds.Tables[0].AsEnumerable()
                                         select new StaffMstViewModel
                                         {
                                             StaffMasterId = Id,
                                             StaffEmployeeId = Convert.ToString(n["StaffEmployeeId"]),
                                             StaffName = Convert.ToString(n["StaffName"]),
                                             UMUserRoleId = Convert.ToInt32(n["StaffRoleId"]),
                                             StaffCompetencyId = Convert.ToString(n["StaffCompetencyId"]),
                                             StaffSpecialityId = Convert.ToString(n["StaffSpecialityId"]),
                                             GradeId = Convert.ToInt32(n["StaffGraded"] == System.DBNull.Value ? 0 : n["StaffGraded"]),
                                             EmployeeTypeLovId = Convert.ToInt32(n["EmployeeTypeLovId"]),
                                             IsEmployeeShared = Convert.ToBoolean(n["IsEmployeeShared"]),
                                             GenderLovId = Convert.ToInt32(n["GenderLovId"]),
                                             NationalityLovId = Convert.ToInt32(n["NationalityLovId"]),
                                             Email = Convert.ToString(n["Email"]),
                                             ContactNo = Convert.ToString(n["ContactNo"]),
                                             Status = Convert.ToInt32(n["Active"]),
                                             Timestamp = Convert.ToBase64String((byte[])(n["Timestamp"]))
                                         }).FirstOrDefault();
                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return CompanyStaffMst;
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
        public bool IsStaffEmployeeIdDuplicate(StaffMstViewModel CompanyStaffMst)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsStaffEmployeeIdDuplicate), Level.Info.ToString());

                var isDuplicate = true;
                string constring = ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ConnectionString;
                using (SqlConnection con = new SqlConnection(constring))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_MstStaff_IsStaffEmployeeIdDuplicate";
                        cmd.Parameters.AddWithValue("@pStaffMasterId", CompanyStaffMst.StaffMasterId);
                        cmd.Parameters.AddWithValue("@StaffEmployeeId", CompanyStaffMst.StaffEmployeeId);
                        cmd.Parameters.Add("@IsDuplicate", SqlDbType.Bit);
                        cmd.Parameters["@IsDuplicate"].Direction = ParameterDirection.Output;
                        
                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();
                        bool.TryParse(cmd.Parameters["@IsDuplicate"].Value.ToString(), out isDuplicate);
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(IsStaffEmployeeIdDuplicate), Level.Info.ToString());
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
        public bool IsRecordModified(StaffMstViewModel CompanyStaffMst)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsRecordModified), Level.Info.ToString());

                var recordModifed = false;
                
                if(CompanyStaffMst.StaffMasterId != 0)
                {
                    var ds = new DataSet();
                    string constring = ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ConnectionString;
                    using (SqlConnection con = new SqlConnection(constring))
                    {
                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.Connection = con;
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.CommandText = "GetBlockTimestamp";
                            cmd.Parameters.AddWithValue("Id", CompanyStaffMst.StaffMasterId);
                            var da = new SqlDataAdapter();
                            da.SelectCommand = cmd;
                            da.Fill(ds);
                        }
                    }
                    if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        var timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                        if (timestamp != CompanyStaffMst.Timestamp)
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
                        cmd.CommandText = "UspFM_MstStaff_Delete";
                        cmd.Parameters.AddWithValue("@pStaffMasterId", Id);

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
    }
}
