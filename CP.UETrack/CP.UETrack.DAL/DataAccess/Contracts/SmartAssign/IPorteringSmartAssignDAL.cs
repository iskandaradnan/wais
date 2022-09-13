using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model;

namespace CP.UETrack.DAL.DataAccess.Contracts.SmartAssign
{
    public interface IPorteringSmartAssignDAL
    {
        GridFilterResult PorteringSmartAssignGetAll(SortPaginateFilter pageFilter);
    }
}
