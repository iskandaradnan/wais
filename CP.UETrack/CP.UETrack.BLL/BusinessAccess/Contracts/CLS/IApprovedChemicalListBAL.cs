using CP.UETrack.Model.CLS;
using CP.UETrack.Model;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.CLS
{
  public  interface IApprovedChemicalListBAL
    {
        ApprovedChemicalList Save(ApprovedChemicalList userRole, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        ApprovedChemicalList Get(int Id);
        ApprovedChemicalListDropdown Load();
    }
}
