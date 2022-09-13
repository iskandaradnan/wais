using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model;
using CP.UETrack.Model.HWMS;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.HWMS
{
   public interface IQualityCauseMasterBAL
   {
        QualityCauseMasterDropdown Load();
        QualityCauseMaster Save(QualityCauseMaster userRole, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        QualityCauseMaster Get(int Id);
    }    
}
