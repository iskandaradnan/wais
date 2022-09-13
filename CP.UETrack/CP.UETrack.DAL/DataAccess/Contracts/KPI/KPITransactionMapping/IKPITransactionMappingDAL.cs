using CP.UETrack.Model;
using System.Collections.Generic;

namespace CP.UETrack.DAL.DataAccess
{
    public interface IKPITransactionMappingDAL
    {
        KPITransactionMappingLovs Load();
        List<KPITransactionFetchResult> FetchRecords(KPITransactionMapping kPITransactionMapping, out string ErrorMessage);
        KPITransactions Save(KPITransactions kpiTransactions, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        KPITransactions Get(int Id, int PageIndex, int PageSize);
        void Delete(int Id);
    }
}