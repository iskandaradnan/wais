using CP.UETrack.Model.CLS;
using CP.UETrack.Model;
using System.Collections.Generic;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.CLS
{
   public  interface IQualityCauseMasterBAL
    {
        QualityCauseMasterDropdown Load();
        QualityCauseMaster Save(QualityCauseMaster userRole, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        QualityCauseMaster Get(int Id);

    }
}
