using CP.UETrack.Model;
using CP.UETrack.Model.KPI;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Contracts.KPI
{
    public interface IParameterMasterDAL
    {
        ParameterTypeDropdown Load();
        ParameterMasterModel Save(ParameterMasterModel Parameter);

        ParameterMasterModel Get(int Id);
        bool Delete(int Id);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        bool IsRecordModified(ParameterMasterModel Parameter);
        bool IsParameterMasterCodeDuplicate(ParameterMasterModel Parameter);
        ParameterMasterModel GetParameterList(int parameterservice, int parameterindicator);
    }
}
