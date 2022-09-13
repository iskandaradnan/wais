using CP.Framework.Common.Audit;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Application.Web.API.Helpers;
using CP.UETrack.BLL.BusinessAccess.Contracts.VM;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using CP.UETrack.Model.VM;
using CP.UETrack.TranslationManager;
using FluentValidation;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using CP.Framework.Common.StateManagement;

namespace UETrack.Application.Web.API.API.VM
{
    [RoutePrefix("api/SummaryofFeeReportAPI")]
    [WebApiAudit]
    public class SummaryofFeeReportAPIController : BaseApiController
    {
        internal string returnMessage;
        internal HttpResponseMessage responseObject;
        internal ResourceFileHelper resxFileHelper = new ResourceFileHelper();
        internal UserDetailsModel userSession;
        private readonly ISummaryofFeeReportBAL _ISummaryofFeeReportBAL;
        private readonly string fileName = nameof(SummaryofFeeReportAPIController);
        readonly ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
     
        public SummaryofFeeReportAPIController(ISummaryofFeeReportBAL ISummaryofFeeReportBAL)
        {

            _ISummaryofFeeReportBAL = ISummaryofFeeReportBAL;
        }
        [HttpGet]
        [Route("Load")]
        public HttpResponseMessage Load()
        {
            Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());

            try
            {
                var ErrorMessage = string.Empty;

                var userDetails = new UserDetailsModel();
                userDetails = GetUserDetails(); // Get login details with ConsortiaId and HospitalId


                var modelTxn = _ISummaryofFeeReportBAL.Load();



                responseObject = BuildResponseObject(HttpStatusCode.Created, modelTxn);

                //}
                Log4NetLogger.LogExit(fileName, nameof(Load), Level.Info.ToString());
            }
            catch (ValidationException ex)
            {
                responseObject = BuildResponseObject(HttpStatusCode.BadRequest, false, ex);
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
        [Route("GetDetails")]
        public HttpResponseMessage GetDetails(FetchDetails entity)
        {
            Log4NetLogger.LogEntry(fileName, nameof(GetDetails), Level.Info.ToString());

            try
            {
                var ErrorMessage = string.Empty;
                var userDetails = new UserDetailsModel();
                userDetails = GetUserDetails(); // Get login details with ConsortiaId and HospitalId
                
                var modelTxn = _ISummaryofFeeReportBAL.Get(entity, out ErrorMessage);

                //responseObject = (modelTxn == null || modelTxn.SummaryList == null && modelTxn.RollOverFeeId!=0) ?
                //             BuildResponseObject(false, resxFileHelper.GetErrorMessagesFromResource("CreateFailed")) :
                //             BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(modelTxn));

                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(modelTxn);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(fileName, nameof(GetDetails), Level.Info.ToString());
            }
            catch (ValidationException ex)
            {
                responseObject = BuildResponseObject(HttpStatusCode.BadRequest, false, ex);
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
        [Route("Save")]
        public HttpResponseMessage Save(SFRSaveEntity model)
        {
            Log4NetLogger.LogEntry(fileName, nameof(Save), Level.Info.ToString());

            try
            {
                var ErrorMessage = string.Empty;
                if (model == null)
                {
                    return responseObject = BuildResponseObject(HttpStatusCode.BadRequest, false);
                }
                if (!ModelState.IsValid)
                {
                    return BuildResponseObject(HttpStatusCode.BadRequest, false, ModelState);
                }

                var userDetails = new UserDetailsModel();
                userDetails = GetUserDetails(); // Get login details with ConsortiaId and HospitalId


                _ISummaryofFeeReportBAL.Save(model);
                var modelTxn = model;
                //if (ErrorMessage != string.Empty)
                //{
                //    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, fa);
                //}
                //else
                //{

                responseObject = (modelTxn == null) ?
                             BuildResponseObject(false, resxFileHelper.GetErrorMessagesFromResource("CreateFailed")) :
                             BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(modelTxn));

                //}
                Log4NetLogger.LogExit(fileName, nameof(Save), Level.Info.ToString());
            }
            catch (ValidationException ex)
            {
                responseObject = BuildResponseObject(HttpStatusCode.BadRequest, false, ex);
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
        [Route("Getall")]
        public HttpResponseMessage GetAll()
        {

            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(GetAll), Level.Info.ToString());

                SortPaginateFilter paginationFilter = null;

                paginationFilter = GridHelper.GetAllFormatSearchCondition<SFRGetallEntity>(Request.GetQueryNameValuePairs());
                var commonDAL = new CommonDAL();
                paginationFilter = commonDAL.GetProperPaginationFilter(paginationFilter);

                var result = _ISummaryofFeeReportBAL.GetAll(paginationFilter);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var jsonData = new
                    {
                        total = result.TotalPages,
                        result.CurrentPage,
                        records = result.TotalRecords,
                        rows = result.RecordsList
                    };
                    responseObject = jsonData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, jsonData);
                }
                Log4NetLogger.LogExit(fileName, nameof(GetAll), Level.Info.ToString());
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
        [Route("Delete/{Id}")]
        public HttpResponseMessage Delete(int Id)
        {

            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Delete), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                _ISummaryofFeeReportBAL.Delete(Id, out ErrorMessage);
                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {
                    responseObject = BuildResponseObject(HttpStatusCode.OK, "Success");
                }
                Log4NetLogger.LogExit(fileName, nameof(Delete), Level.Info.ToString());
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
        [Route("ChangeService/{ServiceId}")]
        public HttpResponseMessage ChangeService( int ServiceId)
        {

            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(ChangeService), Level.Info.ToString());
               
                responseObject = BuildResponseObject(HttpStatusCode.OK, "Success");

                Log4NetLogger.LogExit(fileName, nameof(ChangeService), Level.Info.ToString());
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
