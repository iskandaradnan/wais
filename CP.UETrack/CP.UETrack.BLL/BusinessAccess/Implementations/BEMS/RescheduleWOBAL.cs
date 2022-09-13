using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.BEMS;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.BEMS
{
    public class RescheduleWOBAL: IRescheduleWOBAL
    {
        private readonly IRescheduleWODAL _RescheduleWODAL;

        private readonly static string fileName = nameof(CustomerBAL);

        #region Ctor/init
        public RescheduleWOBAL(IRescheduleWODAL RescheduleWODAL)
        {
            _RescheduleWODAL = RescheduleWODAL;

        }
        #endregion

        public RescheduleDropdownValues Load()
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());
                var result = _RescheduleWODAL.Load();
                Log4NetLogger.LogExit(fileName, nameof(Load), Level.Info.ToString());
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

        #region Business Access Methods
        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(GetAll), Level.Info.ToString());
                var result = _RescheduleWODAL.GetAll(pageFilter);
                Log4NetLogger.LogExit(fileName, nameof(GetAll), Level.Info.ToString());
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
        public RescheduleWOViewModel Get(int RescheduleWOId)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var result = _RescheduleWODAL.Get(RescheduleWOId);
                Log4NetLogger.LogExit(fileName, nameof(Get), Level.Info.ToString());
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
        public void Delete(int RescheduleWOId)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                _RescheduleWODAL.Delete(RescheduleWOId);
                Log4NetLogger.LogExit(fileName, nameof(Get), Level.Info.ToString());
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
        public RescheduleWOViewModel Save(RescheduleWOViewModel RescheduleWO, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                RescheduleWOViewModel result = null;

                //if (IsValid(RescheduleWO, out ErrorMessage))
                //{
                    result = _RescheduleWODAL.Save(RescheduleWO);
                //}

                Log4NetLogger.LogExit(fileName, nameof(Save), Level.Info.ToString());
                return result;
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }

            catch (Exception ex)
            {
                throw new BALException(ex);
            }
        }

        private bool IsValid(RescheduleWOViewModel RescheduleWO, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;
            //if (string.IsNullOrEmpty(RescheduleWO.WorkOrderId))
            //{
             //   ErrorMessage = "Some fields are incorrect or have not been filled in. Please correct this to proceed.";
            //}
            //else 
            if (_RescheduleWODAL.IsRescheduleWOCodeDuplicate(RescheduleWO))
            {
                ErrorMessage = "RescheduleWO Code should be unique";
            }
            else if (_RescheduleWODAL.IsRecordModified(RescheduleWO))
            {
                ErrorMessage = "Record Modified. Please Re-Select";
            }
            else
            {
                isValid = true;
            }
            return isValid;
        }

        public RescheduleWOViewModel FetchWorkorder(RescheduleWOViewModel EODCaptur)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(FetchWorkorder), Level.Info.ToString());
                RescheduleWOViewModel result = null;

                result = _RescheduleWODAL.FetchWorkorder(EODCaptur);

                Log4NetLogger.LogExit(fileName, nameof(FetchWorkorder), Level.Info.ToString());
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
        #endregion
    }
}
