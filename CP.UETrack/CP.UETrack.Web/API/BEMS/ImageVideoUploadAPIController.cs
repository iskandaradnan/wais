using CP.Framework.Common.Audit;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using UETrack.Application.Web.Helpers;

namespace UETrack.Application.Web.API.BEMS
{
    [RoutePrefix("api/ImageVideoUpload")]
    [WebApiAudit]
    public class ImageVideoUploadAPIController : BaseApiController
    {
        private readonly string _FileName = nameof(ImageVideoUploadAPIController);

        public ImageVideoUploadAPIController()
        {

        }

        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet("ImageVideoUpload/Load");
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(Save))]
        public async Task<HttpResponseMessage> Save(ImageVideoUploadModel ImageVideo)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            ImageVideo.ImageVideoUploadListData = FileUploadHelper.FileUpload(ImageVideo.ImageVideoUploadListData);
            var result = await RestHelper.ApiPost("ImageVideoUpload/Save", ImageVideo);
            if (result.StatusCode == HttpStatusCode.OK)
            {
                FileUploadHelper.FileUploadCreate(ImageVideo.ImageVideoUploadListData);
            }
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            return result;
        }

        [HttpGet("GetUploadDetails/{Id}")]
        public Task<HttpResponseMessage> GetUploadDetails(string Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetUploadDetails), Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("ImageVideoUpload/GetUploadDetails/{0}", Id));         
            Log4NetLogger.LogEntry(_FileName, nameof(GetUploadDetails), Level.Info.ToString());
            return result;
        }

        [HttpGet("Delete/{Id}")]
        public async Task<HttpResponseMessage> Delete(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("ImageVideoUpload/Delete/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            return result;
        }

    }
}