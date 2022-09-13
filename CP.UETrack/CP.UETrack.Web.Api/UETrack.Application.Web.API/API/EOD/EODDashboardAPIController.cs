using CP.UETrack.Application.Web.API;
using CP.UETrack.Model;
using CP.Framework.Common.Audit;
using System;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using CP.UETrack.BLL.BusinessAccess.Interface;
using CP.UETrack.BLL.BusinessAccess.Contracts.Common;
using CP.Framework.Common.Logging;
using Newtonsoft.Json;
using CP.UETrack.DAL.DataAccess.Implementation;
using System.Linq;
using CP.UETrack.Application.Web.API.Helpers;

namespace UETrack.Application.Web.Controllers
{

    [RoutePrefix("api/EODDashboard")]
    [WebApiAudit]
    public class EODDashboardApiController : BaseApiController
    {
        IEODDashboardBAL _EODDashboardBAL;
        private readonly ICommonBAL _commonBAL;
        private readonly string _FileName = nameof(EODDashboardApiController);
        public EODDashboardApiController(IEODDashboardBAL accountBAL, ICommonBAL common)
        {
            _EODDashboardBAL = accountBAL;
            _commonBAL = common;
        }

        [HttpGet]
        [Route("Load/{Year}/{Month}")]
        public HttpResponseMessage Load(int Year, int Month)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _EODDashboardBAL.Load(Year, Month);
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
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
        [Route("getChartData/{NoofMonths}/{FacilityId}")]
        public HttpResponseMessage getChartData(int NoofMonths, int FacilityId)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(getChartData), Level.Info.ToString());
                var result = _EODDashboardBAL.getChartData(NoofMonths, FacilityId);
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(_FileName, nameof(getChartData), Level.Info.ToString());
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
