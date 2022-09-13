using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Interface;
using CP.UETrack.DAL.DataAccess.Contracts.LLS;
using CP.UETrack.Model.LLS;
using CP.UETrack.DAL.DataAccess;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model;
using CP.UETrack.BLL.BusinessAccess.Interface.LLS;
using CP.UETrack.DAL.DataAccess.Implementations.LLS;
using CP.UETrack.BLL.BusinessAccess.Interface.LLS.Transaction;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.LLS.Transaction
{
    public class CleanLinenDespatchBAL : ICleanLinenDespatchBAL
    //ICleanLinenDespatchBAL
    {
        private string _FileName = nameof(CleanLinenDespatchBAL);
        ICleanLinenDespatchDAL _CleanLinenDespatchDAL;
        public CleanLinenDespatchBAL(ICleanLinenDespatchDAL CleanLinenDespatchDAL)
        {
            _CleanLinenDespatchDAL = CleanLinenDespatchDAL;
        }
        public CleanLinenDespatchModelLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _CleanLinenDespatchDAL.Load();
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
        public CleanLinenDespatchModel Save(CleanLinenDespatchModel model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                CleanLinenDespatchModel result = null;
                if (IsValid(model, out ErrorMessage))
                {
                    result = _CleanLinenDespatchDAL.Save(model, out ErrorMessage);
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

        private bool IsValid(CleanLinenDespatchModel model, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;

            if (model.DocumentNo == " "|| model.DocumentNo ==null)
            {
                var guid = Guid.NewGuid().ToString();
                model.DocumentNo = guid;
            }
            if (string.IsNullOrEmpty(model.DocumentNo))
            {
                ErrorMessage = "Some fields are incorrect or have not been filled in. Please correct this to proceed.";
            }
            else if (model.CleanLinenDespatchId == 0)
            {
                if (_CleanLinenDespatchDAL.IsCleanLinenDespatchDuplicate(model))
                    ErrorMessage = "DocumentNumber should be unique";
                else
                    isValid = true;
            }
            //else if (_BlockDAL.IsRecordModified(block))
            //{
            //    ErrorMessage = "Record Modified. Please Re-Select";
            //}
            else
            {
                isValid = true;
            }
            return isValid;
        }
        public CleanLinenDespatchModel Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _CleanLinenDespatchDAL.Get(Id);
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
                var result = _CleanLinenDespatchDAL.GetAll(pageFilter);
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
                _CleanLinenDespatchDAL.Delete(Id, out ErrorMessage);
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
 

