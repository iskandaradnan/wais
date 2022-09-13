using FluentValidation;
using FluentValidation.Internal;
using CP.UETrack.CLS.BusinessAccess.Interface;
using CP.UETrack.DAL.DataAccess.Contracts.CLS;
using CP.UETrack.Model.CLS;
using CP.UETrack.Model;
using System;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.UETrack.Models;
using System.Collections.Generic;
using CP.UETrack.BLL.BusinessAccess.Contracts.CLS;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.CLS
{
  public class CLSReportsBAL : ICLSReportsBAL
    {
        private string _FileName = nameof(CLSReportsBAL);
        ICLSReportsDAL _CLSReportsDAL;
        public CLSReportsBAL(ICLSReportsDAL CLSReportsDAL)
        {
            _CLSReportsDAL = CLSReportsDAL;
        }

        public ReportsDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                ReportsDropdown result = null;
                result = _CLSReportsDAL.Load();
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

        public JointInspectionSummaryReport JointInspectionSummaryReportFetch(JointInspectionSummaryReport report, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(JointInspectionSummaryReportFetch), Level.Info.ToString());
                ErrorMessage = string.Empty;
                JointInspectionSummaryReport result = null;
                result = _CLSReportsDAL.JointInspectionSummaryReportFetch(report, out ErrorMessage);
                Log4NetLogger.LogExit(_FileName, nameof(JointInspectionSummaryReportFetch), Level.Info.ToString());
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

        public DailyCleaningActivitySummaryReport DailyCleaningActivitySummaryReportFetch(DailyCleaningActivitySummaryReport report, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(DailyCleaningActivitySummaryReportFetch), Level.Info.ToString());

                ErrorMessage = string.Empty;
                DailyCleaningActivitySummaryReport result = null;
                result = _CLSReportsDAL.DailyCleaningActivitySummaryReportFetch(report, out ErrorMessage);
                Log4NetLogger.LogExit(_FileName, nameof(DailyCleaningActivitySummaryReportFetch), Level.Info.ToString());
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

        public EquipmentReport EquipmentReportFetch(EquipmentReport report, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(EquipmentReportFetch), Level.Info.ToString());
                ErrorMessage = string.Empty;
                EquipmentReport result = null;
                result = _CLSReportsDAL.EquipmentReportFetch(report, out ErrorMessage);
                Log4NetLogger.LogExit(_FileName, nameof(EquipmentReportFetch), Level.Info.ToString());
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
             
        public PeriodicWorkRecordSummaryReport PeriodicWorkRecordSummaryReportFetch(PeriodicWorkRecordSummaryReport report, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(PeriodicWorkRecordSummaryReportFetch), Level.Info.ToString());

                ErrorMessage = string.Empty;
                PeriodicWorkRecordSummaryReport result = null;
                result = _CLSReportsDAL.PeriodicWorkRecordSummaryReportFetch(report, out ErrorMessage);
                Log4NetLogger.LogExit(_FileName, nameof(PeriodicWorkRecordSummaryReportFetch), Level.Info.ToString());
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

        public ToiletInspectionSummaryReport ToiletInspectionSummaryReportFetch(ToiletInspectionSummaryReport report, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ToiletInspectionSummaryReportFetch), Level.Info.ToString());

                ErrorMessage = string.Empty;
                ToiletInspectionSummaryReport result = null;
                result = _CLSReportsDAL.ToiletInspectionSummaryReportFetch(report, out ErrorMessage);
                Log4NetLogger.LogExit(_FileName, nameof(ToiletInspectionSummaryReportFetch), Level.Info.ToString());
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

        public ChemicalUsedReport ChemicalUsedReportFetch(ChemicalUsedReport report, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ChemicalUsedReportFetch), Level.Info.ToString());

                ErrorMessage = string.Empty;
                ChemicalUsedReport result = null;
                result = _CLSReportsDAL.ChemicalUsedReportFetch(report, out ErrorMessage);
                Log4NetLogger.LogExit(_FileName, nameof(ChemicalUsedReportFetch), Level.Info.ToString());
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

        public CRMReport CRMReportFetch(CRMReport report, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(CRMReportFetch), Level.Info.ToString());

                ErrorMessage = string.Empty;
                CRMReport result = null;
                result = _CLSReportsDAL.CRMReportFetch(report, out ErrorMessage);
                Log4NetLogger.LogExit(_FileName, nameof(CRMReportFetch), Level.Info.ToString());
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
