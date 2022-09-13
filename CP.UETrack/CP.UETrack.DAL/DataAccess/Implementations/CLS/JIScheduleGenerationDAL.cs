using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.CLS;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using CP.UETrack.Model.CLS;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using UETrack.DAL;

namespace CP.UETrack.DAL.DataAccess.Implementations.CLS
{
    public class JIScheduleGenerationDAL : IJIScheduleGenerationDAL
    {
        private readonly string _FileName = nameof(JIScheduleGenerationDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public JIDropdowns Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                JIDropdowns status = new JIDropdowns();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        var da = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_CLS_JIScheduleGeneration_Load";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pScreenName", "JIScheduleGeneration");
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables[0] != null)
                        {
                            status.StatusValues = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }

                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return status;
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

        public JIDropdowns GetYear()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetYear), Level.Info.ToString());

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_CLS_YearFetch";
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                JIDropdowns jIDropdowns = new JIDropdowns();

                if (ds.Tables[0] != null)
                {
                    jIDropdowns.YearValues = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                }

                Log4NetLogger.LogExit(_FileName, nameof(GetYear), Level.Info.ToString());
                return jIDropdowns;
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

        public JIDropdowns GetMonth(int Year)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetMonth), Level.Info.ToString());

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_CLS_GetMonthYear";
                        cmd.Parameters.AddWithValue("@Year", Year);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }

                JIDropdowns jIDropdowns = new JIDropdowns();

                if (ds.Tables[0] != null)
                {
                    jIDropdowns.MonthValues = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                }

                Log4NetLogger.LogExit(_FileName, nameof(GetMonth), Level.Info.ToString());
                return jIDropdowns;

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

        public JIDropdowns GetWeek(string YearMonth)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetWeek), Level.Info.ToString());

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_CLS_WeekNameData";
                        cmd.Parameters.AddWithValue("@YearMonth", YearMonth);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }

                JIDropdowns jIDropdowns = new JIDropdowns();

                if (ds.Tables[0] != null)
                {
                    jIDropdowns.WeekValues = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                }

                Log4NetLogger.LogExit(_FileName, nameof(GetWeek), Level.Info.ToString());
                return jIDropdowns;

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
                var strCondition = string.Empty;
                var QueryCondition = pageFilter.QueryWhereCondition;
               
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
                        cmd.CommandText = "Sp_CLS_JIScheduleGeneration_GetAll";

                        cmd.Parameters.AddWithValue("@PageIndex", pageFilter.PageIndex);
                        cmd.Parameters.AddWithValue("@PageSize", pageFilter.PageSize);
                        cmd.Parameters.AddWithValue("@StrCondition", strCondition);
                        cmd.Parameters.AddWithValue("@StrSorting", strOrderBy);

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
        public JIScheduleGeneration Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                JIScheduleGeneration jISchedule = new JIScheduleGeneration();
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_CLS_JIScheduleGeneration_Get";
                        cmd.Parameters.AddWithValue("Id", Id);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                JIScheduleGeneration _JiSchedule = new JIScheduleGeneration();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    DataRow dr = ds.Tables[0].Rows[0];
                    _JiSchedule.Year = Convert.ToInt32(dr["Year"].ToString());
                    _JiSchedule.Month = dr["Month"].ToString();
                    _JiSchedule.Week = Convert.ToInt32(dr["Week"].ToString());
                }
                if (ds.Tables[1] != null)
                {
                    if (ds.Tables[1].Rows.Count > 0)
                    {
                        List<JISchedule> _JIScheduleList = new List<JISchedule>();
                        foreach (DataRow dr in ds.Tables[1].Rows)
                        {

                            JISchedule Auto = new JISchedule();
                            Auto.DocumentNo = dr["DocumentNo"].ToString();
                            Auto.UserAreaLocations = dr["UserAreaLocations"].ToString();
                            Auto.UserAreaCode = dr["UserAreaCode"].ToString();
                            Auto.UserAreaName = dr["UserAreaName"].ToString();
                            Auto.Day = dr["Day"].ToString();
                            Auto.TargetDate = dr["TargetDate"].ToString();
                            Auto.Status = Convert.ToInt32(dr["Status"].ToString());
                            _JIScheduleList.Add(Auto);

                        }
                        _JiSchedule.ScheduleList = _JIScheduleList;
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return _JiSchedule;
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

        public JIScheduleGeneration UserFetch(JIScheduleGeneration schedule)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(UserFetch), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();


                DataTable dt = new DataTable();

                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "SP_CLS_JIScheduleGenerationFetch";

                        cmd.Parameters.AddWithValue("@Year", schedule.Year);
                        cmd.Parameters.AddWithValue("@Month", schedule.Month);
                        cmd.Parameters.AddWithValue("@WeekNo", schedule.Week);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(dt);
                    }
                }


                if (dt != null && dt.Rows.Count > 0)
                {
                    schedule.ScheduleList = (from n in dt.AsEnumerable()
                                             select new JISchedule
                                             {                                                 
                                                 UserAreaLocations = n.Field<string>("UserAreaLocations"),
                                                 UserAreaCode = n.Field<string>("UserAreaCode"),
                                                 UserAreaName = n.Field<string>("UserAreaName"),
                                                 Day = n.Field<string>("JISchedule"),
                                                 TargetDate = n.Field<string>("TargetDate"),
                                                 Status = n.Field<int>("Status")
                                             }).ToList();
                }

                Log4NetLogger.LogExit(_FileName, nameof(UserFetch), Level.Info.ToString());
                return schedule;

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

        public JIScheduleGeneration Save(JIScheduleGeneration model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                var spName = string.Empty;
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "SP_CLS_JIScheduleGeneration_Save";
                        cmd.Parameters.AddWithValue("@JIId", model.JIId);
                        cmd.Parameters.AddWithValue("@CustomerId", model.CustomerId);
                        cmd.Parameters.AddWithValue("@FacilityId", model.FacilityId);
                        cmd.Parameters.AddWithValue("@Year", model.Year);
                        cmd.Parameters.AddWithValue("@Month", model.Month);
                        cmd.Parameters.AddWithValue("@Week", model.Week);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                            cmd.Parameters.Clear();
                            model.JIId = Convert.ToInt32(ds.Tables[0].Rows[0]["JIId"]);
                            var ds1 = new DataSet();
                            cmd.CommandText = "SP_CLS_JIScheduleGeneration_GridSave";
                            foreach (var _schedule in model.ScheduleList)
                            {
                                cmd.Parameters.AddWithValue("@JIId", model.JIId);
                                cmd.Parameters.AddWithValue("@DocumentNo", _schedule.DocumentNo);
                                cmd.Parameters.AddWithValue("@UserAreaCode", _schedule.UserAreaCode);
                                cmd.Parameters.AddWithValue("@UserAreaName", _schedule.UserAreaName);
                                cmd.Parameters.AddWithValue("@Day", _schedule.Day);
                                cmd.Parameters.AddWithValue("@TargetDate", _schedule.TargetDate);
                                cmd.Parameters.AddWithValue("@Status", _schedule.Status);

                                da.SelectCommand = cmd;
                                da.Fill(ds1);
                                cmd.Parameters.Clear();
                            }
                        }
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return model;
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
