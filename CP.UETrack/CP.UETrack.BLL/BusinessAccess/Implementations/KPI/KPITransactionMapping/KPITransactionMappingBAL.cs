
using CP.UETrack.BLL.BusinessAccess.Interface;
using CP.UETrack.DAL.DataAccess;
using CP.UETrack.Model;
using System;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using System.Collections.Generic;

namespace CP.UETrack.BLL.BusinessAccess
{
    public class KPITransactionMappingBAL : IKPITransactionMappingBAL
    {
        private string _FileName = nameof(KPITransactionMappingBAL);
        IKPITransactionMappingDAL _KPITransactionMappingDAL;

        public KPITransactionMappingBAL(IKPITransactionMappingDAL kPITransactionMappingDAL)
        {
            _KPITransactionMappingDAL = kPITransactionMappingDAL;
        }
        public KPITransactionMappingLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _KPITransactionMappingDAL.Load();
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
        public List<KPITransactionFetchResult> FetchRecords(KPITransactionMapping kPITransactionMapping, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchRecords), Level.Info.ToString());
                var result = _KPITransactionMappingDAL.FetchRecords(kPITransactionMapping, out ErrorMessage);

                Log4NetLogger.LogExit(_FileName, nameof(FetchRecords), Level.Info.ToString());
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
        public KPITransactions Save(KPITransactions kpiTransactions, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                KPITransactions result = null;

                if (IsValid(kpiTransactions, out ErrorMessage))
                {
                    result = _KPITransactionMappingDAL.Save(kpiTransactions, out ErrorMessage);
                }

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
        private bool IsValid(KPITransactions kpiTransactions, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = true;
            return isValid;
        }
        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                var result = _KPITransactionMappingDAL.GetAll(pageFilter);
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
        public KPITransactions Get(int Id, int PageIndex, int PageSize)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _KPITransactionMappingDAL.Get(Id, PageIndex, PageSize);
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
        public void Delete(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
                _KPITransactionMappingDAL.Delete(Id);
                Log4NetLogger.LogExit(_FileName, nameof(Delete), Level.Info.ToString());
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
