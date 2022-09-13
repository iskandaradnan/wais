using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Contracts.BEMS
{
    public interface IEODCaptureDAL
    {
        EODCaptureDropdownValues Load();
        EODCapture Save(EODCapture EODParamCodeMapping, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        EODCapture Get(int Id);
        bool IsRoleDuplicate(EODCapture userRole);
        bool IsRecordModified(EODCapture userRole);
        void Delete(int Id);
        //EODCapture BindDetGrid(int serviceId, int CatSysId, DateTime RecDate);
        EODCapture BindDetGrid(EODCapture EODcapture);

    }
}
