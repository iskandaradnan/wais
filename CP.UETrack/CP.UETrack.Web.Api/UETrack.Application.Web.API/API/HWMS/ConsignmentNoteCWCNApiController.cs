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
using CP.UETrack.Model.HWMS;
using CP.UETrack.BLL.BusinessAccess.Contracts.HWMS;
using System.Web;


namespace UETrack.Application.Web.API.API.HWMS
{
    [RoutePrefix("api/ConsignmentNoteCWCN")]
    [WebApiAudit]
    public class ConsignmentNoteCWCNApiController : BaseApiController
    {
        IConsignmentNoteCWCNBAL _consignmentNoteCWCNBAL;
        private readonly string _FileName = nameof(ConsignmentNoteCWCNApiController);
        private readonly ICommonBAL _commonBAL;

        public ConsignmentNoteCWCNApiController(IConsignmentNoteCWCNBAL consignmentNoteCWCNBAL, ICommonBAL common)
        {
            _consignmentNoteCWCNBAL = consignmentNoteCWCNBAL;
            _commonBAL = common;
        }
        [HttpGet]
        [Route(nameof(Load))]
        public HttpResponseMessage Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _consignmentNoteCWCNBAL.Load();
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
        [Route(nameof(AutoDisplaying))]
        public HttpResponseMessage AutoDisplaying()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(AutoDisplaying), Level.Info.ToString());
                var result = _consignmentNoteCWCNBAL.AutoDisplaying();
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(_FileName, nameof(AutoDisplaying), Level.Info.ToString());
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
        public HttpResponseMessage Save(ConsignmentNoteCWCN model)
        {
            try
            {
                var ErrorMessage = string.Empty;
                var result = _consignmentNoteCWCNBAL.Save(model, out ErrorMessage);

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

                paginationFilter = GridHelper.GetAllFormatSearchCondition<ConsignmentNoteCWCN>(Request.GetQueryNameValuePairs());
                var commonDAL = new CommonDAL();
                paginationFilter = commonDAL.GetProperPaginationFilter(paginationFilter);


                var result = _consignmentNoteCWCNBAL.GetAll(paginationFilter);

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
                var result = _consignmentNoteCWCNBAL.Get(Id);
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
        [Route(nameof(VehicleNoFetch))]
        public HttpResponseMessage VehicleNoFetch(VehicleDetails SearchObject)
        {
            try
            {
                
                var result = _consignmentNoteCWCNBAL.VehicleNoFetch(SearchObject);
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                
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
        [Route(nameof(DriverCodeFetch))]
        public HttpResponseMessage DriverCodeFetch(DriverDetails SearchObject)
        {
            try
            {
                
                var result = _consignmentNoteCWCNBAL.DriverCodeFetch(SearchObject);
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                
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
        [Route(nameof(AutoDisplayDWRSNO))]
        public HttpResponseMessage AutoDisplayDWRSNO()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(AutoDisplayDWRSNO), Level.Info.ToString());
                var result = _consignmentNoteCWCNBAL.AutoDisplayDWRSNO();
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(_FileName, nameof(AutoDisplayDWRSNO), Level.Info.ToString());
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
        [Route(nameof(DWRSNOData))]          
        public HttpResponseMessage DWRSNOData(int DWRId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(DWRSNOData), Level.Info.ToString());
                var result = _consignmentNoteCWCNBAL.DWRSNOData(DWRId);
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(_FileName, nameof(DWRSNOData), Level.Info.ToString());
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
        [Route("TreatmentPlantData/{TreatmentPlantName}")]
        public HttpResponseMessage TreatmentPlantData(string TreatmentPlantName)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(TreatmentPlantData), Level.Info.ToString());
                var result = _consignmentNoteCWCNBAL.TreatmentPlantData(TreatmentPlantName);
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(_FileName, nameof(TreatmentPlantData), Level.Info.ToString());
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