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
using static CP.UETrack.Model.Home.permission;

namespace CP.UETrack.DAL.DataAccess.Implementations.Home
{
    public class DashboardDAL : IDashboardDAL
    {
        private readonly string _FileName = nameof(DashboardDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public DashboardDAL()
        {

        }

        public permission DashboardPermission(int UserId, int FacilityId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(DashboardPermission), Level.Info.ToString());
            try
            {

                var dbAccessDAL = new MASTERDBAccessDAL();

                permission entity = new permission();

                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@Id", Convert.ToString(_UserSession.UserId));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                DataSet dt = dbAccessDAL.MasterGetDataSet("uspFM_GetCharts", parameters, DataSetparameters);
                {
                    
                    var griddata = (from n in dt.Tables[0].AsEnumerable()
                                    select new permissionChart
                                    {

                                       // ScreenId = Convert.ToInt32(n["AssetId"]),
                                        ScreenName = Convert.ToString(n["ScreenName"]),
                                        
                                    }).ToList();

                    
                    if (griddata != null && griddata.Count > 0)
                    {
                        entity.permissionChartData = griddata;
                    }

                }

                Log4NetLogger.LogExit(_FileName, nameof(DashboardPermission), Level.Info.ToString());
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
        public BMWorkorder LoadWorkorderChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId, int UserId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(LoadWorkorderChart), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new MASTERDBAccessDAL();
                BMWorkorder entity = new BMWorkorder();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pStartDateYear", StartYear.ToString());
                parameters.Add("@pStartDateMonth", StartMonth.ToString());
                parameters.Add("@pEndDateYear", EndYear.ToString());
                parameters.Add("@pEndDateMonth", EndMonth.ToString());
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));

