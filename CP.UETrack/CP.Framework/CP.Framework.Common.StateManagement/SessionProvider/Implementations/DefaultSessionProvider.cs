using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;



namespace CP.Framework.Common.StateManagement
{

    public class DefaultSessionProvider : ISessionProvider
    {

        #region ISessionProvider Members

        public void Clear(string key)
        {
            System.Web.HttpContext.Current.Session[key] = null;
        }

        public object Get(string key)
        {
            return System.Web.HttpContext.Current.Session[key];
        }

        public void Set(string key, object value)
        {
            System.Web.HttpContext.Current.Session[key] = value;
        }

        #endregion
    }


}
