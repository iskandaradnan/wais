using System.Collections.Generic;
using CP.UETrack.Model.Enum;

namespace CP.UETrack.DAL.DataAccess
{
    public interface ICacheDAL
    {
        IEnumerable<T> GetEntities<T>(CacheKey key, string relatedTable1 = null, string relatedTable2 = null) where T : class;
    }
}
