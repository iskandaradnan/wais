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
    public class CleanLinenIssueBAL : ICleanLinenIssueBAL
    {
        private string _FileName = nameof(CleanLinenIssueBAL);
        ICleanLinenIssueDAL _CleanLinenIssueDAL;
        public CleanLinenIssueBAL(ICleanLinenIssueDAL CleanLinenIssueDAL)
        {
            _CleanLinenIssueDAL = CleanLinenIssueDAL;
        }
        public CleanLinenIssueModelLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _CleanLinenIssueDAL.Load();
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
        public CleanLinenIssueModel Save(CleanLinenIssueModel model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                CleanLinenIssueModel result = null;
                if (IsValid(model, out ErrorMessage))
                {
                    result = _CleanLinenIssueDAL.Save(model, out ErrorMessage);
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

        private bool IsValid(CleanLinenIssueModel model, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;
            if (model.CLINo == " " || model.CLINo == null)
            {
                var guid = Guid.NewGuid().ToString();
                model.CLINo = guid;
            }
            if (string.IsNullOrEmpty(model.CLINo))
            {
                ErrorMessage = "Some fields are incorrect or have not been filled in. Please correct this to proceed.";
            }
            else if (model.CleanLinenIssueId == 0)
            {
                if (_CleanLinenIssueDAL.IsCleanLinenIssueDuplicate(model))
                    ErrorMessage = "Block Code should be unique";
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
        public CleanLinenIssueModel Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _CleanLinenIssueDAL.Get(Id);
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

        public CleanLinenIssueModel GetBY(CleanLinenIssueModel model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetByScheduledId), Level.Info.ToString());
                var result = _CleanLinenIssueDAL.GetBY(model);
                Log4NetLogger.LogExit(_FileName, nameof(GetByScheduledId), Level.Info.ToString());
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
        public CleanLinenIssueModel GetByLinenItemDetails(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetByLinenItemDetails), Level.Info.ToString());
                var result = _CleanLinenIssueDAL.GetByLinenItemDetails(Id);
                Log4NetLogger.LogExit(_FileName, nameof(GetByLinenItemDetails), Level.Info.ToString());
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

        public CleanLinenIssueModel GetByLinenBagDetails(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetByLinenBagDetails), Level.Info.ToString());
                var result = _CleanLinenIssueDAL.GetByLinenBagDetails(Id);
                Log4NetLogger.LogExit(_FileName, nameof(GetByLinenBagDetails), Level.Info.ToString());
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

        public CleanLinenIssueModel GetByScheduledId(CleanLinenIssueModel model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetByScheduledId), Level.Info.ToString());

                ErrorMessage = string.Empty;
                CleanLinenIssueModel result = null;
                if (IsValid(model, out ErrorMessage))
                {
                    result = _CleanLinenIssueDAL.GetByScheduledId(model, out ErrorMessage);
                }

                Log4NetLogger.LogExit(_FileName, nameof(GetByScheduledId), Level.Info.ToString());
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
                var result = _CleanLinenIssueDAL.GetAll(pageFilter);
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
                _CleanLinenIssueDAL.Delete(Id, out ErrorMessage);
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
 

