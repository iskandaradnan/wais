using CP.UETrack.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.UETrack.Models;
using CP.UETrack.Model.CLS;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using UETrack.DAL;
using System.Dynamic;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.DAL.DataAccess.Contracts.CLS;

namespace CP.UETrack.DAL.DataAccess.Implementations.CLS
{
    public class WeekCalendarDAL : IWeekCalendarDAL
    {
        private readonly string _FileName = nameof(WeekCalendarDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public WeekCalendarDAL()
        {

        }

        public WeekCalendar Save(List<WeekCalendar> lstWeekCalender, out string ErrorMessage)
        {
            try
            {
                WeekCalendar model;
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
                        cmd.CommandText = "SP_CLS_WeekCalendarSave";
                        int NoOfRecordsInserted = 0;
                        con.Open();

                        foreach(var _weekCalendar in lstWeekCalender)
                        {
                            cmd.Parameters.Clear();
                                                        
                            cmd.Parameters.AddWithValue("@Customerid", _weekCalendar.CustomerId);
                            cmd.Parameters.AddWithValue("@Facilityid", _weekCalendar.FacilityId);
                            cmd.Parameters.AddWithValue("@Year", _weekCalendar.Year);
                            cmd.Parameters.AddWithValue("@Month", _weekCalendar.Month);
                            cmd.Parameters.AddWithValue("@WeekNo", _weekCalendar.WeekNo);
                            cmd.Parameters.AddWithValue("@StartDate", _weekCalendar.StartDate);
                            cmd.Parameters.AddWithValue("@EndDate", _weekCalendar.EndDate);

                            NoOfRecordsInserted = NoOfRecordsInserted + cmd.ExecuteNonQuery();
                        }

                        model = lstWeekCalender.Last<WeekCalendar>();

                        //if (NoOfRecordsInserted == lstWeekCalender.Count)
                        //{
                           
                        //}
                        //else
                        //{
                        //    model = new WeekCalendar();
                        //}

                        con.Close();
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

        public List<WeekCalendar> LoadStartDateEndDate(WeekCalendar model, out string ErrorMessage)
        {
            try
            {
                List<WeekCalendar> lstWeekCalendars = new List<WeekCalendar>();

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
                        cmd.CommandText = "sp_CLS_WeekCalendarDates";

                        cmd.Parameters.AddWithValue("@Facilityid", model.FacilityId);
                        cmd.Parameters.AddWithValue("@Year", model.Year);
                       
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }

                if (ds.Tables.Count != 0)
                {
                    foreach(DataRow dr in ds.Tables[0].Rows)
                    {
                        WeekCalendar _weekCalendar = new WeekCalendar();

                        _weekCalendar.WeekNo = Convert.ToInt16(dr["WeekNumber"]);
                        _weekCalendar.Month = dr["Month"].ToString();
                        _weekCalendar.StartDate = Convert.ToDateTime(dr["FirstDay"]);
                        _weekCalendar.EndDate = Convert.ToDateTime(dr["LastDay"]);

                        lstWeekCalendars.Add(_weekCalendar);
                    }                   
                }

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return lstWeekCalendars;
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
                        cmd.CommandText = "sp_CLS_WeekCalendar_GetAll";

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

        public List<WeekCalendar> Get(WeekCalendar model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                WeekCalendar weekCalendar = new WeekCalendar();

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "SP_CLS_WeekCalendar_Get";
                        cmd.Parameters.AddWithValue("@CustomerId", model.CustomerId);
                        cmd.Parameters.AddWithValue("@FacilityId", model.FacilityId);
                        cmd.Parameters.AddWithValue("@Year", model.Year);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }

                List<WeekCalendar> WeekCalendarRowsList = new List<WeekCalendar>();
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    WeekCalendar Auto = new WeekCalendar();

                    Auto.Month = dr["Month"].ToString();
                    Auto.WeekNo = Convert.ToInt32(dr["WeekNo"].ToString());
                    Auto.StartDate = Convert.ToDateTime(dr["StartDate"].ToString());
                    Auto.EndDate = Convert.ToDateTime(dr["EndDate"].ToString());
                    WeekCalendarRowsList.Add(Auto);
                }
                


                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return WeekCalendarRowsList;

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

