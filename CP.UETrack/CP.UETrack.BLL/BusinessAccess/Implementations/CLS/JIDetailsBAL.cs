using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.CLS;
using CP.UETrack.DAL.DataAccess.Contracts.CLS;
using CP.UETrack.Model;
using CP.UETrack.Model.CLS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.CLS
{
    public class JIDetailsBAL : IJIDetailsBAL
    {
        private string _FileName = nameof(BlockBAL);
        IJIDetailsDAL _jiDetailsDAL;
        public JIDetailsBAL(IJIDetailsDAL iJIDetails)
        {
            _jiDetailsDAL = iJIDetails;
        }
        public JIDetailsListDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _jiDetailsDAL.Load();
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
        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                var result = _jiDetailsDAL.GetAll(pageFilter);
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
        public JIDetails Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _jiDetailsDAL.Get(Id);
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
        public JIDetails Save(JIDetails block, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                JIDetails result = null;


                result = _jiDetailsDAL.Save(block, out ErrorMessage);


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
        public JIDetails Submit(JIDetails block, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Submit), Level.Info.ToString());

                ErrorMessage = string.Empty;
                JIDetails result = null;


                result = _jiDetailsDAL.Submit(block, out ErrorMessage);


                Log4NetLogger.LogExit(_FileName, nameof(Submit), Level.Info.ToString());
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
        public JIDetails LocationCodeFetch(JIDetails Details)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LocationCodeFetch), Level.Info.ToString());
                JIDetails result = null;

                result = _jiDetailsDAL.LocationCodeFetch(Details);
                Log4NetLogger.LogExit(_FileName, nameof(LocationCodeFetch), Level.Info.ToString());
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
        public List<JIDetailsAttachment> AttachmentSave(JIDetails block, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(AttachmentSave), Level.Info.ToString());

                ErrorMessage = string.Empty;
                List<JIDetailsAttachment> result = null;


                result = _jiDetailsDAL.AttachmentSave(block, out ErrorMessage);


                Log4NetLogger.LogExit(_FileName, nameof(AttachmentSave), Level.Info.ToString());
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
        public List<JISchedule> DocumentNoFetch(JISchedule details)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(DocumentNoFetch), Level.Info.ToString());
                var result = _jiDetailsDAL.DocumentNoFetch(details);
                Log4NetLogger.LogExit(_FileName, nameof(DocumentNoFetch), Level.Info.ToString());
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
