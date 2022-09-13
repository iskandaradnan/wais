using CP.UETrack.Model;
using CP.UETrack.Model.HWMS;


namespace CP.UETrack.BLL.BusinessAccess.Contracts.HWMS
{
   public  interface ILicenseTypeBAL
    {
        LicenseType Save(LicenseType userRole, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        LicenseType Get(int Id);        
        LicenseTypeeDropdown Load();
    }
}

