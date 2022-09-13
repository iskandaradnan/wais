using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model;
using CP.UETrack.Model.HWMS;

namespace CP.UETrack.DAL.DataAccess.Contracts.HWMS
{
   public interface IQualityCauseMasterDAL
   {
        QualityCauseMasterDropdown Load();
        QualityCauseMaster Save(QualityCauseMaster block, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        QualityCauseMaster Get(int Id);
    }
}
