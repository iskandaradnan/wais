
using CP.UETrack.BLL.BusinessAccess.Interface;
using CP.UETrack.DAL.DataAccess;
using CP.UETrack.Model;
using System;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;

namespace CP.UETrack.BLL.BusinessAccess
{
    public class ForgotPasswordBAL : IForgotPasswordBAL
    {
        private string _FileName = nameof(ForgotPasswordBAL);
        IForgotPasswordDAL _ForgotPasswordDAL;

        public ForgotPasswordBAL(IForgotPasswordDAL forgotPasswordDAL)
        {
            _ForgotPasswordDAL = forgotPasswordDAL;
        }
        //public ForgotPasswordLovs Load()
        //{
        //    try
        //    {
        //        Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
        //        var result = _ForgotPasswordDAL.Load();
        //        Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
        //        return result;
        //    }
        //    catch (BALException balException)
        //    {
        //        throw new BALException(balException);
        //    }
        //    catch (Exception)
        //    {
        //        throw;
        //    }
        //}
        public ForgotPassword Save(ForgotPassword forgotPassword, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                ForgotPassword result = null;

                if (IsValid(forgotPassword, out ErrorMessage))
                {
                    result = _ForgotPasswordDAL.Save(forgotPassword, out ErrorMessage);
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
        private bool IsValid(ForgotPassword forgotPassword, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;

            //if (_ForgotPasswordDAL.IsUsernameInValid(forgotPassword))
            //{
            //    ErrorMessage = "Username is invalid	";
            //}
            //else 
            if (_ForgotPasswordDAL.IsInvalidEmailId(forgotPassword))
            {
                ErrorMessage = "Email ID is invalid";
            }
            else
            {
                isValid = true;
            }
            return isValid;
        }
        //public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        //{
        //    try
        //    {
        //        Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
        //        var result = _ForgotPasswordDAL.GetAll(pageFilter);
        //        Log4NetLogger.LogExit(_FileName, nameof(GetAll), Level.Info.ToString());
        //        return result;
        //    }
        //    catch (BALException balException)
        //    {
        //        throw new BALException(balException);
        //    }
        //    catch (Exception)
        //    {
        //        throw;
        //    }
        //}
        //public ForgotPassword Get(int Id)
        //{
        //    try
        //    {
        //        Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
        //        var result = _ForgotPasswordDAL.Get(Id);
        //        Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
        //        return result;
        //    }
        //    catch (BALException balException)
        //    {
        //        throw new BALException(balException);
        //    }
        //    catch (Exception)
        //    {
        //        throw;
        //    }
        //}
        //public void Delete(int Id)
        //{
        //    try
        //    {
        //        Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
        //        _ForgotPasswordDAL.Delete(Id);
        //        Log4NetLogger.LogExit(_FileName, nameof(Delete), Level.Info.ToString());
        //    }
        //    catch (BALException balException)
        //    {
        //        throw new BALException(balException);
        //    }
        //    catch (Exception)
        //    {
        //        throw;
        //    }
        //}
    }
}
