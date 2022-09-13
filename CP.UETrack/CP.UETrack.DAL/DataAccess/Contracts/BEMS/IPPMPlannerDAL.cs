using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;

namespace CP.UETrack.DAL.DataAccess.Contracts.BEMS
{
    public interface IPPMPlannerDAL
    {       
        PPMPlannerLovs Load();
        bool Delete(int Id);
        EngPlannerTxn Get(int Id);
        EngPlannerTxn Popup(int Id, int pagesize, int pageindex);
        EngPlannerTxn Summary(int Service, int WorkGroup, int Year, int TOP, int pagesize, int pageindex);
        EngPlannerTxn Save(EngPlannerTxn model , out string ErrorMessage);
        bool IsRecordModified(EngPlannerTxn model);
        EngPlannerTxn ImportValidation(ref EngPlannerTxn model);
        EngPlannerTxn AssetFrequencyTaskCode(string Id);
        EngPlannerTxn AssetTypeCodeFrequency(string Id);
        

    }
}
