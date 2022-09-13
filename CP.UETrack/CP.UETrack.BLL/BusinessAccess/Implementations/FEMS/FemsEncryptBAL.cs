using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.FEMS;
using CP.UETrack.BLL.BusinessAccess.Interface;
using CP.UETrack.DAL.DataAccess;
using CP.UETrack.DAL.DataAccess.Contracts.FEMS;
using CP.UETrack.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.FEMS
{
    public class FemsEncryptBAL : IFemsEncryptBAL
    {
        private string _FileName = nameof(FemsEncryptBAL);
        IFemsEncryptDAL _FemsEncryptDAL;
        //private object fileName;

        public FemsEncryptBAL(IFemsEncryptDAL FemsEncryptDAL)
        {
            _FemsEncryptDAL = FemsEncryptDAL;
        }

        public BlockMstViewModel Get(string Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _FemsEncryptDAL.Get(Id);
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
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
