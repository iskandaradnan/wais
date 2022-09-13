using CP.UETrack.Model;

namespace CP.UETrack.BLL.BusinessAccess.Interface
{
    public interface ICorrectiveActionReportBAL
    {
        CorrectiveActionReportLovs Load();
        CorrectiveActionReport Save(CorrectiveActionReport correctiveActionReport, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        CorrectiveActionReport Get(int Id, int PageIndex, int PageSize);
        CARWorkOrderList GetWorkOrderDetails(int Id);
        CARHistoryList GetCARHistoryDetails(int Id);
        CARWorkOrderList SaveWorkOrderDetails(CARWorkOrderList carWorkOrderList);
        void Delete(int Id);
        RootCauseList GetRootCauses(int Id);
    }
}
