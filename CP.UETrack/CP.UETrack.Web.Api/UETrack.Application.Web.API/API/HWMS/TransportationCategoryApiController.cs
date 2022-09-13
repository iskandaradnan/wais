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
using System.Linq;
using CP.UETrack.Application.Web.API.Helpers;
using CP.UETrack.BLL.BusinessAccess.Interface;
using CP.UETrack.Model.HWMS;
using CP.UETrack.BLL.BusinessAccess.Contracts.HWMS;


namespace UETrack.Application.Web.API.API.HWMS
{
    [RoutePrefix("api/TransportationCategory")]
    [WebApiAudit]
    public class TransportationCategoryApiController : BaseApiController
    {
        ITransportationCategoryBAL _transportationCategoryBAL;
        private readonly string _FileName = nameof(TransportationCategoryApiController);
        private readonly ICommonBAL _commonBAL;
        public TransportationCategoryApiController(ITransportationCategoryBAL transportationCategoryBAL, ICommonBAL common)
        {
            _transportationCategoryBAL = transportationCategoryBAL;
            _commonBAL = common;
        }
        [HttpGet]
        [Route(nameof(Load))]
        public HttpResponseMessage Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _transportationCategoryBAL.Load();
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
        public HttpResponseMessage Save(TransportationCategory model)
        {
            try
            {
                var ErrorMessage = string.Empty;
                var result = _transportationCategoryBAL.Save(model, out ErrorMessage);

                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {
                    responseObject = BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(result));
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
        [Route(nameof(GetAll))]
        public HttpResponseMessage GetAll()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                SortPaginateFilter paginationFilter = null;

                paginationFilter = GridHelper.GetAllFormatSearchCondition<TransportationCategory>(Request.GetQueryNameValuePairs());
                var commonDAL = new CommonDAL();
                paginationFilter = commonDAL.GetProperPaginationFilter(paginationFilter);

                var result = _transportationCategoryBAL.GetAll(paginationFilter);
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
        [Route("Get/{Id}")]
        public HttpResponseMessage Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _transportationCategoryBAL.Get(Id);
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
        [HttpPost]
        [Route(nameof(HospitalCodeFetch))]
        public HttpResponseMessage HospitalCodeFetch(TransportationCategoryTable SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(HospitalNameData), Level.Info.ToString());
                var result = _transportationCategoryBAL.HospitalCodeFetch(SearchObject);
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(_FileName, nameof(HospitalNameData), Level.Info.ToString());
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
        [Route("HospitalNameData/{HospitalCode}")]
        public HttpResponseMessage HospitalNameData(string HospitalCode)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(HospitalNameData), Level.Info.ToString());
                var result = _transportationCategoryBAL.HospitalNameData(HospitalCode);
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(_FileName, nameof(HospitalNameData), Level.Info.ToString());
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