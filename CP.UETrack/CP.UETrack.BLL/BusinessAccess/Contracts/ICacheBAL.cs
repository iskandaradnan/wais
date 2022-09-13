using CP.UETrack.Model.Enum;
using System.Collections.Generic;


namespace CP.UETrack.BLL.BusinessAccess
{
    public interface ICacheBAL
    {
        IEnumerable<T> GetEntities<T>(CacheKey key) where T : class;
    }
}
