using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Caching;

namespace CP.Framework.Common.StateManagement
{
    public interface ICacheProvider
    {

        void Clear(string key);

        object Get(string key);

        void Set(string key, object value);

        void Set(string key, object value, int DurationInMinutes);

        void Set(string key, object value, CacheDependency dependencies, DateTime absoluteExpiration, TimeSpan slidingExpiration);

    }

}
