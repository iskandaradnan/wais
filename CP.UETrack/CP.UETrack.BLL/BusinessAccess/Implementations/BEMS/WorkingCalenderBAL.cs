using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.BEMS;
using CP.UETrack.BLL.BusinessAccess.Implementations.BEMS;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.DAL.DataAccess.Implementations.BEMS;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.BEMS
{
   public class WorkingCalenderBAL : IWorkingCalenderBAL
    {
        private readonly IWorkingCalenderDAL _IWorkingCalenderDAL;
        
        private readonly string fileName = nameof(WorkingCalenderBAL);

        public WorkingCalenderBAL(IWorkingCalenderDAL dal)
        {
            _IWorkingCalenderDAL = dal;
           

        }
        #region Load
        public FMWorkingCalendarSelectListViewModel Load(int Year)
        {

            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());
                var result = _IWorkingCalenderDAL.Load(Year);
                Log4NetLogger.LogExit(fileName, nameof(Load), Level.Info.ToString());
                return result;
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }
            catch (Exception ex)
            {
                throw new GeneralException(ex);
            }

        }
        #endregion

        #region Save
        public MstWorkingCalenderModel Save(MstWorkingCalenderModel WorkingCalendar, out string ErrorMessage)
        {

            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                MstWorkingCalenderModel result = null; 
                if (IsValid(WorkingCalendar, out ErrorMessage))
                {
                    result = _IWorkingCalenderDAL.Save(WorkingCalendar);
                }
                
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
        private static bool IsValid(MstWorkingCalenderModel model, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;
            if (model.Year == 0)
            {
                ErrorMessage = "Some fields are incorrect or have not been filled in. Please correct this to proceed.";
            }         
            else
            {
                isValid = true;
            }
            return isValid;
        }
        #endregion

        #region GetWorkingDay
        public IEnumerable<MstWorkingCalenderModel> GetWorkingDay(int intYear, int facilityId)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());
                var result = _IWorkingCalenderDAL.GetWorkingDay(intYear, facilityId);
                Log4NetLogger.LogExit(fileName, nameof(Load), Level.Info.ToString());
                return result;
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }
            catch (Exception ex)
            {
                throw new GeneralException(ex);
            }

        }
        #endregion

    }
}
