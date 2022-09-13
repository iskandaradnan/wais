using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Application.Web.Filter;
using CP.UETrack.Model.BEMS;
using System.Net;
using System.Net.Http;
using System.Reflection;
using System.Threading.Tasks;
using System.Web.Http;
using UETrack.Application.Web.Helpers;

namespace UETrack.Application.Web.API.BEMS
{
    [WebApiAuthentication]
    [RoutePrefix("api/SpareParts")]

    public class SparepartRegisterAPIController : BaseApiController
    {
        private readonly string _FileName = nameof(SparepartRegisterAPIController);

        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("SpareParts/GetAll?{0}", filterData));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }
        [System.Web.Http.HttpGetAttribute(nameof(Load))]
        public Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("SpareParts/Load"));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }


        [System.Web.Http.HttpPostAttribute("add")]
        public Task<HttpResponseMessage> Post(EngSpareParts model)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiPost("SpareParts/add", model);
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [HttpGet("Delete/{Id}")]
        public Task<HttpResponseMessage> Delete(int Id)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("SpareParts/Delete/{0}", Id));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [System.Web.Http.HttpGetAttribute("get/{id}")]
        public Task<HttpResponseMessage> Get(string Id)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("SpareParts/get/{0}", Id));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(SPImageVideoSave))]
        public async Task<HttpResponseMessage> SPImageVideoSave(ImageVideoUploadModel ImageVideo)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SPImageVideoSave), Level.Info.ToString());
            ImageVideo.ImageVideoUploadListData = FileUploadHelper.FileUpload(ImageVideo.ImageVideoUploadListData);
            var result = await RestHelper.ApiPost("SpareParts/SPImageVideoSave", ImageVideo);
            if (result.StatusCode == HttpStatusCode.OK)
            {
                FileUploadHelper.FileUploadCreate(ImageVideo.ImageVideoUploadListData);
            }
            Log4NetLogger.LogEntry(_FileName, nameof(SPImageVideoSave), Level.Info.ToString());
            return result;
        }

        [HttpGet("SPGetUploadDetails/{Id}")]
        public Task<HttpResponseMessage> SPGetUploadDetails(string Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SPGetUploadDetails), Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("SpareParts/SPGetUploadDetails/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(SPGetUploadDetails), Level.Info.ToString());
            return result;
        }

        [HttpGet("SPFileDelete/{Id}")]
        public async Task<HttpResponseMessage> SPFileDelete(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SPFileDelete), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("SpareParts/SPFileDelete/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(SPFileDelete), Level.Info.ToString());
            return result;
        }
    }
}
