using CP.UETrack.Model;
using CP.UETrack.Model.HWMS;


namespace CP.UETrack.DAL.DataAccess.Contracts.HWMS
{
    public interface IHWMSReportsDAL
    {
        ReportsDropdown Load();
        LicenseReport LicenseReportFetch(out string ErrorMessage);
        WeighingSummaryReport WeighingSummaryReportFetch(WeighingSummaryReport report, out string ErrorMessage);
        TransportationReport TransportationReportFetch(TransportationReport report, out string ErrorMessage);
        SafetyDataSheetReport SafetyDataSheetReportFetch(SafetyDataSheetReport report, out string ErrorMessage);
        RecordSheetWithoutCN RecordSheetWithoutCNFetch(RecordSheetWithoutCN report, out string ErrorMessage);
        WasteGenerationMonthlyReport WasteGenerationMonthlyReportFetch(WasteGenerationMonthlyReport report, out string ErrorMessage);
        CRMReport CRMReportFetch(CRMReport report, out string ErrorMessage);

    }
}
