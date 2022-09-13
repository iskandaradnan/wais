using CP.UETrack.Model.HWMS;
using CP.UETrack.Model;
using System.Collections.Generic;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.HWMS
{
    public interface IConsignmentNoteCWCNBAL
    {
        ConsignmentNoteCWCN Save(ConsignmentNoteCWCN userRole, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        ConsignmentNoteCWCN Get(int Id);
        ConsignmentCWCNDropDown Load();
        List<VehicleDetails> VehicleNoFetch(VehicleDetails SearchObject);
        List<DriverDetails> DriverCodeFetch(DriverDetails SearchObject);
        List<DailyWeighingRecord> AutoDisplayDWRSNO();
        List<ConsignmentNoteCWCN> AutoDisplaying();
        ConsignmentNoteCWCN_BinDetails DWRSNOData(int DWRId);
        ConsignmentNoteCWCN TreatmentPlantData(string TreatmentPlantName);
     

    }
}
