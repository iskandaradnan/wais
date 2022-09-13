using CP.UETrack.Application.Web.API;
using CP.UETrack.Model;
using CP.Framework.Common.Audit;
using System;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using CP.UETrack.BLL.BusinessAccess.Contracts.Common;
using CP.Framework.Common.Logging;
using Newtonsoft.Json;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Application.Web.API.Helpers;
using CP.UETrack.Model.HWMS;
using CP.UETrack.BLL.BusinessAccess.Contracts.HWMS;

namespace UETrack.Application.Web.API.API.HWMS
{
    [RoutePrefix("api/HWMSReports")]
    [WebApiAudit]
    public class HWMSReportsApiController : BaseApiController
    {
        IHWMSReportsBAL _HWMSReportsBAL;
        private readonly string _FileName = nameof(HWMSReportsApiController);
        private readonly ICommonBAL _commonBAL;

        public HWMSReportsApiController(IHWMSReportsBAL HWMSReportsBAL, ICommonBAL common)
        {
            _HWMSReportsBAL = HWMSReportsBAL;
            _commonBAL = common;
        }

        [HttpGet]
        [Route(nameof(Load))]
        public HttpResponseMessage Load()
        {
            try
            {
                var ErrorMessage = string.Empty;
                var result = _HWMSReportsBAL.Load();

                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {
                    responseObject = BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(result));
                }                
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
        [Route(nameof(LicenseReportFetch))]
        public HttpResponseMessage LicenseReportFetch(LicenseReport model)
        {
            try
            {
                var ErrorMessage = string.Empty;
                var result = _HWMSReportsBAL.LicenseReportFetch(out ErrorMessage);

                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {
                    responseObject = BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(result));
                }
                Log4NetLogger.LogExit(_FileName, nameof(LicenseReportFetch), Level.Info.ToString());
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
        [Route(nameof(WeighingSummaryReportFetch))]
        public HttpResponseMessage WeighingSummaryReportFetch(WeighingSummaryReport model)
        {
            try
            {
                var ErrorMessage = string.Empty;
                var result = _HWMSReportsBAL.WeighingSummaryReportFetch(model, out ErrorMessage);

                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {
                    responseObject = BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(result));
                }
                Log4NetLogger.LogExit(_FileName, nameof(WeighingSummaryReportFetch), Level.Info.ToString());
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
        [Route(nameof(TransportationReportFetch))]
        public HttpResponseMessage TransportationReportFetch(TransportationReport model)
        {
            try
            {
                var ErrorMessage = string.Empty;
                var result = _HWMSReportsBAL.TransportationReportFetch(model, out ErrorMessage);

                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {
                    responseObject = BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(result));
                }
                Log4NetLogger.LogExit(_FileName, nameof(TransportationReportFetch), Level.Info.ToString());
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
        [Route(nameof(SafetyDataSheetReportFetch))]
        public HttpResponseMessage SafetyDataSheetReportFetch(SafetyDataSheetReport model)
        {
            try
            {
                var ErrorMessage = string.Empty;
                var result = _HWMSReportsBAL.SafetyDataSheetReportFetch(model, out ErrorMessage);

                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {
                    responseObject = BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(result));
                }
                Log4NetLogger.LogExit(_FileName, nameof(SafetyDataSheetReportFetch), Level.Info.ToString());
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
        [Route(nameof(RecordSheetWithoutCNFetch))]
        public HttpResponseMessage RecordSheetWithoutCNFetch(RecordSheetWithoutCN model)
        {
            try
            {
                var ErrorMessage = string.Empty;
                var result = _HWMSReportsBAL.RecordSheetWithoutCNFetch(model, out ErrorMessage);

                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {
                    responseObject = BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(result));
                }
                Log4NetLogger.LogExit(_FileName, nameof(RecordSheetWithoutCNFetch), Level.Info.ToString());
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
        [Route(nameof(WasteGenerationMonthlyReportFetch))]
        public HttpResponseMessage WasteGenerationMonthlyReportFetch(WasteGenerationMonthlyReport model)
        {
            try
            {
                var ErrorMessage = string.Empty;
                var result = _HWMSReportsBAL.WasteGenerationMonthlyReportFetch(model, out ErrorMessage);

                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {
                    responseObject = BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(result));
                }
                Log4NetLogger.LogExit(_FileName, nameof(WasteGenerationMonthlyReportFetch), Level.Info.ToString());
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
        [Route(nameof(CRMReportFetch))]
        public HttpResponseMessage CRMReportFetch(CRMReport model)
        {
            try
            {
                var ErrorMessage = string.Empty;
                var result = _HWMSReportsBAL.CRMReportFetch(model, out ErrorMessage);

                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {
                    responseObject = BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(result));
                }
                Log4NetLogger.LogExit(_FileName, nameof(CRMReportFetch), Level.Info.ToString());
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