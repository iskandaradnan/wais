using CP.UETrack.Model.HWMS;
using CP.UETrack.Model;
using System.Collections.Generic;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.HWMS
{
    public interface ITreatmentPlantBAL
    {
        TreatmetPlant Save(TreatmetPlant userRole, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        TreatmetPlant Get(int Id);
        TreatmetPlantDropdown Load();
        List<VehicleDetail> VehicleDetailsFetch(int TreatmentPlantId);
        List<DriverDetail> DriverDetailsFetch(int TreatmentPlantId);
        List<TreatmetPlantLicenseDetails> LicenseCodeFetch(TreatmetPlantLicenseDetails SearchObject);       
    }
}
