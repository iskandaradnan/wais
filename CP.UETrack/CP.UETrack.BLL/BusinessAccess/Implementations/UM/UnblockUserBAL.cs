using CP.UETrack.BLL.BusinessAccess.Interface;
using CP.UETrack.DAL.DataAccess;
using CP.UETrack.Model;
using System;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using System.Collections.Generic;

namespace CP.UETrack.BLL.BusinessAccess
{
    public class UnblockUserBAL : IUnblockUserBAL
    {
        private string _FileName = nameof(UnblockUserBAL);
        IUnblockUserDAL _UnblockUserDAL;
        public UnblockUserBAL(IUnblockUserDAL unblockUserDAL)
        {
            _UnblockUserDAL = unblockUserDAL;
        }
        public UserRegistrationLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _UnblockUserDAL.Load();
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
        public bool BlockingList(string userRegistration)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(BlockingList), Level.Info.ToString());
                var result = false;
                result  = _UnblockUserDAL.BlockingList(userRegistration);
                Log4NetLogger.LogExit(_FileName, nameof(BlockingList), Level.Info.ToString());
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

        public bool Save(int UserRegistrationId, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                var result = false;
                result = _UnblockUserDAL.Save(UserRegistrationId);
                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
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

        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                var result = _UnblockUserDAL.GetAll(pageFilter);
                Log4NetLogger.LogExit(_FileName, nameof(GetAll), Level.Info.ToString());
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
        public UMUserRegistration Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _UnblockUserDAL.Get(Id);
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
        public void Delete(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
                _UnblockUserDAL.Delete(Id);
                Log4NetLogger.LogExit(_FileName, nameof(Delete), Level.Info.ToString());
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
        public UserRegistrationLovs GetUserRoles(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetUserRoles), Level.Info.ToString());
                var result = _UnblockUserDAL.GetUserRoles(Id);
                Log4NetLogger.LogExit(_FileName, nameof(GetUserRoles), Level.Info.ToString());
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
        public UserRegistrationLovs GetLocations(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetLocations), Level.Info.ToString());
                var result = _UnblockUserDAL.GetLocations(Id);
                Log4NetLogger.LogExit(_FileName, nameof(GetLocations), Level.Info.ToString());
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
