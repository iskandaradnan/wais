using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Transactions;
using TransactionException = CP.Framework.Common.ExceptionHandler.ExceptionWrappers.TransactionException;
using CP.Framework.Common.Logging;
using System.Linq.Dynamic;
using System.Data.Entity.Core;

namespace CP.Framework.Common.TransactionManagement
{
    public class TransactionHelper
    {
        #region "Public variable declaration"

        Log4NetLogger log = new Log4NetLogger();
        int TransactionTimeout = 0;
        #endregion
        readonly IList<DbContext> _dbContext = new List<DbContext>();

        public TransactionHelper()
        {
        }
        public TransactionHelper(DbContext DBContext1)
        {
            TransactionTimeout = 20;
            _dbContext.Add(DBContext1);
        }
        public TransactionHelper(DbContext DBContext1, DbContext DBContext2)
        {
            _dbContext.Add(DBContext1);
            _dbContext.Add(DBContext2);
        }
        public TransactionHelper(DbContext DBContext1, DbContext DBContext2, DbContext DBContext3)
        {
            _dbContext.Add(DBContext1);
            _dbContext.Add(DBContext2);
            _dbContext.Add(DBContext3);
        }
        public bool Update<T>(T entity) where T : class
        {
            //try // Exception Capturing @ outer layer
            //{ 
            var transactionOption = new TransactionOptions
                {
                    Timeout = new TimeSpan(0, TransactionTimeout, 0),
                    IsolationLevel = System.Transactions.IsolationLevel.ReadCommitted,
                };
                using (TransactionScope scope = new TransactionScope(TransactionScopeOption.Required, transactionOption))
                {
                    foreach (var dbContext in _dbContext)
                    {
                        using (dbContext)
                        {
                            var dbSet = dbContext.Set<T>();
                            if (dbSet != null)
                            {

                                var dbContextInstance = ((IObjectContextAdapter)dbContext).ObjectContext;
                                var currentObjectSet = dbContextInstance.GetEntitySet(entity);
                                var entityType = currentObjectSet.ElementType;
                                var keyName = entityType.KeyMembers.First().ToString();
                                dbContext.Entry(entity).State = Convert.ToInt32(entity.GetType().GetProperty(keyName).GetValue(entity)) > 0 ? EntityState.Modified : EntityState.Added;

                                if (dbContext.Entry(entity).State == EntityState.Modified)
                                    CheckRowversionAndThrowConcurrencyException(dbContext, entity, log);

                                if (entityType.NavigationProperties.Count > 0)
                                {
                                    foreach (var navigationProperty in entityType.NavigationProperties)
                                    {
                                        var navigationList = (IEnumerable<object>)entity.GetType().GetProperty(navigationProperty.Name).GetValue(entity);
                                        if (navigationList != null)
                                        {
                                            foreach (var child in navigationList)
                                            {
                                                var childObjectSet = dbContextInstance.GetEntitySet(child);
                                                var childKeyName = childObjectSet.ElementType.KeyMembers.Select(k => k.Name).First().ToString();
                                                dbContext.Entry(child).State = Convert.ToInt32(child.GetType().GetProperty(childKeyName).GetValue(child)) > 0 ? EntityState.Modified : EntityState.Added;
                                            }
                                        }

                                    }
                                }

                            }
                            dbContext.SaveChanges();
                        }

                    }
                    scope.Complete();
                }
            //} // Exception Capturing @ outer layer
            //catch (InvalidOperationException ex)
            //{

            //}
            //catch (Exception ex)
            //{

            //}
            return true;
        }

