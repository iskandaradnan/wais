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
using CP.UETrack.BLL.BusinessAccess.Interface.LLS.Transaction;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.LLS.Transaction
{
    public class CleanLinenRequestBAL : ICleanLinenRequestBAL
    {
        private string _FileName = nameof(CleanLinenRequestBAL);
        ICleanLinenRequestDAL _CleanLinenRequestDAL;
        public CleanLinenRequestBAL(ICleanLinenRequestDAL CleanLinenRequestDAL)
        {
            _CleanLinenRequestDAL = CleanLinenRequestDAL;
        }
        public CleanLinenRequestModelLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _CleanLinenRequestDAL.Load();
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
           
        public CleanLinenRequestModel Save(CleanLinenRequestModel model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

               
                ErrorMessage = string.Empty;
                CleanLinenRequestModel result = null;

                if (IsValid(model, out ErrorMessage))
                {
                    result = _CleanLinenRequestDAL.Save(model, out ErrorMessage);
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
        private bool IsValid(CleanLinenRequestModel model, out string ErrorMessage)
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
            else if (model.CleanLinenRequestId == 0)
            {
                if (_CleanLinenRequestDAL.IsUserAreaCodeDuplicate(model))
                    ErrorMessage = "Document Number should be unique";
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
        public CleanLinenRequestModel Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _CleanLinenRequestDAL.Get(Id);
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
                var result = _CleanLinenRequestDAL.GetAll(pageFilter);
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
                _CleanLinenRequestDAL.Delete(Id, out ErrorMessage);
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
 

