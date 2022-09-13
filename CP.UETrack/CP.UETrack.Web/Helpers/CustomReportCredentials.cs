using Microsoft.Reporting.WebForms;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Security.Principal;
using System.Web;

namespace UETrack.Application.Web.Helpers
{
    public class CustomReportCredentials : IReportServerCredentials
    {

        // local variable for network credential.
        private string _userName;
        private string _passWord;
        private string _domainName;

        public CustomReportCredentials(string userName, string passWord, string domainName)
        {
            _userName = userName;
            _passWord = passWord;
            _domainName = domainName;
        }

        public WindowsIdentity ImpersonationUser
        {
            get
            {
                return null;  // not use ImpersonationUser
            }
        }

        public ICredentials NetworkCredentials
        {
            get
            {

                // use NetworkCredentials
                return new NetworkCredential(_userName, _passWord, _domainName);
            }
        }

        public bool GetFormsCredentials(out Cookie authCookie, out string user, out string password, out string authority)
        {

            // not use Forms Credentials unless you have implements a custom autentication.
            authCookie = null;
            user = password = authority = null;
            return false;
        }

    }
}