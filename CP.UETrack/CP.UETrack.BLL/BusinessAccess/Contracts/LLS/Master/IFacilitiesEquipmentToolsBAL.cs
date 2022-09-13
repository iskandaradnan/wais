using CP.UETrack.Model;
using CP.UETrack.Model.LLS;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.LLS.Master
{
   public interface IFacilitiesEquipmentToolsBAL
    {
        FacilitiesEquipmentToolsModelLovs Load();
        FacilitiesEquipmentToolsModel Save(FacilitiesEquipmentToolsModel model, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        FacilitiesEquipmentToolsModel Get(int Id);
        void Delete(int Id, out string ErrorMessage);
    }
}
