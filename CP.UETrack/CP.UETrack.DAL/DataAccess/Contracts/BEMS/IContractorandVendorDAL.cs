using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;

namespace CP.UETrack.DAL.DataAccess.Contracts.BEMS
{
    public interface IContractorandVendorDAL
    {
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        ContractorandVendorLovs Load();
       // ContractorandVendorLovs LoadCountry();
        
        void Delete(int ContractorId, out string ErrorMessage);
        MstContractorandVendorViewModel Get(int ContractorId);
        MstContractorandVendorViewModel SaveUpdate(MstContractorandVendorViewModel Contractor);
        bool IsContractorRegCodeDuplicate(MstContractorandVendorViewModel model);
        bool IsRecordModified(MstContractorandVendorViewModel model);
    }
}
