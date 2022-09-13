using CP.UETrack.Model;
using CP.UETrack.Model.UM;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.SmartAssign
{
    public interface IPorteringSmartAssignBAL
    {
        GridFilterResult PorteringSmartAssignGetAll(SortPaginateFilter pageFilter);
    }
}
