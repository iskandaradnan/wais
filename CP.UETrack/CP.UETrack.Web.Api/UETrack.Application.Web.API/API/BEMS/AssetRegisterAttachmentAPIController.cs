using CP.Framework.Common.Audit;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Application.Web.API.Helpers;
using CP.UETrack.BLL.BusinessAccess.Contracts.BEMS;
using CP.UETrack.Model.BEMS;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace UETrack.Application.Web.API.API.BEMS
{
    [RoutePrefix("api/Document")]
    [WebApiAudit]
    public class AssetRegisterAttachmentAPIController : BaseApiController
    {
       readonly IAssetRegisterAttachmentBAL _AssetRegisterAttachmentBAL;
        private readonly string _FileName = nameof(AssetRegisterAttachmentAPIController);
        public AssetRegisterAttachmentAPIController(IAssetRegisterAttachmentBAL accountBAL)
        {
            _AssetRegisterAttachmentBAL = accountBAL;
        }

        [HttpGet]
        [Route(nameof(Load))]
        public HttpResponseMessage Load()
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _AssetRegisterAttachmentBAL.Load();
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
        public HttpResponseMessage Save(AssetRegisterAttachment Document)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _AssetRegisterAttachmentBAL.Save(Document, out ErrorMessage);

                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                    }
                else
                {
                    
                    result = _AssetRegisterAttachmentBAL.GetAttachmentDetails(result.DocumentGuId);
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
        [Route("GetAttachmentDetails/{id}")]
        public HttpResponseMessage GetAttachmentDetails(string Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var obj = _AssetRegisterAttachmentBAL.GetAttachmentDetails(Id);
                var serialisedData = JsonConvert.SerializeObject(obj);
                if (obj == null)
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                else
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
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
        [Route("Get/{Id}")]
        public HttpResponseMessage Get(int Id)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _AssetRegisterAttachmentBAL.Get(Id);
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

        [HttpDelete]
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
                    var isSuccess = _AssetRegisterAttachmentBAL.Delete(PrimaryID);

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


    }
}
