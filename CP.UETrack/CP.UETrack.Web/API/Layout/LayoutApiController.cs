using UETrack.Application.Web.Helpers;
using CP.Framework.Common.Audit;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Application.Web.Helper;
using CP.UETrack.CodeLib.Helpers;
using CP.Framework.Common.StateManagement;
using CP.UETrack.Model;
using System.Net;
using Newtonsoft.Json;
using CP.UETrack.Model.Layout;
using System.Collections.Generic;
using System.Reflection;

namespace UETrack.Application.Web.Controllers
{
    [RoutePrefix("api/layout")]
    [WebApiAudit]
    public class LayoutApiController : BaseApiController
    {
        private readonly string _FileName = nameof(LayoutApiController);
        ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        public HttpResponseMessage responseObject;

        [HttpGet(nameof(GetCustomerAndFacilities))]
        public async Task<HttpResponseMessage> GetCustomerAndFacilities()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetCustomerAndFacilities), Level.Info.ToString());
            var result = await RestHelper.ApiGet("layout/GetCustomerAndFacilities");
            var jsonString = await result.Content.ReadAsStringAsync();
            var customerFacility = JsonConvert.DeserializeObject<CustomerFacilityLovs>(jsonString);

            var userDetails = (UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel));
            //if (userDetails.CustomerId == 0 && userDetails.FacilityId == 0)
            //{
            if (userDetails != null)
            {
                userDetails.CustomerId = customerFacility.CustomerId;
                userDetails.FacilityId = customerFacility.FacilityId;
                userDetails.DateFormat = customerFacility.DateFormat;
                userDetails.Currency = customerFacility.Currency;
                userDetails.UserRoleId = customerFacility.UserRoleId;
                userDetails.UserRoleName = customerFacility.UserRoleName;
                userDetails.FEMS = customerFacility.FEMS;
                userDetails.BEMS = customerFacility.BEMS;
                userDetails.CLS = customerFacility.CLS;
                userDetails.LLS = customerFacility.LLS;
                userDetails.HWMS = customerFacility.HWMS;

                //userDetails.ThemeColorId = customerFacility.ThemeColorId;                 

                _sessionProvider.Set(nameof(UserDetailsModel), userDetails);
            }
            //}
            Log4NetLogger.LogEntry(_FileName, nameof(GetCustomerAndFacilities), Level.Info.ToString());
            return result;
        }
        [HttpGet("GetFacilities/{CustomerId}")]
        public async Task<HttpResponseMessage> GetFacilities(int CustomerId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetFacilities), Level.Info.ToString());
            var result = await RestHelper.ApiGet("layout/GetFacilities/" + CustomerId);

            var jsonString = await result.Content.ReadAsStringAsync();
            var customerFacility = JsonConvert.DeserializeObject<CustomerFacilityLovs>(jsonString);

            var userDetails = (UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel));
            if (userDetails != null)
            {
                userDetails.CustomerId = customerFacility.CustomerId;
                userDetails.FacilityId = customerFacility.FacilityId;
                _sessionProvider.Set(nameof(UserDetailsModel), userDetails);
            }

            Log4NetLogger.LogEntry(_FileName, nameof(GetFacilities), Level.Info.ToString());
            return result;
        }
        [HttpGet("GetMenus/{CustomerId}/{FacilityId}")]
        public HttpResponseMessage GetMenus(int CustomerId, int FacilityId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetMenus), Level.Info.ToString());
            var userDetails = (UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel));
            if (userDetails != null)
            {
                userDetails.CustomerId = CustomerId;
                userDetails.FacilityId = FacilityId;
                _sessionProvider.Set(nameof(UserDetailsModel), userDetails);
                responseObject = BuildResponseObject(HttpStatusCode.OK);
            }
            else
            {
                responseObject = BuildResponseObject(HttpStatusCode.NotFound);
            }
            Log4NetLogger.LogEntry(_FileName, nameof(GetMenus), Level.Info.ToString());
            return responseObject;
        }

        [HttpGet("GetNotificationCount/{FacilityId}/{UserId}")]
        public async Task<HttpResponseMessage> GetNotificationCount(int FacilityId, int UserId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetNotificationCount), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("layout/GetNotificationCount/{0}/{1}", FacilityId, UserId));
            Log4NetLogger.LogEntry(_FileName, nameof(GetNotificationCount), Level.Info.ToString());
            return result;
        }

        [HttpGet("GetNotification/{pagesize}/{pageindex}")]
        public async Task<HttpResponseMessage> GetNotification(int pagesize, int pageindex)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetNotification), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("layout/GetNotification/{0}/{1}", pagesize, pageindex));
            Log4NetLogger.LogEntry(_FileName, nameof(GetNotification), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(ReseteNotificationCount))]
        public async Task<HttpResponseMessage> ReseteNotificationCount(HttpRequestMessage request, [FromBody] Notification EODCap)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(ReseteNotificationCount), Level.Info.ToString());
            var result = await RestHelper.ApiPost("layout/ReseteNotificationCount", EODCap);
            Log4NetLogger.LogEntry(_FileName, nameof(ReseteNotificationCount), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(ClearNavigatedRec))]
        public async Task<HttpResponseMessage> ClearNavigatedRec(HttpRequestMessage request, [FromBody] Notification EODCap)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(ClearNavigatedRec), Level.Info.ToString());
            var result = await RestHelper.ApiPost("layout/ClearNavigatedRec", EODCap);
            Log4NetLogger.LogEntry(_FileName, nameof(ClearNavigatedRec), Level.Info.ToString());
            return result;
        }

        [HttpGet(nameof(LoadCustomer))]
        public async Task<HttpResponseMessage> LoadCustomer()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(LoadCustomer), Level.Info.ToString());
            var result = await RestHelper.ApiGet("layout/LoadCustomer");
            Log4NetLogger.LogEntry(_FileName, nameof(LoadCustomer), Level.Info.ToString());
            return result;
        }

        [HttpGet("LoadFacility/{CusId}")]
        public async Task<HttpResponseMessage> Get(int CusId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var userDetails = (UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel));
            if (userDetails != null)
            {
                userDetails.CustomerId = CusId;
                _sessionProvider.Set(nameof(UserDetailsModel), userDetails);
            }
            var result = await RestHelper.ApiGet(string.Format("layout/LoadFacility/{0}", CusId));

            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }


        [HttpPost(nameof(SetCustomerFacilityDet))]
        public void SetCustomerFacilityDet(CustomerFacilityLovs WO)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());

            var userDetails = (UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel));
            if (userDetails != null)
            {
                userDetails.CustomerId = WO.CustomerId;
                userDetails.FacilityId = WO.FacilityId;
                userDetails.CustomerName = WO.CustomerName;
                userDetails.FacilityName = WO.FacilityName;

                _sessionProvider.Set(nameof(UserDetailsModel), userDetails);
            }


            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            //return result;
        }

        [HttpGet("GetCustomerFacilityDet/{CusId}/{FacId}")]
        public async Task<HttpResponseMessage> GetCustomerFacilityDet(int CusId, int FacId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetCustomerFacilityDet), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("layout/GetCustomerFacilityDet/{0}/{1}", CusId, FacId));

            var jsonString = await result.Content.ReadAsStringAsync();
            var customerFacility = JsonConvert.DeserializeObject<CustomerFacilityLovs>(jsonString);

            var userDetails = (UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel));

            //    if (userDetails != null)
            //    {
            userDetails.DateFormat = customerFacility.DateFormat;
            userDetails.Currency = customerFacility.Currency;
            userDetails.UserRoleId = customerFacility.UserRoleId;
            userDetails.UserRoleName = customerFacility.UserRoleName;
            _sessionProvider.Set(nameof(UserDetailsModel), userDetails);
            //   }

            Log4NetLogger.LogEntry(_FileName, nameof(GetCustomerFacilityDet), Level.Info.ToString());
            return result;
        }
    }
}
