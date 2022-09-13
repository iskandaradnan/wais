using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using CP.UETrack.Model.BEMS.CRMWorkOrder;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.BEMS
{
    public interface ICRMWorkorderAssignBAL
    {
        CRMWorkorderDropdownValues Load();
        CRMWorkorderAssign Save(CRMWorkorderAssign crmwork, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        CRMWorkorderAssign Get(int Id);
        CRMWorkorderAssign FetchWorkorder(CRMWorkorderAssign work);
    }
}
