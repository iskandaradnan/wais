using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Collections;
using System.Web.Caching;

namespace CP.Framework.Common.StateManagement
{
    public class SessionProviderFactory
    {
        public static ISessionProvider GetSessionProvider()
        {
            return new DefaultSessionProvider();
        }
    }
}
