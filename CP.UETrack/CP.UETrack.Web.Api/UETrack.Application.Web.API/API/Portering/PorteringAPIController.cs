using CP.Framework.Common.Audit;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Application.Web.API.Helpers;
using CP.UETrack.BLL.BusinessAccess.Contracts.Common;
using CP.UETrack.BLL.BusinessAccess.Contracts.Portering;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using CP.UETrack.Model.Portering;
using FluentValidation;
using Newtonsoft.Json;
using System;
using System.Net;
using System.Net.Http;
using System.Web.Http;
namespace UETrack.Application.Web.API.API.Portering
{
    [RoutePrefix("api/Portering")]
    [WebApiAudit]
    public class PorteringAPIController : BaseApiController
    {
        private readonly IPorteringBAL _bal;
        private readonly ICommonBAL _common;
        private readonly string fileName = nameof(PorteringAPIController);

        public PorteringAPIController(IPorteringBAL bal, ICommonBAL common)
        {
            _bal = bal;
            _common = common;
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
        [Route("GetLocationList")]
        public HttpResponseMessage GetLocationList(PorteringLovs lov)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());
                var result = _bal.GetLocationList(lov);
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
        [Route("add")]
        public HttpResponseMessage Post(PorteringModel model)
        {
            Log4NetLogger.LogEntry(fileName, nameof(Post), Level.Info.ToString());
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
                var modelTxn = _bal.Save(model, out ErrorMessage);
                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {
                    if (modelTxn == null || modelTxn.PorteringId == 0)
                        BuildResponseObject(false, resxFileHelper.GetErrorMessagesFromResource("CreateFailed"));
                    else
                    {
                       var ResultData = _bal.Get(modelTxn.PorteringId);
                        responseObject = (ResultData != null) ? responseObject = BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(ResultData)) : responseObject = BuildResponseObject(false, resxFileHelper.GetErrorMessagesFromResource("CreateFailed"));
                    }
                }
                Log4NetLogger.LogExit(fileName, nameof(Post), Level.Info.ToString());
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



        

        /// <summary>
        /// Delete Standard Operating Procedures
        /// </summary>
        /// <param name="Id">Procedure Id</param>
        /// <returns>boolean</returns>


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


        /// <summary>
        /// Get Standard Operating Procedures
        /// </summary>
        /// <param name="Id">Procedures Id</param>
        /// <returns>Standard Operating Procedures object</returns>
        [HttpGet]
        [Route("get/{id}")]
        public HttpResponseMessage Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var obj = _bal.Get(Id);
                var serialisedData = JsonConvert.SerializeObject(obj);
                if (obj == null)
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                else
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(fileName, nameof(Get), Level.Info.ToString());
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
        [Route("GetLoanerBookingRecord/{id}")]
        public HttpResponseMessage GGetLoanerBookingRecordet(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var obj = _bal.GetLoanerBookingRecord(Id);
                var serialisedData = JsonConvert.SerializeObject(obj);
                if (obj == null)
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                else
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(fileName, nameof(Get), Level.Info.ToString());
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
        [Route("GetPorteringHistory/{id}")]
        public HttpResponseMessage GetPorteringHistory(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var obj = _bal.GetPorteringHistory(Id);
                var serialisedData = JsonConvert.SerializeObject(obj);
                if (obj == null)
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                else
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(fileName, nameof(Get), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = string.Format("{0} : {1}", resxFileHelper.GetErrorMessagesFromResource("GeneralException"), ex.Message);
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);
            return responseObject;
        }
        //[HttpGet]
        //[Route("GetReceipt/{id}")]
        //public HttpResponseMessage GetReceipt(int Id)
        //{
        //    try
        //    {
        //        Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
        //        var obj = _bal.GetReceipt(Id);
        //        var serialisedData = JsonConvert.SerializeObject(obj);
        //        if (obj == null)
        //            responseObject = BuildResponseObject(HttpStatusCode.NotFound);
        //        else
        //            responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
        //        Log4NetLogger.LogExit(fileName, nameof(Get), Level.Info.ToString());
        //    }
        //    catch (Exception ex)
        //    {
        //        returnMessage = string.Format("{0} : {1}", resxFileHelper.GetErrorMessagesFromResource("GeneralException"), ex.Message);
        //    }

        //    if (responseObject == null)
        //        responseObject = BuildResponseObject(false, returnMessage);
        //    return responseObject;
        //}


        [HttpGet]
        [Route(nameof(GetAll))]
        public HttpResponseMessage GetAll()
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(GetAll), Level.Info.ToString());
                SortPaginateFilter paginationFilter = null;
                paginationFilter = GridHelper.GetAllFormatSearchCondition<PorteringModel>(Request.GetQueryNameValuePairs());
                var commonDAL = new CommonDAL();
                paginationFilter = commonDAL.GetProperPaginationFilter(paginationFilter);
                var modelName = nameof(PorteringModel);
                var result = _common.GetAll(paginationFilter, modelName);
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
        [Route("GetVendorInfo/{SupplierCategoryid}/{AssetId}")]
        public HttpResponseMessage GetVendorInfo(int SupplierCategoryid, int AssetId)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());
                var result = _bal.GetVendorInfo(SupplierCategoryid, AssetId);
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
    }
}
