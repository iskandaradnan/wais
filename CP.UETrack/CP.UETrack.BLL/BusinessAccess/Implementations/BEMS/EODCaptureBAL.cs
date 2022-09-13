using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.BEMS;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.BEMS
{
    public class EODCaptureBAL : IEODCaptureBAL
    {
        private string _FileName = nameof(EODCaptureBAL);
        IEODCaptureDAL _EODCaptureDAL;
        public EODCaptureBAL(IEODCaptureDAL EODCaptureDAL)
        {
            _EODCaptureDAL = EODCaptureDAL;
        }

        public EODCaptureDropdownValues Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _EODCaptureDAL.Load();
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
        public EODCapture Save(EODCapture EODCaptur, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                EODCapture result = null;

                //if (IsValid(EODParamMapping, out ErrorMessage))
                //{
                result = _EODCaptureDAL.Save(EODCaptur, out ErrorMessage);
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
        //private bool IsValid(EODCapture EODCaptur, out string ErrorMessage)
        //{
        //    ErrorMessage = string.Empty;
        //    var isValid = false;
        //    foreach (var i in EODCaptur.EODCaptureGridData)
        //    {
        //        if (i.ServiceId == 0 || i.CategorySystemId == 0)
        //        {
        //            ErrorMessage = "Some fields are incorrect or have not been filled in. Please correct this to proceed.";
        //        }

        //        //else if (_EODCaptureDAL.IsRoleDuplicate(EODCaptur))
        //        //{
        //        //    ErrorMessage = "User Role should be unique";
        //        //}
        //        //else if (_EODCaptureDAL.IsRecordModified(EODCaptur))
        //        //{
        //        //    ErrorMessage = "Record Modified. Please Re-Select";
        //        //}
        //        else
        //        {
        //            isValid = true;
        //        }
        //    }
        //    return isValid;
        //}

        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                var result = _EODCaptureDAL.GetAll(pageFilter);
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

        public EODCapture Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _EODCaptureDAL.Get(Id);
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


        //public EODCapture BindDetGrid(int serviceId, int CatSysId, DateTime RecDate)
        //{
        //    try
        //    {
        //        Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
        //        var result = _EODCaptureDAL.BindDetGrid(serviceId, CatSysId, RecDate);
        //        Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
        //        return result;
        //    }
        //    catch (BALException balException)
        //    {
        //        throw new BALException(balException);
        //    }
        //    catch (Exception)
        //    {
        //        throw;
        //    }
        //}

        public EODCapture BindDetGrid(EODCapture EODCaptur)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(BindDetGrid), Level.Info.ToString());
                EODCapture result = null;

                //if (IsValid(EODParamMapping, out ErrorMessage))
                //{
                result = _EODCaptureDAL.BindDetGrid(EODCaptur);
                //}

                Log4NetLogger.LogExit(_FileName, nameof(BindDetGrid), Level.Info.ToString());
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
                _EODCaptureDAL.Delete(Id);
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
