using CP.Framework.Common.Audit;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Application.Web.API.Helpers;
using CP.UETrack.BLL.BusinessAccess.Contracts.FEMS;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using CP.UETrack.TranslationManager;
using FluentValidation;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace UETrack.Application.Web.API.API.FEMS
{
    [RoutePrefix("api/FemsStockUpdateRegisterApi")]
    [WebApiAudit]
    public class FemsStockUpdateRegisterApiController : BaseApiController
    {
        internal string returnMessage;
        internal HttpResponseMessage responseObject;
        internal ResourceFileHelper resxFileHelper = new ResourceFileHelper();
        internal UserDetailsModel userSession;
        private readonly IFemsStockUpdateRegisterBAL _StockUpdateRegisterBAL;
        private readonly string fileName = nameof(FemsStockUpdateRegisterApiController);
      
        public FemsStockUpdateRegisterApiController(IFemsStockUpdateRegisterBAL FemsStockUpdateRegisterBAL)
        {

            _StockUpdateRegisterBAL = FemsStockUpdateRegisterBAL;
        }
        [HttpPost]
        [Route("save")]
        public HttpResponseMessage save(StockUpdateRegister model)
        {
            Log4NetLogger.LogEntry(fileName, nameof(AssetProcessingStatus), Level.Info.ToString());

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


                 _StockUpdateRegisterBAL.save(ref model);
                var modelTxn = model;
                if (modelTxn.ErrorMessage != string.Empty && modelTxn.ErrorMessage!=null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, modelTxn.ErrorMessage);
                }
                else
                {

                    responseObject = (modelTxn == null) ?
                             BuildResponseObject(false, resxFileHelper.GetErrorMessagesFromResource("CreateFailed")) :
                             BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(modelTxn));

                }
                Log4NetLogger.LogExit(fileName, nameof(AssetProcessingStatus), Level.Info.ToString());
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
        [Route("update")]
        public HttpResponseMessage update(StockUpdateRegister model)
        {
            Log4NetLogger.LogEntry(fileName, nameof(update), Level.Info.ToString());

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


                _StockUpdateRegisterBAL.update(ref model);
                var modelTxn = model;
                if (modelTxn.ErrorMessage != string.Empty && modelTxn.ErrorMessage != null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, modelTxn.ErrorMessage);
                }
                else
                {

                    responseObject = (modelTxn == null) ?
                             BuildResponseObject(false, resxFileHelper.GetErrorMessagesFromResource("CreateFailed")) :
                             BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(modelTxn));

                }
                Log4NetLogger.LogExit(fileName, nameof(update), Level.Info.ToString());
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
        [Route("Get/{id}/{pagesize}/{pageindex}")]
        public HttpResponseMessage Get(int id,int pagesize,int pageindex)
        {
            Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());

            try
            {
                var ErrorMessage = string.Empty;
                

                var userDetails = new UserDetailsModel();
                userDetails = GetUserDetails(); // Get login details with ConsortiaId and HospitalId


                var modelTxn = _StockUpdateRegisterBAL.Get(id, pagesize,pageindex);



                responseObject = (modelTxn == null) ?
                             BuildResponseObject(false, resxFileHelper.GetErrorMessagesFromResource("CreateFailed")) :
                             BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(modelTxn));

                //}
                Log4NetLogger.LogExit(fileName, nameof(Get), Level.Info.ToString());
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
            Log4NetLogger.LogEntry(fileName, nameof(GetAll), Level.Info.ToString());

            try
            {
                var ErrorMessage = string.Empty;


                SortPaginateFilter paginationFilter = null;

                paginationFilter = GridHelper.GetAllFormatSearchCondition<StockUpdateRegisterGetallEntity>(Request.GetQueryNameValuePairs());
                var commonDAL = new CommonDAL();
                paginationFilter = commonDAL.GetProperPaginationFilter(paginationFilter);
                var userDetails = new UserDetailsModel();
                userDetails = GetUserDetails(); // Get login details with ConsortiaId and HospitalId


                var result =  _StockUpdateRegisterBAL.Getall(paginationFilter);

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
        [Route("Delete/{id}")]
        public HttpResponseMessage Delete(int id)
        {
            Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());

            try
            {
                var ErrorMessage = string.Empty;


                var userDetails = new UserDetailsModel();
                userDetails = GetUserDetails(); // Get login details with ConsortiaId and HospitalId


                var modelTxn = _StockUpdateRegisterBAL.Delete(id);



                responseObject = BuildResponseObject(HttpStatusCode.Created, modelTxn);

                //}
                Log4NetLogger.LogExit(fileName, nameof(Get), Level.Info.ToString());
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
        //CompanyStaffMstDropdown Load();
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


                var modelTxn = _StockUpdateRegisterBAL.Load();



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
        [Route("Upload")]
        public HttpResponseMessage Upload(Upload model)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Upload), Level.Info.ToString());
                 var ErrorMessage = string.Empty;
              var list=  _StockUpdateRegisterBAL.Upload(ref model, out ErrorMessage);

                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {
                    responseObject = BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(model));
                }

                Log4NetLogger.LogExit(fileName, nameof(Upload), Level.Info.ToString());
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

    }
}
