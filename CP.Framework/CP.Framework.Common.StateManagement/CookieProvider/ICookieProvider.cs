using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.Framework.Common.StateManagement
{
    public interface ICookieProvider
    {
        void WriteCookie(string cookieName, string cookieValue, int cookieTimeout, bool NonPersistent);

        string ReadCookie(string cookieName);

        void ClearCookie(string cookieName);

        bool IsCookiesAvailable(string cookieName);
    }
}
