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
    [RoutePrefix("api/Dashboard")]
    [WebApiAudit]
    public class DashboardApiController : BaseApiController
    {
        private readonly string _FileName = nameof(DashboardApiController);

        public DashboardApiController()
        {

        }

        [HttpGet("DashboardPermission/{UserId}/{FacilityId}")]
        public async Task<HttpResponseMessage> DashboardPermission(int UserId, int FacilityId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(DashboardPermission), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("Dashboard/DashboardPermission/{0}/{1}", UserId, FacilityId));
            Log4NetLogger.LogEntry(_FileName, nameof(DashboardPermission), Level.Info.ToString());
            return result;
        }


        [HttpGet("LoadWorkorderChart/{StartYear}/{StartMonth}/{EndYear}/{EndMonth}/{FacilityId}/{UserId}")]
        public async Task<HttpResponseMessage> LoadWorkorderChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId, int userId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(LoadWorkorderChart), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("Dashboard/LoadWorkorderChart/{0}/{1}/{2}/{3}/{4}/{5}", StartYear, StartMonth, EndYear, EndMonth, FacilityId, userId));
            Log4NetLogger.LogEntry(_FileName, nameof(LoadWorkorderChart), Level.Info.ToString());
            return result;
        }

        [HttpGet("LoadPPMWorkOrderChart/{StartYear}/{StartMonth}/{EndYear}/{EndMonth}/{FacilityId}/{UserId}")]
        public async Task<HttpResponseMessage> LoadPPMWorkOrderChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId, int UserId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(LoadPPMWorkOrderChart), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("Dashboard/LoadPPMWorkOrderChart/{0}/{1}/{2}/{3}/{4}/{5}", StartYear, StartMonth, EndYear, EndMonth, FacilityId, UserId));
            Log4NetLogger.LogEntry(_FileName, nameof(LoadPPMWorkOrderChart), Level.Info.ToString());
            return result;
        }

        [HttpGet("LoadMaintCostChart/{StartYear}/{StartMonth}/{EndYear}/{EndMonth}/{FacilityId}")]
        public async Task<HttpResponseMessage> LoadMaintCostChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(LoadMaintCostChart), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("Dashboard/LoadMaintCostChart/{0}/{1}/{2}/{3}/{4}", StartYear, StartMonth, EndYear, EndMonth, FacilityId));
            Log4NetLogger.LogEntry(_FileName, nameof(LoadMaintCostChart), Level.Info.ToString());
            return result;

        }

        [HttpGet("LoadEquipUptimeChart/{StartYear}/{StartMonth}/{EndYear}/{EndMonth}/{FacilityId}")]
        public async Task<HttpResponseMessage> LoadEquipUptimeChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(LoadEquipUptimeChart), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("Dashboard/LoadEquipUptimeChart/{0}/{1}/{2}/{3}/{4}", StartYear, StartMonth, EndYear, EndMonth, FacilityId));
            Log4NetLogger.LogEntry(_FileName, nameof(LoadEquipUptimeChart), Level.Info.ToString());
            return result;

        }

        [HttpGet("LoadKPIChart/{StartYear}/{StartMonth}/{EndYear}/{EndMonth}/{FacilityId}/{UserId}")]
        public async Task<HttpResponseMessage> LoadKPIChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId, int UserId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(LoadKPIChart), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("Dashboard/LoadKPIChart/{0}/{1}/{2}/{3}/{4}/{5}", StartYear, StartMonth, EndYear, EndMonth, FacilityId, UserId));
            Log4NetLogger.LogEntry(_FileName, nameof(LoadKPIChart), Level.Info.ToString());
            return result;

        }

        [HttpGet("LoadKPITargetChart/{StartYear}/{StartMonth}/{EndYear}/{EndMonth}/{FacilityId}/{UserId}")]
        public async Task<HttpResponseMessage> LoadKPITargetChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId, int UserId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(LoadKPITargetChart), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("Dashboard/LoadKPITargetChart/{0}/{1}/{2}/{3}/{4}/{5}", StartYear, StartMonth, EndYear, EndMonth, FacilityId, UserId));
            Log4NetLogger.LogEntry(_FileName, nameof(LoadKPITargetChart), Level.Info.ToString());
            return result;

        }

        [HttpGet("LoadDeductionChart/{StartYear}/{StartMonth}/{EndYear}/{EndMonth}/{FacilityId}/{UserId}")]
        public async Task<HttpResponseMessage> LoadDeductionChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId, int UserId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(LoadDeductionChart), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("Dashboard/LoadDeductionChart/{0}/{1}/{2}/{3}/{4}/{5}", StartYear, StartMonth, EndYear, EndMonth, FacilityId, UserId));
            Log4NetLogger.LogEntry(_FileName, nameof(LoadDeductionChart), Level.Info.ToString());
            return result;

        }

        [HttpGet("LoadAssetCategoryChart/{StartYear}/{StartMonth}/{EndYear}/{EndMonth}/{FacilityId}/{UserId}")]
        public async Task<HttpResponseMessage> LoadAssetCategoryChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId, int UserId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(LoadAssetCategoryChart), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("Dashboard/LoadAssetCategoryChart/{0}/{1}/{2}/{3}/{4}/{5}", StartYear, StartMonth, EndYear, EndMonth, FacilityId, UserId));
            Log4NetLogger.LogEntry(_FileName, nameof(LoadAssetCategoryChart), Level.Info.ToString());
            return result;

        }

        [HttpGet("LoadAssetWarrantyChart/{StartYear}/{StartMonth}/{EndYear}/{EndMonth}/{FacilityId}/{UserId}")]
        public async Task<HttpResponseMessage> LoadAssetWarrantyChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId, int UserId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(LoadAssetWarrantyChart), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("Dashboard/LoadAssetWarrantyChart/{0}/{1}/{2}/{3}/{4}/{5}", StartYear, StartMonth, EndYear, EndMonth, FacilityId, UserId));
            Log4NetLogger.LogEntry(_FileName, nameof(LoadAssetWarrantyChart), Level.Info.ToString());
            return result;

        }

        [HttpGet("LoadExpiryAlertChart/{StartYear}/{StartMonth}/{EndYear}/{EndMonth}/{FacilityId}/{UserId}")]
        public async Task<HttpResponseMessage> LoadExpiryAlertChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId, int UserId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(LoadExpiryAlertChart), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("Dashboard/LoadExpiryAlertChart/{0}/{1}/{2}/{3}/{4}/{5}", StartYear, StartMonth, EndYear, EndMonth, FacilityId, UserId));
            Log4NetLogger.LogEntry(_FileName, nameof(LoadExpiryAlertChart), Level.Info.ToString());
            return result;

        }

        [HttpGet("LoadBERAssetChart/{StartYear}/{StartMonth}/{EndYear}/{EndMonth}/{FacilityId}/{UserId}")]
        public async Task<HttpResponseMessage> LoadBERAssetChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId , int UserId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(LoadBERAssetChart), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("Dashboard/LoadBERAssetChart/{0}/{1}/{2}/{3}/{4}/{5}", StartYear, StartMonth, EndYear, EndMonth, FacilityId, UserId));
            Log4NetLogger.LogEntry(_FileName, nameof(LoadBERAssetChart), Level.Info.ToString());
            return result;

        }

        [HttpGet("LoadContChart/{StartYear}/{StartMonth}/{EndYear}/{EndMonth}/{FacilityId}")]
        public async Task<HttpResponseMessage> LoadContChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(LoadContChart), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("Dashboard/LoadContChart/{0}/{1}/{2}/{3}/{4}", StartYear, StartMonth, EndYear, EndMonth, FacilityId));
            Log4NetLogger.LogEntry(_FileName, nameof(LoadContChart), Level.Info.ToString());
            return result;

        }

    }
}
