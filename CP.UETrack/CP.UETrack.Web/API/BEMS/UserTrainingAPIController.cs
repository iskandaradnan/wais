using CP.Framework.Common.Audit;
using CP.Framework.Common.Logging;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS.UserTraining;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using UETrack.Application.Web.Helpers;
using CP.UETrack.Application.Web.API;
using CP.Framework.Common.StateManagement;

namespace UETrack.Application.Web.API.BEMS
{
    [RoutePrefix("api/UserTraining")]
    [WebApiAudit]
    public class UserTrainingAPIController : BaseApiController
    {
        private readonly string _FileName = nameof(UserTrainingAPIController);
        readonly ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        public UserTrainingAPIController()
        {

        }

        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet("UserTraining/Load");
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(Save))]
        public async Task<HttpResponseMessage> Save(HttpRequestMessage request, [FromBody] UserTrainingCompletion usertraining)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            var userDetail = ((UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel)));
            userDetail.UserDB = usertraining.TypeOfServiceRequest;
            _sessionProvider.Set(nameof(UserDetailsModel), userDetail);
            var result = await RestHelper.ApiPost("UserTraining/Save", usertraining);
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            return result;
        }

        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("UserTraining/GetAll?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            return result;
        }

        [HttpGet("Get/{Id}/{pagesize}/{pageindex}")]
        public async Task<HttpResponseMessage> Get(int Id, int pagesize, int pageindex)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("UserTraining/Get/{0}/{1}/{2}", Id, pagesize, pageindex));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }
        [HttpGet("Delete/{Id}")]
        public async Task<HttpResponseMessage> Delete(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("UserTraining/Delete/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(SaveFeedback))]
        public async Task<HttpResponseMessage> SaveFeedback(HttpRequestMessage request, [FromBody] TrainingFeedback feedback)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SaveFeedback), Level.Info.ToString());
            var result = await RestHelper.ApiPost("UserTraining/SaveFeedback", feedback);
            Log4NetLogger.LogEntry(_FileName, nameof(SaveFeedback), Level.Info.ToString());
            return result;
        }

        [HttpGet("GetFeedback/{Id}")]
        public async Task<HttpResponseMessage> GetFeedback(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetFeedback), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("UserTraining/GetFeedback/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(GetFeedback), Level.Info.ToString());
            return result;
        }
    }
}
