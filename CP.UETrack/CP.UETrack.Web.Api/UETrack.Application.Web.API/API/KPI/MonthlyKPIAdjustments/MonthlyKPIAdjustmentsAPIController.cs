using CP.UETrack.Application.Web.API;
using CP.UETrack.Model;
using CP.Framework.Common.Audit;
using System;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using CP.UETrack.BLL.BusinessAccess.Interface;
using CP.Framework.Common.Logging;
using Newtonsoft.Json;

namespace UETrack.Application.Web.Controllers
{

    [RoutePrefix("api/monthlyKPIAdjustments")]
    [WebApiAudit]
    public class MonthlyKPIAdjustmentsAPIController : BaseApiController
    {
        IMonthlyKPIAdjustmentsBAL _MonthlyKPIAdjustmentsBAL;
        private readonly string _FileName = nameof(MonthlyKPIAdjustmentsAPIController);

        public MonthlyKPIAdjustmentsAPIController(IMonthlyKPIAdjustmentsBAL monthlyKPIAdjustmentsBAL)
        {
            _MonthlyKPIAdjustmentsBAL = monthlyKPIAdjustmentsBAL;
        }

        [HttpGet]
        [Route(nameof(Load))]
        public HttpResponseMessage Load()
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _MonthlyKPIAdjustmentsBAL.Load();
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

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

        [HttpPost]
        [Route(nameof(Save))]
        public HttpResponseMessage Save(MonthlyKPIAdjustments monthlyKPIAdjustments)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _MonthlyKPIAdjustmentsBAL.Save(monthlyKPIAdjustments, out ErrorMessage);

                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }
                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
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
        [Route(nameof(FetchRecords))]
        public HttpResponseMessage FetchRecords(MonthlyKPIAdjustments monthlyKPIAdjustments)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchRecords), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _MonthlyKPIAdjustmentsBAL.FetchRecords(monthlyKPIAdjustments, out ErrorMessage);

                if (ErrorMessage != string.Empty || result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchRecords), Level.Info.ToString());
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
        [Route(nameof(GetPostDemeritPoints))]
        public HttpResponseMessage GetPostDemeritPoints(KPIGenerationFetch KpiGenerationFetch)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetPostDemeritPoints), Level.Info.ToString());
                var result = _MonthlyKPIAdjustmentsBAL.GetPostDemeritPoints(KpiGenerationFetch);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(GetPostDemeritPoints), Level.Info.ToString());
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
