using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.Home;
using CP.UETrack.Model;
using CP.UETrack.Model.Home;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UETrack.DAL;

namespace CP.UETrack.DAL.DataAccess.Implementations.Home
{
    public class HomeDashboardDAL : IHomeDashboardDAL
    {
        private readonly string _FileName = nameof(HomeDashboardDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public HomeDashboardDAL()
        {

        }
        public HomeDashboard LoadWorkorderChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(LoadWorkorderChart), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                HomeDashboard entity = new HomeDashboard();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pStartDateYear", StartYear.ToString());
                parameters.Add("@pStartDateMonth", StartMonth.ToString());
                parameters.Add("@pEndDateYear", EndYear.ToString());
                parameters.Add("@pEndDateMonth", EndMonth.ToString());
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));

                DataSet dt = dbAccessDAL.GetDataSet("uspFM_Home_DashBoard_WorkOrder", parameters, DataSetparameters);
                if (dt != null && dt.Tables[0].Rows.Count > 0)
                {

                    entity.WorkorderChartData = (from n in dt.Tables[0].AsEnumerable()
                                                 select new WorkorderChart
                                                 {
                                                     WorkOrdStatusId = Convert.ToInt32(n["ID"]),
                                                     WorkOrdStatus = Convert.ToString(n["NAME"]),
                                                     Count = Convert.ToInt32(n["COUNTVALUE"]),
                                                 }).ToList();

                }
                return entity;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public HomeDashboard LoadMaintCostChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(LoadWorkorderChart), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                HomeDashboard entity = new HomeDashboard();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pStartDateYear", StartYear.ToString());
                parameters.Add("@pStartDateMonth", StartMonth.ToString());
                parameters.Add("@pEndDateYear", EndYear.ToString());
                parameters.Add("@pEndDateMonth", EndMonth.ToString());
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));

                DataSet dt = dbAccessDAL.GetDataSet("uspFM_Home_DashBoard_MaintenanceCost", parameters, DataSetparameters);
                if (dt != null && dt.Tables[0].Rows.Count > 0)
                {

                    entity.MaintenanceCostChartData = (from n in dt.Tables[0].AsEnumerable()
                                                       select new MaintenanceCostChart
                                                       {                                                          
                                                           MaintenCat = Convert.ToString(n["NAME"]),
                                                           Cost = Convert.ToDecimal(n["COUNTVALUE"])
                                                       }).ToList();

                }
                return entity;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public HomeDashboard LoadEquipUptimeChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(LoadEquipUptimeChart), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                HomeDashboard entity = new HomeDashboard();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pStartDateYear", StartYear.ToString());
                parameters.Add("@pStartDateMonth", StartMonth.ToString());
                parameters.Add("@pEndDateYear", EndYear.ToString());
                parameters.Add("@pEndDateMonth", EndMonth.ToString());
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));

                DataSet dt = dbAccessDAL.GetDataSet("uspFM_Home_DashBoard_EquipmentUptime", parameters, DataSetparameters);
                if (dt != null && dt.Tables[0].Rows.Count > 0)
                {

                    entity.EquipmentUptimeChartData = (from n in dt.Tables[0].AsEnumerable()
                                                       select new EquipmentUptimeChart
                                                       {
                                                           EquipCatId = Convert.ToInt32(n["ID"]),
                                                           EquipCat = Convert.ToString(n["NAME"]),
                                                           Count = Convert.ToInt32(n["COUNTVALUE"]),

                                                       }).ToList();

                }
                return entity;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public HomeDashboard LoadAssetChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(LoadAssetChart), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                HomeDashboard entity = new HomeDashboard();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pStartDateYear", StartYear.ToString());
                parameters.Add("@pStartDateMonth", StartMonth.ToString());
                parameters.Add("@pEndDateYear", EndYear.ToString());
                parameters.Add("@pEndDateMonth", EndMonth.ToString());
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));

                DataSet dt = dbAccessDAL.GetDataSet("uspFM_Home_DashBoard_Asset", parameters, DataSetparameters);
                if (dt != null && dt.Tables[0].Rows.Count > 0)
                {

                    entity.AssetChartData = (from n in dt.Tables[0].AsEnumerable()
                                             select new AssetChart
                                             {
                                                 AssetStatus = Convert.ToString(n["NAME"]),
                                                 Count = Convert.ToInt32(n["COUNTVALUE"]),

                                             }).ToList();

                }
                return entity;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public HomeDashboard LoadAssetAgeChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(LoadAssetAgeChart), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                HomeDashboard entity = new HomeDashboard();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pStartDateYear", StartYear.ToString());
                parameters.Add("@pStartDateMonth", StartMonth.ToString());
                parameters.Add("@pEndDateYear", EndYear.ToString());
                parameters.Add("@pEndDateMonth", EndMonth.ToString());
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));

                DataSet dt = dbAccessDAL.GetDataSet("uspFM_Home_DashBoard_AssetAge", parameters, DataSetparameters);
                if (dt != null && dt.Tables[0].Rows.Count > 0)
                {

                    entity.AssetAgeChartData = (from n in dt.Tables[0].AsEnumerable()
                                              select new AssetAgeChart
                                              {
                                                  AgeGroupId = Convert.ToInt32(n["AgeGroupId"]),
                                                  AgeGroup = Convert.ToString(n["Group_asset_age"]),
                                                  Count = Convert.ToInt32(n["COUNTVALUE"]),
                                              }).ToList();

                }
                return entity;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public HomeDashboard LoadContChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(LoadContChart), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                HomeDashboard entity = new HomeDashboard();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pStartDateYear", StartYear.ToString());
                parameters.Add("@pStartDateMonth", StartMonth.ToString());
                parameters.Add("@pEndDateYear", EndYear.ToString());
                parameters.Add("@pEndDateMonth", EndMonth.ToString());
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));

                DataSet dt = dbAccessDAL.GetDataSet("uspFM_Home_DashBoard_Contract", parameters, DataSetparameters);
                if (dt != null && dt.Tables[0].Rows.Count > 0)
                {

                    entity.ContractorChartData = (from n in dt.Tables[0].AsEnumerable()
                                                  select new ContractorChart
                                                  {
                                                      ConStatus = Convert.ToString(n["CONTRACTSTATUS"]),
                                                      Count = Convert.ToInt32(n["COUNTVALUE"]),
                                                  }).ToList();

                }
                return entity;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

    }
}
