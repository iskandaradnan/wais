using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.BEMS;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using CP.UETrack.Model.ICT;
using System;
using System.Collections.Generic;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.BEMS
{
    public class ScheduleGenerationBAL : IScheduleGenerationBAL
    {
        #region Ctor/init
        private readonly IScheduleGenerationDAL _ScheduleGenerationDAL;
        private readonly static string fileName = nameof(PPMPlannerBAL);
        public ScheduleGenerationBAL(IScheduleGenerationDAL dal)
        {
            _ScheduleGenerationDAL = dal;

        }
        #endregion
        public ScheduleGenerationLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());
                var result = _ScheduleGenerationDAL.Load();
                Log4NetLogger.LogExit(fileName, nameof(Load), Level.Info.ToString());
                return result;

            }
            catch (BALException bx)
            {
                throw new BALException(bx);
            }
            catch (Exception ex)
            {
                throw new BALException(ex);
            }
        }

        public ScheduleGenerationModel Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var result = _ScheduleGenerationDAL.Get(Id);
                Log4NetLogger.LogExit(fileName, nameof(Get), Level.Info.ToString());
                return result;

            }
            catch (BALException bx)
            {
                throw new BALException(bx);
            }
            catch (Exception ex)
            {
                throw new BALException(ex);
            }
        }
        public List<workorde_week> getby_year(int Id,int WorkGroup, int week, int serviceId, int typeofplanner)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(getby_year), Level.Info.ToString());
                var result = _ScheduleGenerationDAL.getby_year(Id, WorkGroup,week,serviceId,typeofplanner);
                Log4NetLogger.LogExit(fileName, nameof(getby_year), Level.Info.ToString());
                return result;

            }
            catch (BALException bx)
            {
                throw new BALException(bx);
            }
            catch (Exception ex)
            {
                throw new BALException(ex);
            }
        }
        public ScheduleGenerationModel Save(ScheduleGenerationModel obj, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                ScheduleGenerationModel result = null;

                //if (IsValid(obj, out ErrorMessage))
                //{
                    result = _ScheduleGenerationDAL.Save(obj);
                //}
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

        public ScheduleGenerationModel Fetch(int Service, int WorkGroup, int Year, string TOP, string StartDate, string EndDate, int WeekNo, string Type, string UserAreaId, string UserLocationId , int pagesize, int pageindex)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var result = _ScheduleGenerationDAL.Fetch(Service, WorkGroup, Year, TOP , StartDate , EndDate , WeekNo , Type, UserAreaId, UserLocationId, pagesize, pageindex);
                Log4NetLogger.LogExit(fileName, nameof(Get), Level.Info.ToString());
                return result;

            }
            catch (BALException bx)
            {
                throw new BALException(bx);
            }
            catch (Exception ex)
            {
                throw new BALException(ex);
            }
        }

        public ScheduleGenerationModel GetWeekNo(int Service, int WorkGroup, int Year, int TOP)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var result = _ScheduleGenerationDAL.GetWeekNo(Service, WorkGroup, Year, TOP);
                Log4NetLogger.LogExit(fileName, nameof(Get), Level.Info.ToString());
                return result;

            }
            catch (BALException bx)
            {
                throw new BALException(bx);
            }
            catch (Exception ex)
            {
                throw new BALException(ex);
            }
        }

        public bool Delete(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var result = _ScheduleGenerationDAL.Delete(Id);
                Log4NetLogger.LogExit(fileName, nameof(Get), Level.Info.ToString());
                return result;

            }
            catch (BALException bx)
            {
                throw new BALException(bx);
            }
            catch (Exception ex)
            {
                throw new BALException(ex);
            }
        }
        private static bool IsValid(ScheduleGenerationModel model, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;
            //if (model.AssetTypeCodeId == 0 || model.AssetTypeCodeId == null)

            //{
            //    ErrorMessage = "Some fields are incorrect or have not been filled in. Please correct this to proceed.";
            //}
            //else if (_assetClassificationDAL.IsClassificationCodeDuplicate(model))
            //{
            //    ErrorMessage = "Asset Classication Code should be unique";
            //}
            //else if (_assetClassificationDAL.IsRecordModified(model))
            //{
            //    ErrorMessage = "Record Modified. Please Re-Select";
            //}
            //else
            //{
            //    isValid = true;
            //}
            return isValid;
        }


        public List<EngScheduleGenerationFileJobViewModel> GetPrintList(EngPpmScheduleGenTxnViewModel schedule)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(GetPrintList), Level.Info.ToString());
                return _ScheduleGenerationDAL.GetPrintList(schedule);
                Log4NetLogger.LogExit(fileName, nameof(GetPrintList), Level.Info.ToString());
            }
            catch (ServiceException serviceException)
            {
                throw new ServiceException(serviceException);
            }
            catch (Exception ex)
            {
                throw new GeneralException(ex);
            }
        }


        public List<EngPpmPrintlist> PrintPDF(EngPpmScheduleGenTxnViewModel schedule)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(PrintPDF), Level.Info.ToString());
                return _ScheduleGenerationDAL.PrintPDF(schedule);
                Log4NetLogger.LogExit(fileName, nameof(PrintPDF), Level.Info.ToString());
            }
            catch (ServiceException serviceException)
            {
                throw new ServiceException(serviceException);
            }
            catch (Exception ex)
            {
                throw new GeneralException(ex);
            }
        }
    }
}
