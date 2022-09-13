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
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace UETrack.Application.Web.API.API.BEMS
{
    [RoutePrefix("api/MaintananceHistoryTabAssetregisterController")]
    [WebApiAudit]
    public class MaintananceHistoryTabAssetregisterController : BaseApiController
    {
        private readonly IMaintananceHistoryTabAssetregisterBAL _maintenaceHistoryBAL;
        private readonly string fileName = nameof(AssertregisterVariationDetailsTabApiController);

        public MaintananceHistoryTabAssetregisterController(IMaintananceHistoryTabAssetregisterBAL maintenanceHistoryBAL)
        {
            _maintenaceHistoryBAL = maintenanceHistoryBAL;
        }


        [HttpPost]
        [Route(nameof(fetchMaitenanceDetails))]
        public HttpResponseMessage fetchMaitenanceDetails(MaitenaceDetailsTab model)
        {
            Log4NetLogger.LogEntry(fileName, nameof(fetchMaitenanceDetails), Level.Info.ToString());

            try
            {
                var result = _maintenaceHistoryBAL.fetchMaitenanceDetails(model);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(fileName, nameof(fetchMaitenanceDetails), Level.Info.ToString());
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
