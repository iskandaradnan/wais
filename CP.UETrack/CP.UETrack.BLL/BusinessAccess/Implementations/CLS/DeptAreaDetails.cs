using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.CLS;
using CP.UETrack.CLS.BusinessAccess.Interface;
using CP.UETrack.DAL.DataAccess.Contracts.CLS;
using CP.UETrack.Model;
using CP.UETrack.Model.CLS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess
{
    public class DeptAreaDetailsBAL : IDeptAreaDetailsBAL
    {
        private string _FileName = nameof(BlockBAL);
        IDeptAreaDetailsDAL _deptAreaDetailsDAL;
        public DeptAreaDetailsBAL(IDeptAreaDetailsDAL deptAreaDetails)
        {
            _deptAreaDetailsDAL = deptAreaDetails;

        }

        public DeptAreaDetailsDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _deptAreaDetailsDAL.Load();
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

        public DeptAreaDetails Save(DeptAreaDetails block, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                DeptAreaDetails result = null;


                result = _deptAreaDetailsDAL.Save(block, out ErrorMessage);


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

        public Receptacles SaveRecp(Receptacles _receptacles, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(SaveRecp), Level.Info.ToString());

                ErrorMessage = string.Empty;
                Receptacles result = null;
                result = _deptAreaDetailsDAL.SaveReceptacles(_receptacles, out ErrorMessage);

                Log4NetLogger.LogExit(_FileName, nameof(SaveRecp), Level.Info.ToString());
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

        public DailyCleaningSchedule SaveDailyClean(DailyCleaningSchedule _dailyCleaning, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(SaveDailyClean), Level.Info.ToString());

                ErrorMessage = string.Empty;
                DailyCleaningSchedule result = null;

                result = _deptAreaDetailsDAL.SaveDailyClean(_dailyCleaning, out ErrorMessage);


                Log4NetLogger.LogExit(_FileName, nameof(SaveDailyClean), Level.Info.ToString());
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

        public PeriodicWorkSchedule SavePeriodicWork(PeriodicWorkSchedule _periodicWorkSchedule, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(SavePeriodicWork), Level.Info.ToString());
                ErrorMessage = string.Empty;
                
                var result = _deptAreaDetailsDAL.SavePeriodicWork(_periodicWorkSchedule, out ErrorMessage);
                Log4NetLogger.LogExit(_FileName, nameof(SavePeriodicWork), Level.Info.ToString());
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

        public List<Toilet> SaveToilet(List<Toilet> _lsttoilet, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(SaveToilet), Level.Info.ToString());
                ErrorMessage = string.Empty; 
                var result = _deptAreaDetailsDAL.SaveToilet(_lsttoilet, out ErrorMessage);

                Log4NetLogger.LogExit(_FileName, nameof(SaveToilet), Level.Info.ToString());
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

        public Dispenser SaveDispenser(Dispenser _dispenser, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(SaveDispenser), Level.Info.ToString());

                ErrorMessage = string.Empty;
                Dispenser result = null;

                result = _deptAreaDetailsDAL.SaveDispenser(_dispenser, out ErrorMessage);


                Log4NetLogger.LogExit(_FileName, nameof(SaveDispenser), Level.Info.ToString());
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

        public List<VariationDetails> SaveVariationDetails(List<VariationDetails> _lstVariationDetails, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(SaveVariationDetails), Level.Info.ToString());
                ErrorMessage = string.Empty;
                var result = _deptAreaDetailsDAL.SaveVariationDetails(_lstVariationDetails, out ErrorMessage);

                Log4NetLogger.LogExit(_FileName, nameof(SaveVariationDetails), Level.Info.ToString());
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
                var result = _deptAreaDetailsDAL.GetAll(pageFilter);
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

        public DeptAreaDetails Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _deptAreaDetailsDAL.Get(Id);
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

        public DeptAreaDetails UserAreaCodeFetch(DeptAreaDetails areaDetails)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(UserAreaCodeFetch), Level.Info.ToString());
                DeptAreaDetails result = null;

                result = _deptAreaDetailsDAL.UserAreaCodeFetch(areaDetails);
                Log4NetLogger.LogExit(_FileName, nameof(UserAreaCodeFetch), Level.Info.ToString());
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
