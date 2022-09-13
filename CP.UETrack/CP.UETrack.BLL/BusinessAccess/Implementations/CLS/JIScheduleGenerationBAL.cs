using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.CLS;
using CP.UETrack.DAL.DataAccess.Contracts.CLS;
using CP.UETrack.Model;
using CP.UETrack.Model.CLS;
using System;

namespace CP.UETrack.BLL.BusinessAccess.Implementation.CLS
{
    public class JIScheduleGenerationBAL : IJIScheduleGenerationBAL
    {
        private string _FileName = nameof(JIScheduleGenerationBAL);
        IJIScheduleGenerationDAL _jischedulegenerationDAL;
        public JIScheduleGenerationBAL(IJIScheduleGenerationDAL schedule)
        {
            _jischedulegenerationDAL = schedule;
        }

        public JIDropdowns Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _jischedulegenerationDAL.Load();
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

        public JIDropdowns GetYear()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetYear), Level.Info.ToString());
                var result = _jischedulegenerationDAL.GetYear();
                Log4NetLogger.LogExit(_FileName, nameof(GetYear), Level.Info.ToString());
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

        public JIDropdowns GetMonth(int Year)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetMonth), Level.Info.ToString());
                var result = _jischedulegenerationDAL.GetMonth(Year);
                Log4NetLogger.LogExit(_FileName, nameof(GetMonth), Level.Info.ToString());
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

        public JIDropdowns GetWeek(string YearMonth)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetWeek), Level.Info.ToString());
                var result = _jischedulegenerationDAL.GetWeek(YearMonth);
                Log4NetLogger.LogExit(_FileName, nameof(GetWeek), Level.Info.ToString());
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
                var result = _jischedulegenerationDAL.GetAll(pageFilter);
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
        
        public JIScheduleGeneration Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _jischedulegenerationDAL.Get(Id);
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

        public JIScheduleGeneration UserFetch(JIScheduleGeneration jISchedule)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(UserFetch), Level.Info.ToString());
                JIScheduleGeneration result = null;

                result = _jischedulegenerationDAL.UserFetch(jISchedule);
                Log4NetLogger.LogExit(_FileName, nameof(UserFetch), Level.Info.ToString());
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

        public JIScheduleGeneration Save(JIScheduleGeneration block, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                JIScheduleGeneration result = null;


                result = _jischedulegenerationDAL.Save(block, out ErrorMessage);


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
      
        
        

        

    }
}
