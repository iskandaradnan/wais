using CP.UETrack.Application.Web.API;
using CP.UETrack.Model;
using CP.Framework.Common.Audit;
using System;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using CP.UETrack.BLL.BusinessAccess.Interface;
using CP.Framework.Common.Logging;
using Newtonsoft.Json;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Application.Web.API.Helpers;
using CP.UETrack.Model.BEMS.AssetRegister;
using CP.UETrack.DAL.DataAccess;

namespace UETrack.Application.Web.Controllers
{

    [RoutePrefix("api/currentMaintenance")]
    [WebApiAudit]
    public class CurrentMaintenanceAPIController : BaseApiController
    {
        ICurrentMaintenanceBAL _CurrentMaintenanceBAL;
        private readonly string _FileName = nameof(AssetRegisterAPIController);
        public CurrentMaintenanceAPIController(ICurrentMaintenanceBAL currentMaintenaceBAL)
        {
            _CurrentMaintenanceBAL = currentMaintenaceBAL;
        }
        
        [HttpGet]
        [Route("Get/{Id}")]
        public HttpResponseMessage Get(int Id)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _CurrentMaintenanceBAL.Get(Id);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }
                
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
