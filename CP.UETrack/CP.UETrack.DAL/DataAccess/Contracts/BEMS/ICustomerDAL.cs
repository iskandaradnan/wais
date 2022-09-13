using CP.UETrack.Model;
using CP.UETrack.Models.BEMS;

namespace CP.UETrack.DAL.DataAccess.Contracts.BEMS
{
    public interface ICustomerDAL
    {
        #region Business Access Methods    
        GridFilterResult GetAll(SortPaginateFilter pageFilter);

        CustomerMstViewModel Load();
        void Delete(int Customerid, out string ErrorMessage);
        CustomerMstViewModel Get(int Customerid);
        CustomerMstViewModel Save(CustomerMstViewModel Cust, out string ErrorMessage);
        bool IsRecordModified(CustomerMstViewModel Customer);
        bool IsCustomerCodeDuplicate(CustomerMstViewModel customer);
        ActiveFacility GetFacilityList(int customerId);
        ReportsAndRecordsList SaveReportsAndRecords(ReportsAndRecordsList ReportsAndRecords, out string ErrorMessage);
        ReportsAndRecordsList GetReportsAndRecords(int CustomerId);
        #endregion
    }
}
