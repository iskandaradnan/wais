using CP.UETrack.Model;

namespace CP.UETrack.BLL.BusinessAccess.Interface
{
    public interface IReportsAndRecordsBAL
    {
        ReportsAndRecordsLovs Load();
        ReportsAndRecordsLst FetchRecords(int Year, int Month);
        ReportsAndRecordsLst Save(ReportsAndRecordsLst repotsAndRecordsList, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        ReportsAndRecordsLst Get(int Id);
        CARWorkOrderList GetWorkOrderDetails(int Id);
        CARHistoryList GetCARHistoryDetails(int Id);
        CARWorkOrderList SaveWorkOrderDetails(CARWorkOrderList carWorkOrderList);
        void Delete(int Id);
        RootCauseList GetRootCauses(int Id);
    }
}
