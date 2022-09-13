using UETrack.Application.Web.Helpers;
using CP.UETrack.Model.CLS;
using CP.Framework.Common.Audit;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using CP.UETrack.Application.Web.API;
using CP.Framework.Common.Logging;
using System.Reflection;
using System.Collections.Generic;

namespace UETrack.Application.Web.API.CLS
{

    [RoutePrefix("api/WeekCalendar")]
    [WebApiAudit]
    public class WeekCalendarApiController : BaseApiController
    {
        // GET: WeekCalendarApi
        private readonly string _FileName = nameof(WeekCalendarApiController);

        public WeekCalendarApiController()
        {
        }

        [HttpPost(nameof(Save))]
        public async Task<HttpResponseMessage> Save(HttpRequestMessage request, [FromBody] List<WeekCalendar> lstWeekCalendar)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("WeekCalendar/Save", lstWeekCalendar);
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            return result;
        }

        [HttpGet(nameof(GetStartDateEndDate))]
        public async Task<HttpResponseMessage> GetStartDateEndDate(int FacilityId, int Year)
        {
            var model = new WeekCalendar
            {
                FacilityId = FacilityId,
                Year = Year.ToString()
            };
            Log4NetLogger.LogEntry(_FileName, nameof(GetStartDateEndDate), Level.Info.ToString());
            var result = await RestHelper.ApiPost("WeekCalendar/GetStartDateEndDate", model);
            Log4NetLogger.LogEntry(_FileName, nameof(GetStartDateEndDate), Level.Info.ToString());
            return result;
        }

        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("WeekCalendar/GetAll?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            return result;
        }

        [HttpGet(nameof(Get))]
        public async Task<HttpResponseMessage> Get(int CustomerId, int FacilityId, int Year)
        {
            var model = new WeekCalendar
            {
                CustomerId = CustomerId,
                FacilityId = FacilityId,
                Year = Year.ToString()
            };
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            //var filterData = "CustomerId=" + CustomerId + "&FacilityId=" + FacilityId + "&Year=" + Year;
            //RestHelper.ApiGet(string.Format("WeekCalendar/Get?{0}", filterData));

            var result = await RestHelper.ApiPost("WeekCalendar/Get?{0}", model);            
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }

        //[HttpGet("Delete/{Id}")]
        //public async Task<HttpResponseMessage> Delete(int Id)
        //{
        //    Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
        //    var result = await RestHelper.ApiGet(string.Format("WeekCalendar/Delete/{0}", Id));
        //    Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
        //    return result;
        //}
    }
}