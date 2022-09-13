using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.HWMS;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using CP.UETrack.Model.Common;
using CP.UETrack.Model.HWMS;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UETrack.DAL;

namespace CP.UETrack.DAL.DataAccess.Implementations.HWMS
{
    public class DailyTemperatureLogDAL : IDailyTemperatureLogDAL
    {
        private readonly string _FileName = nameof(BlockDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public DailyDropDowns Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                DailyDropDowns daily = new DailyDropDowns();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        var da = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_HWMS_DailyTemperatureLog_Load";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pScreenName", "DailyTemperatureLog");
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables[0] != null)
                        {
                            daily.DailyYearValues = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }
                        if (ds.Tables[1] != null)
                        {
                            daily.DailyMonthValues = dbAccessDAL.GetLovRecords(ds.Tables[1]);
                        }
                        if (ds.Tables[2] != null)
                        {
                            daily.TemperatureReadingValues = dbAccessDAL.GetLovRecords(ds.Tables[2]);
                        }
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return daily;
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

        public DailyTemperatureLog Save(DailyTemperatureLog model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                var spName = string.Empty;
                var ds = new DataSet();
                var ds1 = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_HWMS_DailyTemperatureLog";


                        cmd.Parameters.AddWithValue("@pDailyId", model.DailyId);
                        cmd.Parameters.AddWithValue("@pCustomerId", model.CustomerId);
                        cmd.Parameters.AddWithValue("@pFacilityId", model.FacilityId);
                        cmd.Parameters.AddWithValue("@pYear", model.Year);
                        cmd.Parameters.AddWithValue("@pMonth", model.Month);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                        if (ds.Tables.Count != 0)
                        {
                            if (ds.Tables[0].Rows[0][0].ToString() == "-1")
                            {
                                ErrorMessage = "Daily Temperature Log record already exist for the selected Year and Month";
                            }
                            else
                            {
                                cmd.Parameters.Clear();
                                model.DailyId = Convert.ToInt32(ds.Tables[0].Rows[0]["DailyId"]);

                                var da1 = new SqlDataAdapter();
                                cmd.CommandText = "sp_HWMS_DailyTemperatureLogDate";

                                foreach (var table in model.dailyTemperatureLogsList)
                                {
                                    cmd.Parameters.Clear();
                                    cmd.Parameters.AddWithValue("@TemperatureId", table.TemperatureId);
                                    cmd.Parameters.AddWithValue("@pDate", table.Date);
                                    cmd.Parameters.AddWithValue("@pTemperatureReading", table.TemperatureReading);
                                    cmd.Parameters.AddWithValue("@pDailyId", model.DailyId);
                                    cmd.Parameters.AddWithValue("@isDeleted", table.isDeleted);
                                    da.SelectCommand = cmd;
                                    da.Fill(ds1);

                                    if (ds1.Tables[0].Rows[0][0].ToString() == "-1")
                                    {
                                        ErrorMessage = "Date already exists";
                                    }
                                }

                                model = Get(model.DailyId);
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
                        cmd.CommandText = "SP_HWMS_DailyTemperatureLog_GetAll";
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

        public DailyTemperatureLog Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_HWMS_DailyTemperatureLog_Get";
                        cmd.Parameters.AddWithValue("Id", Id);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                DailyTemperatureLog _type = new DailyTemperatureLog();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    DataRow dr = ds.Tables[0].Rows[0];
                    _type.DailyId = Convert.ToInt32(dr["DailyId"].ToString());
                    _type.Year = Convert.ToInt32(dr["Year"].ToString());
                    _type.Month = dr["Month"].ToString();
                }
                if (ds.Tables[1] != null)
                {
                    if (ds.Tables[1].Rows.Count > 0)
                    {
                        List<DailyDate> _dailyDates = new List<DailyDate>();
                        foreach (DataRow dr in ds.Tables[1].Rows)
                        {
                            DailyDate wasteTypes = new DailyDate();

                            wasteTypes.TemperatureId = Convert.ToInt32(dr["DateId"].ToString());
                            wasteTypes.Date = Convert.ToDateTime(dr["Date"].ToString());
                            wasteTypes.TemperatureReading = dr["TemperatureReading"].ToString();
                            _dailyDates.Add(wasteTypes);
                        }
                        _type.dailyTemperatureLogsList = _dailyDates;
                    }
                }
                if (ds.Tables[2].Rows.Count > 0)
                {
                    List<Attachment> _attachmentList = new List<Attachment>();

                    foreach (DataRow dr in ds.Tables[2].Rows)
                    {
                        Attachment obj = new Attachment();

                        obj.AttachmentId = Convert.ToInt32(dr["AttachmentId"]);
                        obj.FileType = dr["FileType"].ToString();
                        obj.FileName = dr["FileName"].ToString();
                        obj.AttachmentName = dr["AttachmentName"].ToString();
                        obj.FilePath = dr["FilePath"].ToString();
                        _attachmentList.Add(obj);

                    }
                    _type.AttachmentList = _attachmentList;
                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return _type;
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

        public DailyTemperatureLog Get(string YearMonth)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_HWMS_DailyTemperatureLog_Getby_YearMonth";
                        cmd.Parameters.AddWithValue("YearMonth", YearMonth);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                DailyTemperatureLog _type = new DailyTemperatureLog();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    DataRow dr = ds.Tables[0].Rows[0];
                    _type.DailyId = Convert.ToInt32(dr["DailyId"].ToString());
                    _type.Year = Convert.ToInt32(dr["Year"].ToString());
                    _type.Month = dr["Month"].ToString();
                }
                if (ds.Tables[1] != null)
                {
                    if (ds.Tables[1].Rows.Count > 0)
                    {
                        List<DailyDate> _dailyDates = new List<DailyDate>();
                        foreach (DataRow dr in ds.Tables[1].Rows)
                        {
                            DailyDate wasteTypes = new DailyDate();

                            wasteTypes.TemperatureId = Convert.ToInt32(dr["DateId"].ToString());
                            wasteTypes.Date = Convert.ToDateTime(dr["Date"].ToString());
                            wasteTypes.TemperatureReading = dr["TemperatureReading"].ToString();
                            _dailyDates.Add(wasteTypes);
                        }
                        _type.dailyTemperatureLogsList = _dailyDates;
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return _type;
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
