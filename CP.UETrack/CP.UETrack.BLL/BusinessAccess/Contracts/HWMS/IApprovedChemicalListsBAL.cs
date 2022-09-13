using CP.UETrack.Model.HWMS;
using CP.UETrack.Model;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.HWMS
{
  public  interface IApprovedChemicalListsBAL
    {
        ApprovedChemicalLists Save(ApprovedChemicalLists userRole, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        ApprovedChemicalLists Get(int Id);
        ApprovedChemicalListsDropdown Load();
    }
}
