using CP.Framework.Common.Audit;
using CP.Framework.Common.Logging;
using CP.Framework.Common.StateManagement;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using UETrack.Application.Web.Helpers;


namespace UETrack.Application.Web.API.BEMS
{
    [RoutePrefix("api/CRMRequestApi")]
    [WebApiAudit]
    public class CRMRequestApiController : BaseApiController
    {
        readonly ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        private readonly string _FileName = nameof(CRMRequestApiController);
        [HttpPost("save")]
        public async Task<HttpResponseMessage> save([FromBody] CRMRequestEntity level)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(save), Level.Info.ToString());
            var userDetail = ((UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel)));
            userDetail.UserDB = level.TypeOfServiceRequest;
            _sessionProvider.Set(nameof(UserDetailsModel), userDetail);
            var result = await RestHelper.ApiPost("CRMRequestApi/save", level);
            Log4NetLogger.LogEntry(_FileName, nameof(save), Level.Info.ToString());
            return result;
        }
        [HttpPost("update")]
        public async Task<HttpResponseMessage> update([FromBody] CRMRequestEntity level)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(update), Level.Info.ToString());
            var result = await RestHelper.ApiPut("CRMRequestApi/update", level);
            Log4NetLogger.LogEntry(_FileName, nameof(update), Level.Info.ToString());
            return result;
        }
        [HttpGet("Get/{id}/{pagesize}/{pageindex}")]
        public async Task<HttpResponseMessage> Get(int id , int pagesize, int pageindex)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("CRMRequestApi/Get/{0}/{1}/{2}", id, pagesize, pageindex));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }

        [HttpGet("Getall/{id}")]
        public async Task<HttpResponseMessage> Getall(int id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Getall), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();

            var result = await RestHelper.ApiGet(string.Format("CRMRequestApi/GetAll/{0}",id,filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(Getall), Level.Info.ToString());
            return result;
        }
        [HttpGet("get_Indicator_by_Serviceid/{id}")]
        public async Task<HttpResponseMessage> get_Indicator_by_Serviceid(int id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(get_Indicator_by_Serviceid), Level.Info.ToString());        
            var result = await RestHelper.ApiGet(string.Format("CRMRequestApi/get_Indicator_by_Serviceid/{0}", id));
            Log4NetLogger.LogEntry(_FileName, nameof(get_Indicator_by_Serviceid), Level.Info.ToString());
            return result;
        }
        [HttpGet("get_TypeofRequset_by_Serviceid/{id}")]
        public async Task<HttpResponseMessage> get_TypeofRequset_by_Serviceid(int id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(get_TypeofRequset_by_Serviceid), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("CRMRequestApi/get_TypeofRequset_by_Serviceid/{0}", id));
            Log4NetLogger.LogEntry(_FileName, nameof(get_TypeofRequset_by_Serviceid), Level.Info.ToString());
            return result;
        }

        [HttpGet("Getall")]
        public async Task<HttpResponseMessage> Getall()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Getall), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();

            var result = await RestHelper.ApiGet(string.Format("CRMRequestApi/GetAll?/{0}",filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(Getall), Level.Info.ToString());
            return result;
        }

        [HttpGet("GetallService/{id}")]
        public async Task<HttpResponseMessage> GetallService(int id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetallService), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("CRMRequestApi/GetallService/{0}",id, filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(GetallService), Level.Info.ToString());
            return result;
        }
        [HttpGet("Cancel/{id}/{Remarks}")]
        public async Task<HttpResponseMessage> Cancel(int id,string Remarks)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Cancel), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("CRMRequestApi/Cancel/{0}/{1}", id, Remarks));
            Log4NetLogger.LogEntry(_FileName, nameof(Cancel), Level.Info.ToString());
            return result;
        }
        [HttpGet("Load")]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("CRMRequestApi/Load"));
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }



        [HttpPost(nameof(ConvertWO))]
        public async Task<HttpResponseMessage> ConvertWO(HttpRequestMessage request, [FromBody] CRMRequestEntity req)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(ConvertWO), Level.Info.ToString());
            var result = await RestHelper.ApiPost("CRMRequestApi/ConvertWO", req);
            Log4NetLogger.LogEntry(_FileName, nameof(ConvertWO), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(ApplyingProcess))]
        public async Task<HttpResponseMessage> ApplyingProcess(HttpRequestMessage request, [FromBody] CRMRequestEntity req)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(ApplyingProcess), Level.Info.ToString());
            var result = await RestHelper.ApiPost("CRMRequestApi/ApplyingProcess", req);
            Log4NetLogger.LogEntry(_FileName, nameof(ApplyingProcess), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(GetObsAsset))]
        public async Task<HttpResponseMessage> GetObsAsset(HttpRequestMessage request, [FromBody] CRMRequestEntity req)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetObsAsset), Level.Info.ToString());
            var result = await RestHelper.ApiPost("CRMRequestApi/GetObsAsset", req);
            Log4NetLogger.LogEntry(_FileName, nameof(GetObsAsset), Level.Info.ToString());
            return result;
        }

        [HttpGet("GetObsAssetM/{ManId}/{ModId}/{pagesize}/{pageindex}")]
        public async Task<HttpResponseMessage> GetObsAssetM(int ManId, int ModId, int pagesize, int pageindex)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetObsAssetM), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("CRMRequestApi/GetObsAssetM/{0}/{1}/{2}/{3}", ManId, ModId, pagesize, pageindex));
            Log4NetLogger.LogEntry(_FileName, nameof(GetObsAssetM), Level.Info.ToString());
            return result;
        }
        [HttpGet("UpdateDB/{id}")]
        public async Task<int> UpdateDB(int id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(UpdateDB), Level.Info.ToString());
            var userDetail = ((UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel)));
            if (id==1)
            {
                userDetail.UserDB = 2;
            }
            else
            {
                if (id == 2)
                {
                    userDetail.UserDB = 1;
                }
                else
                {
                    userDetail.UserDB = 0;
                }
            }
          
            _sessionProvider.Set(nameof(UserDetailsModel), userDetail);
            // var result = await RestHelper.ApiGet(string.Format("CRMRequestApi/Cancel/{0}", id));
            Log4NetLogger.LogEntry(_FileName, nameof(UpdateDB), Level.Info.ToString());
            return 0;
        }


        //[HttpGet("BemsCRMGetall/{id}/{pageFilter}/{TypeOfRequest}/{ServiceId}")]
        //public async Task<HttpResponseMessage> BemsCRMGetall(int id, SortPaginateFilter pageFilter, int TypeOfRequest, int ServiceId)
        //{
        //    Log4NetLogger.LogEntry(_FileName, nameof(BemsCRMGetall), Level.Info.ToString());
        //    var result = await RestHelper.ApiGet(string.Format("CRMRequestApi/BemsCRMGetall/{0}/{1}/{2}/{3}", id, pageFilter, TypeOfRequest, ServiceId));
        //    Log4NetLogger.LogEntry(_FileName, nameof(BemsCRMGetall), Level.Info.ToString());
        //    return result;
        //}
    }
}
