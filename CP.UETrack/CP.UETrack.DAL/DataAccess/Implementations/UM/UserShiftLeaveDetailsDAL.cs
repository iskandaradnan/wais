using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.UM;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using CP.UETrack.Model.UM;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UETrack.DAL;

namespace CP.UETrack.DAL.DataAccess.Implementations.UM
{
    public class UserShiftLeaveDetailsDAL : IUserShiftLeaveDetailsDAL
    {
        private readonly string _FileName = nameof(UserShiftLeaveDetailsDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public UserShiftLeaveDetailsDAL()
        {

        }

        public UserShiftLeaveDropdownValues Load()
        {
            //throw new NotImplementedException();
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                UserShiftLeaveDropdownValues UserShiftLeaveDropdownValues = null;
                var UserworkShiftDuration = Convert.ToInt32(ConfigurationManager.AppSettings["UserworkShiftDuration"]);
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))           
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown";
                        cmd.Parameters.AddWithValue("@pLovKey", "ShiftLunchTimeValue,UserShiftTimingsValues");
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                            UserShiftLeaveDropdownValues = new UserShiftLeaveDropdownValues();
                            UserShiftLeaveDropdownValues.ShiftLunchTime = dbAccessDAL.GetLovRecords(ds.Tables[0], "ShiftLunchTimeValue");
                            UserShiftLeaveDropdownValues.ShiftTime = dbAccessDAL.GetLovRecords(ds.Tables[0], "UserShiftTimingsValues");
                            UserShiftLeaveDropdownValues.UserworkShiftTime = UserworkShiftDuration;

                        }


                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return UserShiftLeaveDropdownValues;
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

