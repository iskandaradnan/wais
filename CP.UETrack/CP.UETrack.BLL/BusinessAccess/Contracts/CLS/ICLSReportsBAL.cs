using CP.UETrack.Model.CLS;
using CP.UETrack.Model;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.CLS
{
    public interface ICLSReportsBAL
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

