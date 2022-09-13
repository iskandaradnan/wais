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

namespace CP.UETrack.BLL.BusinessAccess
{
    public class EODTypeCodeMappingBAL : IEODTypeCodeMappingBAL
    {
        private string _FileName = nameof(EODTypeCodeMappingBAL);
        IEODTypeCodeMappingDAL _EODTypeCodeMappingDAL;
        public EODTypeCodeMappingBAL(IEODTypeCodeMappingDAL EODTypeCodeMappingDAL)
        {
            _EODTypeCodeMappingDAL = EODTypeCodeMappingDAL;
        }
        public EODDropdownValues Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _EODTypeCodeMappingDAL.Load();
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
        public EODTypeCodeMappingViewModel Save(EODTypeCodeMappingViewModel EODTypeCodeMapping, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                EODTypeCodeMappingViewModel result = null;

                if (IsValid(EODTypeCodeMapping, out ErrorMessage))
                {
                    result = _EODTypeCodeMappingDAL.Save(EODTypeCodeMapping, out ErrorMessage);
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
        private bool IsValid(EODTypeCodeMappingViewModel EODTypeCodeMapping, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;
            foreach (var i in EODTypeCodeMapping.EODTypeCodeMappingGridData)
            {
                if (i.ServiceId == 0 || i.CategorySystemId == 0)
                {
                    ErrorMessage = "Some fields are incorrect or have not been filled in. Please correct this to proceed.";
                }

                //else if (_EODTypeCodeMappingDAL.IsRoleDuplicate(EODTypeCodeMapping))
                //{
                //    ErrorMessage = "User Role should be unique";
                //}
                //else if (_EODTypeCodeMappingDAL.IsRecordModified(EODTypeCodeMapping))
                //{
                //    ErrorMessage = "Record Modified. Please Re-Select";
                //}
                else
                {
                    isValid = true;
                }
            }
            return isValid;
        }

        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                var result = _EODTypeCodeMappingDAL.GetAll(pageFilter);
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

        public EODTypeCodeMappingViewModel Get(int Id, int pagesize, int pageindex)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _EODTypeCodeMappingDAL.Get(Id, pagesize, pageindex);
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return result;
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }
            catch (Exception ex)
            {
                throw ;
            }
        }

        public void Delete(int Id , out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
                _EODTypeCodeMappingDAL.Delete(Id, out ErrorMessage);
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
