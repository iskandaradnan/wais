using UETrack.Application.Web.Helpers;
using CP.UETrack.Model.CLS;
using CP.Framework.Common.Audit;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;

namespace UETrack.Application.Web.API.CLS
{
    [RoutePrefix("api/CLSReports")]
    [WebApiAudit]
    public class CLSReportsApiController : BaseApiController
    {
        private readonly string _FileName = nameof(CLSReportsApiController);

        public CLSReportsApiController()
        {
        }

        [HttpGet(nameof(Load))]
        public Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = RestHelper.ApiGet("CLSReports/Load");
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(JointInspectionSummaryReportFetch))]
        public Task<HttpResponseMessage> JointInspectionSummaryReportFetch(JointInspectionSummaryReport report)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(JointInspectionSummaryReportFetch), Level.Info.ToString());
            var result = RestHelper.ApiPost("CLSReports/JointInspectionSummaryReportFetch", report);
            Log4NetLogger.LogEntry(_FileName, nameof(JointInspectionSummaryReportFetch), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(DailyCleaningActivitySummaryReportFetch))]
        public async Task<HttpResponseMessage> DailyCleaningActivitySummaryReportFetch(DailyCleaningActivitySummaryReport report)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(DailyCleaningActivitySummaryReportFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("CLSReports/DailyCleaningActivitySummaryReportFetch", report);
            Log4NetLogger.LogEntry(_FileName, nameof(DailyCleaningActivitySummaryReportFetch), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(PeriodicWorkRecordSummaryReportFetch))]
        public async Task<HttpResponseMessage> PeriodicWorkRecordSummaryReportFetch(PeriodicWorkRecordSummaryReport report)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(PeriodicWorkRecordSummaryReportFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("CLSReports/PeriodicWorkRecordSummaryReportFetch", report);
            Log4NetLogger.LogEntry(_FileName, nameof(PeriodicWorkRecordSummaryReportFetch), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(ToiletInspectionSummaryReportFetch))]
        public async Task<HttpResponseMessage> ToiletInspectionSummaryReportFetch(ToiletInspectionSummaryReport report)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(ToiletInspectionSummaryReportFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("CLSReports/ToiletInspectionSummaryReportFetch", report);
            Log4NetLogger.LogEntry(_FileName, nameof(ToiletInspectionSummaryReportFetch), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(EquipmentReportFetch))]
        public async Task<HttpResponseMessage> EquipmentReportFetch(EquipmentReport report)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(EquipmentReportFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("CLSReports/EquipmentReportFetch", report);
            Log4NetLogger.LogEntry(_FileName, nameof(EquipmentReportFetch), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(ChemicalUsedReportFetch))]
        public async Task<HttpResponseMessage> ChemicalUsedReportFetch(ChemicalUsedReport report)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(ChemicalUsedReportFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("CLSReports/ChemicalUsedReportFetch", report);
            Log4NetLogger.LogEntry(_FileName, nameof(ChemicalUsedReportFetch), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(CRMReportFetch))]
        public async Task<HttpResponseMessage> CRMReportFetch(CRMReport report)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(CRMReportFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("CLSReports/CRMReportFetch", report);
            Log4NetLogger.LogEntry(_FileName, nameof(CRMReportFetch), Level.Info.ToString());
            return result;
        }

    }
}