using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.HWMS;
using CP.UETrack.DAL.DataAccess.Contracts.HWMS;
using CP.UETrack.Model;
using CP.UETrack.Model.HWMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.HWMS
{
   public class CollectionCategoryBAL : ICollectionCategoryBAL
   {
        private string _FileName = nameof(BlockBAL);
        ICollectionCategoryDAL _collectionCategoryDAL;
        public CollectionCategoryBAL(ICollectionCategoryDAL collectionCategoryDAL)
        {
            _collectionCategoryDAL = collectionCategoryDAL;
        }

        public CollectionCategoryDropDown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _collectionCategoryDAL.Load();
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return result;
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }
            catch (Exception)
            {
                throw;
            }
        }

        public CollectionCategory Save(CollectionCategory model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                CollectionCategory result = null;


                result = _collectionCategoryDAL.Save(model, out ErrorMessage);


                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return result;
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }
            catch (Exception)
            {
                throw;
            }
        }
       

        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                var result = _collectionCategoryDAL.GetAll(pageFilter);
                Log4NetLogger.LogExit(_FileName, nameof(GetAll), Level.Info.ToString());
                return result;
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }
            catch (Exception)
            {
                throw;
            }
        }
        public CollectionCategory Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _collectionCategoryDAL.Get(Id);
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return result;
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<DeptAreaDetails> UserAreaCodeFetch(DeptAreaDetails SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(UserAreaCodeFetch), Level.Info.ToString());
                var result = _collectionCategoryDAL.UserAreaCodeFetch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(UserAreaCodeFetch), Level.Info.ToString());
                return result;
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }
            catch (Exception)
            {
                throw;
            }
        }

        public CollectionCategory UserAreaNameData(string UserAreaCode)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(UserAreaNameData), Level.Info.ToString());
                var result = _collectionCategoryDAL.UserAreaNameData(UserAreaCode);
                Log4NetLogger.LogExit(_FileName, nameof(UserAreaNameData), Level.Info.ToString());
                return result;
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }
            catch (Exception)
            {
                throw;
            }
        }    

    }
}
