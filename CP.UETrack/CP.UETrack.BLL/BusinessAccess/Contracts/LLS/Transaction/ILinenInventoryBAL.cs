using CP.UETrack.DAL.DataAccess.Implementations.LLS.Transaction;
using CP.UETrack.Model;
using CP.UETrack.Model.LLS;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.LLS.Transaction
{
    public interface ILinenInventoryBAL
    {
        LinenInventoryModelClassLovs Load();
        TestModel Save(TestModel model, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        TestModel Get(int Id);
        void Delete(int Id, out string ErrorMessage);
    }
}
