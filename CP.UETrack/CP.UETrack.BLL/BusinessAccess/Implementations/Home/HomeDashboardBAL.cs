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
    public class HomeDashboardBAL : IHomeDashboardBAL
    {
        private string _FileName = nameof(HomeDashboardBAL);
        IHomeDashboardDAL _HomeDashboardDALL;
        public HomeDashboardBAL(IHomeDashboardDAL HomeDashboardDAL)
        {
            _HomeDashboardDALL = HomeDashboardDAL;
        }

        public HomeDashboard LoadWorkorderChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LoadWorkorderChart), Level.Info.ToString());
                var result = _HomeDashboardDALL.LoadWorkorderChart(StartYear, StartMonth, EndYear, EndMonth, FacilityId);
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

        public HomeDashboard LoadMaintCostChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LoadMaintCostChart), Level.Info.ToString());
                var result = _HomeDashboardDALL.LoadMaintCostChart(StartYear, StartMonth, EndYear, EndMonth, FacilityId);
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

        public HomeDashboard LoadEquipUptimeChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LoadEquipUptimeChart), Level.Info.ToString());
                var result = _HomeDashboardDALL.LoadEquipUptimeChart(StartYear, StartMonth, EndYear, EndMonth, FacilityId);
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

        public HomeDashboard LoadAssetChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LoadAssetChart), Level.Info.ToString());
                var result = _HomeDashboardDALL.LoadAssetChart(StartYear, StartMonth, EndYear, EndMonth, FacilityId);
                Log4NetLogger.LogExit(_FileName, nameof(LoadAssetChart), Level.Info.ToString());
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

        public HomeDashboard LoadAssetAgeChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LoadAssetAgeChart), Level.Info.ToString());
                var result = _HomeDashboardDALL.LoadAssetAgeChart(StartYear, StartMonth, EndYear, EndMonth, FacilityId);
                Log4NetLogger.LogExit(_FileName, nameof(LoadAssetAgeChart), Level.Info.ToString());
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
                var result = _HomeDashboardDALL.LoadContChart(StartYear, StartMonth, EndYear, EndMonth, FacilityId);
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
