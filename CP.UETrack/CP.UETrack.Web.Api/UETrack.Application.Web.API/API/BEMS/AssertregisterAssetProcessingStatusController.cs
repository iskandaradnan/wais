using CP.Framework.Common.Audit;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.BLL.BusinessAccess.Contracts.BEMS;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using CP.UETrack.TranslationManager;
using FluentValidation;
using Newtonsoft.Json;
using System;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;

namespace UETrack.Application.Web.API.API.BEMS
{
    [RoutePrefix("api/AssertregisterAssetProcessingStatus")]
    [WebApiAudit]
    public class AssertregisterAssetProcessingStatusController : BaseApiController
    {

        internal string returnMessage;
        internal HttpResponseMessage responseObject;
        internal ResourceFileHelper resxFileHelper = new ResourceFileHelper();
        internal UserDetailsModel userSession;
        private readonly IAssertregisterAssetProcessingStatusBAL _assetClassificationBAL;
        private readonly string fileName = nameof(AssertregisterVariationDetailsTabApiController);

        public AssertregisterAssetProcessingStatusController(IAssertregisterAssetProcessingStatusBAL assetClassificationBAL)
        {
            _assetClassificationBAL = assetClassificationBAL;
        }

        [HttpPost]
        [Route("AssetProcessingStatus")]
        public HttpResponseMessage AssetProcessingStatus(AssetProcessingStatus model)
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


                var modelTxn = _assetClassificationBAL.AssetProcessingStatus(model);
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
    }
}
