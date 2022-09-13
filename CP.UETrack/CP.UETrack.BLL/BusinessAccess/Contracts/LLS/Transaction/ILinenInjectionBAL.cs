using CP.UETrack.Model;
using CP.UETrack.Model.LLS;

namespace CP.UETrack.BLL.BusinessAccess.Interface.LLS.Transaction
{
    public interface ILinenInjectionBAL
    {
        LinenInjectionModel Load();
        LinenConemnationModel Save(LinenConemnationModel model, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        LinenInjectionModel Get(int Id);
        void Delete(int Id, out string ErrorMessage);
    }

    
}