        public UserShiftLeaveViewModel Get(int Id)
        {
         
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                UserShiftLeaveViewModel entity = null;
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pUserShiftsId", Id.ToString());
                DataSet ds = dbAccessDAL.GetDataSet("UspFM_UMUserShifts_GetById", parameters, DataSetparameters);
                if (ds != null)
                {
                    if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)

                    {
                        entity = new UserShiftLeaveViewModel();
                        entity.UserRegistrationId = Convert.ToInt16(ds.Tables[0].Rows[0]["UserRegistrationId"]);
                        entity.UserShiftsId = Convert.ToInt16(ds.Tables[0].Rows[0]["UserShiftsId"]);
                        entity.StaffName = Convert.ToString(ds.Tables[0].Rows[0]["StaffName"]);
                        entity.MobileNumber = Convert.ToString(ds.Tables[0].Rows[0]["MobileNumber"]);
                        entity.UserType = Convert.ToString(ds.Tables[0].Rows[0]["UserTypeName"]);
                        entity.AccessLevel = Convert.ToString(ds.Tables[0].Rows[0]["AccessLevelValue"]);
                        //entity.Role = Convert.ToString(ds.Tables[0].Rows[0]["Role"]);
                        entity.Designation = Convert.ToString(ds.Tables[0].Rows[0]["DesignationName"]);
                        entity.LunchTimeLovId = Convert.ToInt32(ds.Tables[0].Rows[0]["LunchTimeLovId"]);
                        entity.ShiftTime = ds.Tables[0].Rows[0].Field<int?>("ShiftTimeLovId");
                        entity.ShiftStartTime = Convert.ToString(ds.Tables[0].Rows[0]["ShiftStartTime"]);
                        entity.ShiftStartTimeMin = Convert.ToString(ds.Tables[0].Rows[0]["ShiftStartTimeMin"]);
                        entity.ShiftEndTime = Convert.ToString(ds.Tables[0].Rows[0]["ShiftEndTime"]);
                        entity.ShiftEndTimeMin = Convert.ToString(ds.Tables[0].Rows[0]["ShiftEndTimeMin"]);
                        entity.ShiftBreakStartTime = Convert.ToString(ds.Tables[0].Rows[0]["ShiftBreakStartTime"]);
                        entity.ShiftBreakStartTimeMin = Convert.ToString(ds.Tables[0].Rows[0]["ShiftBreakStartTimeMin"]);
                        entity.ShiftBreakEndTime = Convert.ToString(ds.Tables[0].Rows[0]["ShiftBreakEndTime"]);
                        entity.ShiftBreakEndTimeMin = Convert.ToString(ds.Tables[0].Rows[0]["ShiftBreakEndTimeMin"]);
                        entity.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));

                    }
                   //entity.UserShiftLeaveGridData = (from n in ds.Tables[1].AsEnumerable()
                   //select new UserShiftLeaveGrid
                   // {
                   //   UserShiftDetId = Convert.ToInt32(ds.Tables[1].Rows[0]["UserShiftDetId"]),
                   //   LeaveFromGrid = Convert.ToDateTime(ds.Tables[1].Rows[0]["LeaveFrom"]),
                   //   LeaveToGrid = Convert.ToDateTime(ds.Tables[1].Rows[0]["LeaveTo"]),
                   //   NoOfDays=Convert.ToInt32(ds.Tables[1].Rows[0]["NoOfDays"]),
                   //   Remarks = Convert.ToString(ds.Tables[1].Rows[0]["Remarks"]),
                   // }).ToList();


                    var list = (from n in ds.Tables[1].AsEnumerable()
                                           select new UserShiftLeaveGrid
                                           {
                                               UserShiftDetId = Convert.ToInt32(n["UserShiftDetId"]),
                                               LeaveFromGrid = Convert.ToDateTime(n["LeaveFrom"]),
                                               LeaveToGrid = Convert.ToDateTime(n["LeaveTo"]),
                                               NoOfDays = Convert.ToInt16(n["NoOfDays"]),
                                               Remarks = Convert.ToString(n["Remarks"]),
                                           
                                           }).ToList();

                    if (list != null && list.Count > 0)
                    {
                        entity.UserShiftLeaveGridData = list; 
                    }

                }
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
        public UserShiftLeaveViewModel GetLeaveDetails(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var entity = new UserShiftLeaveViewModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pUserRegistrationId", Id.ToString());
                DataSet ds = dbAccessDAL.GetDataSet("uspFM_UMUserShifts_GetByUserRegId", parameters, DataSetparameters);
                if (ds != null)
                {
                    if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                    {
                        entity.UserRegistrationId = Convert.ToInt16(ds.Tables[0].Rows[0]["UserRegistrationId"]);
                        entity.UserShiftsId = Convert.ToInt16(ds.Tables[0].Rows[0]["UserShiftsId"]);
                        entity.StaffName = Convert.ToString(ds.Tables[0].Rows[0]["StaffName"]);
                        entity.MobileNumber = Convert.ToString(ds.Tables[0].Rows[0]["MobileNumber"]);
                        entity.UserType = Convert.ToString(ds.Tables[0].Rows[0]["UserTypeName"]);
                        //entity.AccessLevel = Convert.ToString(ds.Tables[0].Rows[0]["AccessLevelValue"]);
                        //entity.Role = Convert.ToString(ds.Tables[0].Rows[0]["Role"]);
                        entity.Designation = Convert.ToString(ds.Tables[0].Rows[0]["DesignationName"]);
                        entity.LunchTimeLovId = Convert.ToInt32(ds.Tables[0].Rows[0]["LunchTimeLovId"]);
                        entity.ShiftTime = ds.Tables[0].Rows[0].Field<int?>("ShiftTimeLovId");
                        entity.ShiftStartTime = Convert.ToString(ds.Tables[0].Rows[0]["ShiftStartTime"]);
                        entity.ShiftStartTimeMin = Convert.ToString(ds.Tables[0].Rows[0]["ShiftStartTimeMin"]);
                        entity.ShiftEndTime = Convert.ToString(ds.Tables[0].Rows[0]["ShiftEndTime"]);
                        entity.ShiftEndTimeMin = Convert.ToString(ds.Tables[0].Rows[0]["ShiftEndTimeMin"]);
                        entity.ShiftBreakStartTime = Convert.ToString(ds.Tables[0].Rows[0]["ShiftBreakStartTime"]);
                        entity.ShiftBreakStartTimeMin = Convert.ToString(ds.Tables[0].Rows[0]["ShiftBreakStartTimeMin"]);
                        entity.ShiftBreakEndTime = Convert.ToString(ds.Tables[0].Rows[0]["ShiftBreakEndTime"]);
                        entity.ShiftBreakEndTimeMin = Convert.ToString(ds.Tables[0].Rows[0]["ShiftBreakEndTimeMin"]);
                        entity.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                    }

                    if (ds.Tables[1] != null && ds.Tables[1].Rows.Count > 0)
                    { 
                        var list = (from n in ds.Tables[1].AsEnumerable()
                                    select new UserShiftLeaveGrid
                                    {
                                        UserShiftDetId = Convert.ToInt32(n["UserShiftDetId"]),
                                        LeaveFromGrid = Convert.ToDateTime(n["LeaveFrom"]),
                                        LeaveToGrid = Convert.ToDateTime(n["LeaveTo"]),
                                        NoOfDays = Convert.ToInt16(n["NoOfDays"]),
                                        Remarks = Convert.ToString(n["Remarks"]),

                                    }).ToList();

                        if (list != null && list.Count > 0)
                        {
                            entity.UserShiftLeaveGridData = list;
                        }
                    }
                
                    //entity.UserShiftLeaveGridData = (from n in ds.Tables[1].AsEnumerable()
                    //                                 select new UserShiftLeaveGrid
                    //                                 {
                    //                                     UserShiftDetId = Convert.ToInt32(ds.Tables[1].Rows[0]["UserShiftDetId"]),
                    //                                     LeaveFromGrid = Convert.ToDateTime(ds.Tables[1].Rows[0]["LeaveFrom"]),
                    //                                     LeaveToGrid = Convert.ToDateTime(ds.Tables[1].Rows[0]["LeaveTo"]),
                    //                                     NoOfDays = Convert.ToInt32(ds.Tables[1].Rows[0]["NoOfDays"]),
                    //                                     Remarks = Convert.ToString(ds.Tables[1].Rows[0]["Remarks"]),
                    //                                 }).ToList();

                }
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
                var QueryCondition = pageFilter.QueryWhereCondition;
                var strCondition = string.Empty;
                if (string.IsNullOrEmpty(QueryCondition))
                {
                    strCondition = "FacilityId = " + _UserSession.FacilityId.ToString();
                }
                else
                {
                    strCondition = QueryCondition + " AND FacilityId = " + _UserSession.FacilityId.ToString();
                }
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_UMUserShifts_GetAll";

                        cmd.Parameters.AddWithValue("@PageIndex", pageFilter.PageIndex);
                        cmd.Parameters.AddWithValue("@PageSize", pageFilter.PageSize);
                        cmd.Parameters.AddWithValue("@strCondition", strCondition);
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
        public UserShiftLeaveViewModel Save(UserShiftLeaveViewModel UserShiftLeave, out string ErrorMessage)
        {
            //throw new NotImplementedException();
            try

            {
                ErrorMessage = string.Empty;
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                UserShiftLeaveViewModel griddata = new UserShiftLeaveViewModel();
                var dbAccessDAL = new DBAccessDAL();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pUserShiftsId", Convert.ToString(UserShiftLeave.UserShiftsId));
                parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pUserRegistrationId", Convert.ToString(UserShiftLeave.UserRegistrationId));
                parameters.Add("@pLunchTimeLovId", Convert.ToString(302));
                parameters.Add("@pLeaveFrom", Convert.ToString(null));
                parameters.Add("@pLeaveTo", Convert.ToString(null));
                parameters.Add("@pNoOfDays", Convert.ToString(null));
                parameters.Add("@pRemarks", Convert.ToString(UserShiftLeave.Remarks));
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@pTimestamp", Convert.ToString(UserShiftLeave.Timestamp));
                parameters.Add("@pShiftTimeLovId", Convert.ToString(null));
                parameters.Add("@ShiftStartTime", Convert.ToString(UserShiftLeave.ShiftStartTime));
                parameters.Add("@ShiftStartTimeMin", Convert.ToString(UserShiftLeave.ShiftStartTimeMin));
                parameters.Add("@ShiftEndTime", Convert.ToString(UserShiftLeave.ShiftEndTime));
                parameters.Add("@ShiftEndTimeMin", Convert.ToString(UserShiftLeave.ShiftEndTimeMin));
                parameters.Add("@ShiftBreakStartTime", Convert.ToString(UserShiftLeave.ShiftBreakStartTime));
                parameters.Add("@ShiftBreakStartTimeMin", Convert.ToString(UserShiftLeave.ShiftBreakStartTimeMin));
                parameters.Add("@ShiftBreakEndTime", Convert.ToString(UserShiftLeave.ShiftBreakEndTime));
                parameters.Add("@ShiftBreakEndTimeMin", Convert.ToString(UserShiftLeave.ShiftBreakEndTimeMin));
                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable dt = new DataTable();
                if (UserShiftLeave.UserShiftLeaveGridData != null)
                {
                    dt.Columns.Add("UserShiftDetId", typeof(int));
                    dt.Columns.Add("LeaveFrom", typeof(DateTime));
                    dt.Columns.Add("LeaveTo", typeof(DateTime));
                    dt.Columns.Add("NoOfDays", typeof(Decimal));
                    dt.Columns.Add("Remarks", typeof(string));
                    dt.Columns.Add("UserId", typeof(int));

                    var deletedId = UserShiftLeave.UserShiftLeaveGridData.Where(y => y.IsDeleted).Select(x => x.UserShiftDetId).ToList();
                    var idstring = string.Empty;
                    if (deletedId.Count() > 0)
                    {
                        foreach (var item in deletedId.Select((value, i) => new { i, value }))
                        {
                            idstring += item.value;
                            if (item.i != deletedId.Count() - 1)
                            { idstring += ","; }
                        }
                        deleteChildRecords(idstring);
                    }
                    foreach (var i in UserShiftLeave.UserShiftLeaveGridData.Where(y => !y.IsDeleted))
                    {
                        dt.Rows.Add(i.UserShiftDetId, i.LeaveFromGrid, i.LeaveToGrid, i.NoOfDays, null, _UserSession.UserId);

                    }

                    DataSetparameters.Add("@pUMUserShiftsDet", dt);
                }
               
                DataTable dt1 = dbAccessDAL.GetDataTable("uspFM_UMUserShifts_Save", parameters, DataSetparameters);
                if (dt1 != null)
                {
                    foreach (DataRow row in dt1.Rows)
                    {
                        UserShiftLeave.UserShiftsId = Convert.ToInt32(row["UserShiftsId"]);
                        UserShiftLeave.UserRegistrationId = Convert.ToInt32(row["UserRegistrationId"]);
                        UserShiftLeave.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                        ErrorMessage = Convert.ToString(row["ErrorMessage"]);

                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return UserShiftLeave;
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
            public void deleteChildRecords(string id)
        {
            try
            {
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_UMUserShiftsDet_Delete";
                        cmd.Parameters.AddWithValue("@pUserShiftDetId", id);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
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


