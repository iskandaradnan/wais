using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Data.Entity;
using System.Linq.Expressions;
using System.Data.Entity.Infrastructure;

namespace CP.Framework.Data
{
    public class Repository<T> : Disposable, IRepository<T> where T : class
    {
        private readonly DbContext context;


        public Repository(DbContext context)
        {
            this.context = context;

        }

        public virtual void Add(T entity)
        {


            context.Entry(entity).State = EntityState.Added;
            context.SaveChanges();

        }
        public IQueryable<T> StoredProc(string sprocname, params object[] sparameters)
        {


            if (sparameters != null)
            {
                return context.Database.SqlQuery<T>(sprocname, sparameters).AsQueryable();
            }
            return context.Database.SqlQuery<T>(sprocname).AsQueryable();
        }
        /// <summary>
        /// Calls stored procedure.
        /// </summary>
        /// <param name="sprocname"></param>
        /// <param name="update"></param>
        /// <param name="sparameters"></param>
        public void StoredProc(string sprocname, bool update, params object[] sparameters)
        {

            if (update)
            {
                context.Database.ExecuteSqlCommand(TransactionalBehavior.DoNotEnsureTransaction, sprocname,
                    sparameters);
            }
            else
            {
                context.Database.SqlQuery<T>(sprocname, sparameters);
            }



        }
        public virtual void Delete(T entity)
        {

                context.Entry(entity).State = EntityState.Deleted;
                context.SaveChanges();

        }
        public virtual void DeleteAll(IEnumerable<T> entity)
        {
            foreach (var ent in entity)
            {
                Delete(ent);
            }
        }

        public virtual void AddAll(IEnumerable<T> entity)
        {
            foreach (var ent in entity)
            {
                context.Entry(ent).State = EntityState.Added;
            }
            context.SaveChanges();
        }

        public T RefreshAfterUpdate(T entity)
        {
            var key = 0;
            var prop = typeof(T).GetProperties();
            // we have detached the entity from the context
            ((IObjectContextAdapter)context).ObjectContext.Detach(entity);
            // trying to find out the primary key
            var set = ((IObjectContextAdapter)context).ObjectContext.CreateObjectSet<T>();
            var entityset = set.EntitySet;
            var array = entityset.ElementType.KeyMembers.Select(s => s.Name).ToArray();
            if (array.Length > 0)
            {
                var propinfo = prop.FirstOrDefault(w => w.Name == array[0]);
                var value = int.TryParse(propinfo.GetValue(entity, null).ToString(), out key);
                if (value)
                    return context.Set<T>().Find(key); // refreshing here
                else
                    return entity;
            }
            return entity;
        }

        public virtual void Update(T entity)
        {
            context.Entry(entity).State = EntityState.Modified;
            context.SaveChanges();
        }

        public virtual void Update(T entity, string[] properties)
        {
            foreach(var property in properties)
            {
                context.Entry(entity).Property(property).IsModified = true;
            }
            context.SaveChanges();
        }

        public virtual bool Any()
        {
            return context.Set<T>().AsQueryable<T>().Any();
        }
        public virtual int Count(Expression<Func<T, bool>> predicate)
        {
            return Fetch(predicate).Count();
        }

        public virtual IQueryable<T> GetAll()
        {
            return Fetch();
        }
        public T Single(Expression<Func<T, bool>> where)
        {

            return context.Set<T>().AsQueryable().FirstOrDefault(where);
        }

        public T SingleForUpdate(Expression<Func<T, bool>> where)
        {
            return context.Set<T>().AsQueryable().SingleOrDefault(where);
             }

        private IQueryable<T> Fetch()
        {
            return context.Set<T>().AsQueryable<T>();
        }
        public virtual IQueryable<T> Fetch(Expression<Func<T, bool>> predicate)
        {

            return context.Set<T>().AsQueryable<T>().Where(predicate);
        }
        public virtual IQueryable<T> Fetch(Expression<Func<T, bool>> predicate, Action<Orderable<T>> order)
        {
            var orderable = new Orderable<T>(Fetch(predicate));
            order?.Invoke(orderable);
            return orderable.Queryable;
        }
        public virtual IQueryable<T> Fetch(Expression<Func<T, bool>> predicate, Action<Orderable<T>> order, int skip, int count)
        {
            return Fetch(predicate, order).Skip(skip).Take(count);
        }
        public virtual IQueryable<T> Fetch(int count)
        {
            return Fetch().Take(count);
        }

        protected override void DisposeCore()
        {
            if (this.context != null)
            {
                this.context.Dispose();
            }
            base.DisposeCore();
        }
    }
}