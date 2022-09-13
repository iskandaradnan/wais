using FluentValidation;
using FluentValidation.Internal;
using CP.UETrack.BLL.BusinessAccess.Interface;
using CP.UETrack.DAL.DataAccess;
using CP.UETrack.Model;
using System;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.UETrack.Models;
using System.Collections.Generic;

namespace CP.UETrack.BLL.BusinessAccess
{
    public class AccountBAL : IAccountBAL
    {
        private readonly IAccountDAL _accountDalValue;
        private readonly IValidator<LoginViewModel> _accountValidator;

        #region "Public variable declaration"

        Log4NetLogger log = new Log4NetLogger();

        #endregion

        public AccountBAL(IAccountDAL accountDal,
            IValidator<LoginViewModel> accountValidator)
        {
            _accountDalValue = accountDal;

            _accountValidator = accountValidator;
        }

        public LoginViewModel IsAuthenticated(LoginViewModel loginUser)
        {
            try
            {
                return _accountDalValue.IsAuthenticated(loginUser);
            }
            catch (BALException balex)
            {
                log.LogMessage("An error has occured because of exception", Level.Info);
                throw new BALException(balex);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public void SaveChangePasswordLinkDetails(string userName, string password)
        {
            try
            {
                _accountDalValue.SaveChangePasswordLinkDetails(userName, password);
            }
            catch (Exception ex)
            {
                throw new GeneralException(ex);
            }
        }
        public bool IsLinkExpired(string userName, string password)
        {
            var linkExpired = false;
            try
            {
                linkExpired = _accountDalValue.IsLinkExpired(userName, password);
            }
            catch (Exception ex)
            {
                throw new GeneralException(ex);
            }

            return linkExpired;
        }
      
        public bool GetMultipleLoginSetting()
        {
            try
            {
                return _accountDalValue.GetMultipleLoginSetting();
            }
            catch (Exception ex)
            {
                throw new BALException(ex);
            }
        }
        public bool UserSessionLogin(AboutModel LoginModel)
        {
            try
            {
                return _accountDalValue.UserSessionLogin(LoginModel);
            }
            catch (Exception ex)
            {
                throw new BALException(ex);
            }
        }


        public AboutModel GetConcurrentLoggedAndVistorHistory()
        {
            try
            {
                return _accountDalValue.GetConcurrentLoggedAndVistorHistory();
            }
            catch (Exception ex)
            {
                throw new BALException(ex);
            }
        }

        public List<VistorHistoryDetails> VisitorHistoryDetails(string Selecteddate, int? HistryType)
        {
            try
            {
                return _accountDalValue.VisitorHistoryDetails(Selecteddate,HistryType);
            }
            catch (Exception ex)
            {
                throw new BALException(ex);
            }
        }
    }
}
