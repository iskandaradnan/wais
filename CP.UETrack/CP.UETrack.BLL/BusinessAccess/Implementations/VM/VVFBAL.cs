using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.VM;
using CP.UETrack.DAL.DataAccess.Contracts.VM;
using CP.UETrack.Model.VM;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.VM
{
   public class VVFBAL: IVVFBAL
    {
        private readonly IVVFDAL _IVVFDAL;
        private readonly static string fileName = nameof(VVFBAL);
        public VVFBAL(IVVFDAL IVVFDAL)
        {
            _IVVFDAL = IVVFDAL;

        }
        public VVFDetails Get(VVFDetails entity)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());

                Log4NetLogger.LogExit(fileName, nameof(Get), Level.Info.ToString());
                return _IVVFDAL.Get(entity);
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
        public LoadEntity Load()
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());

                Log4NetLogger.LogExit(fileName, nameof(Load), Level.Info.ToString());
                return _IVVFDAL.Load();
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
        public VVFEntity Update(VVFEntity model)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Update), Level.Info.ToString());

                Log4NetLogger.LogExit(fileName, nameof(Update), Level.Info.ToString());
                return _IVVFDAL.Update(model);
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
