using CP.Framework.Common.Audit;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.BLL.BusinessAccess.Contracts.Common;
using CP.UETrack.BLL.BusinessAccess.Contracts.Home;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace UETrack.Application.Web.API.API.Home
{
    [RoutePrefix("api/HomeDashboard")]
    [WebApiAudit]

    public class HomeDashboardApiController : BaseApiController
    {
        IHomeDashboardBAL _HomeDashboardBAL;
        private readonly ICommonBAL _commonBAL;
        private readonly string _FileName = nameof(HomeDashboardApiController);
        public HomeDashboardApiController(IHomeDashboardBAL accountBAL, ICommonBAL common)
        {
            _HomeDashboardBAL = accountBAL;
            _commonBAL = common;
        }

        [HttpGet]
        [Route("LoadWorkorderChart/{StartYear}/{StartMonth}/{EndYear}/{EndMonth}/{FacilityId}")]
        public HttpResponseMessage LoadWorkorderChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LoadWorkorderChart), Level.Info.ToString());
                var result = _HomeDashboardBAL.LoadWorkorderChart(StartYear, StartMonth, EndYear, EndMonth, FacilityId);
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(_FileName, nameof(LoadWorkorderChart), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpGet]
        [Route("LoadMaintCostChart/{StartYear}/{StartMonth}/{EndYear}/{EndMonth}/{FacilityId}")]
        public HttpResponseMessage LoadMaintCostChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LoadMaintCostChart), Level.Info.ToString());
                var result = _HomeDashboardBAL.LoadMaintCostChart(StartYear, StartMonth, EndYear, EndMonth, FacilityId);
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(_FileName, nameof(LoadMaintCostChart), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpGet]
        [Route("LoadEquipUptimeChart/{StartYear}/{StartMonth}/{EndYear}/{EndMonth}/{FacilityId}")]
        public HttpResponseMessage LoadEquipUptimeChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LoadEquipUptimeChart), Level.Info.ToString());
                var result = _HomeDashboardBAL.LoadEquipUptimeChart(StartYear, StartMonth, EndYear, EndMonth, FacilityId);
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(_FileName, nameof(LoadEquipUptimeChart), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpGet]
        [Route("LoadAssetChart/{StartYear}/{StartMonth}/{EndYear}/{EndMonth}/{FacilityId}")]
        public HttpResponseMessage LoadAssetChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LoadAssetChart), Level.Info.ToString());
                var result = _HomeDashboardBAL.LoadAssetChart(StartYear, StartMonth, EndYear, EndMonth, FacilityId);
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(_FileName, nameof(LoadAssetChart), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpGet]
        [Route("LoadAssetAgeChart/{StartYear}/{StartMonth}/{EndYear}/{EndMonth}/{FacilityId}")]
        public HttpResponseMessage LoadAssetAgeChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LoadAssetAgeChart), Level.Info.ToString());
                var result = _HomeDashboardBAL.LoadAssetAgeChart(StartYear, StartMonth, EndYear, EndMonth, FacilityId);
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(_FileName, nameof(LoadAssetAgeChart), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpGet]
        [Route("LoadContChart/{StartYear}/{StartMonth}/{EndYear}/{EndMonth}/{FacilityId}")]
        public HttpResponseMessage LoadContChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LoadContChart), Level.Info.ToString());
                var result = _HomeDashboardBAL.LoadContChart(StartYear, StartMonth, EndYear, EndMonth, FacilityId);
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(_FileName, nameof(LoadContChart), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }
    }
}


