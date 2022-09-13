using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.VM;
using CP.UETrack.DAL.DataAccess.Contracts.VM;
using CP.UETrack.Model;
using CP.UETrack.Model.VM;
using System;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.VM
{
    public class BulkAuthorizationBAL: IBulkAuthorizationBAL
    {
        private readonly IBulkAuthorizationDAL _BulkAuthorizationDAL;

        private readonly static string fileName = nameof(BulkAuthorizationBAL);

        #region Ctor/init
        public BulkAuthorizationBAL(IBulkAuthorizationDAL BulkAuthorizationDAL)
        {
            _BulkAuthorizationDAL = BulkAuthorizationDAL;

        }
        #endregion

        public BulkAuthorizationViewModel Load()
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());
                var result = _BulkAuthorizationDAL.Load();
                Log4NetLogger.LogExit(fileName, nameof(Load), Level.Info.ToString());
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

        public BulkAuthorizationViewModel Get(int Year, int Month, int ServiceId, int PageSize, int PageIndex)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var result = _BulkAuthorizationDAL.Get(Year, Month, ServiceId, PageSize, PageIndex);
                Log4NetLogger.LogExit(fileName, nameof(Get), Level.Info.ToString());
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

        public BulkAuthorizationViewModel Save(BulkAuthorizationViewModel BulkAuthorization, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                BulkAuthorizationViewModel result = null;

                result = _BulkAuthorizationDAL.Save(BulkAuthorization);

                Log4NetLogger.LogExit(fileName, nameof(Save), Level.Info.ToString());
                return result;
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }

            catch (Exception ex)
            {
                throw new BALException(ex);
            }
        }
    }
}
