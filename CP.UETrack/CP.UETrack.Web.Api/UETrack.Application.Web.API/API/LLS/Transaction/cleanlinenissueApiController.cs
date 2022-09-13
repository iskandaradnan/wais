using CP.Framework.Common.Audit;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Application.Web.API.Helpers;
//using CP.UETrack.BLL.BusinessAccess.Contracts.LLS.Transaction;
using CP.UETrack.BLL.BusinessAccess.Contracts.Common;
using CP.UETrack.DAL.DataAccess;
using CP.UETrack.BLL.BusinessAccess.Interface;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using CP.UETrack.Model.LLS;
using CP.UETrack.Model.BEMS;
using FluentValidation;
using Newtonsoft.Json;
using System;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using CP.UETrack.BLL.BusinessAccess.Interface.LLS.Transaction;

namespace UETrack.Application.Web.API.API.LLS.Transaction
{
    [RoutePrefix("api/CleanLinenIssue")]
    [WebApiAudit]
    public class CleanLinenIssueApiController : BaseApiController
    {
          string IssuedOnTime;
        private readonly ICleanLinenIssueBAL _bal;
        private readonly string fileName = nameof(CleanLinenIssueApiController);

       
        public CleanLinenIssueApiController(ICleanLinenIssueBAL bal)
        {
            _bal = bal;
        }


        [HttpGet]
        [Route(nameof(Load))]
        public HttpResponseMessage Load()
        {

            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());
                var result = _bal.Load();
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(fileName, nameof(Load), Level.Info.ToString());
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
        public HttpResponseMessage Save(CleanLinenIssueModel model)
        {
            try
            {
                var ErrorMessage = string.Empty;
                var result = _bal.Save(model, out ErrorMessage);

                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {

                    if (result == null || result.CleanLinenIssueId == 0)
                        BuildResponseObject(false, resxFileHelper.GetErrorMessagesFromResource("CreateFailed"));
                    else
                    {
                        var ResultData = _bal.Get(result.CleanLinenIssueId);

                        responseObject = (result != null) ? responseObject = BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(ResultData)) : responseObject = BuildResponseObject(false, resxFileHelper.GetErrorMessagesFromResource("CreateFailed"));

                    }

                }
                Log4NetLogger.LogExit(fileName, nameof(Save), Level.Info.ToString());
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
        [Route("Get/{Id}")]
        public HttpResponseMessage Get(int Id)
        {

            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var result = _bal.Get(Id);
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(fileName, nameof(Get), Level.Info.ToString());
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
        [Route("GetByLinenItemDetails/{Id}")]
        public HttpResponseMessage GetByLinenItemDetails(int Id)
        {

            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(GetByLinenItemDetails), Level.Info.ToString());
                var result = _bal.GetByLinenItemDetails(Id);
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(fileName, nameof(GetByLinenItemDetails), Level.Info.ToString());
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
        [Route("GetByLinenBagDetails/{Id}")]
        public HttpResponseMessage GetByLinenBagDetails(int Id)
        {

            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(GetByLinenBagDetails), Level.Info.ToString());
                var result = _bal.GetByLinenBagDetails(Id);
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(fileName, nameof(GetByLinenBagDetails), Level.Info.ToString());
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
        [Route(nameof(GetByScheduledId))]
        public HttpResponseMessage GetByScheduledId(CleanLinenIssueModel model)
        {
            try
            {
                var ErrorMessage = string.Empty;
                var result = _bal.GetByScheduledId(model, out ErrorMessage);

                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {

                    if (result == null || result.CleanLinenIssueId != 0)
                        BuildResponseObject(false, resxFileHelper.GetErrorMessagesFromResource("CreateFailed"));
                    else
                    {
                        var ResultData = _bal.GetBY(model);
                        IssuedOnTime = ResultData.IssuedOnTime.ToString();
                        responseObject = (result != null) ? responseObject = BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(ResultData)) : responseObject = BuildResponseObject(false, resxFileHelper.GetErrorMessagesFromResource("CreateFailed"));

                    }

                }
                Log4NetLogger.LogExit(fileName, nameof(GetByScheduledId), Level.Info.ToString());
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
        [Route(nameof(GetAll))]
        public HttpResponseMessage GetAll()
        {

            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(GetAll), Level.Info.ToString());

                SortPaginateFilter paginationFilter = null;

                paginationFilter = GridHelper.GetAllFormatSearchCondition<CleanLinenIssueModel_Filter>(Request.GetQueryNameValuePairs());
                var commonDAL = new CommonDAL();
                paginationFilter = commonDAL.GetProperPaginationFilter(paginationFilter);

                var result = _bal.GetAll(paginationFilter);
                if (result == null)
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
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
                _bal.Delete(Id, out ErrorMessage);
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
    }
}