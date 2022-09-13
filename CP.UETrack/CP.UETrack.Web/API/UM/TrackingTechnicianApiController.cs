using UETrack.Application.Web.Helpers;
using CP.UETrack.Model;
using CP.Framework.Common.Audit;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using System;

namespace UETrack.Application.Web.API.UM
{
    [RoutePrefix("api/TrackingTechnician")]
    [WebApiAudit]
    public class TrackingTechnicianApiController : BaseApiController
    {
        private readonly string _FileName = nameof(TrackingTechnicianApiController);
        public TrackingTechnicianApiController()
        {

        }
        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll(string starDate, string endDate, string customerid, string facilityid, int staffid)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            // var result = await RestHelper.ApiGet(string.Format("TrackingTechnician/GetAll?starDate=" + starDate + "&endDate=" + endDate+ "&customerid="+ customerid + "&facilityid="+ facilityid + "&staffname="+ staffname + "&username="+ username));
            var result = await RestHelper.ApiGet(string.Format("TrackingTechnician/GetAll?starDate=" + starDate + "&endDate=" + endDate + "&customerid=" + customerid + "&facilityid=" + facilityid + "&staffid=" + staffid));
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            return result;
        }
        [HttpGet(nameof(GetFacility))]
        public async Task<HttpResponseMessage> GetFacility()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetFacility), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("TrackingTechnician/GetFacility"));
            Log4NetLogger.LogEntry(_FileName, nameof(GetFacility), Level.Info.ToString());
            return result;
        }

        [HttpGet(nameof(GetEngineerByid))]
        public async Task<HttpResponseMessage> GetEngineerByid(int Engineerid, string starDate, string endDate)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("TrackingTechnician/GetEngineerByid?Engineerid=" + Engineerid + "&starDate=" + starDate + "&endDate=" + endDate));
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            return result;
        }
    }
}
