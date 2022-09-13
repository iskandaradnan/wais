using CP.UETrack.Model;
using CP.UETrack.Model.LLS;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.LLS.Master
{
   public interface ILaundryPlantBAL
    {
        LaundryPlantModelLovs Load();
        LaundryPlantModel Save(LaundryPlantModel model, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        LaundryPlantModel Get(int Id);
        void Delete(int Id, out string ErrorMessage);

    }
}
