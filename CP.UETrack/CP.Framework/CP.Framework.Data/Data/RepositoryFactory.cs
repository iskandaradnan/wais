using System.Data.Entity;

namespace CP.Framework.Data
{
    public class RepositoryFactory: IRepositoryFactory
    {
        public IRepository<T> GetRepositoryInstance<T>(DbContext context) where T : class
        {
            return new Repository<T>(context);
        }
    }
}
