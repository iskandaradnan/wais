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
    [RoutePrefix("api/FemsContractOutRegisterApi")]
    [WebApiAudit]
    public class FemsContractOutRegisterApiController : BaseApiController
    {

        internal string returnMessage;
        internal HttpResponseMessage responseObject;
        internal ResourceFileHelper resxFileHelper = new ResourceFileHelper();
        internal UserDetailsModel userSession;
        private readonly IFemsContractOutRegisterBAL _IContractOutRegisterBAL;
        private readonly string fileName = nameof(FemsContractOutRegisterApiController);

        public FemsContractOutRegisterApiController(IFemsContractOutRegisterBAL IFemsContractOutRegisterBAL)
        {

            _IContractOutRegisterBAL = IFemsContractOutRegisterBAL;
        }

        [HttpGet]
        [Route(nameof(Load))]
        public HttpResponseMessage Load()
        {
            Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());

            try
            {
                var ErrorMessage = string.Empty;


                var userDetails = new UserDetailsModel();
                userDetails = GetUserDetails(); // Get login details with ConsortiaId and HospitalId


                var modelTxn = _IContractOutRegisterBAL.Load();



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
        [Route("save")]
        public HttpResponseMessage save(ContractOutRegisterEntity model)
        {
            Log4NetLogger.LogEntry(fileName, nameof(save), Level.Info.ToString());

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


                _IContractOutRegisterBAL.save(ref model,out ErrorMessage);


                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {
                    var modelTxn = model;
                    responseObject = (modelTxn == null) ?
                                 BuildResponseObject(false, resxFileHelper.GetErrorMessagesFromResource("CreateFailed")) :
                                 BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(modelTxn));

                }

                Log4NetLogger.LogExit(fileName, nameof(save), Level.Info.ToString());
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

        [HttpPut]
        [Route("update")]
        public HttpResponseMessage update(ContractOutRegisterEntity model)
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


                _IContractOutRegisterBAL.update(ref model, out ErrorMessage);
                var modelTxn = model;
                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else {

                    if (modelTxn == null || modelTxn.ContractId == 0)
                        BuildResponseObject(false, resxFileHelper.GetErrorMessagesFromResource("CreateFailed"));
                    else
                    {
                       // var ResultData = _customerBAL.Get(CustomerTxn.CustomerId);
                        // ResultData.WorkingCalendar = modelTxn;
                        responseObject = (modelTxn != null) ? responseObject = BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(modelTxn)) : responseObject = BuildResponseObject(false, resxFileHelper.GetErrorMessagesFromResource("CreateFailed"));

                    }


                }
                //if (ErrorMessage != string.Empty)
                //{
                //    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, fa);
                //}
                //else
                //{

                //responseObject = (modelTxn == null) ?
                //             BuildResponseObject(false, resxFileHelper.GetErrorMessagesFromResource("CreateFailed")) :
                //             BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(modelTxn));

                //}
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
        public HttpResponseMessage Get(int id, int pagesize, int pageindex)
        {
            Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());

            try
            {
                var ErrorMessage = string.Empty;


                var userDetails = new UserDetailsModel();
                userDetails = GetUserDetails(); // Get login details with ConsortiaId and HospitalId


                var modelTxn = _IContractOutRegisterBAL.Get(id, pagesize, pageindex);



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

                paginationFilter = GridHelper.GetAllFormatSearchCondition<CORGetallEntity>(Request.GetQueryNameValuePairs());
                var commonDAL = new CommonDAL();
                paginationFilter = commonDAL.GetProperPaginationFilter(paginationFilter);
                var userDetails = new UserDetailsModel();
                userDetails = GetUserDetails(); // Get login details with ConsortiaId and HospitalId


                var result = _IContractOutRegisterBAL.Getall(paginationFilter);

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


                var modelTxn = _IContractOutRegisterBAL.Delete(id);



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
        [HttpGet]
        [Route("GetPopupDetails/{primaryId}/{ContractHisId}")]
        public HttpResponseMessage GetPopupDetails(int primaryId, int ContractHisId)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var obj = _IContractOutRegisterBAL.GetPopupDetails(primaryId, ContractHisId);
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
    }
}
