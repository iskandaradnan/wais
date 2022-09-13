using CP.UETrack.Model;
using CP.UETrack.Models;
using System;
using System.Collections.Generic;
namespace CP.UETrack.DAL.DataAccess
{
    public interface IAccountDAL
    {

        LoginViewModel IsAuthenticated(LoginViewModel loginUser);

        void SaveChangePasswordLinkDetails(string userName, string password);

        bool IsLinkExpired(string userName, string password);

        bool GetMultipleLoginSetting();
        bool UserSessionLogin(AboutModel LoginModel);
        AboutModel GetConcurrentLoggedAndVistorHistory();
        List<VistorHistoryDetails> VisitorHistoryDetails(string Selecteddate, int? HistryType);
    }
}


