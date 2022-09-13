using CP.Framework.Common.Audit;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using UETrack.Application.Web.Helpers;


namespace UETrack.Application.Web.API.Home
{
    [RoutePrefix("api/HomeDashboard")]
    [WebApiAudit]
    public class HomeDashboardApiController : BaseApiController
    {
        private readonly string _FileName = nameof(HomeDashboardApiController);

        public HomeDashboardApiController()
        {

        }

        [HttpGet("LoadWorkorderChart/{StartYear}/{StartMonth}/{EndYear}/{EndMonth}/{FacilityId}")]
        public async Task<HttpResponseMessage> LoadWorkorderChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(LoadWorkorderChart), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("HomeDashboard/LoadWorkorderChart/{0}/{1}/{2}/{3}/{4}", StartYear, StartMonth, EndYear, EndMonth, FacilityId));
            Log4NetLogger.LogEntry(_FileName, nameof(LoadWorkorderChart), Level.Info.ToString());
            return result;
        }

        [HttpGet("LoadMaintCostChart/{StartYear}/{StartMonth}/{EndYear}/{EndMonth}/{FacilityId}")]
        public async Task<HttpResponseMessage> LoadMaintCostChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(LoadMaintCostChart), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("HomeDashboard/LoadMaintCostChart/{0}/{1}/{2}/{3}/{4}", StartYear, StartMonth, EndYear, EndMonth, FacilityId));
            Log4NetLogger.LogEntry(_FileName, nameof(LoadMaintCostChart), Level.Info.ToString());
            return result;

        }

        [HttpGet("LoadEquipUptimeChart/{StartYear}/{StartMonth}/{EndYear}/{EndMonth}/{FacilityId}")]
        public async Task<HttpResponseMessage> LoadEquipUptimeChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(LoadEquipUptimeChart), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("HomeDashboard/LoadEquipUptimeChart/{0}/{1}/{2}/{3}/{4}", StartYear, StartMonth, EndYear, EndMonth, FacilityId));
            Log4NetLogger.LogEntry(_FileName, nameof(LoadEquipUptimeChart), Level.Info.ToString());
            return result;

        }

        [HttpGet("LoadAssetChart/{StartYear}/{StartMonth}/{EndYear}/{EndMonth}/{FacilityId}")]
        public async Task<HttpResponseMessage> LoadAssetChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(LoadAssetChart), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("HomeDashboard/LoadAssetChart/{0}/{1}/{2}/{3}/{4}", StartYear, StartMonth, EndYear, EndMonth, FacilityId));
            Log4NetLogger.LogEntry(_FileName, nameof(LoadAssetChart), Level.Info.ToString());
            return result;

        }

        [HttpGet("LoadAssetAgeChart/{StartYear}/{StartMonth}/{EndYear}/{EndMonth}/{FacilityId}")]
        public async Task<HttpResponseMessage> LoadAssetAgeChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(LoadAssetAgeChart), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("HomeDashboard/LoadAssetAgeChart/{0}/{1}/{2}/{3}/{4}", StartYear, StartMonth, EndYear, EndMonth, FacilityId));
            Log4NetLogger.LogEntry(_FileName, nameof(LoadAssetAgeChart), Level.Info.ToString());
            return result;

        }

        [HttpGet("LoadContChart/{StartYear}/{StartMonth}/{EndYear}/{EndMonth}/{FacilityId}")]
        public async Task<HttpResponseMessage> LoadContChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(LoadContChart), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("HomeDashboard/LoadContChart/{0}/{1}/{2}/{3}/{4}", StartYear, StartMonth, EndYear, EndMonth, FacilityId));
            Log4NetLogger.LogEntry(_FileName, nameof(LoadContChart), Level.Info.ToString());
            return result;

        }

    }
}
