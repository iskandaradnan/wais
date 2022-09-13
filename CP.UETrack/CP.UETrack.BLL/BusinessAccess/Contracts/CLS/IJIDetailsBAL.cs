using CP.UETrack.Model;
using CP.UETrack.Model.CLS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.CLS
{
    public interface IJIDetailsBAL
    {
        JIDetails Save(JIDetails userRole, out string ErrorMessage);
        JIDetails Submit(JIDetails userRole, out string ErrorMessage);
        JIDetails LocationCodeFetch(JIDetails details);
        List<JISchedule> DocumentNoFetch(JISchedule SearchObject);
        List<JIDetailsAttachment> AttachmentSave(JIDetails userRole, out string ErrorMessage);
        JIDetailsListDropdown Load();
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        JIDetails Get(int Id);
    }
}
