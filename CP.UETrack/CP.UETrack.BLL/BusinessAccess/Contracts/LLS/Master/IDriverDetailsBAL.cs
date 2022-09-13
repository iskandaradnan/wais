using CP.UETrack.Model;
using CP.UETrack.Model.LLS;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.LLS.Master
{
   public interface IDriverDetailsBAL
    {
        DriverDetailsModelLovs Load();
        DriverDetailsModel Save(DriverDetailsModel model, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        DriverDetailsModel Get(int Id);
        void Delete(int Id, out string ErrorMessage);
    }
}
