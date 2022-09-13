using CP.UETrack.Model;
using CP.UETrack.Model.QAP;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.QAP
{
    public interface IQAPIndicatorMasterBAL
    {
        QAPIndicatorTypeDropdown Load();
        QAPIndicatorMasterModel Save(QAPIndicatorMasterModel QAPIndicator);

        QAPIndicatorMasterModel Get(int Id);
        bool Delete(int Id);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
    }
}