        public bool UpdateRelated<T>(IEnumerable<T> relatedentities) where T : class
        {
            //try // Exception Capturing @ outer layer
            //{
            var transactionOption = new TransactionOptions
                {
                    Timeout = new TimeSpan(0, TransactionTimeout, 0),
                    IsolationLevel = System.Transactions.IsolationLevel.ReadCommitted,
                };

                using (TransactionScope scope = new TransactionScope(TransactionScopeOption.Required, transactionOption))
                {
                    foreach (var dbContext in _dbContext)
                    {
                        foreach (var entity in relatedentities)
                        {
                            if (dbContext != null && entity != null)
                            {
                                var dbSet = dbContext.Set<T>();
                                if (dbSet != null)
                                {
                                    var dbContextInstance = ((IObjectContextAdapter)dbContext).ObjectContext;
                                    var currentObjectSet = dbContextInstance.GetEntitySet(entity);
                                    var entityType = currentObjectSet.ElementType;
                                    var keyName = currentObjectSet.ElementType.KeyMembers.First().ToString();
                                    dbContext.Entry(entity).State = Convert.ToInt32(entity.GetType().GetProperty(keyName).GetValue(entity)) > 0 ? EntityState.Modified : EntityState.Added;

                                    if (dbContext.Entry(entity).State == EntityState.Modified)
                                        CheckRowversionAndThrowConcurrencyException(dbContext, entity, log);

                                    if (entityType.NavigationProperties.Count > 0)
                                    {
                                        foreach (var navigationProperty in entityType.NavigationProperties)
                                        {
                                            var objEnumerable = ((object)entity.GetType().GetProperty(navigationProperty.Name).GetValue(entity)) as System.Collections.IEnumerable;
                                            if (objEnumerable != null)
                                            {
                                                var navigationList = (IEnumerable<object>)entity.GetType().GetProperty(navigationProperty.Name).GetValue(entity);
                                                if (navigationList != null)
                                                {
                                                    foreach (var child in navigationList)
                                                    {
                                                        var childObjectSet = dbContextInstance.GetEntitySet(child);
                                                        var childKeyName = childObjectSet.ElementType.KeyMembers.Select(k => k.Name).First().ToString();
                                                        dbContext.Entry(child).State = Convert.ToInt32(child.GetType().GetProperty(childKeyName).GetValue(child)) > 0 ? EntityState.Modified : EntityState.Added;
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        dbContext.SaveChanges();
                    }
                    scope.Complete();
                }


            //} // Exception Capturing @ outer layer
            //catch (Exception e)
            //{

            //    throw;
            //}
            return true;
        }

        public IEnumerable<T> UpdateAndGetRelatedEntities<T>(IEnumerable<T> relatedentities) where T : class
        {
            var transactionOption = new TransactionOptions
            {
                Timeout = new TimeSpan(0, TransactionTimeout, 0),
                IsolationLevel = System.Transactions.IsolationLevel.ReadCommitted,
            };

            using (TransactionScope scope = new TransactionScope(TransactionScopeOption.Required, transactionOption))
            {
                dynamic entityAudit1 = null;
                foreach (var dbContext in _dbContext)
                {
                    foreach (var entity in relatedentities)
                    {

                        if (dbContext != null && entity != null)
                        {
                            var dbSet = dbContext.Set<T>();
                            if (dbSet != null)
                            {
                                var dbContextInstance = ((IObjectContextAdapter)dbContext).ObjectContext;
                                var currentObjectSet = dbContextInstance.GetEntitySet(entity);
                                var entityType = currentObjectSet.ElementType;
                                var keyName = currentObjectSet.ElementType.KeyMembers.First().ToString();
                                dbContext.Entry(entity).State = Convert.ToInt32(entity.GetType().GetProperty(keyName).GetValue(entity)) > 0 ? EntityState.Modified : EntityState.Added;

                                if (dbContext.Entry(entity).State == EntityState.Modified)
                                    CheckRowversionAndThrowConcurrencyException(dbContext, entity, log);
                                var entityType1 = entity.GetType().Name;
                                if (entityType1 == "EntityAudit")
                                {
                                    entityAudit1 = entity;
                                }
                                if (entityType.NavigationProperties.Count > 0)
                                {
                                    foreach (var navigationProperty in entityType.NavigationProperties)
                                    {
                                        var objEnumerable = ((object)entity.GetType().GetProperty(navigationProperty.Name).GetValue(entity)) as System.Collections.IEnumerable;
                                        if (objEnumerable != null)
                                        {
                                            var navigationList = (IEnumerable<object>)entity.GetType().GetProperty(navigationProperty.Name).GetValue(entity);
                                            if (navigationList != null)
                                            {
                                                foreach (var child in navigationList)
                                                {
                                                    var childObjectSet = dbContextInstance.GetEntitySet(child);
                                                    var childKeyName = childObjectSet.ElementType.KeyMembers.Select(k => k.Name).First().ToString();
                                                    dbContext.Entry(child).State = Convert.ToInt32(child.GetType().GetProperty(childKeyName).GetValue(child)) > 0 ? EntityState.Modified : EntityState.Added;
                                                }
                                            }
                                        }

                                    }
                                }
                            }
                        }
                        //dbContext.SaveChanges();
                        //if (entityAudit1 != null)
                        //{
                        //    relatedentities = relatedentities.Where(x => x != entityAudit1);
                        //}
                        //relatedentities = relatedentities.Where(x => !x.GetType().Name.Contains("EntityAudit"));
                    }
                    dbContext.SaveChanges();
                    relatedentities = relatedentities.Where(x => !x.GetType().Name.Contains("EntityAudit"));
                }
                scope.Complete();
            }
            return relatedentities;
        }

        public bool Add<T>(T entity) where T : class
        {
            var transactionOption = new TransactionOptions
            {
                Timeout = new TimeSpan(0, TransactionTimeout, 0),
                IsolationLevel = System.Transactions.IsolationLevel.ReadCommitted,
            };
            using (TransactionScope scope = new TransactionScope(TransactionScopeOption.Required, transactionOption))
            {
                foreach (var dbContext in _dbContext)
                {
                    using (dbContext)
                    {
                        if (dbContext != null && entity != null)
                        {
                            var dbSet = dbContext.Set<T>();
                            if (dbSet != null)
                            {
                                dbContext.Entry(entity).State = EntityState.Added;
                            }
                        }
                        dbContext.SaveChanges();
                    }
                }
                scope.Complete();
            }
            return true;
        }

        public T AddAndGetEntity<T>(T entity) where T : class
        {
            var transactionOption = new TransactionOptions
            {
                Timeout = new TimeSpan(0, TransactionTimeout, 0),
                IsolationLevel = System.Transactions.IsolationLevel.ReadCommitted,
            };
            using (TransactionScope scope = new TransactionScope(TransactionScopeOption.Required, transactionOption))
            {
                foreach (var dbContext in _dbContext)
                {
                    using (dbContext)
                    {
                        if (dbContext != null && entity != null)
                        {
                            var dbSet = dbContext.Set<T>();
                            if (dbSet != null)
                            {
                                dbContext.Entry(entity).State = EntityState.Added;
                            }
                        }
                        dbContext.SaveChanges();
                    }
                }
                scope.Complete();
            }

            return entity;
        }

        public bool AddRelated<T>(IEnumerable<T> relatedentities) where T : class
        {
            //try // Exception Capturing @ outer layer
            //{
            var transactionOption = new TransactionOptions
                {
                    Timeout = new TimeSpan(0, TransactionTimeout, 0),
                    IsolationLevel = System.Transactions.IsolationLevel.ReadCommitted,
                };

                using (TransactionScope scope = new TransactionScope(TransactionScopeOption.Required, transactionOption))
                {

                    foreach (var dbContext in _dbContext)
                    {
                        foreach (var entity in relatedentities)
                        {
                            if (dbContext != null && entity != null)
                            {
                                var dbSet = dbContext.Set(entity.GetType());
                                try
                                {
                                    var exist = dbSet.Local;
                                    dbContext.Entry(entity).State = EntityState.Added;
                                }
                                catch (TransactionException)
                                {
                                    log.LogMessage("Entity and DBcontext mismatch", Level.Info);
                                }
                            }
                        }
                        try
                        {
                            dbContext.SaveChanges();
                        }
                        catch (TransactionException dbEx)
                        {
                            log.LogMessage("An error has occured because of exception", Level.Info);
                            throw new TransactionException(dbEx);
                        }
                    }
                    scope.Complete();
                }
                return true;
            //} // Exception Capturing @ outer layer
            //catch (Exception e)
            //{

            //    throw;
            //}
        }

        public IEnumerable<T> AddAndGetRelatedEntities<T>(IEnumerable<T> relatedentities) where T : class
        {
            var transactionOption = new TransactionOptions
            {
                Timeout = new TimeSpan(0, TransactionTimeout, 0),
                IsolationLevel = System.Transactions.IsolationLevel.ReadCommitted,
            };

            dynamic entityAudit = null;

            using (TransactionScope scope = new TransactionScope(TransactionScopeOption.Required, transactionOption))
            {
                foreach (var dbContext in _dbContext)
                {
                    foreach (var entity in relatedentities)
                    {
                        if (dbContext != null && entity != null)
                        {
                            var dbSet = dbContext.Set(entity.GetType());
                            try
                            {
                                var exist = dbSet.Local;
                                dbContext.Entry(entity).State = EntityState.Added;
                                var entityType = entity.GetType().Name;
                                if (entityType == "EntityAudit")
                                {
                                    entityAudit = entity;
                                }
                            }
                            catch (TransactionException ex)
                            {
                                log.LogMessage("Entity and DBcontext mismatch", Level.Info);
                            }
                        }
                    }
                    try
                    {
                        dbContext.SaveChanges();

                        relatedentities = relatedentities.Where(x => !x.GetType().Name.Contains("EntityAudit"));
                    }
                    catch (TransactionException dbEx)
                    {
                        log.LogMessage("An error has occured because of exception", Level.Info);
                        throw new TransactionException(dbEx);
                    }
                    catch (Exception rt)
                    {
                        throw new TransactionException(rt);
                    }
                }
                scope.Complete();
            }
            return relatedentities;
        }



        public bool AddBulk<T>(IEnumerable<T> bulkentities) where T : class
        {
            var transactionOption = new TransactionOptions
            {
                Timeout = new TimeSpan(0, TransactionTimeout, 0),
                IsolationLevel = System.Transactions.IsolationLevel.ReadCommitted,
            };
            using (TransactionScope scope = new TransactionScope(TransactionScopeOption.Required, transactionOption))
            {
                foreach (var dbContext in _dbContext)
                {
                    foreach (var entity in bulkentities)
                    {

                        using (dbContext)
                        {
                            if (dbContext != null && entity != null)
                            {
                                var dbSet = dbContext.Set<T>();
                                if (dbSet != null)
                                {
                                    dbContext.Entry(entity).State = EntityState.Added;
                                }
                            }
                            dbContext.SaveChanges();
                        }
                    }
                }
                scope.Complete();
            }
            return true;
        }

        /// <summary>
        /// Used for hard delete only
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="entity"></param>
        /// <returns></returns>
        public bool Delete<T>(T entity) where T : class
        {
            //try // Exception Capturing @ outer layer
            //{
            var transactionOption = new TransactionOptions
                {
                    Timeout = new TimeSpan(0, TransactionTimeout, 0),
                    IsolationLevel = System.Transactions.IsolationLevel.ReadCommitted,
                };

                using (TransactionScope scope = new TransactionScope(TransactionScopeOption.Required, transactionOption))
                {
                    foreach (var dbContext in _dbContext)
                    {
                        using (dbContext)
                        {
                            if (dbContext != null && entity != null)
                            {
                                var dbSet = dbContext.Set<T>();
                                if (dbSet != null)
                                {
                                    dbContext.Entry(entity).State = EntityState.Modified;
                                }
                            }
                            dbContext.SaveChanges();
                        }

                    }
                    scope.Complete();

                }
                return true;
            //}
            //catch (Exception e)
            //{

            //    throw;
            //}
        }

        /// <summary>
        /// Used for hard delete only
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="entity"></param>
        /// <returns></returns>
        public bool HardDelete<T>(T entity) where T : class
        {
            var transactionOption = new TransactionOptions
            {
                Timeout = new TimeSpan(0, TransactionTimeout, 0),
                IsolationLevel = System.Transactions.IsolationLevel.ReadCommitted,
            };

            using (TransactionScope scope = new TransactionScope(TransactionScopeOption.Required, transactionOption))
            {
                foreach (var dbContext in _dbContext)
                {
                    using (dbContext)
                    {
                        if (dbContext != null && entity != null)
                        {
                            var dbSet = dbContext.Set<T>();
                            if (dbSet != null)
                            {
                                dbSet.Remove(entity);
                            }
                        }
                        dbContext.SaveChanges();
                    }

                }
                scope.Complete();
            }
            return true;
        }

        public bool DeleteRelated<T>(IEnumerable<T> relatedentities) where T : class
        {
            var transactionOption = new TransactionOptions
            {
                Timeout = new TimeSpan(0, TransactionTimeout, 0),
                IsolationLevel = System.Transactions.IsolationLevel.ReadCommitted,
            };
            using (TransactionScope scope = new TransactionScope(TransactionScopeOption.Required, transactionOption))
            {
                foreach (var dbContext in _dbContext)
                {
                    foreach (var entity in relatedentities)
                    {
                        if (dbContext != null && entity != null)
                        {
                            var dbSet = dbContext.Set<T>();
                            if (dbSet != null)
                            {
                                dbContext.Entry(entity).State = EntityState.Deleted;
                            }
                        }
                    }
                    dbContext.SaveChanges();
                }
                scope.Complete();
            }
            return true;
        }


        public T Get<T>(int Id, string relatedTable1 = null, string relatedTable2 = null, string relatedTable3 = null, string relatedTable4 = null, string relatedTable5 = null, string relatedTable1IsDeleted = null) where T : class
        {
          
            foreach (var dbContext in _dbContext)
            {
                using (dbContext)
                {
                    if (dbContext != null)
                    {
                        dbContext.Configuration.ProxyCreationEnabled = false;
                        var dbSet = dbContext.Set<T>();
                        if (dbSet != null)
                        {

                            var objectContext = ((IObjectContextAdapter)dbContext).ObjectContext;
                            var set = objectContext.CreateObjectSet<T>();
                            var keyName = set.EntitySet.ElementType.KeyMembers.First().ToString();


                            var condition = keyName + "=" + Id;
                            //if(!string.IsNullOrEmpty(relatedTable1IsDeleted))
                            // {
                            //     condition = condition + " and " + relatedTable1 + ".IsDeleted =" + relatedTable1IsDeleted;
                            // }
                            if (relatedTable5 != null)
                            {
                                return dbSet.Where(condition)
                                 .Include(relatedTable1)
                                 .Include(relatedTable2)
                                  .Include(relatedTable3)
                                   .Include(relatedTable4)
                                    .Include(relatedTable5).FirstOrDefault();
                            }
                            else if (relatedTable4 != null)
                            {
                                return dbSet.Where(condition)
                                 .Include(relatedTable1)
                                 .Include(relatedTable2)
                                  .Include(relatedTable3)
                                   .Include(relatedTable4).FirstOrDefault();
                            }
                            else if (relatedTable3 != null)
                            {
                                return dbSet.Where(condition)
                                 .Include(relatedTable1)
                                  .Include(relatedTable2)
                                   .Include(relatedTable3).FirstOrDefault();
                            }
                            else if (relatedTable2 != null)
                            {
                                return dbSet.Where(condition)
                                 .Include(relatedTable1)
                                  .Include(relatedTable2).FirstOrDefault();
                            }
                            else if (relatedTable1 != null)
                            {
                                return dbSet.Where(condition).Include(relatedTable1).FirstOrDefault();
                            }
                            return dbSet.Where(condition).FirstOrDefault();
                        }
                    }

                }
            }
            return null;
        }

        public T GetRecords<T>(int Id, List<string> relatedTables, System.Data.IsolationLevel isolationLevel) where T : class
        {
            foreach (var dbContext in _dbContext)
            {
                using (dbContext)
                {
                    if (dbContext != null)
                    {
                        using (var dbTransaction = dbContext.Database.BeginTransaction(isolationLevel))
                        {
                            dbContext.Configuration.ProxyCreationEnabled = false;
                            var dbSet = dbContext.Set<T>();

                            if (dbSet != null)
                            {
                                var objectContext = ((IObjectContextAdapter)dbContext).ObjectContext;
                                var set = objectContext.CreateObjectSet<T>();
                                var keyName = set.EntitySet.ElementType.KeyMembers.First().ToString();

                                var condition = keyName + "=" + Id;
                                var query = dbSet.AsQueryable();
                                foreach (string include in relatedTables)
                                {
                                    query = query.Include(include);
                                }

                                return query
                                    .AsNoTracking()
                                    .Where(condition)
                                    .FirstOrDefault();
                            }
                        }

                    }
                }
            }
            return null;
        }


        public static T GetAll<T>(DbContext dbContext, int Id, List<string> relatedTables) where T : class
        {
            //foreach (var dbContext in _dbContext)
            {
                // using (dbContext)
                {
                    if (dbContext != null)
                    {
                        dbContext.Configuration.ProxyCreationEnabled = false;
                        var dbSet = dbContext.Set<T>();

                        if (dbSet != null)
                        {
                            var objectContext = ((IObjectContextAdapter)dbContext).ObjectContext;
                            var set = objectContext.CreateObjectSet<T>();
                            var keyName = set.EntitySet.ElementType.KeyMembers.First().ToString();

                            var condition = keyName + "=" + Id;
                            var query = dbSet.AsQueryable();
                            if (relatedTables != null)
                            {
                                foreach (string include in relatedTables)
                                {
                                    query = query.Include(include);
                                }
                            }
                            return query
                                .AsNoTracking()
                                .Where(condition)
                                .FirstOrDefault();
                        }
                    }
                }
            }
            return null;
        }

        public T Get<T>(int Id, List<string> relatedTables) where T : class
        {
            foreach (var dbContext in _dbContext)
            {
                using (dbContext)
                {
                    if (dbContext != null)
                    {
                        dbContext.Configuration.ProxyCreationEnabled = false;
                        var dbSet = dbContext.Set<T>();

                        if (dbSet != null)
                        {
                            var objectContext = ((IObjectContextAdapter)dbContext).ObjectContext;
                            var set = objectContext.CreateObjectSet<T>();
                            var keyName = set.EntitySet.ElementType.KeyMembers.First().ToString();

                            var condition = keyName + "=" + Id;
                            var query = dbSet.AsQueryable();
                            foreach (string include in relatedTables)
                            {
                                query = query.Include(include);
                            }

                            return query
                                .AsNoTracking()
                                .Where(condition)
                                .FirstOrDefault();
                        }
                    }
                }
            }
            return null;
        }

        public IEnumerable<T> GetEntitySet<T>(int skip, int take, string orderField, string sortOrder, out int totalCount, string relatedTable1 = null, string relatedTable2 = null, string condition = null, string relatedTable3 = null, string relatedTable4 = null, string relatedTable5 = null, string relatedTable6 = null) where T : class
        {
            totalCount = 0;
            //try
            //{
                foreach (var dbContext in _dbContext)
                {
                    using (dbContext)
                    {
                        if (dbContext != null)
                        {
                            dbContext.Configuration.ProxyCreationEnabled = false;
                            var dbSet = dbContext.Set<T>();
                            if (dbSet != null)
                            {
                                var objectContext = ((IObjectContextAdapter)dbContext).ObjectContext;
                                var set = objectContext.CreateObjectSet<T>();
                                var deleteKey = set.EntitySet.ElementType.Members.Contains("IsDeleted");
                                condition = concatIsDeletedFlag(deleteKey, condition);
                                IQueryable<T> result;
                                if (relatedTable6 != null)
                                {

                                    if (!string.IsNullOrEmpty(condition))
                                    {
                                        if (sortOrder == "ASC")
                                        {
                                            result = dbSet
                                             .Include(relatedTable1)
                                              .Include(relatedTable2)
                                               .Include(relatedTable3)
                                               .Include(relatedTable4)
                                               .Include(relatedTable5)
                                               .Include(relatedTable6)
                                              .Where(condition)
                                                .OrderBy(orderField)
                                              .Skip(skip)
                                              .Take(take);
                                        }
                                        else
                                        {
                                            result = dbSet
                                            .Include(relatedTable1)
                                             .Include(relatedTable2)
                                               .Include(relatedTable3)
                                               .Include(relatedTable4)
                                               .Include(relatedTable5)
                                               .Include(relatedTable6)
                                             .Where(condition)
                                               .OrderByDescending(x => orderField)
                                             .Skip(skip)
                                             .Take(take);
                                        }
                                    }
                                    else
                                    {
                                        if (sortOrder == "ASC")
                                        {
                                            result = dbSet
                                         .Include(relatedTable1)
                                          .Include(relatedTable2)
                                            .Include(relatedTable3)
                                            .Include(relatedTable4)
                                             .Include(relatedTable5)
                                             .Include(relatedTable6)
                                        .OrderBy(orderField)
                                          .Skip(skip)
                                          .Take(take);
                                        }
                                        else
                                        {
                                            result = dbSet
                                            .Include(relatedTable1)
                                             .Include(relatedTable2)
                                               .Include(relatedTable3)
                                               .Include(relatedTable4)
                                                .Include(relatedTable5)
                                                .Include(relatedTable6)
                                               .OrderByDescending(x => orderField)
                                             .Skip(skip)
                                             .Take(take);
                                        }
                                    }

                                }
                                else if (relatedTable5 != null)
                                {

                                    if (!string.IsNullOrEmpty(condition))
                                    {
                                        if (sortOrder == "ASC")
                                        {
                                            result = dbSet
                                             .Include(relatedTable1)
                                              .Include(relatedTable2)
                                               .Include(relatedTable3)
                                               .Include(relatedTable4)
                                               .Include(relatedTable5)
                                              .Where(condition)
                                                .OrderBy(orderField)
                                              .Skip(skip)
                                              .Take(take);
                                        }
                                        else
                                        {
                                            result = dbSet
                                            .Include(relatedTable1)
                                             .Include(relatedTable2)
                                               .Include(relatedTable3)
                                               .Include(relatedTable4)
                                               .Include(relatedTable5)
                                             .Where(condition)
                                               .OrderByDescending(x => orderField)
                                             .Skip(skip)
                                             .Take(take);
                                        }
                                    }
                                    else
                                    {
                                        if (sortOrder == "ASC")
                                        {
                                            result = dbSet
                                         .Include(relatedTable1)
                                          .Include(relatedTable2)
                                            .Include(relatedTable3)
                                            .Include(relatedTable4)
                                             .Include(relatedTable5)
                                        .OrderBy(orderField)
                                          .Skip(skip)
                                          .Take(take);
                                        }
                                        else
                                        {
                                            result = dbSet
                                            .Include(relatedTable1)
                                             .Include(relatedTable2)
                                               .Include(relatedTable3)
                                               .Include(relatedTable4)
                                                .Include(relatedTable5)
                                               .OrderByDescending(x => orderField)
                                             .Skip(skip)
                                             .Take(take);
                                        }
                                    }

                                }
                                else if (relatedTable4 != null)
                                {

                                    if (!string.IsNullOrEmpty(condition))
                                    {
                                        if (sortOrder == "ASC")
                                        {
                                            result = dbSet
                                             .Include(relatedTable1)
                                              .Include(relatedTable2)
                                               .Include(relatedTable3)
                                               .Include(relatedTable4)
                                              .Where(condition)
                                                .OrderBy(orderField)
                                              .Skip(skip)
                                              .Take(take);
                                        }
                                        else
                                        {
                                            result = dbSet
                                            .Include(relatedTable1)
                                             .Include(relatedTable2)
                                               .Include(relatedTable3)
                                               .Include(relatedTable4)
                                             .Where(condition)
                                               .OrderByDescending(x => orderField)
                                             .Skip(skip)
                                             .Take(take);
                                        }
                                    }
                                    else
                                    {
                                        if (sortOrder == "ASC")
                                        {
                                            result = dbSet
                                         .Include(relatedTable1)
                                          .Include(relatedTable2)
                                            .Include(relatedTable3)
                                            .Include(relatedTable4)
                                        .OrderBy(orderField)
                                          .Skip(skip)
                                          .Take(take);
                                        }
                                        else
                                        {
                                            result = dbSet
                                            .Include(relatedTable1)
                                             .Include(relatedTable2)
                                               .Include(relatedTable3)
                                               .Include(relatedTable4)
                                               .OrderByDescending(x => orderField)
                                             .Skip(skip)
                                             .Take(take);
                                        }
                                    }

                                }
                                else if (relatedTable3 != null)
                                {

                                    if (!string.IsNullOrEmpty(condition))
                                    {
                                        if (sortOrder == "ASC")
                                        {
                                            result = dbSet
                                             .Include(relatedTable1)
                                              .Include(relatedTable2)
                                               .Include(relatedTable3)
                                              .Where(condition)
                                                .OrderBy(orderField)
                                              .Skip(skip)
                                              .Take(take);
                                        }
                                        else
                                        {
                                            result = dbSet
                                            .Include(relatedTable1)
                                             .Include(relatedTable2)
                                               .Include(relatedTable3)
                                             .Where(condition)
                                               .OrderByDescending(x => orderField)
                                             .Skip(skip)
                                             .Take(take);
                                        }
                                    }
                                    else
                                    {
                                        if (sortOrder == "ASC")
                                        {
                                            result = dbSet
                                         .Include(relatedTable1)
                                          .Include(relatedTable2)
                                            .Include(relatedTable3)
                                        .OrderBy(orderField)
                                          .Skip(skip)
                                          .Take(take);
                                        }
                                        else
                                        {
                                            result = dbSet
                                            .Include(relatedTable1)
                                             .Include(relatedTable2)
                                               .Include(relatedTable3)
                                               .OrderByDescending(x => orderField)
                                             .Skip(skip)
                                             .Take(take);
                                        }
                                    }

                                }
                                else if (relatedTable2 != null)
                                {
                                    if (!string.IsNullOrEmpty(condition))
                                    {
                                        if (sortOrder == "ASC")
                                        {
                                            result = dbSet
                                             .Include(relatedTable1)
                                              .Include(relatedTable2)
                                              .Where(condition)
                                                .OrderBy(orderField)
                                              .Skip(skip)
                                              .Take(take);
                                        }
                                        else
                                        {
                                            result = dbSet
                                            .Include(relatedTable1)
                                             .Include(relatedTable2)
                                             .Where(condition)
                                               .OrderByDescending(x => orderField)
                                             .Skip(skip)
                                             .Take(take);
                                        }
                                    }
                                    else
                                    {
                                        if (sortOrder == "ASC")
                                        {
                                            result = dbSet
                                         .Include(relatedTable1)
                                          .Include(relatedTable2)
                                        .OrderBy(orderField)
                                          .Skip(skip)
                                          .Take(take);
                                        }
                                        else
                                        {
                                            result = dbSet
                                            .Include(relatedTable1)
                                             .Include(relatedTable2)
                                               .OrderByDescending(x => orderField)
                                             .Skip(skip)
                                             .Take(take);
                                        }
                                    }

                                }
                                else if (relatedTable1 != null)
                                {

                                    if (!string.IsNullOrEmpty(condition))
                                    {
                                        if (sortOrder == "ASC")
                                        {

                                            result = dbSet
                                         .Include(relatedTable1)
                                          .Where(condition)
                                          .OrderBy(orderField)
                                         .Skip(skip)
                                         .Take(take);
                                        }
                                        else
                                        {
                                            result = dbSet
                                       .Include(relatedTable1)
                                        .Where(condition)
                                          .OrderByDescending(x => orderField)
                                       .Skip(skip)
                                       .Take(take);
                                        }

                                    }
                                    else
                                    {
                                        if (sortOrder == "ASC")
                                        {

                                            result = dbSet
                                         .Include(relatedTable1)

                                          .OrderBy(orderField)
                                         .Skip(skip)
                                         .Take(take);
                                        }
                                        else
                                        {
                                            result = dbSet
                                       .Include(relatedTable1)

                                          .OrderByDescending(x => orderField)
                                       .Skip(skip)
                                       .Take(take);
                                        }
                                    }

                                }



                                else if (!string.IsNullOrEmpty(condition))
                                {

                                    if (sortOrder == "ASC")
                                    {
                                        result = dbSet
                                    .Where(condition)
                                    .OrderBy(orderField)
                                    .Skip(skip)
                                          .Take(take);
                                    }
                                    else
                                    {
                                        result = dbSet
                                   .Where(condition)
                                    .OrderByDescending(x => orderField)
                                   .Skip(skip)
                                         .Take(take);
                                    }
                                }

                                else
                                {
                                    result = dbSet.OrderBy(orderField)
                                                .Skip(skip)
                                                .Take(take);
                                }

                                totalCount = dbSet.Where("IsDeleted = false").Count();

                                return result.ToList<T>();
                            }
                        }
                    }
                }
            //}
            //catch (TransactionException ex)
            //{
            //    log.LogMessage("An error has occured because of exception", Level.Info);
            //}
            //catch (Exception ex)
            //{
            //    log.LogMessage("An error has occured because of exception", Level.Info);
            //}
            //finally
            //{

            //}
            return null;
        }

        public IEnumerable<T> GetSearchResultByQuery<T>(IQueryable<T> dynamicQuery, int skip, int take, string orderField, string sortOrder, out int totalCount) where T : class
        {
            totalCount = 0;
            //try
            //{
                foreach (var dbContext in _dbContext)
                {
                    using (dbContext)
                    {
                        if (dbContext != null)
                        {
                            dbContext.Configuration.ProxyCreationEnabled = false;

                            IQueryable<T> result;
                            if (sortOrder == "ASC")
                            {
                                result = dynamicQuery
                             .OrderBy(orderField)
                            .Skip(skip)
                                  .Take(take);
                            }
                            else
                            {
                                result = dynamicQuery
                             .OrderByDescending(x => orderField)
                           .Skip(skip)
                                 .Take(take);
                            }
                            return result.ToList();
                        }
                    }
                }
            //}
            //catch (TransactionException)
            //{
            //    log.LogMessage("An error has occured because of exception", Level.Info);
            //}
            //catch (Exception ex)
            //{
            //    log.LogMessage("An error has occured because of exception", Level.Info);
            //}
            //finally
            //{

            //}
            return null;

        }

        public IEnumerable<T> GetEntitySet<T>(T entity = null, string relatedTable1 = null, string relatedTable2 = null) where T : class
        {
            //try
            //{
                foreach (var dbContext in _dbContext)
                {
                    using (dbContext)
                    {
                        if (dbContext != null)
                        {



                            DbSet<T> dbSet = dbContext.Set<T>();
                            if (dbSet != null)
                            {
                                if (relatedTable2 != null)
                                {
                                    return dbSet
                                     .Include(relatedTable1)
                                      .Include(relatedTable2)
                                     .ToList<T>();
                                }
                                else if (relatedTable1 != null)
                                {
                                    return dbSet
                                     .Include(relatedTable1)
                                     .ToList<T>();
                                }


                                return dbSet
                                 .ToList<T>();
                            }
                        }

                    }
                }
            //}
            //catch (TransactionException)
            //{
            //    log.LogMessage("An error has occured because of exception", Level.Info);
            //}
            //catch (Exception ex)
            //{
            //    log.LogMessage("An error has occured because of exception", Level.Info);
            //}
            //finally
            //{

            //}
            return null;
        }

        public IEnumerable<T> GetEntitySetByCondition<T>(string condition, string relatedTable1 = null, string relatedTable2 = null) where T : class
        {
            //try
            //{
                foreach (var dbContext in _dbContext)
                {
                    using (dbContext)
                    {
                        if (dbContext != null)
                        {
                            dbContext.Configuration.ProxyCreationEnabled = false;
                            var dbSet = dbContext.Set<T>();
                            if (dbSet != null)
                            {

                                if (!string.IsNullOrEmpty(condition))
                                {
                                    if (relatedTable2 != null)
                                    {
                                        return dbSet
                                         .Include(relatedTable1)
                                          .Include(relatedTable2)
                                          .Where(condition)
                                         .ToList<T>();
                                    }
                                    else if (relatedTable1 != null)
                                    {
                                        return dbSet
                                         .Include(relatedTable1)
                                          .Where(condition)
                                         .ToList<T>();
                                    }
                                    return dbSet
                                      .Where(condition)
                                     .ToList<T>();
                                }

                                else
                                {

                                    if (relatedTable2 != null)
                                    {
                                        return dbSet
                                         .Include(relatedTable1)
                                          .Include(relatedTable2)
                                         .ToList<T>();
                                    }
                                    else if (relatedTable1 != null)
                                    {
                                        return dbSet
                                         .Include(relatedTable1)
                                         .ToList<T>();
                                    }
                                    return dbSet
                                     .ToList<T>();

                                }
                            }

                        }
                    }
                }
            //}

            //catch (TransactionException)
            //{
            //    log.LogMessage("An error has occured because of exception", Level.Info);
            //}
            //catch (Exception ex)
            //{
            //    log.LogMessage("An error has occured because of exception", Level.Info);
            //}
            //finally
            //{

            //}
            return null;
        }

        public IEnumerable<T> GetEntitySetByConditionWithIsolationLevel<T>(string condition, string relatedTable1 = null, string relatedTable2 = null, System.Data.IsolationLevel isolationLevel = System.Data.IsolationLevel.ReadCommitted) where T : class
        {
            //try
            //{
                foreach (var dbContext in _dbContext)
                {
                    using (dbContext)
                    {
                        if (dbContext != null)
                        {
                            using (var transaction = dbContext.Database.BeginTransaction(isolationLevel))
                            {
                                dbContext.Configuration.ProxyCreationEnabled = false;
                                var dbSet = dbContext.Set<T>();
                                if (dbSet != null)
                                {
                                    if (!string.IsNullOrEmpty(condition))
                                    {
                                        if (relatedTable2 != null)
                                        {
                                            return dbSet
                                             .Include(relatedTable1)
                                              .Include(relatedTable2)
                                              .Where(condition)
                                             .ToList<T>();
                                        }
                                        else if (relatedTable1 != null)
                                        {
                                            return dbSet
                                             .Include(relatedTable1)
                                              .Where(condition)
                                             .ToList<T>();
                                        }
                                        return dbSet
                                          .Where(condition)
                                         .ToList<T>();
                                    }

                                    else
                                    {

                                        if (relatedTable2 != null)
                                        {
                                            return dbSet
                                             .Include(relatedTable1)
                                              .Include(relatedTable2)
                                             .ToList<T>();
                                        }
                                        else if (relatedTable1 != null)
                                        {
                                            return dbSet
                                             .Include(relatedTable1)
                                             .ToList<T>();
                                        }
                                        return dbSet
                                         .ToList<T>();

                                    }
                                }
                            }
                        }
                    }
                }
            //}

            //catch (TransactionException)
            //{
            //    log.LogMessage("An error has occured because of exception", Level.Info);
            //}
            //catch (Exception ex)
            //{
            //    log.LogMessage("An error has occured because of exception", Level.Info);
            //}
            //finally
            //{

            //}
            return null;
        }
        public IEnumerable<Tuple<string, string, string>> GetChangedProperties<T>(T entity, Dictionary<string, string> auditableValues) where T : class
        {
            if (auditableValues.Any(x => x.Value.Contains(entity.GetType().BaseType.Name) || x.Value.Contains(entity.GetType().Name)))
            {

                var objectContext = ((IObjectContextAdapter)_dbContext[0]).ObjectContext;
                var set = objectContext.CreateObjectSet<T>();
                var keyName = set.EntitySet.ElementType.KeyMembers.First().ToString();

                object dbEntity = null;
                DbSet<T> dbSet = _dbContext[0].Set<T>();
                if (dbSet != null)
                {
                    dbEntity = dbSet.Find(Convert.ToInt32(entity.GetType().GetProperty(keyName).GetValue(entity)));
                }

                var auditable = auditableValues.Where(x => x.Value.Contains(entity.GetType().BaseType.Name) || x.Value.Contains(entity.GetType().Name)).AsQueryable();

                IList<Tuple<string, string, string>> changedValues = new List<Tuple<string, string, string>>();
                foreach (var propName in entity.GetType().GetProperties())
                {
                    if (auditable.Any(x => x.Key.Contains(propName.Name)) && dbEntity.GetType().GetProperties().Where(x => x.Name == propName.Name).Count() > 0)
                    {
                        if (propName.GetValue(dbEntity).ToString() != dbEntity.GetType().GetProperty(propName.Name).GetValue(entity).ToString())
                        {
                            changedValues.Add(new Tuple<string, string, string>(propName.Name, propName.GetValue(dbEntity).ToString(), dbEntity.GetType().GetProperty(propName.Name).GetValue(entity).ToString()));
                        }
                    }
                }

                return changedValues;
            }
            return null;
        }

        public IEnumerable<Tuple<string, string, string>> GetAddedProperties<T>(T entity, Dictionary<string, string> auditableValues) where T : class
        {
            if (auditableValues.Any(x => (x.Value.Contains(entity.GetType().BaseType.Name) || x.Value.Contains(entity.GetType().Name))))
            {
                _dbContext[0].Entry(entity).State = EntityState.Added;
                var auditable = auditableValues.Where(x => x.Value.Contains(entity.GetType().BaseType.Name) || x.Value.Contains(entity.GetType().Name)).AsQueryable();

                IList<Tuple<string, string, string>> changedValues = new List<Tuple<string, string, string>>();
                var myObjectState = ((IObjectContextAdapter)_dbContext[0]).ObjectContext.ObjectStateManager.GetObjectStateEntry(entity);

                foreach (var property in myObjectState.Entity.GetType().GetProperties())
                {
                    if (auditable.Any(x => x.Key.Contains(property.Name)))
                    {
                        changedValues.Add(new Tuple<string, string, string>(property.Name, "", property.GetValue(myObjectState.Entity).ToString()));
                    }
                }

                return changedValues;
            }
            return null;
        }

        public IEnumerable<Tuple<string, string, string>> GetDeletedProperties<T>(T entity, Dictionary<string, string> auditableValues) where T : class
        {
            if (auditableValues.Any(x => (x.Value.Contains(entity.GetType().BaseType.Name) || x.Value.Contains(entity.GetType().Name))))
            {
                _dbContext[0].Entry(entity).State = EntityState.Added;
                var auditable = auditableValues.Where(x => x.Value.Contains(entity.GetType().BaseType.Name) || x.Value.Contains(entity.GetType().Name)).AsQueryable();

                IList<Tuple<string, string, string>> changedValues = new List<Tuple<string, string, string>>();
                var myObjectState = ((IObjectContextAdapter)_dbContext[0]).ObjectContext.ObjectStateManager.GetObjectStateEntry(entity);

                foreach (var property in myObjectState.Entity.GetType().GetProperties())
                {
                    if (auditable.Any(x => x.Key.Contains(property.Name)))
                    {
                        changedValues.Add(new Tuple<string, string, string>(property.Name, property.GetValue(myObjectState.Entity).ToString(), ""));
                    }
                }
                return changedValues;
            }
            return null;
        }

        /// <summary>
        /// Used to retreive list of values which may not change often/metadata
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="key">column name in table</param>
        /// <param name="value"></param>
        /// <returns></returns>
        public IEnumerable<T> GetListOfValues<T>(string key, string value) where T : class
        {
            //try
            //{
                foreach (var dbContext in _dbContext)
                {
                    using (dbContext)
                    {
                        if (dbContext != null)
                        {
                            var dbSet = dbContext.Set<T>();
                            if (dbSet != null)
                            {

                                var objectContext = ((IObjectContextAdapter)dbContext).ObjectContext;
                                var set = objectContext.CreateObjectSet<T>();
                                var deleteKey = set.EntitySet.ElementType.Members.Contains("IsDeleted");
                                var condition = "";
                                if (deleteKey)
                                    condition = "IsDeleted=false";
                                if (!string.IsNullOrEmpty(key) && !string.IsNullOrEmpty(condition))
                                {
                                    condition = condition + " and " + key + "=\"" + value + "\"";
                                }
                                else if (!string.IsNullOrEmpty(key) && string.IsNullOrEmpty(condition))
                                {
                                    condition = key + "=" + value;
                                }

                                if (!string.IsNullOrEmpty(condition))
                                {
                                    return dbSet.Where(condition).ToList();
                                }
                                else
                                {
                                    return dbSet;
                                }
                            }
                        }
                    }
                }


            //}
            //catch (TransactionException)
            //{
            //    log.LogMessage("An error has occured because of exception", Level.Info);
            //}
            //catch (Exception ex)
            //{
            //    log.LogMessage("An error has occured because of exception", Level.Info);
            //}
            //finally
            //{

            //}
            return null;
        }



        /// <summary>
        /// Used to retreive lookup values
        /// </summary>
        /// <returns></returns>
        public IEnumerable<T> GetLookUpValues<T>() where T : class
        {
            foreach (var dbContext in _dbContext)
            {
                using (dbContext)
                {
                    if (dbContext != null)
                    {
                        var dbSet = dbContext.Set<T>();
                        if (dbSet != null)
                        {

                            var objectContext = ((IObjectContextAdapter)dbContext).ObjectContext;
                            var set = objectContext.CreateObjectSet<T>();
                            var deleteKey = set.EntitySet.ElementType.Members.Contains("IsDeleted");
                            var condition = "";
                            if (deleteKey)
                                condition = "IsDeleted=false";

                            if (!string.IsNullOrEmpty(condition))
                            {
                                return dbSet.Where(condition).ToList();
                            }
                            else
                            {
                                return dbSet;
                            }
                        }
                    }
                }
            }
            return null;
        }

        private static string concatIsDeletedFlag(bool IsDeletedFlag, string condition)
        {
            if (!string.IsNullOrEmpty(condition) && IsDeletedFlag)
            {
                condition = condition + " and IsDeleted=false";
            }
            else if (string.IsNullOrEmpty(condition) && IsDeletedFlag)
            {
                condition = "IsDeleted=false";
            }
            return condition;
        }

        public IEnumerable<T> GetDcoumentnumber<T>(string condition, DbContext dbContext) where T : class
        {
            //try
            //{
                if (dbContext != null)
                {
                    dbContext.Configuration.ProxyCreationEnabled = false;
                    var dbSet = dbContext.Set<T>();
                    if (dbSet != null)
                    {

                        if (!string.IsNullOrEmpty(condition))
                        {
                            return dbSet
                              .Where(condition)
                             .ToList<T>();
                        }
                    }
                }
            //}
            //catch (TransactionException)
            //{
            //    log.LogMessage("An error has occured because of exception", Level.Info);
            //}
            //catch (Exception ex)
            //{
            //    log.LogMessage("An error has occured because of exception", Level.Info);
            //}
            //finally
            //{

            //}
            return null;
        }

        public TransactionScope CreateTransactionScope()
        {
            return new TransactionScope();
        }

        public TransactionScope CreateTransactionScopeWithParam()
        {
            return new TransactionScope(TransactionScopeOption.Required, new TransactionOptions { IsolationLevel = IsolationLevel.ReadCommitted });
        }



        private void SaveDbContext(DbContext dbContext)
        {
            try
            {
                dbContext.SaveChanges();
            }
            catch (TransactionException dbEx)
            {
                log.LogMessage("An error has occured because of exception", Level.Info);
                throw new TransactionException(dbEx);
            }
            catch (Exception ex)
            {
                log.LogMessage("An error has occured because of exception", Level.Info);
                throw new TransactionException(ex);
            }
        }
        public IEnumerable<T> AddAndGetRelatedEntities<T>(IEnumerable<T> relatedentities, DbContext dbContext) where T : class
        {
            //try
            //{
                if (dbContext != null)
                {
                    var transactionOption = new TransactionOptions
                    {
                        Timeout = new TimeSpan(0, TransactionTimeout, 0),
                        IsolationLevel = System.Transactions.IsolationLevel.ReadCommitted,
                    };

                    using (TransactionScope scope = new TransactionScope(TransactionScopeOption.Required, transactionOption))
                    {
                        foreach (var entity in relatedentities)
                        {
                            if (dbContext != null && entity != null)
                            {
                                var dbSet = dbContext.Set(entity.GetType());
                                try
                                {
                                    var exist = dbSet.Local;
                                    dbContext.Entry(entity).State = EntityState.Added;
                                }
                                catch (TransactionException ex)
                                {
                                    log.LogMessage("Entity and DBcontext mismatch", Level.Info);
                                }
                            }
                        }
                        SaveDbContext(dbContext);
                        scope.Complete();
                    }
                }
                return relatedentities;
            //}
            //catch (Exception)
            //{
            //    throw;
            //}
        }

        public IEnumerable<T> UpdateAndGetRelatedEntities<T>(IEnumerable<T> relatedentities, DbContext dbContext) where T : class
        {
            //try
            //{
                if (dbContext != null)
                {
                    var transactionOption = new TransactionOptions
                    {
                        Timeout = new TimeSpan(0, TransactionTimeout, 0),
                        IsolationLevel = System.Transactions.IsolationLevel.ReadCommitted,
                    };

                    using (TransactionScope scope = new TransactionScope(TransactionScopeOption.Required, transactionOption))
                    {
                        foreach (var entity in relatedentities)
                        {
                            if (dbContext != null && entity != null)
                            {
                                var dbSet = dbContext.Set<T>();
                                if (dbSet != null)
                                {
                                    var dbContextInstance = ((IObjectContextAdapter)dbContext).ObjectContext;
                                    var currentObjectSet = dbContextInstance.GetEntitySet(entity);
                                    var entityType = currentObjectSet.ElementType;
                                    var keyName = currentObjectSet.ElementType.KeyMembers.First().ToString();

                                    dbContext.Entry(entity).State = Convert.ToInt32(entity.GetType().GetProperty(keyName).GetValue(entity)) > 0 ? EntityState.Modified : EntityState.Added;


                                    if (entityType.NavigationProperties.Count > 0)
                                    {
                                        foreach (var navigationProperty in entityType.NavigationProperties)
                                        {
                                            var navigationList = (IEnumerable<object>)entity.GetType().GetProperty(navigationProperty.Name).GetValue(entity);
                                            if (navigationList != null)
                                            {
                                                foreach (var child in navigationList)
                                                {
                                                    var childObjectSet = dbContextInstance.GetEntitySet(child);
                                                    var childKeyName = childObjectSet.ElementType.KeyMembers.Select(k => k.Name).First().ToString();
                                                    dbContext.Entry(child).State = Convert.ToInt32(child.GetType().GetProperty(childKeyName).GetValue(child)) > 0 ? EntityState.Modified : EntityState.Added;
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        SaveDbContext(dbContext);
                        scope.Complete();
                    }
                }
                return relatedentities;
            //}
            //catch (Exception)
            //{
            //    throw;
            //}
        }
        public bool CloseTransactionScope(TransactionScope scope)
        {
            try
            {
                scope.Complete();
                return true;
            }
            catch (TransactionException dbEx)
            {
                log.LogMessage("An error has occured because of exception", Level.Info);
                throw new TransactionException(dbEx);
            }
            catch (Exception ex)
            {
                log.LogMessage("An error has occured because of exception Close Transaction Scope", Level.Info);
                throw new TransactionException(ex);
            }
        }

        private static void CheckRowversionAndThrowConcurrencyException<T>(DbContext dbContext, T entity, Log4NetLogger log) where T : class
        {
            //-- To acheive Concurrency validation, remove comment in the following block

            ////------------------ Concurrency Check - Begins ------------------------------

            var timeStampPropertyName = "Timestamp";

            var timeStampProp = entity.GetType().GetProperty(timeStampPropertyName);
            byte[] TimeStamptoUpdate = null;
            if (timeStampProp != null)
                TimeStamptoUpdate = (byte[])timeStampProp.GetValue(entity);

            if (TimeStamptoUpdate == null || TimeStamptoUpdate.Length == 0)
            {
                log.LogMessage("Concurrency not handled in " + entity.ToString(), Level.Info);
            }

            var DatabaseValues = dbContext.Entry(entity).GetDatabaseValues();

            if (DatabaseValues != null)
            {
                timeStampPropertyName = DatabaseValues.PropertyNames.FirstOrDefault(x => x.Equals(timeStampPropertyName));

                var TimeStampinTable = timeStampPropertyName != null ? (byte[])DatabaseValues[timeStampPropertyName] : null;

                if (TimeStampinTable != null && TimeStamptoUpdate != null && TimeStamptoUpdate.Count() > 0)
                {
                    if (!TimeStampinTable.SequenceEqual(TimeStamptoUpdate))
                    {
                        throw new OptimisticConcurrencyException("RECORDMODIFIED");
                    }

                }

            }

            ////------------------ Concurrency Check - Ends ----------------------------------
        }

        private static byte[] GetProperty<T>(T entity, out string timeStampPropertyName) where T : class
        {
            timeStampPropertyName = "Timestamp";

            var property = entity.GetType().GetProperty(timeStampPropertyName);

            return (byte[])entity.GetType().GetProperty(timeStampPropertyName).GetValue(entity);
        }
    }
}
