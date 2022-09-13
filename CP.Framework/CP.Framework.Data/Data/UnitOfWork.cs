using System;
using System.Data.Entity.Validation;
using System.Diagnostics;
using System.Data.Entity;
using log4net;


namespace CP.Framework.Data
{
    public class UnitOfWork : Disposable, IUnitOfWork
    {
        private readonly DbContext _context;
        private static readonly ILog log = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        public UnitOfWork(DbContext context)
        {
            this._context = context;
        }

        public void Save()
        {
            try
            {
                _context.SaveChanges();
            }
            catch (DbEntityValidationException dbEx)
            {
                foreach (var validationErrors in dbEx.EntityValidationErrors)
                {
                    var entity = validationErrors.Entry.Entity.GetType().Name;
                    foreach (var validationError in validationErrors.ValidationErrors)
                    {
                        var errorMessage = String.Format("Entity: {0} Property: {1} Error: {2}", entity,
                            validationError.PropertyName, validationError.ErrorMessage);
                        Trace.TraceInformation(errorMessage);
                        //Log exceptions on to the database here.
                        log.Error(String.Format("Database error occurred. {0}", errorMessage), dbEx);
                    }
                }
            }
        }

        public IRepository<T> Repository<T>() where T : class
        {
            // We actually shouldn't be storing repositories in here.
            // A new repository should be made for each request, otherwise things can get very confused.
            // The Unit Of Work is the bit that should persist.

            // Also, the Activator.CreateInstance stuff is wrong.
            // To be honest, the act of getting a repository has NOTHING to do with the UoW
            // and shouldn't be in here. But whilst it is... let's just do it like this:

            // Also, you should NEVER box stuff like this: return (T) obj;
            // but instead should do: return obj as T;
            // since the former can crash whereas the latter will just return null.

            return new Repository<T>(_context);
        }

        public DbContext GetObjectContext()
        {
            return (DbContext)_context;
        }

        protected override void DisposeCore()
        {
            if (_context != null)
            {
                _context.Dispose();
            }
            base.DisposeCore();
        }
    }
}
