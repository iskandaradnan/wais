
using CP.UETrack.BLL.BusinessAccess.Interface;
using CP.UETrack.DAL.DataAccess;
using CP.UETrack.Model;
using System;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;

namespace CP.UETrack.BLL.BusinessAccess
{
    public class CustomerConfigBAL : ICustomerConfigBAL
    {
        private string _FileName = nameof(CustomerConfigBAL);
        ICustomerConfigDAL _CustomerConfigDAL;

        public CustomerConfigBAL(ICustomerConfigDAL customerConfigDAL)
        {
            _CustomerConfigDAL = customerConfigDAL;
        }
        public CustomerConfigLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _CustomerConfigDAL.Load();
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
        public CustomerConfig Save(CustomerConfig customerConfig, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                CustomerConfig result = null;

                if (IsValid(customerConfig, out ErrorMessage))
                {
                    result = _CustomerConfigDAL.Save(customerConfig, out ErrorMessage);
                }

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
        private bool IsValid(CustomerConfig customerConfig, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = true;
            return isValid;
        }
        
        public CustomerConfig Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _CustomerConfigDAL.Get(Id);
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
