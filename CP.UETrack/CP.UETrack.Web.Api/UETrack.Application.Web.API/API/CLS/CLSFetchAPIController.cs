
using CP.UETrack.Application.Web.API;
using CP.UETrack.Model;
using CP.Framework.Common.Audit;
using System;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using CP.UETrack.BLL.BusinessAccess.Contracts.CLS;
using CP.Framework.Common.Logging;
using Newtonsoft.Json;
using CP.UETrack.Model.BEMS;
using CP.UETrack.Model.FetchModels;
using CP.UETrack.Model.VM;

namespace UETrack.Application.Web.API.API.CLS
{

    [RoutePrefix("api/CLSFetch")]
    [WebApiAudit]
    public class CLSFetchAPIController : BaseApiController
    {
        ICLSFetchBAL _FetchBAL;
        private readonly string _FileName = nameof(CLSFetchAPIController);
        public CLSFetchAPIController(ICLSFetchBAL fetchBAL)
        {
            _FetchBAL = fetchBAL;
        }
           


        [HttpPost]
        [Route(nameof(LocationCodeFetch))]
        public HttpResponseMessage LocationCodeFetch(UserLocationCodeSearch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LocationCodeFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.LocationCodeFetch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(LocationCodeFetch), Level.Info.ToString());
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


