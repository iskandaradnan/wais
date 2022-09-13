using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model.Enum;
using CP.UETrack.Model;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.CLS;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.UETrack.DAL.DataAccess.Contracts.CLS;



namespace CP.UETrack.BLL.BusinessAccess.Implementations.CLS
{
    public class CLSFetchBAL : ICLSFetchBAL
    {
        private string _FileName = nameof(CLSFetchBAL);

        ICLSFetchDAL _CLSFetchDAL;
        public CLSFetchBAL(ICLSFetchDAL CLSFetchDAL)
        {
            _CLSFetchDAL = CLSFetchDAL;
        }

        public List<UserLocationCodeSearch> LocationCodeFetch(UserLocationCodeSearch SearchObject) 
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LocationCodeFetch), Level.Info.ToString());
                var result = _CLSFetchDAL.LocationCodeFetch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(LocationCodeFetch), Level.Info.ToString());
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
