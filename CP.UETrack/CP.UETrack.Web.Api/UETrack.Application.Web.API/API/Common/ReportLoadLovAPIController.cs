using CP.Framework.Common.Audit;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.BLL.BusinessAccess.Contracts.Common;
using CP.UETrack.DAL.DataAccess;
using CP.UETrack.Model;
using Newtonsoft.Json;
using System;
using System.Net;
using System.Net.Http;
using System.Web.Http;
namespace UETrack.Application.Web.API.API.Common
{
    [RoutePrefix("api/ReportLoadLov")]
    [WebApiAudit]
    public class ReportLoadLovAPIController : BaseApiController
    {
        private readonly IReportLoadLovBAL _bal;
        private readonly string fileName = nameof(ReportLoadLovAPIController);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public ReportLoadLovAPIController(IReportLoadLovBAL bal)
        {
            _bal = bal;
           
        }

        [HttpGet]
        [Route("Load/{screenname}")]
        
        public HttpResponseMessage Load(string screenname)
        {

            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());
                var result = _bal.Load(screenname);
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

    }
}
