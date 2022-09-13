using System.Data.Entity;

namespace CP.Framework.Data
{
    public interface IRepositoryFactory
    {
        IRepository<T> GetRepositoryInstance<T>(DbContext context) where T : class;
    }
}