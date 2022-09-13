using CP.UETrack.Model;
using CP.UETrack.Model.QAP;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Contracts.QAP
{
    public interface IQualityCauseMasterDAL
    {
        QualityCauseTypeDropdown Load();
        QualityCauseMasterModel Save(QualityCauseMasterModel Quality, out string ErrorMessage);

        QualityCauseMasterModel Get(int Id,int pagesize,int pageindex);
        bool Delete(int Id);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        bool IsRecordModified(QualityCauseMasterModel Quality);
        bool IsQualityCauseMasterCodeDuplicate(QualityCauseMasterModel Quality);
    }
}
