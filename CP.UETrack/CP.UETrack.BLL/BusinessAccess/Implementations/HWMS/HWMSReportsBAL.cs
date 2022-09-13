using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.HWMS;
using CP.UETrack.DAL.DataAccess.Contracts.HWMS;
using CP.UETrack.Model;
using CP.UETrack.Model.HWMS;
using System;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.HWMS
{
    public class HWMSReportsBAL : IHWMSReportsBAL
    {
        private string _FileName = nameof(HWMSReportsBAL);
        IHWMSReportsDAL _HWMSReportsDAL;
        public HWMSReportsBAL(IHWMSReportsDAL HWMSReportsDAL)
        {
            _HWMSReportsDAL = HWMSReportsDAL;
        }

        public ReportsDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                ReportsDropdown result = null;
                result = _HWMSReportsDAL.Load();
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

        public LicenseReport LicenseReportFetch(out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LicenseReportFetch), Level.Info.ToString());

                ErrorMessage = string.Empty;
                LicenseReport result = null;
                result = _HWMSReportsDAL.LicenseReportFetch(out ErrorMessage);
                Log4NetLogger.LogExit(_FileName, nameof(LicenseReportFetch), Level.Info.ToString());
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

        public WeighingSummaryReport WeighingSummaryReportFetch(WeighingSummaryReport report, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(WeighingSummaryReport), Level.Info.ToString());
                ErrorMessage = string.Empty;
                WeighingSummaryReport result = null;
                result = _HWMSReportsDAL.WeighingSummaryReportFetch(report, out ErrorMessage);
                Log4NetLogger.LogExit(_FileName, nameof(WeighingSummaryReport), Level.Info.ToString());
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

        public TransportationReport TransportationReportFetch(TransportationReport report, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(TransportationReportFetch), Level.Info.ToString());
                ErrorMessage = string.Empty;
                TransportationReport result = null;
                result = _HWMSReportsDAL.TransportationReportFetch(report, out ErrorMessage);
                Log4NetLogger.LogExit(_FileName, nameof(TransportationReportFetch), Level.Info.ToString());
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

        public SafetyDataSheetReport SafetyDataSheetReportFetch(SafetyDataSheetReport report, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(SafetyDataSheetReportFetch), Level.Info.ToString());
                ErrorMessage = string.Empty;
                SafetyDataSheetReport result = null;
                result = _HWMSReportsDAL.SafetyDataSheetReportFetch(report, out ErrorMessage);
                Log4NetLogger.LogExit(_FileName, nameof(SafetyDataSheetReportFetch), Level.Info.ToString());
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

        public RecordSheetWithoutCN RecordSheetWithoutCNFetch(RecordSheetWithoutCN report, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(RecordSheetWithoutCNFetch), Level.Info.ToString());
                ErrorMessage = string.Empty;
                RecordSheetWithoutCN result = null;
                result = _HWMSReportsDAL.RecordSheetWithoutCNFetch(report, out ErrorMessage);
                Log4NetLogger.LogExit(_FileName, nameof(RecordSheetWithoutCNFetch), Level.Info.ToString());
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

        public WasteGenerationMonthlyReport WasteGenerationMonthlyReportFetch(WasteGenerationMonthlyReport report, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(WasteGenerationMonthlyReportFetch), Level.Info.ToString());
                ErrorMessage = string.Empty;
                WasteGenerationMonthlyReport result = null;
                result = _HWMSReportsDAL.WasteGenerationMonthlyReportFetch(report, out ErrorMessage);
                Log4NetLogger.LogExit(_FileName, nameof(WasteGenerationMonthlyReportFetch), Level.Info.ToString());
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
                result = _HWMSReportsDAL.CRMReportFetch(report, out ErrorMessage);
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
