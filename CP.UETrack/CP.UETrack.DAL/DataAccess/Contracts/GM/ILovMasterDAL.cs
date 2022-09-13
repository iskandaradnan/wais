using CP.UETrack.Model;
using CP.UETrack.Model.GM;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Contracts.GM
{
    public interface ILovMasterDAL
    {
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        LovMasterDropdownValues Load();
        LovMasterViewModel Get(string Id);
        LovMasterViewModel Save(LovMasterViewModel userRole, out string ErrorMessage);
    }
}

