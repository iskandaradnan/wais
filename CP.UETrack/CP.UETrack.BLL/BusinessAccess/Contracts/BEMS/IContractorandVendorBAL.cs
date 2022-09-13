using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.BEMS
{
    public interface IContractorandVendorBAL
    {
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        ContractorandVendorLovs Load();
       // ContractorandVendorLovs LoadCountry();
        void Delete(int Id, out string ErrorMessage);
        MstContractorandVendorViewModel Get(int Customerid);
        MstContractorandVendorViewModel SaveUpdate(MstContractorandVendorViewModel Cust, out string ErrorMessage);       
    }
}
