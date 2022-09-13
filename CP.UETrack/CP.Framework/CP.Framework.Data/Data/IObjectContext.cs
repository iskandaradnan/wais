using System;
using System.Data.Entity.Core.Objects;
using System.Data.Entity.Core.Objects.DataClasses;
using System.Data.Common;

namespace CP.Framework.Data
{
    public interface IObjectContext: IDisposable
    {
        IObjectSet<TEntity> CreateObjectSet<TEntity>() where TEntity : class;
        void AddObject(string entitySetName, object entity);
        void Attach(IEntityWithKey entity);
        void Detach(object entity);
        void DeleteObject(object entity);
        int SaveChanges();
        int SaveChanges(bool acceptChangesDuringSave);
        int SaveChanges(SaveOptions options);
        ObjectStateManager GetObjectStateManager();
        DbConnection ConnectionObject{get;}
    }

}
