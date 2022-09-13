using CP.UETrack.Model;
using CP.UETrack.Model.HWMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace CP.UETrack.BLL.BusinessAccess.Contracts.HWMS
{
    public interface IConsumablesReceptaclesBAL
    {
        ConsumablesReceptacles Save(ConsumablesReceptacles userRole, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        ConsumablesReceptacles Get(int Id);       
        ItemTypeDropdown Load();        
    }
}


