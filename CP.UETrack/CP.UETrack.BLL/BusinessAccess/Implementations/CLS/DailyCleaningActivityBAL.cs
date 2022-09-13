﻿using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.CLS;
using CP.UETrack.DAL.DataAccess.Contracts.CLS;
using CP.UETrack.Model;
using CP.UETrack.Model.CLS;
using System;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.CLS
{
    public class DailyCleaningActivityBAL: IDailyCleaningActivityBAL
    {
        private string _FileName = nameof(BlockBAL);
        IDailyCleaningActivityDAL _dailyCleaningActivityDAL;
        public DailyCleaningActivityBAL(IDailyCleaningActivityDAL dailyCleaningActivityDAL)
        {
            _dailyCleaningActivityDAL = dailyCleaningActivityDAL;
        }
        public DailyCleaningActivityDropDown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _dailyCleaningActivityDAL.Load();
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

        public DailyCleaningActivity AutoGeneratedCode()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(AutoGeneratedCode), Level.Info.ToString());
                var result = _dailyCleaningActivityDAL.AutoGeneratedCode();
                Log4NetLogger.LogExit(_FileName, nameof(AutoGeneratedCode), Level.Info.ToString());
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

        public DailyCleaningActivity Save(DailyCleaningActivity model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                DailyCleaningActivity result = null;


                result = _dailyCleaningActivityDAL.Save(model, out ErrorMessage);


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
                var result = _dailyCleaningActivityDAL.GetAll(pageFilter);
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

        public DailyCleaningActivity Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _dailyCleaningActivityDAL.Get(Id);
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
        public DailyCleaningActivity DocFetch(DailyCleaningActivity dailyCleaning)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(DocFetch), Level.Info.ToString());
                DailyCleaningActivity result = null;

                result = _dailyCleaningActivityDAL.DocFetch(dailyCleaning);
                Log4NetLogger.LogExit(_FileName, nameof(DocFetch), Level.Info.ToString());
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
