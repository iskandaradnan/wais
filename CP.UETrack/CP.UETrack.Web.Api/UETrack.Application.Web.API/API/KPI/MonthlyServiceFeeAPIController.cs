using CP.Framework.Common.Audit;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Application.Web.API.Helpers;
using CP.UETrack.BLL.BusinessAccess.Contracts.KPI;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using CP.UETrack.Model.KPI;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace UETrack.Application.Web.API.API.KPI
{
    [RoutePrefix("api/MonthlyServiceFee")]
    [WebApiAudit]
    public class MonthlyServiceFeeAPIController : BaseApiController
    {
        IMonthlyServiceFeeBAL _MonthlyServiceFeeBAL;
        private readonly string _FileName = nameof(MonthlyServiceFeeAPIController);
        public MonthlyServiceFeeAPIController(IMonthlyServiceFeeBAL accountBAL)
        {
            _MonthlyServiceFeeBAL = accountBAL;
        }

        [HttpGet]
        [Route(nameof(Load))]
        public HttpResponseMessage Load()
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _MonthlyServiceFeeBAL.Load();
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

        [HttpPost]
        [Route(nameof(Save))]
        public HttpResponseMessage Save(MonthlyServiceFeeModel ServiceFee)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _MonthlyServiceFeeBAL.Save(ServiceFee, out ErrorMessage);

                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {
                    result = _MonthlyServiceFeeBAL.Get(result.MonthlyFeeId);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, JsonConvert.SerializeObject(result));

                    //var serialisedData = JsonConvert.SerializeObject(result);
                    //responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
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


        [HttpGet]
        [Route("Get/{Id}")]
        public HttpResponseMessage Get(int Id)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _MonthlyServiceFeeBAL.Get(Id);
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
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
        public HttpResponseMessage Delete(string Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
                if (string.IsNullOrEmpty(Id))
                    return BuildResponseObject(HttpStatusCode.BadRequest);
                var PrimaryID = 0;
                if (int.TryParse(Id, out PrimaryID))
                {
                    var isSuccess = _MonthlyServiceFeeBAL.Delete(PrimaryID);

                    if (isSuccess)
                        responseObject = BuildResponseObject(HttpStatusCode.OK);
                    else
                        responseObject = BuildResponseObject(false, resxFileHelper.GetErrorMessagesFromResource("DeleteFailed"));
                }
                else
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest);
                Log4NetLogger.LogExit(_FileName, nameof(Delete), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = string.Format("{0} : {1}", resxFileHelper.GetErrorMessagesFromResource("GeneralException"), ex.Message);
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
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());

                SortPaginateFilter paginationFilter = null;

                paginationFilter = GridHelper.GetAllFormatSearchCondition<MonthlyServiceFeeModel>(Request.GetQueryNameValuePairs());
                var commonDAL = new CommonDAL();
                paginationFilter = commonDAL.GetProperPaginationFilter(paginationFilter);

                var result = _MonthlyServiceFeeBAL.GetAll(paginationFilter);
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
                Log4NetLogger.LogExit(_FileName, nameof(GetAll), Level.Info.ToString());
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
        [Route("GetRevision/{Id}/{Year}")]
        public HttpResponseMessage GetRevision(int Id,int Year)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetRevision), Level.Info.ToString());
                var result = _MonthlyServiceFeeBAL.GetRevision(Id,Year);
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(_FileName, nameof(GetRevision), Level.Info.ToString());
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
        [Route("GetVersion/{Year}")]
        public HttpResponseMessage GetVersion(int Year)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetVersion), Level.Info.ToString());
                var result = _MonthlyServiceFeeBAL.GetVersion(Year);
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(_FileName, nameof(GetVersion), Level.Info.ToString());
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