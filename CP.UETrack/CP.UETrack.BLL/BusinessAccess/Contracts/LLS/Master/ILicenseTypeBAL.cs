using CP.UETrack.Model;
using CP.UETrack.Model.LLS;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.LLS.Master
{
   public interface ILicenseTypeBAL
    {
        LicenseTypeModelLovs Load();
        LicenseTypeModel Save(LicenseTypeModel model, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        LicenseTypeModel Get(int Id);
        void Delete(int Id, out string ErrorMessage);
    }
}
