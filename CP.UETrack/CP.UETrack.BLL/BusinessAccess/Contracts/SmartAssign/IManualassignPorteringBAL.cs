using CP.UETrack.Model;
using CP.UETrack.Model.Portering;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.SmartAssign
{
    public interface IManualassignPorteringBAL
    {
        PorteringLovs Load();
        PorteringModel Save(PorteringModel port, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        PorteringModel Get(int Id);
    }
}
