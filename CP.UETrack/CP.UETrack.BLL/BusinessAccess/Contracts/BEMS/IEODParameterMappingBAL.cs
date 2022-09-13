using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.BEMS
{
    public interface IEODParameterMappingBAL
    {
        EODTpeCodeMapDropdownValues Load();
        EODParameterMapping Save(EODParameterMapping userRole, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        EODParameterMapping Get(int Id, int pagesize, int pageindex);
        void Delete(int Id, out string ErrorMessage);
        EODParameterMapping GetHistory(int Id);
    }
}
