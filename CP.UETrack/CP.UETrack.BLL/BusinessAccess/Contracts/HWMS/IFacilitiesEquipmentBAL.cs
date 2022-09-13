using CP.UETrack.Model;
using CP.UETrack.Model.HWMS;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.HWMS
{
    public interface IFacilitiesEquipmentBAL
    {
        FacilitiesEquipment Save(FacilitiesEquipment userRole, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        FacilitiesEquipment Get(int Id);
        FacilitiesEquipment AutoGenerateCode();
        FacilitiesEquipmentDropdown Load();
    }
}
