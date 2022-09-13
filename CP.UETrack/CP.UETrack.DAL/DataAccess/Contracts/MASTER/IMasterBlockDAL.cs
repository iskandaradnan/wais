using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model;

namespace CP.UETrack.DAL.DataAccess
{
    public interface IMasterBlockDAL
    {
        BlockFacilityDropdown Load();
        BlockMstViewModel Save(BlockMstViewModel block, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        BlockMstViewModel Get(int Id);
        bool IsBlockCodeDuplicate(BlockMstViewModel userRole);
        bool IsRecordModified(BlockMstViewModel userRole);
        void Delete(int Id, out string ErrorMessage);
    }
}
