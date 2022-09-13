using FluentValidation;
using FluentValidation.Internal;
using CP.UETrack.BLL.BusinessAccess.Interface;
using CP.UETrack.DAL.DataAccess;
using CP.UETrack.Model;
using System;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.UETrack.Models;
using System.Collections.Generic;
using CP.UETrack.BLL.BusinessAccess.Contracts.BEMS;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.Model.BEMS;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.BEMS
{
    public class EODParameterMappingBAL : IEODParameterMappingBAL
    {
        private string _FileName = nameof(EODParameterMappingBAL);
        IEODParameterMappingDAL _EODParameterMappingDAL;
        public EODParameterMappingBAL(IEODParameterMappingDAL EODParameterMappingDAL)
        {
            _EODParameterMappingDAL = EODParameterMappingDAL;
        }
        public EODTpeCodeMapDropdownValues Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _EODParameterMappingDAL.Load();
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
        public EODParameterMapping Save(EODParameterMapping EODParamMapping, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                EODParameterMapping result = null;

               // if (IsValid(EODParamMapping, out ErrorMessage))
               // {
                    result = _EODParameterMappingDAL.Save(EODParamMapping, out ErrorMessage);
               // }

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

        private static bool IsValid(EODParameterMapping EODParamMapping, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = true;
            var _currentDate = DateTime.Now;
            foreach (var a in EODParamMapping.EODParameterMappingGridData) {

                if (a.EffectiveFrom.Date > _currentDate.Date) {
                    ErrorMessage = "Effective From Date should be lesser than or equal to Current Date";
                    isValid = false;
                }
            }
            
            return isValid;
        }

        //private bool IsValid(EODParameterMapping EODParamMapping, out string ErrorMessage)
        //{
        //    ErrorMessage = string.Empty;
        //    var isValid = false;
        //    foreach (var i in EODParamMapping.EODParameterMappingGridData)
        //    {
        //        if (i.ServiceId == 0 || i.CategorySystemId == 0)
        //        {
        //            ErrorMessage = "Some fields are incorrect or have not been filled in. Please correct this to proceed.";
        //        }

        //        //else if (_EODTypeCodeMappingDAL.IsRoleDuplicate(EODTypeCodeMapping))
        //        //{
        //        //    ErrorMessage = "User Role should be unique";
        //        //}
        //        //else if (_EODTypeCodeMappingDAL.IsRecordModified(EODTypeCodeMapping))
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
                var result = _EODParameterMappingDAL.GetAll(pageFilter);
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

        public EODParameterMapping Get(int Id, int pagesize, int pageindex)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _EODParameterMappingDAL.Get(Id, pagesize, pageindex);
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return result;
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }
            catch (Exception )
            {
                throw;
            }
        }

        public void Delete(int Id, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
                _EODParameterMappingDAL.Delete(Id, out ErrorMessage);
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

        public EODParameterMapping GetHistory(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetHistory), Level.Info.ToString());
                var result = _EODParameterMappingDAL.GetHistory(Id);
                Log4NetLogger.LogExit(_FileName, nameof(GetHistory), Level.Info.ToString());
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
