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
    public class EODCategorySystemBAL : IEODCategorySystemBAL
    {
        private string _FileName = nameof(EODCategorySystemBAL);
        IEODCategorySystemDAL _EODCategorySystemDAL;
        public EODCategorySystemBAL(IEODCategorySystemDAL EODCategorySystemDAL)
        {
            _EODCategorySystemDAL = EODCategorySystemDAL;
        }
        public EODCategorySystemViewModel Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _EODCategorySystemDAL.Load();
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
        public EODCategorySystemViewModel Save(EODCategorySystemViewModel EODCategorySystem, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                EODCategorySystemViewModel result = null;

                //if (IsValid(EODCategorySystem, out ErrorMessage))
                //{
                    result = _EODCategorySystemDAL.Save(EODCategorySystem, out  ErrorMessage);
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
        private bool IsValid(EODCategorySystemViewModel EODCategorySystem, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;

            if (string.IsNullOrEmpty(EODCategorySystem.CategorySystemName))
            {
                ErrorMessage = "Some fields are incorrect or have not been filled in. Please correct this to proceed.";
            }
            else if (_EODCategorySystemDAL.IsRoleDuplicate(EODCategorySystem))
            {
                ErrorMessage = "User Role should be unique";
            }
            else if (_EODCategorySystemDAL.IsRecordModified(EODCategorySystem))
            {
                ErrorMessage = "Record Modified. Please Re-Select";
            }
            else
            {
                isValid = true;
            }
            return isValid;
        }

        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                var result = _EODCategorySystemDAL.GetAll(pageFilter);
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

        public EODCategorySystemViewModel Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _EODCategorySystemDAL.Get(Id);
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return result;
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public void Delete(int Id, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
                _EODCategorySystemDAL.Delete(Id, out ErrorMessage);
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
