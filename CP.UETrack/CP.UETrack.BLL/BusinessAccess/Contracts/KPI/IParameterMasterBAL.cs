using CP.UETrack.Model;
using CP.UETrack.Model.KPI;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.KPI
{
    public interface IParameterMasterBAL
    {
        ParameterTypeDropdown Load();
        ParameterMasterModel Save(ParameterMasterModel Parameter);

        ParameterMasterModel Get(int Id);
        bool Delete(int Id);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        ParameterMasterModel GetParameterList(int parameterservice, int parameterindicator);
    }
}
