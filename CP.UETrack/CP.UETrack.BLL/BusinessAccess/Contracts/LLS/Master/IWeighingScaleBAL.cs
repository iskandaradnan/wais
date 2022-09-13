using CP.UETrack.Model;
using CP.UETrack.Model.LLS;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.LLS.Master
{
   public interface IWeighingScaleBAL
    {
        WeighingScaleEquipmentModelLovs Load();
        WeighingScaleEquipmentModel Save(WeighingScaleEquipmentModel model, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        WeighingScaleEquipmentModel Get(int Id);
        void Delete(int Id, out string ErrorMessage);

    }
}
 