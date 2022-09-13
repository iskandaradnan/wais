using CP.Framework.Common.Audit;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Application.Web.API.Helpers;
using CP.UETrack.BLL.BusinessAccess.Contracts.BEMS;
using CP.UETrack.BLL.BusinessAccess.Contracts.BER;
using CP.UETrack.BLL.BusinessAccess.Contracts.Common;
using CP.UETrack.DAL.DataAccess;
using CP.UETrack.BLL.BusinessAccess.Interface;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using CP.UETrack.Model.BER;
using CP.UETrack.Model.BEMS;
using FluentValidation;
using Newtonsoft.Json;
using System;
using System.Net;
using System.Net.Http;
using System.Web.Http;


namespace UETrack.Application.Web.Controllers
{
    [RoutePrefix("api/Arp")]
    [WebApiAudit]
    public class ArpApiApplicationController : BaseApiController
    {
         IARPApplicationBAL _bal;
        private readonly ICommonBAL _common;
        private readonly string fileName = nameof(ArpApiApplicationController);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public ArpApiApplicationController(IARPApplicationBAL bal, ICommonBAL common)
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
        [Route(nameof(Save))]
        public HttpResponseMessage Save(Arp model)
        {
            try
            {
                var ErrorMessage = string.Empty;
                Log4NetLogger.LogEntry(fileName, nameof(Save), Level.Info.ToString());
                var result = _bal.Save(model, out ErrorMessage);

                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {

                    if (result == null || result.ARPID == 0)
                        BuildResponseObject(false, resxFileHelper.GetErrorMessagesFromResource("CreateFailed"));
                    else
                    {
                        var ResultData = _bal.Get(result.ARPID);
                        // ResultData.WorkingCalendar = modelTxn;
                        responseObject = (result != null) ? responseObject = BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(ResultData)) : responseObject = BuildResponseObject(false, resxFileHelper.GetErrorMessagesFromResource("CreateFailed"));

                    }
                    //    var serialisedData = JsonConvert.SerializeObject(result);
                    //    responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
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

        [HttpPost]
        [Route(nameof(ProposalSave))]
        public HttpResponseMessage ProposalSave(Arp model)
        {
            try
            {
                var ErrorMessage = string.Empty;
                Log4NetLogger.LogEntry(fileName, nameof(ProposalSave), Level.Info.ToString());
                var result = _bal.ProposalSave(model, out ErrorMessage);

                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {

                    if (result == null || result.ARPID == 0)
                        BuildResponseObject(false, resxFileHelper.GetErrorMessagesFromResource("CreateFailed"));
                    else
                    {
                        var ResultData = _bal.Get(result.ARPID);
                        // ResultData.WorkingCalendar = modelTxn;
                        responseObject = (result != null) ? responseObject = BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(ResultData)) : responseObject = BuildResponseObject(false, resxFileHelper.GetErrorMessagesFromResource("CreateFailed"));

                    }
                    //    var serialisedData = JsonConvert.SerializeObject(result);
                    //    responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }
                Log4NetLogger.LogExit(fileName, nameof(ProposalSave), Level.Info.ToString());
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
        [Route(nameof(Submit))]
        public HttpResponseMessage Submit(Arp model)
        {
            try
            {
                var ErrorMessage = string.Empty;
                Log4NetLogger.LogEntry(fileName, nameof(Submit), Level.Info.ToString());
                var result = _bal.Submit(model, out ErrorMessage);

                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {

                    if (result == null || result.ARPID == 0)
                        BuildResponseObject(false, resxFileHelper.GetErrorMessagesFromResource("CreateFailed"));
                    else
                    {
                        var ResultData = _bal.Get(result.ARPID);
                        // ResultData.WorkingCalendar = modelTxn;
                        responseObject = (result != null) ? responseObject = BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(ResultData)) : responseObject = BuildResponseObject(false, resxFileHelper.GetErrorMessagesFromResource("CreateFailed"));

                    }
                    //    var serialisedData = JsonConvert.SerializeObject(result);
                    //    responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }
                Log4NetLogger.LogExit(fileName, nameof(Submit), Level.Info.ToString());
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
        [Route("Arpget/{id}")]
        public HttpResponseMessage ArpGet(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(ArpGet), Level.Info.ToString());
                var obj = _bal.ArpGet(Id);
                var serialisedData = JsonConvert.SerializeObject(obj);
                if (obj == null)
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                else
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(fileName, nameof(ArpGet), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = string.Format("{0} : {1}", resxFileHelper.GetErrorMessagesFromResource("GeneralException"), ex.Message);
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);
            return responseObject;

        }

        [HttpPost]
        [Route("add")]
        public HttpResponseMessage Post(Arp model)
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

                    if (modelTxn == null || modelTxn.BERApplicationId == 0)
                        BuildResponseObject(false, resxFileHelper.GetErrorMessagesFromResource("CreateFailed"));
                    else
                    {
                        var ResultData = _bal.Get(modelTxn.BERApplicationId);
                        // ResultData.WorkingCalendar = modelTxn;
                        responseObject = (modelTxn != null) ? responseObject = BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(ResultData)) : responseObject = BuildResponseObject(false, resxFileHelper.GetErrorMessagesFromResource("CreateFailed"));

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
        [Route("GetAttachmentDetails/{id}")]
        public HttpResponseMessage GetAttachmentDetails(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var obj = _bal.GetAttachmentDetails(Id);
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
        [Route("GetBERNoDetails/{id}")]
        public HttpResponseMessage GetBERNoDetails(string Id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(GetBERNoDetails), Level.Info.ToString());
                var obj = _bal.GetBERNoDetails(Id);
                var serialisedData = JsonConvert.SerializeObject(obj);
                if (obj == null)
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                else
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(fileName, nameof(GetBERNoDetails), Level.Info.ToString());
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
                Log4NetLogger.LogEntry(fileName, nameof(GetAll), Level.Info.ToString());

                SortPaginateFilter paginationFilter = null;

                paginationFilter = GridHelper.GetAllFormatSearchCondition<AssetRegister>(Request.GetQueryNameValuePairs());
                var commonDAL = new CommonDAL();
                paginationFilter = commonDAL.GetProperPaginationFilter(paginationFilter);

                var result = _bal.GetAll(paginationFilter);
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

        #region Commented
        //[HttpGet]
        //[Route("GetMaintainanceHistory/{id}")]
        //public HttpResponseMessage GetMaintainanceHistory(int Id)
        //{
        //    try
        //    {
        //        Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
        //        var obj = _bal.GetMaintainanceHistory(Id);
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

        //[HttpGet]
        //[Route("GetApplicationHistiry/{id}")]
        //public HttpResponseMessage GetApplicationHistiry(int Id)
        //{
        //    try
        //    {
        //        Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
        //        var obj = _bal.GetApplicationHistiry(Id);
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
        //[HttpGet]
        //[Route(nameof(GetAllBER2))]
        //public HttpResponseMessage GetAllBER2()
        //{
        //    try
        //    {
        //        Log4NetLogger.LogEntry(fileName, nameof(GetAll), Level.Info.ToString());
        //        SortPaginateFilter paginationFilter = null;
        //        paginationFilter = GridHelper.GetAllFormatSearchCondition<BERApplicationTxn>(Request.GetQueryNameValuePairs());
        //        var commonDAL = new CommonDAL();
        //        paginationFilter = commonDAL.GetProperPaginationFilter(paginationFilter);
        //        var modelName = "Ber2";
        //        var result = _common.GetAll(paginationFilter, modelName);
        //        if (result == null)
        //            responseObject = BuildResponseObject(HttpStatusCode.NotFound);
        //        else
        //        {
        //            var jsonData = new
        //            {
        //                total = result.TotalPages,
        //                result.CurrentPage,
        //                records = result.TotalRecords,
        //                rows = result.RecordsList
        //            };
        //            responseObject = jsonData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, jsonData);
        //        }
        //        Log4NetLogger.LogExit(fileName, nameof(GetAll), Level.Info.ToString());
        //    }
        //    catch (Exception ex)
        //    {
        //        returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
        //    }

        //    if (responseObject == null)
        //        responseObject = BuildResponseObject(false, returnMessage);

        //    return responseObject;
        //}
        //[HttpGet]
        //[Route("getBerCurrentValueHistory/{id}")]
        //public HttpResponseMessage GetBerCurrentValueHistory(int Id)
        //{
        //    try
        //    {
        //        Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
        //        var obj = _bal.GetBerCurrentValueHistory(Id);
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
        //[HttpPost]
        //[Route(nameof(SaveDocument))]
        //public HttpResponseMessage SaveDocument(BERApplicationTxn Document)
        //{
        //    Log4NetLogger.LogEntry(fileName, nameof(Post), Level.Info.ToString());

        //    try
        //    {
        //        var ErrorMessage = string.Empty;
        //        if (Document == null)
        //        {
        //            return responseObject = BuildResponseObject(HttpStatusCode.BadRequest, false);
        //        }
        //        if (!ModelState.IsValid)
        //        {
        //            return BuildResponseObject(HttpStatusCode.BadRequest, false, ModelState);
        //        }


        //        var modelTxn = _bal.SaveDocument(Document, out ErrorMessage);
        //        if (ErrorMessage != string.Empty)
        //        {
        //            responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
        //        }
        //        else
        //        {

        //            if (modelTxn == null || modelTxn.ApplicationId == 0)
        //                BuildResponseObject(false, resxFileHelper.GetErrorMessagesFromResource("CreateFailed"));
        //            else
        //            {
        //                var ResultData = _bal.GetAttachmentDetails(modelTxn.ApplicationId);
        //                // ResultData.WorkingCalendar = modelTxn;
        //                responseObject = (modelTxn != null) ? responseObject = BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(ResultData)) : responseObject = BuildResponseObject(false, resxFileHelper.GetErrorMessagesFromResource("CreateFailed"));

        //            }
        //        }
        //        Log4NetLogger.LogExit(fileName, nameof(Post), Level.Info.ToString());
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




        //[HttpPost]
        //[Route("SaveAdditionalInfoForAsset")]
        //public HttpResponseMessage SaveAdditionalInfoForBer(BerAdditionalFields AdditionalInfo)
        //{

        //    try
        //    {
        //        Log4NetLogger.LogEntry(fileName, nameof(SaveAdditionalInfoForBer), Level.Info.ToString());
        //        var ErrorMessage = string.Empty;
        //        var result = _bal.SaveAdditionalInfoForBer(AdditionalInfo, out ErrorMessage);

        //        if (ErrorMessage != string.Empty)
        //        {
        //            responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
        //        }
        //        else
        //        {
        //            var serialisedData = JsonConvert.SerializeObject(result);
        //            responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
        //        }
        //        Log4NetLogger.LogExit(fileName, nameof(SaveAdditionalInfoForBer), Level.Info.ToString());
        //    }
        //    catch (Exception ex)
        //    {
        //        returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
        //    }

        //    if (responseObject == null)
        //        responseObject = BuildResponseObject(false, returnMessage);

        //    return responseObject;
        //}




        //[HttpGet]
        //[Route("GetAdditionalInfoForAsset/{AssetId}")]
        //public HttpResponseMessage GetAdditionalInfoForAsset(int AssetId)
        //{

        //    try
        //    {
        //        Log4NetLogger.LogEntry(fileName, nameof(GetAdditionalInfoForAsset), Level.Info.ToString());
        //        var result = _bal.GetAdditionalInfoForBer(AssetId);
        //        if (result == null)
        //        {
        //            responseObject = BuildResponseObject(HttpStatusCode.NotFound);
        //        }
        //        else
        //        {
        //            var serialisedData = JsonConvert.SerializeObject(result);
        //            responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
        //        }

        //        Log4NetLogger.LogExit(fileName, nameof(GetAdditionalInfoForAsset), Level.Info.ToString());
        //    }
        //    catch (Exception ex)
        //    {
        //        returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
        //    }

        //    if (responseObject == null)
        //        responseObject = BuildResponseObject(false, returnMessage);

        //    return responseObject;
        //}

        #endregion

    }
}
   
