using CP.UETrack.BLL.BusinessAccess.Contracts.KPI;
using CP.UETrack.DAL.DataAccess.Contracts.KPI;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model;
using CP.UETrack.Model.KPI;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.KPI
{
    public class MonthlyServiceFeeBAL: IMonthlyServiceFeeBAL
    {
        private string _FileName = nameof(MonthlyServiceFeeBAL);
        IMonthlyServiceFeeDAL _MonthlyServiceFeeDAL;

        public MonthlyServiceFeeBAL(IMonthlyServiceFeeDAL MonthlyServiceFeeDAL)
        {
            _MonthlyServiceFeeDAL = MonthlyServiceFeeDAL;
        }

        public bool Delete(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _MonthlyServiceFeeDAL.Delete(Id);
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

        public MonthlyServiceFeeModel Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _MonthlyServiceFeeDAL.Get(Id);
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

        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                var result = _MonthlyServiceFeeDAL.GetAll(pageFilter);
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

        public MonthlyServiceFeeModel GetRevision(int Id, int Year)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetRevision), Level.Info.ToString());
                var result = _MonthlyServiceFeeDAL.GetRevision(Id,Year);
                Log4NetLogger.LogExit(_FileName, nameof(GetRevision), Level.Info.ToString());
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

        public MonthlyServiceFeeModel GetVersion(int Year)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetVersion), Level.Info.ToString());
                var result = _MonthlyServiceFeeDAL.GetVersion(Year);
                Log4NetLogger.LogExit(_FileName, nameof(GetVersion), Level.Info.ToString());
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

        public MonthlyServiceFeeTypeDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _MonthlyServiceFeeDAL.Load();
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

        public MonthlyServiceFeeModel Save(MonthlyServiceFeeModel ServiceFee, out string ErrorMessage)
        {
            
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                MonthlyServiceFeeModel result = null;

                //if (IsValid(block, out ErrorMessage))
                //{
                result = _MonthlyServiceFeeDAL.Save(ServiceFee, out ErrorMessage);
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
    }
}
