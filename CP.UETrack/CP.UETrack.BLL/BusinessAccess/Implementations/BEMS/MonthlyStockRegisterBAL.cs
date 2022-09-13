using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.BEMS;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.BEMS
{
   public class MonthlyStockRegisterBAL: IMonthlyStockRegisterBAL
    {
        private string _FileName = nameof(MonthlyStockRegisterBAL);
        IMonthlyStockRegisterDAL _MonthlyStockRegisterDAL;

        public MonthlyStockRegisterBAL(IMonthlyStockRegisterDAL MonthlyStockRegisterDAL)
        {
            _MonthlyStockRegisterDAL = MonthlyStockRegisterDAL;
        }

        public MonthlyStockRegisterTypeDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _MonthlyStockRegisterDAL.Load();
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
        public MonthlyStockRegisterModel Save(MonthlyStockRegisterModel MonthlyStock)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                var ErrorMessage = string.Empty;
                MonthlyStockRegisterModel result = null;

                //if (IsValid(block, out ErrorMessage))
                //{
                result = _MonthlyStockRegisterDAL.Save(MonthlyStock);
                //}

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
        public MonthlyStockRegisterModel Get(MonthlyStockRegisterModel MonthlyStock)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _MonthlyStockRegisterDAL.Get(MonthlyStock);
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

        public MonthlyStockRegisterModel GetModal(ItemMonthlyStockRegisterModal MonthlyReg)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetModal), Level.Info.ToString());
                var result = _MonthlyStockRegisterDAL.GetModal( MonthlyReg);
                Log4NetLogger.LogExit(_FileName, nameof(GetModal), Level.Info.ToString());
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

        public bool Delete(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _MonthlyStockRegisterDAL.Delete(Id);
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return result;
            }
            catch (BALException bx)
            {
                throw new BALException(bx);
            }
            catch (Exception ex)
            {
                throw new BALException(ex);
            }
        }

        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                var result = _MonthlyStockRegisterDAL.GetAll(pageFilter);
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

        
    }
}
