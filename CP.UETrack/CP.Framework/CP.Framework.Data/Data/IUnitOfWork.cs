using System;
using System.Data.Entity;


namespace CP.Framework.Data
{
    public interface IUnitOfWork : IDisposable
    {
        DbContext GetObjectContext();
        void Save();
        IRepository<T> Repository<T>() where T : class;
    }
}
