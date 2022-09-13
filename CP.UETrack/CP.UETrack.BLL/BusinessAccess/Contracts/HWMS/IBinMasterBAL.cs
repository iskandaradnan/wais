using CP.UETrack.Model;
using CP.UETrack.Model.HWMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.HWMS
{
    public interface IBinMasterBAL
    {
        BinMasterDropDown Load();
        BinMaster Save(BinMaster userRole, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        BinMaster Get(int Id);        
    }
}
