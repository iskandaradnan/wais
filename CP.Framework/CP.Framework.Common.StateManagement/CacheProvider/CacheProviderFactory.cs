namespace CP.Framework.Common.StateManagement
{
    public class CacheProviderFactory
    {
        public static ICacheProvider GetCacheProvider(int durationInMinutes)
        {
            return new DefaultCacheProvider(durationInMinutes);
        }
    }

}
