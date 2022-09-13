using CP.Framework.Common.Audit;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Application.Web.API.Helpers;
using CP.UETrack.BLL.BusinessAccess.Contracts.BEMS;
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

namespace UETrack.Application.Web.API.API.BEMS
{
    [RoutePrefix("api/CRMRequestApi")]
    [WebApiAudit]
    public class CRMRequestApiController : BaseApiController
    {
        internal string returnMessage;
        internal HttpResponseMessage responseObject;
        internal ResourceFileHelper resxFileHelper = new ResourceFileHelper();
        internal UserDetailsModel userSession;
        private readonly ICRMRequestBAL _ICRMRequestBAL;
        private readonly string fileName = nameof(StockUpdateRegisterApiController);

        public CRMRequestApiController(ICRMRequestBAL ICRMRequestBAL)
        {

            _ICRMRequestBAL = ICRMRequestBAL;
        }






        [HttpPost]
        [Route("save")]
        public HttpResponseMessage save(CRMRequestEntity model)
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


                _ICRMRequestBAL.save(ref model);
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

        [HttpPut]
        [Route("update")]
        public HttpResponseMessage update(CRMRequestEntity model)
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


                _ICRMRequestBAL.update(ref model);
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


                var modelTxn = _ICRMRequestBAL.Get(id, pagesize, pageindex);



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
        [Route("Getall/{id}")]
        public HttpResponseMessage GetAll(int id)
        {
            Log4NetLogger.LogEntry(fileName, nameof(GetAll), Level.Info.ToString());

            try
            {
                var ErrorMessage = string.Empty;


                SortPaginateFilter paginationFilter = null;

                paginationFilter = GridHelper.GetAllFormatSearchCondition<CRMRequestEntity>(Request.GetQueryNameValuePairs());
                var commonDAL = new CommonDAL();
                paginationFilter = commonDAL.GetProperPaginationFilter(paginationFilter);
                var userDetails = new UserDetailsModel();
                userDetails = GetUserDetails(); // Get login details with ConsortiaId and HospitalId


                var result = _ICRMRequestBAL.Getall(id,paginationFilter);

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
        [Route("get_Indicator_by_Serviceid/{id}")]
        public HttpResponseMessage get_Indicator_by_Serviceid(int id)
        {
            Log4NetLogger.LogEntry(fileName, nameof(get_Indicator_by_Serviceid), Level.Info.ToString());

            try
            {
                
               
                var result = _ICRMRequestBAL.get_Indicator_by_Serviceid(id);
                responseObject = BuildResponseObject(HttpStatusCode.Created, result);

                Log4NetLogger.LogExit(fileName, nameof(get_Indicator_by_Serviceid), Level.Info.ToString());
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
        [Route("get_TypeofRequset_by_Serviceid/{id}")]
        public HttpResponseMessage get_TypeofRequset_by_Serviceid(int id)
        {
            Log4NetLogger.LogEntry(fileName, nameof(get_TypeofRequset_by_Serviceid), Level.Info.ToString());

            try
            {


                var result = _ICRMRequestBAL.get_TypeofRequset_by_Serviceid(id);
                responseObject = BuildResponseObject(HttpStatusCode.Created, result);

                Log4NetLogger.LogExit(fileName, nameof(get_TypeofRequset_by_Serviceid), Level.Info.ToString());
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

                paginationFilter = GridHelper.GetAllFormatSearchCondition<CRMRequestEntity>(Request.GetQueryNameValuePairs());
                var commonDAL = new CommonDAL();
                paginationFilter = commonDAL.GetProperPaginationFilter(paginationFilter);
                var userDetails = new UserDetailsModel();
                userDetails = GetUserDetails(); // Get login details with ConsortiaId and HospitalId


                var result = _ICRMRequestBAL.Getall(paginationFilter);

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
        [Route("GetallService/{id}")]
        public HttpResponseMessage GetallService(int id)
        {
            Log4NetLogger.LogEntry(fileName, nameof(GetallService), Level.Info.ToString());

            try
            {
                var ErrorMessage = string.Empty;


                SortPaginateFilter paginationFilter = null;

                paginationFilter = GridHelper.GetAllFormatSearchCondition<CRMRequestEntity>(Request.GetQueryNameValuePairs());
                var commonDAL = new CommonDAL();
                paginationFilter = commonDAL.GetProperPaginationFilter(paginationFilter);
                var userDetails = new UserDetailsModel();
                userDetails = GetUserDetails(); // Get login details with ConsortiaId and HospitalId


                var result = _ICRMRequestBAL.GetallService(id,paginationFilter);

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
                Log4NetLogger.LogExit(fileName, nameof(GetallService), Level.Info.ToString());
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
        [Route("Cancel/{id}/{Remarks}")]
        public HttpResponseMessage Cancel(int id,string Remarks)
        {
            Log4NetLogger.LogEntry(fileName, nameof(Cancel), Level.Info.ToString());

            try
            {
                var ErrorMessage = string.Empty;


                var userDetails = new UserDetailsModel();
                userDetails = GetUserDetails(); // Get login details with ConsortiaId and HospitalId


                var modelTxn = _ICRMRequestBAL.Cancel(id,Remarks);



                responseObject = BuildResponseObject(HttpStatusCode.Created, modelTxn);

                //}
                Log4NetLogger.LogExit(fileName, nameof(Cancel), Level.Info.ToString());
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


                var modelTxn = _ICRMRequestBAL.Load();



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
        [Route(nameof(ConvertWO))]
        public HttpResponseMessage ConvertWO(CRMRequestEntity req)
        {

            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(ConvertWO), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _ICRMRequestBAL.ConvertWO(req);

                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {
                    result = _ICRMRequestBAL.Get(result.CRMRequestId, 5,1);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, JsonConvert.SerializeObject(result));
                    //var serialisedData = JsonConvert.SerializeObject(result);
                    //responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }
                Log4NetLogger.LogExit(fileName, nameof(ConvertWO), Level.Info.ToString());
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
        [Route(nameof(ApplyingProcess))]
        public HttpResponseMessage ApplyingProcess(CRMRequestEntity req)
        {

            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(ApplyingProcess), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _ICRMRequestBAL.ApplyingProcess(req);

                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {
                    result = _ICRMRequestBAL.Get(result.CRMRequestId,5,1);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, JsonConvert.SerializeObject(result));
                    //var serialisedData = JsonConvert.SerializeObject(result);
                    //responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }
                Log4NetLogger.LogExit(fileName, nameof(ApplyingProcess), Level.Info.ToString());
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
        [Route(nameof(GetObsAsset))]
        public HttpResponseMessage GetObsAsset(CRMRequestEntity req)
        {

            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(GetObsAsset), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _ICRMRequestBAL.GetObsAsset(req);

                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }
                Log4NetLogger.LogExit(fileName, nameof(GetObsAsset), Level.Info.ToString());
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
        [Route("GetObsAssetM/{ManId}/{ModId}/{pagesize}/{pageindex}")]
        public HttpResponseMessage GetObsAssetM(int ManId, int ModId, int pagesize, int pageindex)
        {
            Log4NetLogger.LogEntry(fileName, nameof(GetObsAssetM), Level.Info.ToString());

            try
            {
                var ErrorMessage = string.Empty;


                var userDetails = new UserDetailsModel();
                userDetails = GetUserDetails(); // Get login details with ConsortiaId and HospitalId


                var modelTxn = _ICRMRequestBAL.GetObsAssetM(ManId, ModId, pagesize, pageindex);



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

        //[HttpGet]
        //[Route("BemsCRMGetall/{id}/{pageFilter}/{TypeOfRequest}/{ServiceId}")]
        //public HttpResponseMessage BemsCRMGetall(int id, SortPaginateFilter pageFilter, int TypeOfRequest, int ServiceId)
        //{
        //    Log4NetLogger.LogEntry(fileName, nameof(BemsCRMGetall), Level.Info.ToString());

        //    try
        //    {
        //        var ErrorMessage = string.Empty;


        //        var userDetails = new UserDetailsModel();
        //        userDetails = GetUserDetails(); // Get login details with ConsortiaId and HospitalId


        //        var modelTxn = _ICRMRequestBAL.BemsCRMGetall(id, pageFilter, TypeOfRequest, ServiceId);



        //        responseObject = (modelTxn == null) ?
        //                     BuildResponseObject(false, resxFileHelper.GetErrorMessagesFromResource("CreateFailed")) :
        //                     BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(modelTxn));

        //        //}
        //        Log4NetLogger.LogExit(fileName, nameof(Get), Level.Info.ToString());
        //    }
        //    catch (ValidationException ex)
        //    {
        //        responseObject = BuildResponseObject(HttpStatusCode.BadRequest, false, ex);
        //    }
        //    catch (Exception ex)
        //    {
        //        returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
        //    }

        //    if (responseObject == null)
        //        responseObject = BuildResponseObject(false, returnMessage);

        //    return responseObject;
        //}
    }
}
