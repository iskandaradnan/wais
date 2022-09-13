using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Caching;

namespace CP.Framework.Common.StateManagement
{

    public class DefaultCacheProvider : ICacheProvider
    {

        public int CacheDuration
        {
            get;
            set;
        }

        private const int DEFAULT_CACHE_DURATION = 30;

        public DefaultCacheProvider()
        {
            CacheDuration = DEFAULT_CACHE_DURATION;
        }
        public DefaultCacheProvider(int durationInMinutes)
        {
            CacheDuration = durationInMinutes;
        }

        #region ICacheProvider Members

        public void Clear(string key)
        {
            HttpRuntime.Cache[key] = null;
        }

        public object Get(string key)
        {
            return HttpRuntime.Cache[key];
        }

        public void Set(string key, object value)
        {
            HttpRuntime.Cache[key] = value;
        }

        public void Set(string key, object value, int DurationinMinutes)
        {

            HttpRuntime.Cache.Insert(

                key,

                value,

                null,

                DateTime.Now.AddMinutes(DurationinMinutes),

                TimeSpan.Zero);

        }

        public void Set(string key, object value, CacheDependency dependencies, DateTime absoluteExpiration, TimeSpan slidingExpiration)
        {
            HttpRuntime.Cache.Insert(

                key,

                value,

                dependencies,

                absoluteExpiration,

                slidingExpiration);
        }

        #endregion


       
    }


}
