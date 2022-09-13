using UETrack.Application.Web.Helpers;
using CP.UETrack.Model;
using CP.Framework.Common.Audit;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;

namespace UETrack.Application.Web.Controllers
{

    [RoutePrefix("api/EODDashboard")]
    [WebApiAudit]
    public class EODDashboardAPIController : BaseApiController
    {
        private readonly string _FileName = nameof(EODDashboardAPIController);

        public EODDashboardAPIController()
        {
            
        }

        [HttpGet("Load/{Year}/{Month}")]
        public async Task<HttpResponseMessage> Load(int Year, int Month)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("EODDashboard/Load/{0}/{1}", Year, Month));
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }

        [HttpGet("getChartData/{NoofMonths}/{FacilityId}")]
        public async Task<HttpResponseMessage> getChartData(int NoofMonths, int FacilityId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(getChartData), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("EODDashboard/getChartData/{0}/{1}", NoofMonths, FacilityId));
            Log4NetLogger.LogEntry(_FileName, nameof(getChartData), Level.Info.ToString());
            return result;
        }
    }
}
