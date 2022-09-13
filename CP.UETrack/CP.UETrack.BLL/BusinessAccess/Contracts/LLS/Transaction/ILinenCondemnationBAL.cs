using CP.UETrack.Model;
using CP.UETrack.Model.LLS;

namespace CP.UETrack.BLL.BusinessAccess.Interface.LLS.Transaction
{
    public interface ILinenCondemnationBAL
    {
        LinenConemnationModelLovs Load();
        LinenConemnationModel Save(LinenConemnationModel model, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        LinenConemnationModel Get(int Id);
        void Delete(int Id, out string ErrorMessage);
    }

    
}
