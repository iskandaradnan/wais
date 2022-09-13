using CP.UETrack.Model;
using CP.UETrack.Model.KPI;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.KPI
{
    public interface IPenaltyMasterBAL
    {
        PenaltyTypeDropdown Load();
        PenaltyMasterModel Save(PenaltyMasterModel Penalty);

        PenaltyMasterModel Get(int Id);
        bool Delete(int Id);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        PenaltyMasterModel GetPenaltyList(int penaltyservice, int penaltycriteria);
    }
}
