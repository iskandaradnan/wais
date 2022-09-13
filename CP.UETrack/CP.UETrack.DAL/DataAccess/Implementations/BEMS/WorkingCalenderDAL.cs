using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity.Core;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using UETrack.DAL;

namespace CP.UETrack.DAL.DataAccess.Implementations.BEMS
{
    public class WorkingCalenderDAL : IWorkingCalenderDAL
    {
        private readonly static string fileName = nameof(WorkingCalenderDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        #region Load
        public FMWorkingCalendarSelectListViewModel Load(int Year)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());
                var WorkingCalendarModel = new FMWorkingCalendarSelectListViewModel();
                WorkingCalenderLovs lovs = null;
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "UspBEMS_MstWorkingCalendar_GetLovs";
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0)
                {
                    lovs = new WorkingCalenderLovs();
                    //assetClassificationLovs.StatusList = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                    lovs.MonthList = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                }
                var CurrentYear = DateTime.Today.Year;
                var CurrentDay = DateTime.Now;
                var _year = new List<int> {
                    CurrentYear,
                    DateTime.Today.Year -1
                };
                DateTimeFormatInfo dfi = DateTimeFormatInfo.CurrentInfo;
                Calendar cal = dfi.Calendar;
                var week = cal.GetWeekOfYear(CurrentDay, dfi.CalendarWeekRule,
                                                    dfi.FirstDayOfWeek);
                //if (week == 52 || week == 53)
                //{
                //_year.Add(CurrentYear + 1);
                //}
                int? Weekno = null;
                //var _State = lovDAL.GetStateValues<AsisStateMst>().Where(x => x.IsDeleted == false).Distinct().ToList();
                //using (var context = new ASISWebDatabaseEntities())
                //{
                var StateList = new List<int>();
                var Nextyear = "26";
                var year = 0;
                Nextyear = !(int.TryParse(Convert.ToString(Nextyear), out year)) ? null : Nextyear;
                Weekno = Nextyear != null ? Convert.ToInt32(Nextyear) : 52;
                if (week >= Weekno)
                {
                    _year.Add(CurrentYear + 1);
                }
                // }

                WorkingCalendarModel = new FMWorkingCalendarSelectListViewModel
                {
                    Month = lovs.MonthList,
                    Year = _year,
                    // FacilityId = _UserSession.FacilityId
                    FacilityId =_UserSession.FacilityId,
                    // = GetExistingState(Year),
                    Week = week,
                    CurrentYear = DateTime.Now.Year
                };
                Log4NetLogger.LogExit(fileName, nameof(Load), Level.Info.ToString());
                return WorkingCalendarModel;
            }
            catch (DALException dalException)
            {
                throw new DALException(dalException);
            }
            catch (Exception ex)
            {
                throw new GeneralException(ex);
            }
        }
        #endregion



        #region GetWorkingDay
        public IEnumerable<MstWorkingCalenderModel> GetWorkingDay(int intYear, int intFacilityId)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(GetWorkingDay), Level.Info.ToString());
                //var tranHelper = new TransactionHelper(new ASISWebDatabaseEntities());
                var weekHolidayDetails = new List<FacilityWeeklyHolidayMstDetViewModel>();

                var dbAccessDAL = new DBAccessDAL();
                var obj = new EngAssetClassification();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@Id", intFacilityId.ToString());
                parameters.Add("@Year", intYear.ToString());
                var WorkingCalendereDetails = new List<MstWorkingCalenderModel>();
                //  var WorkingCalendereDetails = tranHelper.GetEntitySetByCondition<FmsWorkingCalenderMst>("IsDeleted=False And Year =" + intYear + " And StateId = " + intStateId + " And HospitalId = null And CompanyId = null", "FMSWorkingCalenderMstDets", null).ToList();
                DataSet ds = dbAccessDAL.GetDataSet("UspBEMS_MstWorkingCalender_GetWorkingDay", parameters, DataSetparameters);
                if (ds.Tables != null && ds.Tables[0].Rows.Count > 0)
                {
                    weekHolidayDetails = (from n in ds.Tables[0].AsEnumerable()
                                          select new FacilityWeeklyHolidayMstDetViewModel
                                          {
                                              FacilityId = intFacilityId,
                                              WeeklyHoliday = Convert.ToInt32(n["LovId"]),
                                              WeekDayName = Convert.ToString(n["WeekDay"])
                                          }).ToList();
                }
                if (ds.Tables != null && ds.Tables[1].Rows.Count > 0)
                {
                    WorkingCalendereDetails.Add(new MstWorkingCalenderModel());
                    WorkingCalendereDetails[0].MstWorkingCalenderDets = (from n in ds.Tables[1].AsEnumerable()
                                                                         select new MstWorkingCalenderDetModel
                                                                         {
                                                                             CalenderDetId = Convert.ToInt32(n["CalenderDetId"]),
                                                                             Day = Convert.ToInt32(n["Day"]),
                                                                             CalenderId = Convert.ToInt32(n["CalenderId"]),
                                                                             Month = Convert.ToInt32(n["Month"]),
                                                                             IsWorking = Convert.ToBoolean(n["IsWorking"]),
                                                                             Remarks = Convert.ToString(n["Remarks"]),

                                                                         }).ToList();


                    if (WorkingCalendereDetails[0].MstWorkingCalenderDets != null && WorkingCalendereDetails[0].MstWorkingCalenderDets.Count > 0)
                    {
                        WorkingCalendereDetails[0].CalenderId = WorkingCalendereDetails[0].MstWorkingCalenderDets[0].CalenderId;
                        WorkingCalendereDetails[0].Year = intYear;
                        WorkingCalendereDetails[0].FacilityId = intFacilityId;
                    }
                }

                if (WorkingCalendereDetails.Count == 0 && weekHolidayDetails.Count == 0)
                {
                    return new List<MstWorkingCalenderModel>();
                }
                if (WorkingCalendereDetails.Count == 0)
                {
                    WorkingCalendereDetails.Add(new MstWorkingCalenderModel());
                }
                //var WorkingCalendar = AutoMapper.Mapper.Map<IEnumerable<FmsWorkingCalenderMst>, IEnumerable<FMSWorkingCalendarEntity>>(WorkingCalendereDetails);
                // var WorkingCalendar = new List<MstWorkingCalenderModel>();
                if (WorkingCalendereDetails != null && WorkingCalendereDetails.Count > 0)
                {
                    WorkingCalendereDetails.FirstOrDefault().FacilityWeeklyHolidayMstDets = weekHolidayDetails;

                    if (WorkingCalendereDetails.FirstOrDefault().MstWorkingCalenderDets != null && WorkingCalendereDetails.FirstOrDefault().MstWorkingCalenderDets.Count > 0)
                        WorkingCalendereDetails.FirstOrDefault().MstWorkingCalenderDets = WorkingCalendereDetails.FirstOrDefault().MstWorkingCalenderDets.Where(x => !x.Active).OrderBy(x => x.Month).ThenBy(x => x.Day).ToList();


                }
                Log4NetLogger.LogExit(fileName, nameof(GetWorkingDay), Level.Info.ToString());
                return WorkingCalendereDetails.AsEnumerable();
            }
            catch (DALException dalException)
            {
                throw new DALException(dalException);
            }
            catch (Exception ex)
            {
                throw new GeneralException(ex);
            }
        }
        #endregion

        #region Save
        public MstWorkingCalenderModel Save(MstWorkingCalenderModel model)
        {
            try
            {
                //      Convert.ToString()
                model.CustomerId = 1;
                int userid = 2;
                var dbAccessDAL = new DBAccessDAL();
                var obj = new EngAssetClassification();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@CustomerId", Convert.ToString(model.CustomerId));
                parameters.Add("@FacilityId", Convert.ToString(model.FacilityId));
                parameters.Add("@Year", Convert.ToString(model.Year));
                parameters.Add("@pCalenderId", Convert.ToString(model.CalenderId));
                parameters.Add("@userid", Convert.ToString(userid));

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable dt = new DataTable();

                dt.Columns.Add("CalenderDetId", typeof(int));
                dt.Columns.Add("CalenderId", typeof(int));
                dt.Columns.Add("Year", typeof(int));
                dt.Columns.Add("Month", typeof(int));
                dt.Columns.Add("Day", typeof(int));
                dt.Columns.Add("IsWorking", typeof(bool));
                dt.Columns.Add("Remarks", typeof(string));
                int i = 0;
                foreach (var monid in model.Month)
                {
                    var dayList = new List<MstWorkingCalenderDetModel>();
                    dayList = model.DayDetails[i].Where(x => x.Month == monid.LovId).ToList();
                    foreach (var day in dayList)
                    {
                        dt.Rows.Add(day.CalenderDetId, day.CalenderId, model.Year, day.Month, day.Day, day.IsWorking, day.Remarks);
                    }
                    i++;
                }
                DataSetparameters.Add("@MstWorkingCalenderDetTable", dt);

                DataTable ds = dbAccessDAL.GetDataTable("uspFM_MstWorkingCalenderDet_Save", parameters, DataSetparameters);
                if (ds != null)
                {
                    foreach (DataRow row in ds.Rows)
                    {
                        model.CalenderId = Convert.ToInt32(row["CalenderId"]);
                        model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    }
                }
                Log4NetLogger.LogExit(fileName, nameof(Save), Level.Info.ToString());
                return model;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception ex)
            {
                throw;
            }
        }
        #endregion     
    }
}
