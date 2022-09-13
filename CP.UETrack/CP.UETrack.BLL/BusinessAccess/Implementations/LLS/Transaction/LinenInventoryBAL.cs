using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model;
using CP.UETrack.Model.LLS;
using CP.UETrack.BLL.BusinessAccess.Interface.LLS;
using CP.UETrack.DAL.DataAccess.Contracts.LLS.Transaction;
using CP.UETrack.BLL.BusinessAccess.Interface.LLS.Transaction;
using CP.UETrack.BLL.BusinessAccess.Contracts.LLS.Transaction;
using CP.UETrack.DAL.DataAccess.Implementations.LLS.Transaction;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.LLS
{
    public class LinenInventoryBAL : ILinenInventoryBAL

    {
        private string _FileName = nameof(LinenInventoryBAL);
        ILinenInventoryDAL _LinenInventoryDAL;
        public LinenInventoryBAL(ILinenInventoryDAL LinenInventoryDAL)
        {
            _LinenInventoryDAL = LinenInventoryDAL;
        }
        public LinenInventoryModelClassLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _LinenInventoryDAL.Load();

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
        public TestModel Save(TestModel model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                TestModel result = null;
                if (IsValid(model, out ErrorMessage))
                {
                    result = _LinenInventoryDAL.Save(model, out ErrorMessage);
                }

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return result;
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private bool IsValid(TestModel model, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;
            if (model.DocumentNo == " " || model.DocumentNo == null)
            {
                var guid = Guid.NewGuid().ToString();
                model.DocumentNo = guid;
            }
            if (string.IsNullOrEmpty(model.DocumentNo))
            {
                ErrorMessage = "Some fields are incorrect or have not been filled in. Please correct this to proceed.";
            }
            else if (model.LinenInventoryId == 0)
            {
                if (_LinenInventoryDAL.IsLinenAdjustmentDuplicate(model))
                    ErrorMessage = "DocumentNumber should be unique";
                else
                    isValid = true;
            }
            else
            {
                isValid = true;
            }
            return isValid;
        }
        public TestModel Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _LinenInventoryDAL.Get(Id);
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return result;
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                var result = _LinenInventoryDAL.GetAll(pageFilter);
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
        public void Delete(int Id, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
                _LinenInventoryDAL.Delete(Id, out ErrorMessage);
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


