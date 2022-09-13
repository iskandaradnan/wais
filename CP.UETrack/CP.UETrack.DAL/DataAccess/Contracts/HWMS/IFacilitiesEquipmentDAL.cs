using CP.UETrack.Model;
using CP.UETrack.Model.HWMS;

namespace CP.UETrack.DAL.DataAccess.Contracts.HWMS
{
    public interface IFacilitiesEquipmentDAL
    {
        FacilitiesEquipmentDropdown Load();
        FacilitiesEquipment Save(FacilitiesEquipment block, out string ErrorMessage);

        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        FacilitiesEquipment Get(int Id);
        FacilitiesEquipment AutoGenerateCode();
    }
}