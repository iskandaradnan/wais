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
    [RoutePrefix("api/Dashboard")]
    [WebApiAudit]

    public class DashboardApiController : BaseApiController
    {
        IDashboardBAL _DashboardBAL;
        private readonly ICommonBAL _commonBAL;
        private readonly string _FileName = nameof(DashboardApiController);
        public DashboardApiController(IDashboardBAL accountBAL, ICommonBAL common)
        {
            _DashboardBAL = accountBAL;
            _commonBAL = common;
        }

        [HttpGet]
        [Route("DashboardPermission/{UserId}/{FacilityId}")]
        public HttpResponseMessage DashboardPermission(int UserId, int FacilityId)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(DashboardPermission), Level.Info.ToString());
                var result = _DashboardBAL.DashboardPermission(UserId, FacilityId);
                var serialisedData = result;
                responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(_FileName, nameof(DashboardPermission), Level.Info.ToString());
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
        [Route("LoadWorkorderChart/{StartYear}/{StartMonth}/{EndYear}/{EndMonth}/{FacilityId}/{UserId}")]
        public HttpResponseMessage LoadWorkorderChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId, int UserId)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LoadWorkorderChart), Level.Info.ToString());
                var result = _DashboardBAL.LoadWorkorderChart(StartYear, StartMonth, EndYear, EndMonth, FacilityId, UserId);
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
        [Route("LoadPPMWorkOrderChart/{StartYear}/{StartMonth}/{EndYear}/{EndMonth}/{FacilityId}/{UserId}")]
        public HttpResponseMessage LoadPPMWorkOrderChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId, int UserId)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LoadPPMWorkOrderChart), Level.Info.ToString());
                var result = _DashboardBAL.LoadPPMWorkOrderChart(StartYear, StartMonth, EndYear, EndMonth, FacilityId, UserId);
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(_FileName, nameof(LoadPPMWorkOrderChart), Level.Info.ToString());
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
                var result = _DashboardBAL.LoadMaintCostChart(StartYear, StartMonth, EndYear, EndMonth, FacilityId);
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
                var result = _DashboardBAL.LoadEquipUptimeChart(StartYear, StartMonth, EndYear, EndMonth, FacilityId);
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
        [Route("LoadKPIChart/{StartYear}/{StartMonth}/{EndYear}/{EndMonth}/{FacilityId}/{UserId}")]
        public HttpResponseMessage LoadKPIChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId, int UserId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LoadKPIChart), Level.Info.ToString());
                var result = _DashboardBAL.LoadKPIChart(StartYear, StartMonth, EndYear, EndMonth, FacilityId, UserId);
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(_FileName, nameof(LoadKPIChart), Level.Info.ToString());
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
        [Route("LoadKPITargetChart/{StartYear}/{StartMonth}/{EndYear}/{EndMonth}/{FacilityId}/{UserId}")]
        public HttpResponseMessage LoadKPITargetChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId, int UserId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LoadKPITargetChart), Level.Info.ToString());
                var result = _DashboardBAL.LoadKPITargetChart(StartYear, StartMonth, EndYear, EndMonth, FacilityId, UserId);
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(_FileName, nameof(LoadKPITargetChart), Level.Info.ToString());
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
        [Route("LoadDeductionChart/{StartYear}/{StartMonth}/{EndYear}/{EndMonth}/{FacilityId}/{UserId}")]
        public HttpResponseMessage LoadDeductionChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId, int UserId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LoadDeductionChart), Level.Info.ToString());
                var result = _DashboardBAL.LoadDeductionChart(StartYear, StartMonth, EndYear, EndMonth, FacilityId, UserId);
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(_FileName, nameof(LoadDeductionChart), Level.Info.ToString());
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
        [Route("LoadAssetCategoryChart/{StartYear}/{StartMonth}/{EndYear}/{EndMonth}/{FacilityId}/{UserId}")]
        public HttpResponseMessage LoadAssetCategoryChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId, int UserId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LoadAssetCategoryChart), Level.Info.ToString());
                var result = _DashboardBAL.LoadAssetCategoryChart(StartYear, StartMonth, EndYear, EndMonth, FacilityId, UserId);
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(_FileName, nameof(LoadAssetCategoryChart), Level.Info.ToString());
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
        [Route("LoadAssetWarrantyChart/{StartYear}/{StartMonth}/{EndYear}/{EndMonth}/{FacilityId}/{UserId}")]
        public HttpResponseMessage LoadAssetWarrantyChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId , int UserId)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LoadAssetWarrantyChart), Level.Info.ToString());
                var result = _DashboardBAL.LoadAssetWarrantyChart(StartYear, StartMonth, EndYear, EndMonth, FacilityId, UserId);
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(_FileName, nameof(LoadAssetWarrantyChart), Level.Info.ToString());
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
        [Route("LoadExpiryAlertChart/{StartYear}/{StartMonth}/{EndYear}/{EndMonth}/{FacilityId}/{UserId}")]
        public HttpResponseMessage LoadExpiryAlertChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId, int UserId)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LoadExpiryAlertChart), Level.Info.ToString());
                var result = _DashboardBAL.LoadExpiryAlertChart(StartYear, StartMonth, EndYear, EndMonth, FacilityId, UserId);
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(_FileName, nameof(LoadExpiryAlertChart), Level.Info.ToString());
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
        [Route("LoadBERAssetChart/{StartYear}/{StartMonth}/{EndYear}/{EndMonth}/{FacilityId}/{UserId}")]
        public HttpResponseMessage LoadBERAssetChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId, int UserId)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LoadBERAssetChart), Level.Info.ToString());
                var result = _DashboardBAL.LoadBERAssetChart(StartYear, StartMonth, EndYear, EndMonth, FacilityId, UserId);
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(_FileName, nameof(LoadBERAssetChart), Level.Info.ToString());
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
                var result = _DashboardBAL.LoadContChart(StartYear, StartMonth, EndYear, EndMonth, FacilityId);
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


