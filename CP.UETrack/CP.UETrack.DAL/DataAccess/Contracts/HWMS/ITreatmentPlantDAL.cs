using CP.UETrack.Model;
using CP.UETrack.Model.HWMS;
using System.Collections.Generic;

namespace CP.UETrack.DAL.DataAccess.Contracts.HWMS
{
    public interface ITreatmentPlantDAL
    {
        TreatmetPlantDropdown Load();
        TreatmetPlant Save(TreatmetPlant Plant, out string ErrorMessage);
        List<VehicleDetail> VehicleDetailsFetch(int TreatmentPlantId);
        List<DriverDetail> DriverDetailsFetch(int TreatmentPlantId);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        TreatmetPlant Get(int Id);
        List<TreatmetPlantLicenseDetails> LicenseCodeFetch(TreatmetPlantLicenseDetails SearchObject);       
    }
}
