using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.VM;
using CP.UETrack.DAL.DataAccess.Contracts.VM;
using CP.UETrack.Model;
using CP.UETrack.Model.VM;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.VM
{
    class SNFBAL:ISNFBAL
    {
        private string _FileName = nameof(TestingAndCommissioningBAL);
        ISNFDAL _ISNFDAL;

        public SNFBAL(ISNFDAL ISNFDAL)
        {
            _ISNFDAL = ISNFDAL;
        }
        public LovEntity Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _ISNFDAL.Load();
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
        public SNFEntity Save(SNFEntity testingAndCommissioning, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                SNFEntity result = null;

                if (IsValid(testingAndCommissioning, out ErrorMessage))
                {
                    result = _ISNFDAL.Save(testingAndCommissioning, out ErrorMessage);
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
        private bool IsValid(SNFEntity testingAndCommissioning, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;

            var currentDate = DateTime.Now.Date;

            if (testingAndCommissioning.TandCDate != null && testingAndCommissioning.TandCDate.Date > currentDate)
            {
                ErrorMessage = "SNF Date cannot be a future date";
            }
            else if (testingAndCommissioning.TandCDate != null && testingAndCommissioning.ServiceStartDate != DateTime.MinValue
                && testingAndCommissioning.TandCDate < testingAndCommissioning.ServiceStartDate)
            {
                ErrorMessage = "SNF Date should be greater than or equal to Service Start Date";
            }
            else if (testingAndCommissioning.ServiceEndDate != DateTime.MinValue && testingAndCommissioning.ServiceStartDate != DateTime.MinValue 
                && testingAndCommissioning.ServiceEndDate < testingAndCommissioning.ServiceStartDate)
            {
                ErrorMessage = "Service Stop Date should be greater than or equal to Service Start Date";
            }
            else
            {
                isValid = true;
            }
            return isValid;
        }
        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                var result = _ISNFDAL.GetAll(pageFilter);
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
        public SNFEntity Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _ISNFDAL.Get(Id);
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
        public void Delete(int Id, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
                _ISNFDAL.Delete(Id, out ErrorMessage);
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
