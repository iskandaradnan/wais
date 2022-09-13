using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.BEMS;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS.CRMWorkOrder;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Implementations
{
    public class CRMWorkorderBAL : ICRMWorkorderBAL
    {
        private string _FileName = nameof(CRMWorkorderBAL);
        ICRMWorkorderDAL _CRMWorkorderDAL;

        public CRMWorkorderBAL(ICRMWorkorderDAL CRMWorkorderDAL)
        {
            _CRMWorkorderDAL = CRMWorkorderDAL;
        }

        public CRMWorkorderDropdownValues Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _CRMWorkorderDAL.Load();
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
        public CRMWorkorder Save(CRMWorkorder workorder, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                CRMWorkorder result = null;

                //if (IsValid(EODParamMapping, out ErrorMessage))
                //{
                result = _CRMWorkorderDAL.Save(workorder, out ErrorMessage);
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
        //private bool IsValid(CRMWorkorder workorder, out string ErrorMessage)
        //{
        //    ErrorMessage = string.Empty;
        //    var isValid = false;
        //    foreach (var i in EODCaptur.EODCaptureGridData)
        //    {
        //        if (i.ServiceId == 0 || i.CategorySystemId == 0)
        //        {
        //            ErrorMessage = "Some fields are incorrect or have not been filled in. Please correct this to proceed.";
        //        }

        //        //else if (_CRMWorkorderDAL.IsRoleDuplicate(EODCaptur))
        //        //{
        //        //    ErrorMessage = "User Role should be unique";
        //        //}
        //        //else if (_CRMWorkorderDAL.IsRecordModified(EODCaptur))
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
                var result = _CRMWorkorderDAL.GetAll(pageFilter);
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

        public CRMWorkorder Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _CRMWorkorderDAL.Get(Id);
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

        public bool Delete(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
                var result = _CRMWorkorderDAL.Delete(Id);
                Log4NetLogger.LogExit(_FileName, nameof(Delete), Level.Info.ToString());
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

        public CRMWorkorderAssessment SaveAssessment(CRMWorkorderAssessment workordeassr, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                CRMWorkorderAssessment result = null;

                //if (IsValid(EODParamMapping, out ErrorMessage))
                //{
                result = _CRMWorkorderDAL.SaveAssessment(workordeassr, out ErrorMessage);
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

        public CRMWorkorderAssessment GetAssessment(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _CRMWorkorderDAL.GetAssessment(Id);
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

        public CRMWorkorderCompInfo SaveCompInfo(CRMWorkorderCompInfo workordercomp, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                CRMWorkorderCompInfo result = null;

                //if (IsValid(EODParamMapping, out ErrorMessage))
                //{
                result = _CRMWorkorderDAL.SaveCompInfo(workordercomp, out ErrorMessage);
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

        public CRMWorkorderCompInfo GetCompInfo(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _CRMWorkorderDAL.GetCompInfo(Id);
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

        public CRMWorkorderProcessStatus GetProcessStatus(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetProcessStatus), Level.Info.ToString());
                var result = _CRMWorkorderDAL.GetProcessStatus(Id);
                Log4NetLogger.LogExit(_FileName, nameof(GetProcessStatus), Level.Info.ToString());
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
