using CP.UETrack.BLL.BusinessAccess.Contracts.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model.BER;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.UETrack.DAL.DataAccess.Contracts.Common;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.Common
{
    public class ReportLoadLovBAL : IReportLoadLovBAL
    {
        private readonly IReportLoadLovDAL _dal;
        private readonly static string fileName = nameof(ReportLoadLovBAL);
        public ReportLoadLovBAL(IReportLoadLovDAL dal)
        {
            _dal = dal;

        }
        public ReportLoadLovModel Load(string screenName)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());
                var result = _dal.Load(screenName);
                Log4NetLogger.LogExit(fileName, nameof(Load), Level.Info.ToString());
                return result;

            }
            catch (BALException bx)
            {
                throw new BALException(bx);
            }
            catch (Exception ex)
            {
                throw new BALException(ex);
            }
        }
    }
}
