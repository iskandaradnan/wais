using CP.Framework.Common.Audit;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.BLL.BusinessAccess.Contracts.BEMS;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using FluentValidation;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace UETrack.Application.Web.API.API.BEMS
{
    [RoutePrefix("api/WorkingCalender")]
    [WebApiAudit]
    public class WorkingCalenderAPIController : BaseApiController
    {
        private readonly IWorkingCalenderBAL _workingCalenderBAL;
        private readonly string fileName = nameof(ContractorandVendorAPIController);

        public WorkingCalenderAPIController(IWorkingCalenderBAL bal)
        {
            _workingCalenderBAL = bal;
        }

        [HttpGet]
        [Route("Load/{CurrentYear}")]
        public HttpResponseMessage Load(int CurrentYear)
        {

            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());
                var WCList = _workingCalenderBAL.Load(CurrentYear);

                WCList.DayList = DayCount(CurrentYear, null, null, null);
               
                responseObject = (WCList.Year.Count() == 0 || WCList.Month.Count() == 0) ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, WCList);
                Log4NetLogger.LogExit(fileName, nameof(Load), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }
        public static List<List<MstWorkingCalenderDetModel>> DayCount(int year, List<MstWorkingCalenderDetModel> WcDetEntity, List<MstWorkingCalenderDetModel> WcDetCopyEntity, List<FacilityWeeklyHolidayMstDetViewModel> WCWeekHolidayEntity)
        {
            var idx = 0;
            var WcEntity = WcDetCopyEntity == null ? WcDetEntity : WcDetCopyEntity;
            List<MstWorkingCalenderDetModel> ObjWCEntity = null;
            var dayList = Enumerable.Range(1, 12).Select(m =>
                    Enumerable.Range(1, DateTime.DaysInMonth(year, m))  // Days: 1, 2 ... 31 etc.
                   .Select(day => new MstWorkingCalenderDetModel
                   {
                       Day = new DateTime(year, m, day).Day,
                       DayName = new DateTime(year, m, day).DayOfWeek.ToString().Substring(0, 1),
                       IsWorking = IsWorkingDay(year, m, day, new DateTime(year, m, day).DayOfWeek.ToString(), WcEntity, WcDetEntity, WCWeekHolidayEntity, ref ObjWCEntity, ref idx),
                       CalenderDetId = (WcEntity != null && ObjWCEntity != null) ? ObjWCEntity[0].CalenderDetId : 0,
                       CalenderId = (WcEntity != null && ObjWCEntity != null) ? ObjWCEntity[0].CalenderId : 0,
                       Month = (WcEntity != null && ObjWCEntity != null) ? ObjWCEntity[0].Month : m,
                       Remarks = (WcEntity != null && ObjWCEntity != null) ? ObjWCEntity[0].Remarks : "",
                       CreatedBy = (WcEntity != null && ObjWCEntity != null) ? ObjWCEntity[0].CreatedBy : 0,
                       CreatedDate = (WcEntity != null && ObjWCEntity != null) ? ObjWCEntity[0].CreatedDate : DateTime.Now,
                       Index = idx,
                       Date = new DateTime(year, m, day).Date,
                       CurrentDate = DateTime.Today,
                       CurrentMonth = DateTime.Now.Month,
                       DaysCheck= GetDayCheck(new DateTime(year, m, day))

                   }).ToList()).ToList(); // Map each day to a date

            return dayList;
        }


        private static bool GetDayCheck(DateTime date )
        {

            bool daychecck = false;
            daychecck = (DateTime.Now.Date > date.Date) ? true : false; 
            return daychecck;
        }


        [HttpGet]
        [Route("GetWorkingDay/{intYear}/{intFacilityId}/{intCopyFromFacilityId}")]
        public HttpResponseMessage GetWorkingDay(int intYear, int intFacilityId, int intCopyFromFacilityId)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(GetWorkingDay), Level.Info.ToString());
                var WCDefList = WorkingDays(intYear, intFacilityId, intCopyFromFacilityId);
                responseObject = (WCDefList.Year.Count() == 0 || WCDefList.Month.Count() == 0) ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, WCDefList);
                Log4NetLogger.LogExit(fileName, nameof(Load), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = string.Format("{0} : {1}", resxFileHelper.GetErrorMessagesFromResource("GeneralException"), ex.Message);
            }
            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }
        private FMWorkingCalendarSelectListViewModel WorkingDays(int intYear, int intFacilityId, int intCopyFromFacilityId)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(WorkingDays), Level.Info.ToString());
                var WCDefList = _workingCalenderBAL.Load(intYear);
                var WCStWList = _workingCalenderBAL.GetWorkingDay(intYear, intFacilityId);
                var WCCStWList = _workingCalenderBAL.GetWorkingDay(intYear, intCopyFromFacilityId);
                var WCStWMstDets = WCStWList.Count() > 0 ? WCStWList.FirstOrDefault().MstWorkingCalenderDets : null;
                var WCCStWMstDets = WCCStWList.Count() > 0 ? WCCStWList.FirstOrDefault().MstWorkingCalenderDets : null;
                var WCCstWkHolDets = WCStWList.Count() > 0 ? WCStWList.FirstOrDefault().FacilityWeeklyHolidayMstDets : null;

                WCDefList.DayList = DayCount(intYear, (intFacilityId > 0) ? WCStWMstDets : null, intFacilityId > 0 ? WCCStWMstDets : null, intFacilityId > 0 ? WCCstWkHolDets : null);
                WCDefList.CalenderId = (WCStWList.Count() > 0) ? WCStWList.FirstOrDefault().CalenderId : 0;
               // WCDefList.Timestamp = (WCStWList.Count() > 0) ? WCStWList.FirstOrDefault().Timestamp : null;
                Log4NetLogger.LogExit(fileName, nameof(Load), Level.Info.ToString());
                return WCDefList;
            }
            catch (Exception ex)
            {
                returnMessage = string.Format("{0} : {1}", resxFileHelper.GetErrorMessagesFromResource("GeneralException"), ex.Message);
            }
            return null;
        }


        [HttpPost]
        [Route("Add")]
        public HttpResponseMessage Post(MstWorkingCalenderModel WorkingCalendar)
        {
            Log4NetLogger.LogEntry(fileName, nameof(Post), Level.Info.ToString());
            try
            {
                var ErrorMessage = string.Empty;
                if (WorkingCalendar == null)
                {
                    return responseObject = BuildResponseObject(HttpStatusCode.BadRequest, false);
                }
                if (!ModelState.IsValid)
                {
                    return BuildResponseObject(HttpStatusCode.BadRequest, false, ModelState);
                }
            
                var modelTxn = _workingCalenderBAL.Save(WorkingCalendar, out ErrorMessage);
                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {
                    if (modelTxn == null || modelTxn.CalenderId == 0)
                        BuildResponseObject(false, resxFileHelper.GetErrorMessagesFromResource("CreateFailed"));
                    else
                    {
                        var ResultData = WorkingDays(WorkingCalendar.Year, WorkingCalendar.FacilityId, 0);                        
                        ResultData.WorkingCalendar = modelTxn;
                        responseObject = (modelTxn != null) ? responseObject = BuildResponseObject(HttpStatusCode.Created, ResultData) : responseObject = BuildResponseObject(false, resxFileHelper.GetErrorMessagesFromResource("CreateFailed"));
                        
                    }        

                }
                Log4NetLogger.LogExit(fileName, nameof(Post), Level.Info.ToString());
            }
            catch (ValidationException ex)
            {
                responseObject = BuildResponseObject(HttpStatusCode.BadRequest, false, ex);
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }
        private static bool IsWorkingDay(int year, int m, int day, string WeekDayName, List<MstWorkingCalenderDetModel> WcEntity, List<MstWorkingCalenderDetModel> WcDetEntity, List<FacilityWeeklyHolidayMstDetViewModel> WCWeekHolidayEntity, ref List<MstWorkingCalenderDetModel> ObjWCEntity, ref int idx)
        {
            var isReturn = false;
            ObjWCEntity = null;
            idx++;
            if ((WcEntity != null) && WcEntity.Count > 0)
            {
                var objWc = WcEntity.Where(s => (s.Month == m && s.Day == day) == true);
                ////var objwkHoliday = WCWeekHolidayEntity.Where(wk => (wk.WeekDayName == "Monday" || wk.WeekDayName == "Tuesday"));
                if (objWc.Count() > 0)
                {
                    var IsWorkingDay = objWc.Where(s => s.IsWorking);
                    isReturn = IsWorkingDay.Count() > 0 ? true : false;

                    ObjWCEntity = objWc.ToList();

                    if ((WcDetEntity != null) && WcDetEntity.Count > 0)  // to change the CalendarId based on State
                    {
                        var WcDet = WcDetEntity.Where(s => (s.Month == m && s.Day == day) == true);
                        if (WcDet.Count() > 0)
                        {
                            ObjWCEntity.First().CalenderDetId = WcDet.First().CalenderDetId;
                            ObjWCEntity.First().CalenderId = WcDet.First().CalenderId;
                        }
                    }
                    else
                    {
                        ObjWCEntity.First().CalenderDetId = 0;
                        ObjWCEntity.First().CalenderId = 0;
                    }
                }
            }
            else
            {
                if (WCWeekHolidayEntity != null)
                {
                    isReturn = WCWeekHolidayEntity.Count(x => x.WeekDayName.ToUpper() == WeekDayName.ToUpper())<= 0;
                }
                //var DayName = new DateTime(year, m, day).DayOfWeek.ToString();
                //isReturn = (DayName == "Saturday" || DayName == "Sunday") ? false : true;
            }

            return isReturn;
        }


    }
}
