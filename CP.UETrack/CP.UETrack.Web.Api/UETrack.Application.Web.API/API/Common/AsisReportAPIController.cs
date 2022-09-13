using CP.Framework.Common.Audit;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.BLL.BusinessAccess.Contracts.Common;
using CP.UETrack.Model.Common;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace UETrack.Application.Web.API.API.Common
{
    [RoutePrefix("api/AsisReport")]
    [WebApiAudit]
    public class AsisReportAPIController : BaseApiController
    {
        IAsisReportBLL _AsisReportBLL;
        private readonly string _FileName = nameof(AsisReportAPIController);
        public AsisReportAPIController(IAsisReportBLL accountBAL)
        {
            _AsisReportBLL = accountBAL;
        }

        [HttpPost]
        [Route(nameof(ExecuteDataSet))]
        public HttpResponseMessage ExecuteDataSet(AsisReportViewModel rVM)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ExecuteDataSet), Level.Info.ToString());
                var result = _AsisReportBLL.ExecuteDataSet(rVM);
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(_FileName, nameof(ExecuteDataSet), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(GetDataTableForDdl))]
        public HttpResponseMessage GetDataTableForDdl(AsisReportViewModel rVM)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetDataTableForDdl), Level.Info.ToString());
                var result = _AsisReportBLL.GetDataTableForDdl(rVM);
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(_FileName, nameof(GetDataTableForDdl), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(GetSqlParmsList))]
        public HttpResponseMessage GetSqlParmsList(AsisReportViewModel rVM)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetSqlParmsList), Level.Info.ToString());
                var result = _AsisReportBLL.GetSqlParmsList(rVM);
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(_FileName, nameof(GetSqlParmsList), Level.Info.ToString());
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
