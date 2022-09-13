using CP.UETrack.Model;
using CP.UETrack.Model.KPI;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Contracts.KPI
{
    public interface IPenaltyMasterDAL
    {
        PenaltyTypeDropdown Load();
        PenaltyMasterModel Save(PenaltyMasterModel Penalty);

        PenaltyMasterModel Get(int Id);
        bool Delete(int Id);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        bool IsRecordModified(PenaltyMasterModel Penalty);
        bool IsPenaltyMasterCodeDuplicate(PenaltyMasterModel Penalty);
        PenaltyMasterModel GetPenaltyList(int penaltyservice, int penaltycriteria);
    }
}
