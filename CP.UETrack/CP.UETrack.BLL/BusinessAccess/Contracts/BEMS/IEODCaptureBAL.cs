using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.BEMS
{
    public interface IEODCaptureBAL
    {
        EODCaptureDropdownValues Load();
        EODCapture Save(EODCapture userRole, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        EODCapture Get(int Id);
        void Delete(int Id);
       // EODCapture BindDetGrid(int serviceId, int CatSysId, DateTime RecDate);
        EODCapture BindDetGrid(EODCapture eodcapture);
    }
}
