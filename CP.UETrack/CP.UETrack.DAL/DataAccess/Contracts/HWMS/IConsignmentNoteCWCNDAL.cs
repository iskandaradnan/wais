using CP.UETrack.Model;
using CP.UETrack.Model.HWMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Contracts.HWMS
{
    public interface IConsignmentNoteCWCNDAL
    {
        ConsignmentNoteCWCN Save(ConsignmentNoteCWCN block, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        ConsignmentNoteCWCN Get(int Id);
        List<VehicleDetails> VehicleNoFetch(VehicleDetails SearchObject);
        List<DriverDetails> DriverCodeFetch(DriverDetails SearchObject);
        List<DailyWeighingRecord> AutoDisplayDWRSNO();
        ConsignmentCWCNDropDown Load();
        List<ConsignmentNoteCWCN> AutoDisplaying();
        ConsignmentNoteCWCN_BinDetails DWRSNOData(int DWRId);
        ConsignmentNoteCWCN TreatmentPlantData(string TreatmentPlantName);
      
    }
}
