
using UETrack.Application.Web.Helpers;
using CP.UETrack.Model;
using CP.Framework.Common.Audit;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;


namespace UETrack.Application.Web.API.BEMS
{
    [RoutePrefix("api/AssetRegisterLicenseCertificateTab")]
    [WebApiAudit]
    public class AssetRegisterLicenseCertificateTabAPIController : BaseApiController
    {
        private readonly string _FileName = nameof(AssetRegisterLicenseCertificateTabAPIController);

        public AssetRegisterLicenseCertificateTabAPIController()
        {

        }

        [HttpGet("Get/{Id}")]
        public async Task<HttpResponseMessage> Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("AssetRegisterLicenseCertificateTab/Get/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }
    }
}