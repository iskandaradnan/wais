using CP.Framework.Common.Audit;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.BLL.BusinessAccess.Contracts.BEMS;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace UETrack.Application.Web.API.API.BEMS
{
    [RoutePrefix("api/AssetRegisterLicenseCertificateTab")]
    [WebApiAudit]
    public class AssetRegisterLicenseCertificateTabApiController : BaseApiController
    {
        IAssetRegisterLicenseCertificateTabBAL _AssetRegisterLicenseCertificateTabBAL;
        private readonly string _FileName = nameof(AssetRegisterLicenseCertificateTabApiController);
        public AssetRegisterLicenseCertificateTabApiController(IAssetRegisterLicenseCertificateTabBAL LicenseCertificateBAL)
        {
            _AssetRegisterLicenseCertificateTabBAL = LicenseCertificateBAL;
        }

        [HttpGet]
        [Route("Get/{Id}")]
        public HttpResponseMessage Get(int Id)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _AssetRegisterLicenseCertificateTabBAL.Get(Id);
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
    }
}
