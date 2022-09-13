using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.Home;
using CP.UETrack.DAL.DataAccess.Contracts.Home;
using CP.UETrack.Model.Home;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.Home
{
    public class DashboardBAL : IDashboardBAL
    {
        private string _FileName = nameof(DashboardBAL);
        IDashboardDAL _DashboardDALL;
        public DashboardBAL(IDashboardDAL DashboardDAL)
        {
            _DashboardDALL = DashboardDAL;
        }


        public permission DashboardPermission(int USerId, int FacilityId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LoadWorkorderChart), Level.Info.ToString());
                var result = _DashboardDALL.DashboardPermission(USerId, FacilityId);
                Log4NetLogger.LogExit(_FileName, nameof(LoadWorkorderChart), Level.Info.ToString());
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
        public BMWorkorder LoadWorkorderChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId , int UserId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LoadWorkorderChart), Level.Info.ToString());
                var result = _DashboardDALL.LoadWorkorderChart(StartYear, StartMonth, EndYear, EndMonth, FacilityId, UserId);
                Log4NetLogger.LogExit(_FileName, nameof(LoadWorkorderChart), Level.Info.ToString());
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

        public PPMWorkorder LoadPPMWorkOrderChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId , int UserId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LoadPPMWorkOrderChart), Level.Info.ToString());
                var result = _DashboardDALL.LoadPPMWorkOrderChart(StartYear, StartMonth, EndYear, EndMonth, FacilityId, UserId);
                Log4NetLogger.LogExit(_FileName, nameof(LoadPPMWorkOrderChart), Level.Info.ToString());
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

        public HomeDashboard LoadMaintCostChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LoadMaintCostChart), Level.Info.ToString());
                var result = _DashboardDALL.LoadMaintCostChart(StartYear, StartMonth, EndYear, EndMonth, FacilityId);
                Log4NetLogger.LogExit(_FileName, nameof(LoadMaintCostChart), Level.Info.ToString());
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

        public KPIChart LoadKPIChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId, int UserId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LoadKPIChart), Level.Info.ToString());
                var result = _DashboardDALL.LoadKPIChart(StartYear, StartMonth, EndYear, EndMonth, FacilityId, UserId);
                Log4NetLogger.LogExit(_FileName, nameof(LoadKPIChart), Level.Info.ToString());
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

        public HomeDashboard LoadEquipUptimeChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LoadEquipUptimeChart), Level.Info.ToString());
                var result = _DashboardDALL.LoadEquipUptimeChart(StartYear, StartMonth, EndYear, EndMonth, FacilityId);
                Log4NetLogger.LogExit(_FileName, nameof(LoadEquipUptimeChart), Level.Info.ToString());
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

        public KPITarget LoadKPITargetChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId, int UserId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LoadKPITargetChart), Level.Info.ToString());
                var result = _DashboardDALL.LoadKPITargetChart(StartYear, StartMonth, EndYear, EndMonth, FacilityId, UserId);
                Log4NetLogger.LogExit(_FileName, nameof(LoadKPITargetChart), Level.Info.ToString());
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

        public Deduction LoadDeductionChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId, int UserId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LoadDeductionChart), Level.Info.ToString());
                var result = _DashboardDALL.LoadDeductionChart(StartYear, StartMonth, EndYear, EndMonth, FacilityId, UserId);
                Log4NetLogger.LogExit(_FileName, nameof(LoadDeductionChart), Level.Info.ToString());
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

        public AssetCategory LoadAssetCategoryChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId, int UserId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LoadAssetCategoryChart), Level.Info.ToString());
                var result = _DashboardDALL.LoadAssetCategoryChart(StartYear, StartMonth, EndYear, EndMonth, FacilityId, UserId);
                Log4NetLogger.LogExit(_FileName, nameof(LoadAssetCategoryChart), Level.Info.ToString());
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

        public AssetWarranty LoadAssetWarrantyChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId, int UserId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LoadAssetWarrantyChart), Level.Info.ToString());
                var result = _DashboardDALL.LoadAssetWarrantyChart(StartYear, StartMonth, EndYear, EndMonth, FacilityId, UserId);
                Log4NetLogger.LogExit(_FileName, nameof(LoadAssetWarrantyChart), Level.Info.ToString());
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

        public BERAsset LoadBERAssetChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId , int UserId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LoadBERAssetChart), Level.Info.ToString());
                var result = _DashboardDALL.LoadBERAssetChart(StartYear, StartMonth, EndYear, EndMonth, FacilityId, UserId);
                Log4NetLogger.LogExit(_FileName, nameof(LoadBERAssetChart), Level.Info.ToString());
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

        public ExpiryAlert LoadExpiryAlertChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId, int UserId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LoadExpiryAlertChart), Level.Info.ToString());
                var result = _DashboardDALL.LoadExpiryAlertChart(StartYear, StartMonth, EndYear, EndMonth, FacilityId, UserId);
                Log4NetLogger.LogExit(_FileName, nameof(LoadExpiryAlertChart), Level.Info.ToString());
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

        public HomeDashboard LoadContChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LoadContChart), Level.Info.ToString());
                var result = _DashboardDALL.LoadContChart(StartYear, StartMonth, EndYear, EndMonth, FacilityId);
                Log4NetLogger.LogExit(_FileName, nameof(LoadContChart), Level.Info.ToString());
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
