using CP.UETrack.Model.HWMS;
using CP.UETrack.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Contracts.HWMS
{
    public interface IConsignmentNoteOSWCNDAL
    {
        ConsignmentOSWCNDropDown Load();
        ConsignmentNoteOSWCN Save(ConsignmentNoteOSWCN consignmentnoteOSWCN, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        ConsignmentNoteOSWCN Get(int Id);        
        ConsignmentNoteOSWCN WasteTypeData(string WasteCode);
        ConsignmentNoteOSWCN FetchConsign(ConsignmentNoteOSWCN consignment, out string ErrorMessage);
  
    }
}
