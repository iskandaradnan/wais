using UETrack.Application.Web.Helpers;
using CP.Framework.Common.Audit;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Model.HWMS;

namespace UETrack.Application.Web.API.HWMS
{

    [RoutePrefix("api/HWMSReports")]
    [WebApiAudit]
    public class HWMSReportsApiController : BaseApiController
    {
        private readonly string _FileName = nameof(HWMSReportsApiController);

        public HWMSReportsApiController()
        {
        }

        [HttpGet(nameof(Load))]
        public Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = RestHelper.ApiGet("HWMSReports/Load");
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(LicenseReportFetch))]
        public Task<HttpResponseMessage> LicenseReportFetch(LicenseReport report)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(LicenseReportFetch), Level.Info.ToString());
            var result = RestHelper.ApiPost("HWMSReports/LicenseReportFetch", report);
            Log4NetLogger.LogEntry(_FileName, nameof(LicenseReportFetch), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(WeighingSummaryReportFetch))]
        public Task<HttpResponseMessage> WeighingSummaryReportFetch(WeighingSummaryReport report)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(WeighingSummaryReportFetch), Level.Info.ToString());
            var result = RestHelper.ApiPost("HWMSReports/WeighingSummaryReportFetch", report);
            Log4NetLogger.LogEntry(_FileName, nameof(WeighingSummaryReportFetch), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(TransportationReportFetch))]
        public Task<HttpResponseMessage> TransportationReportFetch(TransportationReport report)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(TransportationReportFetch), Level.Info.ToString());
            var result = RestHelper.ApiPost("HWMSReports/TransportationReportFetch", report);
            Log4NetLogger.LogEntry(_FileName, nameof(TransportationReportFetch), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(SafetyDataSheetReportFetch))]
        public Task<HttpResponseMessage> SafetyDataSheetReportFetch(SafetyDataSheetReport report)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SafetyDataSheetReportFetch), Level.Info.ToString());
            var result = RestHelper.ApiPost("HWMSReports/SafetyDataSheetReportFetch", report);
            Log4NetLogger.LogEntry(_FileName, nameof(SafetyDataSheetReportFetch), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(RecordSheetWithoutCNFetch))]
        public Task<HttpResponseMessage> RecordSheetWithoutCNFetch(RecordSheetWithoutCN report)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(RecordSheetWithoutCNFetch), Level.Info.ToString());
            var result = RestHelper.ApiPost("HWMSReports/RecordSheetWithoutCNFetch", report);
            Log4NetLogger.LogEntry(_FileName, nameof(RecordSheetWithoutCNFetch), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(WasteGenerationMonthlyReportFetch))]
        public Task<HttpResponseMessage> WasteGenerationMonthlyReportFetch(WasteGenerationMonthlyReport report)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(WasteGenerationMonthlyReportFetch), Level.Info.ToString());
            var result = RestHelper.ApiPost("HWMSReports/WasteGenerationMonthlyReportFetch", report);
            Log4NetLogger.LogEntry(_FileName, nameof(WasteGenerationMonthlyReportFetch), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(CRMReportFetch))]
        public Task<HttpResponseMessage> CRMReportFetch(CRMReport report)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(CRMReportFetch), Level.Info.ToString());
            var result = RestHelper.ApiPost("HWMSReports/CRMReportFetch", report);
            Log4NetLogger.LogEntry(_FileName, nameof(CRMReportFetch), Level.Info.ToString());
            return result;
        }


    }
}