                DataSet dt = dbAccessDAL.MasterGetDataSet("uspFM_Home_DashBoard_WorkOrder_BDM", parameters, DataSetparameters);
                if (dt != null && dt.Tables[0].Rows.Count > 0)
                {

                    entity.BMWorkorderChartData = (from n in dt.Tables[0].AsEnumerable()
                                                 select new BMWorkorderChart
                                                 {
                                                     WorkOrdStatusId = Convert.ToInt32(n["ID"]),
                                                     WorkOrdStatus = Convert.ToString(n["NAME"]),
                                                     Count = Convert.ToInt32(n["COUNTVALUE"]),
                                                     Percentage = Convert.ToDecimal(n["PERVALUE"]),
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
        public PPMWorkorder LoadPPMWorkOrderChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId, int UserId )
        {
            Log4NetLogger.LogEntry(_FileName, nameof(LoadPPMWorkOrderChart), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new MASTERDBAccessDAL();
                PPMWorkorder entity = new PPMWorkorder();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pStartDateYear", StartYear.ToString());
                parameters.Add("@pStartDateMonth", StartMonth.ToString());
                parameters.Add("@pEndDateYear", EndYear.ToString());
                parameters.Add("@pEndDateMonth", EndMonth.ToString());
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));

                DataSet dt = dbAccessDAL.MasterGetDataSet("uspFM_Home_DashBoard_WorkOrder_PPM", parameters, DataSetparameters);
                if (dt != null && dt.Tables[0].Rows.Count > 0)
                {

                    entity.PPMWorkorderChartData = (from n in dt.Tables[0].AsEnumerable()
                                                 select new PPMWorkorderChart
                                                 {
                                                     WorkOrdStatusId = Convert.ToInt32(n["ID"]),
                                                     WorkOrdStatus = Convert.ToString(n["NAME"]),
                                                     Count = Convert.ToInt32(n["COUNTVALUE"]),
                                                     Percentage = Convert.ToDecimal(n["PERVALUE"]),
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
                var dbAccessDAL = new MASTERDBAccessDAL();
                HomeDashboard entity = new HomeDashboard();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pStartDateYear", StartYear.ToString());
                parameters.Add("@pStartDateMonth", StartMonth.ToString());
                parameters.Add("@pEndDateYear", EndYear.ToString());
                parameters.Add("@pEndDateMonth", EndMonth.ToString());
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));

                DataSet dt = dbAccessDAL.MasterGetDataSet("uspFM_Home_DashBoard_MaintenanceCost", parameters, DataSetparameters);
                if (dt != null && dt.Tables[0].Rows.Count > 0)
                {
                    entity.CurrencyFormat = _UserSession.Currency;
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

        public KPIChart LoadKPIChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId , int UserId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(LoadKPIChart), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new MASTERDBAccessDAL();
                KPIChart entity = new KPIChart();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pStartDateYear", StartYear.ToString());
                parameters.Add("@pStartDateMonth", StartMonth.ToString());
                parameters.Add("@pEndDateYear", EndYear.ToString());
                parameters.Add("@pEndDateMonth", EndMonth.ToString());
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));

                DataSet dt = dbAccessDAL.MasterGetDataSet("uspFM_Home_DashBoard_KPIPer", parameters, DataSetparameters);
                if (dt != null && dt.Tables[0].Rows.Count > 0)
                {

                    entity.KPIChartValueData = (from n in dt.Tables[0].AsEnumerable()
                                                       select new KPIChartValue
                                                       {
                                                          
                                                           KPIName = Convert.ToString(n["NAME"]),
                                                           Cost = Convert.ToInt32(n["DeductionValue"]),
                                                           KPIPerc = Convert.ToDecimal(n["DeductionPercentage"]),

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
                var dbAccessDAL = new MASTERDBAccessDAL();
                HomeDashboard entity = new HomeDashboard();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pStartDateYear", StartYear.ToString());
                parameters.Add("@pStartDateMonth", StartMonth.ToString());
                parameters.Add("@pEndDateYear", EndYear.ToString());
                parameters.Add("@pEndDateMonth", EndMonth.ToString());
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));

                DataSet dt = dbAccessDAL.MasterGetDataSet("uspFM_Home_DashBoard_EquipmentUptime", parameters, DataSetparameters);
                if (dt != null && dt.Tables[0].Rows.Count > 0)
                {

                    entity.EquipmentUptimeChartData = (from n in dt.Tables[0].AsEnumerable()
                                                       select new EquipmentUptimeChart
                                                       {
                                                           EquipCatId = Convert.ToInt32(n["ID"]),
                                                           EquipCat = Convert.ToString(n["NAME"]),
                                                           Count = Convert.ToInt32(n["COUNTVALUE"]),
                                                           Percentage = Convert.ToDecimal(n["PERVALUE"]),

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

        

        public Deduction LoadDeductionChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId, int UserId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(LoadDeductionChart), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new MASTERDBAccessDAL();
                Deduction entity = new Deduction();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pStartDateYear", StartYear.ToString());
                parameters.Add("@pStartDateMonth", StartMonth.ToString());
                parameters.Add("@pEndDateYear", EndYear.ToString());
                parameters.Add("@pEndDateMonth", EndMonth.ToString());
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));

                DataSet dt = dbAccessDAL.MasterGetDataSet("uspFM_Home_DashBoard_DeductionRevenueList", parameters, DataSetparameters);
                if (dt != null && dt.Tables[0].Rows.Count > 0)
                {

                    entity.DeductionChartData = (from n in dt.Tables[0].AsEnumerable()
                                                       select new DeductionChart
                                                       {
                                                           Name = Convert.ToString(n["Name"]),
                                                           //MSFCost = Convert.ToDecimal(n["BemsMSF"]),
                                                           //CFCost = Convert.ToDecimal(n["BemsCF"]),
                                                           //KPIFCost = Convert.ToDecimal(n["BemsKPIF"]),
                                                           Cost = Convert.ToDecimal(n["countValues"]),
                                                          // Percentage = Convert.ToDecimal(n["Percentage"]),

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

        public AssetCategory LoadAssetCategoryChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId, int UserId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(LoadAssetCategoryChart), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new MASTERDBAccessDAL();
                AssetCategory entity = new AssetCategory();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pStartDateYear", StartYear.ToString());
                parameters.Add("@pStartDateMonth", StartMonth.ToString());
                parameters.Add("@pEndDateYear", EndYear.ToString());
                parameters.Add("@pEndDateMonth", EndMonth.ToString());
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));

                DataSet dt = dbAccessDAL.MasterGetDataSet("uspFM_Home_DashBoard_AssetClassificationList", parameters, DataSetparameters);
                if (dt != null && dt.Tables[0].Rows.Count > 0)
                {

                    entity.AssetCategoryChartData = (from n in dt.Tables[0].AsEnumerable()
                                                 select new AssetCategoryChart
                                                 {
                                                     category = Convert.ToString(n["AssetClassificationDescription"]),
                                                     Count = Convert.ToInt32(n["COUNTVALUE"]),
                                                     Percentage = Convert.ToInt32(n["PERVALUE"]),

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

        public AssetWarranty LoadAssetWarrantyChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId, int UserId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(LoadAssetWarrantyChart), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new MASTERDBAccessDAL();
                AssetWarranty entity = new AssetWarranty();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pStartDateYear", StartYear.ToString());
                parameters.Add("@pStartDateMonth", StartMonth.ToString());
                parameters.Add("@pEndDateYear", EndYear.ToString());
                parameters.Add("@pEndDateMonth", EndMonth.ToString());
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));

                DataSet dt = dbAccessDAL.MasterGetDataSet("uspFM_Home_DashBoard_AssetListCategory", parameters, DataSetparameters);
                if (dt != null && dt.Tables[0].Rows.Count > 0)
                {

                    entity.AssetWarrantyChartData = (from n in dt.Tables[0].AsEnumerable()
                                                     select new AssetWarrantyChart
                                                     {
                                                         NameId = Convert.ToInt32(n["ID"]),
                                                         Name = Convert.ToString(n["NAME"]),
                                                         Count = Convert.ToInt32(n["COUNTVALUE"]),
                                                         Percentage = Convert.ToDecimal(n["PERVALUE"]),

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

        public KPITarget LoadKPITargetChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId , int UserId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(LoadKPITargetChart), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new MASTERDBAccessDAL();
                KPITarget entity = new KPITarget();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pStartDateYear", StartYear.ToString());
                parameters.Add("@pStartDateMonth", StartMonth.ToString());
                parameters.Add("@pEndDateYear", EndYear.ToString());
                parameters.Add("@pEndDateMonth", EndMonth.ToString());
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));

                DataSet dt = dbAccessDAL.MasterGetDataSet("uspFM_Home_DashBoard_UpTimeAssetList", parameters, DataSetparameters);
                if (dt != null && dt.Tables[0].Rows.Count > 0)
                {

                    entity.KPITargetChartData = (from n in dt.Tables[0].AsEnumerable()
                                                 select new KPITargetChart
                                                 {
                                                     Name = Convert.ToString(n["AssetClassificationDescription"]),
                                                     Count = Convert.ToInt32(n["COUNTVALUE"]),
                                                 Percentage = Convert.ToDecimal(n["PERVALUE"]),

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

        public ExpiryAlert LoadExpiryAlertChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId , int UserId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(LoadExpiryAlertChart), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new MASTERDBAccessDAL();
                ExpiryAlert entity = new ExpiryAlert();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pStartDateYear", StartYear.ToString());
                parameters.Add("@pStartDateMonth", StartMonth.ToString());
                parameters.Add("@pEndDateYear", EndYear.ToString());
                parameters.Add("@pEndDateMonth", EndMonth.ToString());
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));

                DataSet dt = dbAccessDAL.MasterGetDataSet("uspFM_Home_DashBoard_AssetAlert", parameters, DataSetparameters);
                if (dt != null && dt.Tables[0].Rows.Count > 0)
                {

                    entity.ExpiryAlertChartData = (from n in dt.Tables[0].AsEnumerable()
                                                select new ExpiryAlertChart
                                                {
                                                    NameId = Convert.ToInt32(n["ID"]),
                                                    Name = Convert.ToString(n["NAME"]),
                                                    Count = Convert.ToInt32(n["COUNTVALUE"]),
                                                    Percentage = Convert.ToDecimal(n["PERVALUE"]),
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

        public BERAsset LoadBERAssetChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId, int UserId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(LoadBERAssetChart), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new MASTERDBAccessDAL();
                BERAsset entity = new BERAsset();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pStartDateYear", StartYear.ToString());
                parameters.Add("@pStartDateMonth", StartMonth.ToString());
                parameters.Add("@pEndDateYear", EndYear.ToString());
                parameters.Add("@pEndDateMonth", EndMonth.ToString());
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));

                DataSet dt = dbAccessDAL.MasterGetDataSet("uspFM_Home_DashBoard_BERAssetChart", parameters, DataSetparameters);
                if (dt != null && dt.Tables[0].Rows.Count > 0)
                {

                    entity.BERAssetChartData = (from n in dt.Tables[0].AsEnumerable()
                                                   select new BERAssetChart
                                                   {
                                                       Id = Convert.ToInt32(n["ID"]),
                                                       Name = Convert.ToString(n["NAME"]),
                                                       Count = Convert.ToInt32(n["BER1COUNTVALUE"]),
                                                       BER2Count = Convert.ToInt32(n["BER2COUNTVALUE"]),
                                                       Percentage = Convert.ToDecimal(n["BER1PERVALUE"]),
                                                       BER2Percentage = Convert.ToDecimal(n["BER2PERVALUE"]),
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
                var dbAccessDAL = new MASTERDBAccessDAL();
                HomeDashboard entity = new HomeDashboard();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pStartDateYear", StartYear.ToString());
                parameters.Add("@pStartDateMonth", StartMonth.ToString());
                parameters.Add("@pEndDateYear", EndYear.ToString());
                parameters.Add("@pEndDateMonth", EndMonth.ToString());
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));

                DataSet dt = dbAccessDAL.MasterGetDataSet("uspFM_Home_DashBoard_Contract", parameters, DataSetparameters);
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
