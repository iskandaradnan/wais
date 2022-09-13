using CP.UETrack.Model;
using CP.UETrack.Model.HWMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Contracts.HWMS
{
   public interface IBinMasterDAL
    {
        BinMasterDropDown Load();
        BinMaster Save(BinMaster block, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        BinMaster Get(int Id);
        
    }
}
