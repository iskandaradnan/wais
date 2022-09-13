using CP.UETrack.Model.HWMS;
using CP.UETrack.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.HWMS
{
    public interface IConsignmentNoteOSWCNBAL
    {
        ConsignmentOSWCNDropDown Load();
        ConsignmentNoteOSWCN Save(ConsignmentNoteOSWCN userRole, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        ConsignmentNoteOSWCN Get(int Id);       
        ConsignmentNoteOSWCN WasteTypeData(string Wastetype);
        ConsignmentNoteOSWCN FetchConsign(ConsignmentNoteOSWCN userRole, out string ErrorMessage);
        
    }
}
