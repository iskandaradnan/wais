using CP.UETrack.Application.Web.API;
using CP.UETrack.Model;
using CP.UETrack.Model.CLS;
using CP.Framework.Common.Audit;
using System;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using CP.UETrack.CLS.BusinessAccess.Interface;
using CP.UETrack.BLL.BusinessAccess.Contracts.Common;
using CP.Framework.Common.Logging;
using Newtonsoft.Json;
using CP.UETrack.DAL.DataAccess.Implementation;
using System.Linq;
using CP.UETrack.Application.Web.API.Helpers;
using CP.UETrack.BLL.BusinessAccess.Contracts.CLS;

namespace UETrack.Application.Web.API.API.CLS
{
    [RoutePrefix("api/CLSReports")]
    [WebApiAudit]
    public class CLSReportsApiController: BaseApiController
    {
        ICLSReportsBAL _ICLSReportsBAL;
        private readonly string _FileName = nameof(CLSReportsApiController);
        private readonly ICommonBAL _commonBAL;

        public CLSReportsApiController(ICLSReportsBAL CLSReportsBAL, ICommonBAL common)
        {
            _ICLSReportsBAL = CLSReportsBAL;
            _commonBAL = common;
        }

        [HttpGet]
        [Route(nameof(Load))]
        public HttpResponseMessage Load()
        {
            try
            {
                var ErrorMessage = string.Empty;
                var result = _ICLSReportsBAL.Load();
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
        [Route(nameof(JointInspectionSummaryReportFetch))]
        public HttpResponseMessage JointInspectionSummaryReportFetch(JointInspectionSummaryReport model)
        {
            try
            {
                var ErrorMessage = string.Empty;
                var result = _ICLSReportsBAL.JointInspectionSummaryReportFetch(model, out ErrorMessage);

                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {
                    responseObject = BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(result));
                }
                Log4NetLogger.LogExit(_FileName, nameof(JointInspectionSummaryReportFetch), Level.Info.ToString());
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
        [Route(nameof(DailyCleaningActivitySummaryReportFetch))]
        public HttpResponseMessage DailyCleaningActivitySummaryReportFetch(DailyCleaningActivitySummaryReport model)
        {
            try
            {
                var ErrorMessage = string.Empty;
                var result = _ICLSReportsBAL.DailyCleaningActivitySummaryReportFetch(model, out ErrorMessage);

                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {
                    responseObject = BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(result));
                }
                Log4NetLogger.LogExit(_FileName, nameof(DailyCleaningActivitySummaryReportFetch), Level.Info.ToString());
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
        [Route(nameof(PeriodicWorkRecordSummaryReportFetch))]
        public HttpResponseMessage PeriodicWorkRecordSummaryReportFetch(PeriodicWorkRecordSummaryReport model)
        {
            try
            {
                var ErrorMessage = string.Empty;
                var result = _ICLSReportsBAL.PeriodicWorkRecordSummaryReportFetch(model, out ErrorMessage);

                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {
                    responseObject = BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(result));
                }
                Log4NetLogger.LogExit(_FileName, nameof(PeriodicWorkRecordSummaryReportFetch), Level.Info.ToString());
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
        [Route(nameof(ToiletInspectionSummaryReportFetch))]
        public HttpResponseMessage ToiletInspectionSummaryReportFetch(ToiletInspectionSummaryReport model)
        {
            try
            {
                var ErrorMessage = string.Empty;
                var result = _ICLSReportsBAL.ToiletInspectionSummaryReportFetch(model, out ErrorMessage);

                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {
                    responseObject = BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(result));
                }
                Log4NetLogger.LogExit(_FileName, nameof(ToiletInspectionSummaryReportFetch), Level.Info.ToString());
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
        [Route(nameof(EquipmentReportFetch))]
        public HttpResponseMessage EquipmentReportFetch(EquipmentReport model)
        {
            try
            {
                var ErrorMessage = string.Empty;
                var result = _ICLSReportsBAL.EquipmentReportFetch(model, out ErrorMessage);

                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {
                    responseObject = BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(result));
                }
                Log4NetLogger.LogExit(_FileName, nameof(ToiletInspectionSummaryReportFetch), Level.Info.ToString());
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
        [Route(nameof(ChemicalUsedReportFetch))]
        public HttpResponseMessage ChemicalUsedReportFetch(ChemicalUsedReport model)
        {
            try
            {
                var ErrorMessage = string.Empty;
                var result = _ICLSReportsBAL.ChemicalUsedReportFetch(model, out ErrorMessage);

                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {
                    responseObject = BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(result));
                }
                Log4NetLogger.LogExit(_FileName, nameof(ChemicalUsedReportFetch), Level.Info.ToString());
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
                var result = _ICLSReportsBAL.CRMReportFetch(model, out ErrorMessage);

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