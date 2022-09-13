using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.CLS;
using CP.UETrack.DAL.DataAccess.Contracts.CLS;
using CP.UETrack.Model.CLS;
using CP.UETrack.Model;
using System;
using System.Collections.Generic;
using FluentValidation;
using FluentValidation.Internal;
using CP.UETrack.CLS.BusinessAccess.Interface;
using CP.UETrack.Models;
using System.Data.SqlClient;
using UETrack.DAL;
using System.Data;
using System.Linq;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.CLS
{
    public class FETCBAL : IFETCBAL
    {
        private string _FileName = nameof(FETCBAL);
        IFETCDAL _fetcDAL;
        public FETCBAL(IFETCDAL fetc)
        {
            _fetcDAL = fetc;
        }

        public FETCDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _fetcDAL.Load();
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
        public FETC Save(FETC block, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                FETC result = null;


                result = _fetcDAL.Save(block, out ErrorMessage);


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


        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                var result = _fetcDAL.GetAll(pageFilter);
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
        public FETC Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _fetcDAL.Get(Id);
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

        public FETC AutoGenerateCode()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(AutoGenerateCode), Level.Info.ToString());
                var result = _fetcDAL.AutoGenerateCode();
                Log4NetLogger.LogExit(_FileName, nameof(AutoGenerateCode), Level.Info.ToString());
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

