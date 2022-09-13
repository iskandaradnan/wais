using CP.UETrack.Application.Web.API;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.Filter;
using CP.UETrack.Model.BEMS;
using System.Net.Http;
using System.Reflection;
using System.Threading.Tasks;
using System.Web.Http;
using UETrack.Application.Web.Helpers;
namespace UETrack.Application.Web.API.BEMS
{
    [WebApiAuthentication]
    [RoutePrefix("api/WorkingCalender")]
    public class WorkingCalenderAPIController : BaseApiController
    {
        
        // GET api/<controller>
        [System.Web.Http.HttpGetAttribute("Load/{CurrentYear}")]
        public Task<HttpResponseMessage> Load(int CurrentYear)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("WorkingCalender/Load/{0}", CurrentYear));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }


        [System.Web.Http.HttpGetAttribute("GetWorkingDay/{intYear}/{intFacilityId}/{intCopyFromFacilityId}")]
        public Task<HttpResponseMessage> GetWorkingDay(int intYear, int intFacilityId, int intCopyFromFacilityId)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("WorkingCalender/GetWorkingDay/{0}/{1}/{2}", intYear, intFacilityId, intCopyFromFacilityId));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [System.Web.Http.HttpPostAttribute("add")]
     
        public Task<HttpResponseMessage> Post(MstWorkingCalenderModel WorkingCalendar)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiPost("WorkingCalender/add", WorkingCalendar);
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

      
    }
}
