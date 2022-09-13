using CP.UETrack.Model;
using CP.UETrack.Model.CLS;

namespace CP.UETrack.DAL.DataAccess.Contracts.CLS
{
    public interface ICLSReportsDAL
    {
        ReportsDropdown Load();
        JointInspectionSummaryReport JointInspectionSummaryReportFetch(JointInspectionSummaryReport report, out string ErrorMessage);

        DailyCleaningActivitySummaryReport DailyCleaningActivitySummaryReportFetch(DailyCleaningActivitySummaryReport report, out string ErrorMessage);

        PeriodicWorkRecordSummaryReport PeriodicWorkRecordSummaryReportFetch(PeriodicWorkRecordSummaryReport report, out string ErrorMessage);

        ToiletInspectionSummaryReport ToiletInspectionSummaryReportFetch(ToiletInspectionSummaryReport report, out string ErrorMessage);

        EquipmentReport EquipmentReportFetch(EquipmentReport report, out string ErrorMessage);

        ChemicalUsedReport ChemicalUsedReportFetch(ChemicalUsedReport report, out string ErrorMessage);

        CRMReport CRMReportFetch(CRMReport report, out string ErrorMessage);
    }
}
