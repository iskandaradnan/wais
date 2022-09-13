using CP.UETrack.Model;
using CP.UETrack.Models.BEMS;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.BEMS
{
    public interface ICustomerBAL
    {

        #region Business Access Methods  
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        CustomerMstViewModel Load();
        void Delete(int Customerid, out string ErrorMessage);
        CustomerMstViewModel Get(int Customerid);
        CustomerMstViewModel Save(CustomerMstViewModel Cust, out string ErrorMessage);
        ActiveFacility GetFacilityList(int customerId);
        ReportsAndRecordsList SaveReportsAndRecords(ReportsAndRecordsList ReportsAndRecords, out string ErrorMessage);
        ReportsAndRecordsList GetReportsAndRecords(int CustomerId);
        #endregion
    }
}
