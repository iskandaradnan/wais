using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;

namespace CP.Framework.Data
{
    public interface IRepository<T> where T : class
    {
        void Add(T entity);
        void Delete(T entity);
        void DeleteAll(IEnumerable<T> entity);
        void AddAll(IEnumerable<T> entity);
        void Update(T entity);
        void Update(T entity, string[] properties);
        bool Any();
        int Count(Expression<Func<T, bool>> predicate);

        IQueryable<T> StoredProc(string sproc, params object[] sparms);
        void StoredProc(string sproc, bool update, params object[] sparms);
        IQueryable<T> GetAll();
        T Single(Expression<Func<T, bool>> where);
        T SingleForUpdate(Expression<Func<T, bool>> where);
        T RefreshAfterUpdate(T entity);
        IQueryable<T> Fetch(Expression<Func<T, bool>> predicate);
        IQueryable<T> Fetch(Expression<Func<T, bool>> predicate, Action<Orderable<T>> order);
        IQueryable<T> Fetch(Expression<Func<T, bool>> predicate, Action<Orderable<T>> order, int skip, int count);
        IQueryable<T> Fetch(int count);
    }

}