using CP.UETrack.Model.Enum;
using System.Collections.Generic;
using System;
using CP.UETrack.DAL.DataAccess;
namespace CP.UETrack.BLL.BusinessAccess.Implementations
{
    public class CacheBAL : ICacheBAL
    {
        private ICacheDAL _cacheDAL;
        public CacheBAL(ICacheDAL cacheDAL)
        {
            _cacheDAL = cacheDAL;
        }
        public IEnumerable<T> GetEntities<T>(CacheKey key) where T : class
        {
            return _cacheDAL.GetEntities<T>(key);
        }
    }
}
