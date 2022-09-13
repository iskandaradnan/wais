using CP.UETrack.Model;
using CP.UETrack.Model.LLS;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.LLS.Master
{
  public  interface IVehicleDetailsBAL
    {
        VehicleDetailsModelLovs Load();
        VehicleDetailsModel Save(VehicleDetailsModel model, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        VehicleDetailsModel Get(int Id);
        void Delete(int Id, out string ErrorMessage);
    }
}
