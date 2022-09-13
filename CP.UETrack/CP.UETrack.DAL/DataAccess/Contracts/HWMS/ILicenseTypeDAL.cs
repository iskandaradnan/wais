using CP.UETrack.Model;
using CP.UETrack.Model.HWMS;

namespace CP.UETrack.DAL.DataAccess.Contracts.HWMS
{
    public interface ILicenseTypeDAL
    {

        LicenseType Save(LicenseType block, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        LicenseType Get(int Id);      
        LicenseTypeeDropdown Load();
    }
}

 


