using CP.UETrack.BLL.BusinessAccess.Interface;
using CP.UETrack.DAL.DataAccess;
using CP.UETrack.Model;
using System;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using System.Collections.Generic;

namespace CP.UETrack.BLL.BusinessAccess
{
    public class KPIGenerationBAL : IKPIGenerationBAL
    {
        private string _FileName = nameof(KPIGenerationBAL);
        IKPIGenerationDAL _KPIGenerationDAL;

        public KPIGenerationBAL(IKPIGenerationDAL kpiGenerationDAL)
        {
            _KPIGenerationDAL = kpiGenerationDAL;
        }
        public KPIGenerationLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _KPIGenerationDAL.Load();
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
        public MonthlyServiceFeeFetch GetMonthlyServiceFee(MonthlyServiceFeeFetch serviceFeeFetch)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetMonthlyServiceFee), Level.Info.ToString());
                var result = _KPIGenerationDAL.GetMonthlyServiceFee(serviceFeeFetch);
                Log4NetLogger.LogExit(_FileName, nameof(GetMonthlyServiceFee), Level.Info.ToString());
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
        public KPIGeneration Save(KPIGeneration kpiGeneration, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                KPIGeneration result = null;

                if (IsValid(kpiGeneration, out ErrorMessage))
                {
                    result = _KPIGenerationDAL.Save(kpiGeneration, out ErrorMessage);
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
        private bool IsValid(KPIGeneration kpiGeneration, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = true;
            return isValid;
        }
        public GridFilterResult GetAll(KPIGenerationFetch kpiGenerationFetch)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                var result = _KPIGenerationDAL.GetAll(kpiGenerationFetch);
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
        public List<KPIGenerationRecord> GetAllRecords(KPIGenerationFetch kpiGenerationFetch)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                var result = _KPIGenerationDAL.GetAllRecords(kpiGenerationFetch);
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
        public List<KPIGenerationDemertis> GetDemeritPoints(KPIGenerationFetch kpiGenerationFetch)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetDemeritPoints), Level.Info.ToString());
                var result = _KPIGenerationDAL.GetDemeritPoints(kpiGenerationFetch);
                Log4NetLogger.LogExit(_FileName, nameof(GetDemeritPoints), Level.Info.ToString());
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
        public List<KPIGenerationDemertis> GetDeductionValues(KPIGenerationFetch kpiGenerationFetch)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetDeductionValues), Level.Info.ToString());
                var result = _KPIGenerationDAL.GetDeductionValues(kpiGenerationFetch);
                Log4NetLogger.LogExit(_FileName, nameof(GetDeductionValues), Level.Info.ToString());
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
                _KPIGenerationDAL.Delete(Id);
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
