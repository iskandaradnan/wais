using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.BEMS
{
    public interface IPPMPlannerBAL
    {
        PPMPlannerLovs Load();
        bool Delete(int Id);
        EngPlannerTxn Get(int Id);
        EngPlannerTxn Popup(int Id, int pagesize, int pageindex);
        EngPlannerTxn Summary(int Service, int WorkGroup, int Year, int TOP, int pagesize, int pageindex);
        EngPlannerTxn Save(EngPlannerTxn model, out string ErrorMessage);
        PlannerUpload Upload(ref PlannerUpload model, out string ErrorMessage);
        EngPlannerTxn AssetFrequencyTaskCode(string Id);
        EngPlannerTxn AssetTypeCodeFrequency(string Id);
        


    }
}
