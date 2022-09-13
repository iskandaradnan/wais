using CP.UETrack.Model;
using CP.UETrack.Model.VM;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.VM
{
    public interface ISummaryofFeeReportBAL
    {
        SFRLovEntity Load();
        FetchDetails Get(FetchDetails entity, out string ErrorMessage);
        SFRSaveEntity Save(SFRSaveEntity model);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        void Delete(int Id, out string ErrorMessage);
    }
}
