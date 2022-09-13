using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.BER;
using CP.UETrack.DAL.DataAccess.Contracts.BER;
using CP.UETrack.Model.BER;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.BER
{
    public class BERDashboardBAL : IBERDashboardBAL
    {
        private string _FileName = nameof(BERDashboardBAL);
        IBERDashboardDAL _BERDashboardDAL;
        public BERDashboardBAL(IBERDashboardDAL BERDashboardDAL)
        {
            _BERDashboardDAL = BERDashboardDAL;
        }

        public BERDashboard Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _BERDashboardDAL.Load();
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return result;
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }
            catch (Exception)
            {
                throw;
            }
        }

        public BERDashboard LoadGrid(int pagesize, int pageindex)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _BERDashboardDAL.LoadGrid(pagesize, pageindex);
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return result;
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }
            catch (Exception)
            {
                throw;
            }
        }
    }
}
