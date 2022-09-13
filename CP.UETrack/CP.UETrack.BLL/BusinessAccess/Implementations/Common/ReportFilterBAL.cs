using CP.UETrack.BLL.BusinessAccess.Contracts.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
//using CP.Framework.ReportHelper;
using CP.UETrack.DAL.DataAccess.Contracts.Common;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.Common
{
    //public class ReportFilterBAL : IReportFilterBLL
    //{
    //    private string _FileName = nameof(ReportFilterBAL);
    //    IReportFilterDAL _ReportFilterDAL;

    //    public ReportFilterBAL(IReportFilterDAL ReportFilterDAL)
    //    {
    //        _ReportFilterDAL = ReportFilterDAL;
    //    }
    //    public ReportMasterEntity GetReportParameters(string spName, string reportKeyId)
    //    {
    //        try
    //        {
    //            Log4NetLogger.LogEntry(_FileName, nameof(GetReportParameters), Level.Info.ToString());
    //            var result = _ReportFilterDAL.GetReportParameters(spName, reportKeyId);
    //            Log4NetLogger.LogExit(_FileName, nameof(GetReportParameters), Level.Info.ToString());
    //            return result;
    //        }
    //        catch (BALException balException)
    //        {
    //            throw new BALException(balException);
    //        }
    //        catch (Exception ex)
    //        {
    //            throw new BALException(ex);
    //        }
    //    }
    //}
}
