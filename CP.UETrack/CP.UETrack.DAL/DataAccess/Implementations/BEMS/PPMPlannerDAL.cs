using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UETrack.DAL;

namespace CP.UETrack.DAL.DataAccess.Implementations.BEMS
{
    public class PPMPlannerDAL : IPPMPlannerDAL
    {
        private readonly string _FileName = nameof(PPMPlannerDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        private object searchObject;

        public PPMPlannerDAL()
        {

        }
        public PPMPlannerLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                PPMPlannerLovs lovcollection = null;

                var ds = new DataSet();
                var ds1 = new DataSet();
                var ds2 = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown_Others";
                        cmd.Parameters.AddWithValue("@pLovKey", "");
                        cmd.Parameters.AddWithValue("@pTableName", "EngPlannerTxn");


                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        da = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pLovKey", "ScheduleTypeValue,WarrantyTypeValue,StatusValue,WorkOrderTypeValue,PlannerClassificationValue,PlannerScheduleTypeValue,PPMFrequencyValue");
                        da.SelectCommand = cmd;
                        da.Fill(ds1);

                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown_Others";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pLovKey", "");
                        cmd.Parameters.AddWithValue("@pTableName", "Service");

                        da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds2);

                    }
                }
                if (ds.Tables.Count != 0)
                {
                    lovcollection = new PPMPlannerLovs();
                    lovcollection.WorkGroupList = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                    lovcollection.AssetClarificationList = dbAccessDAL.GetLovRecords(ds.Tables[1]);
                    // lovcollection.YearList = dbAccessDAL.GetLovRecords(ds.Tables[4]);
                }
                if (ds1.Tables.Count != 0)
                {
                    lovcollection.ScheduleList = dbAccessDAL.GetLovRecords(ds1.Tables[0], "ScheduleTypeValue");
                    lovcollection.WarrentyTypeList = dbAccessDAL.GetLovRecords(ds1.Tables[0], "WarrantyTypeValue");
                    lovcollection.StatusList = dbAccessDAL.GetLovRecords(ds1.Tables[0], "StatusValue");
                    lovcollection.WorkOrderTypeList = dbAccessDAL.GetLovRecords(ds1.Tables[0], "WorkOrderTypeValue");
                    lovcollection.TypeOfPlannerList = dbAccessDAL.GetLovRecords(ds1.Tables[0], "PlannerClassificationValue");
                    lovcollection.TypeOfPlannerList = lovcollection.TypeOfPlannerList.Where(x => x.LovId == 36 || x.LovId == 198 || x.LovId == 343).ToList();
                    lovcollection.TaskCodeOptionList = dbAccessDAL.GetLovRecords(ds1.Tables[0], "PlannerScheduleTypeValue");
                    lovcollection.FrequencyList = dbAccessDAL.GetLovRecords(ds1.Tables[0], "PPMFrequencyValue");
                }
                if (ds2.Tables.Count != 0)
                {
                    lovcollection.ServiceList = dbAccessDAL.GetLovRecords(ds2.Tables[0]);
                }
                var currentYear = DateTime.Now.Year; var nextYear = currentYear + 1;
                lovcollection.YearList = new List<SelectListLookup>();
                lovcollection.YearList.Add(new SelectListLookup() { LovId = currentYear, FieldCode = currentYear.ToString(), FieldValue = currentYear.ToString() });
                lovcollection.YearList.Add(new SelectListLookup() { LovId = nextYear, FieldCode = nextYear.ToString(), FieldValue = nextYear.ToString() });

                lovcollection.CurrentYear = currentYear;
                lovcollection.CurrentMonth = DateTime.Now.Month;

                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return lovcollection;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception)
            {
                throw;
            }

        }
        public EngPlannerTxn Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var obj = new EngPlannerTxn();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pPlannerId", Id.ToString());
                DataSet ds = dbAccessDAL.GetDataSet("UspFM_EngPlannerTxn_GetById", parameters, DataSetparameters);
                if (ds != null)
                {
                    if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                    {
                        obj.PlannerId = Convert.ToInt32(ds.Tables[0].Rows[0]["PlannerId"]);
                        obj.ServiceId = Convert.ToInt32(ds.Tables[0].Rows[0]["ServiceId"]);
                        obj.Year = Convert.ToInt32(ds.Tables[0].Rows[0]["Year"]);
                        obj.WorkGroup = Convert.ToInt32(ds.Tables[0].Rows[0]["WorkGroupId"]);
                        obj.WorkOrderType = Convert.ToInt32(ds.Tables[0].Rows[0]["WorkOrderType"]);
                        obj.TypeOfPlanner = Convert.ToInt32(ds.Tables[0].Rows[0]["TypeOfPlanner"]);
                        obj.UserAreaId = Convert.ToInt32(ds.Tables[0].Rows[0]["UserAreaId"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["UserAreaId"]);
                        obj.UserAreaCode = Convert.ToString(ds.Tables[0].Rows[0]["UserAreaCode"]);
                        obj.UserAreaName = Convert.ToString(ds.Tables[0].Rows[0]["UserAreaName"]);
                        obj.AssetCount = Convert.ToString(ds.Tables[0].Rows[0]["TotalNoOfAssets"]);
                        obj.AssigneeId = Convert.ToInt32(ds.Tables[0].Rows[0]["AssigneeCompanyStaffId"]);
                        obj.Assignee = Convert.ToString(ds.Tables[0].Rows[0]["CompanyStaffName"]);
                        obj.FacRepId = Convert.ToInt32(ds.Tables[0].Rows[0]["FacilityStaffId"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["FacilityStaffId"]);
                        obj.FacRep = Convert.ToString(ds.Tables[0].Rows[0]["HospitalStaffName"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["HospitalStaffName"]);
                        obj.AssetClarification = Convert.ToInt32(ds.Tables[0].Rows[0]["AssetClassificationId"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["AssetClassificationId"]); // Convert.ToInt32(ds.Tables[0].Rows[0]["AssetClassificationId"]);
                        obj.WarrentyType = Convert.ToInt16(ds.Tables[0].Rows[0]["WarrantyType"]);
                        obj.AssetTypeCodeId = Convert.ToInt32(ds.Tables[0].Rows[0]["AssetTypeCodeId"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["AssetTypeCodeId"]);
                        obj.AssetTypeCode = Convert.ToString(ds.Tables[0].Rows[0]["AssetTypeCode"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["AssetTypeCode"]);
                        obj.AssetTypeDescription = Convert.ToString(ds.Tables[0].Rows[0]["AssetTypeDescription"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["AssetTypeDescription"]);
                        obj.PPMFrequencyValue = Convert.ToString(ds.Tables[0].Rows[0]["PPMFrequencyValue"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["PPMFrequencyValue"]);
                        obj.AssetRegisterId = Convert.ToInt32(ds.Tables[0].Rows[0]["AssetId"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["AssetId"]);
                        obj.AssetNo = Convert.ToString(ds.Tables[0].Rows[0]["AssetNo"]);
                        obj.Model = Convert.ToString(ds.Tables[0].Rows[0]["Model"]);
                        obj.Manufacturer = Convert.ToString(ds.Tables[0].Rows[0]["Manufacturer"]);
                        obj.SerialNumber = Convert.ToString(ds.Tables[0].Rows[0]["SerialNo"]);
                        obj.StandardTaskDetId = Convert.ToInt32(ds.Tables[0].Rows[0]["StandardTaskDetId"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["StandardTaskDetId"]);
                        if (obj.ServiceId ==1)
                        {
                            obj.PPMCheckListId = Convert.ToInt32(ds.Tables[0].Rows[0]["PPMCheckListId"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["PPMCheckListId"]);
                        }
                        obj.PPMTaskCode = Convert.ToString(ds.Tables[0].Rows[0]["TaskCode"]);
                        obj.PPMTaskDescription = Convert.ToString(ds.Tables[0].Rows[0]["TaskDescription"]);
                        obj.WarrentyEndDate = Convert.ToDateTime(ds.Tables[0].Rows[0]["WarrantyEndDate"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["WarrantyEndDate"]);
                        obj.SupplierName = Convert.ToString(ds.Tables[0].Rows[0]["MainSupplier"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["MainSupplier"]);
                        obj.ContractEndDate = Convert.ToDateTime(ds.Tables[0].Rows[0]["ContractEndDate"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["ContractEndDate"]);
                        obj.ContractorName = Convert.ToString(ds.Tables[0].Rows[0]["ContractorName"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["ContractorName"]);
                        obj.EngineerId = Convert.ToInt32(ds.Tables[0].Rows[0]["EngineerStaffId"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["EngineerStaffId"]);
                        obj.Engineer = Convert.ToString(ds.Tables[0].Rows[0]["EngineerStaffName"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["EngineerStaffName"]);
                        obj.Schedule = Convert.ToInt32(ds.Tables[0].Rows[0]["ScheduleType"]);
                        obj.Status = Convert.ToInt32(ds.Tables[0].Rows[0]["Status"]);
                        obj.Month = Convert.ToString(ds.Tables[0].Rows[0]["Month"]);
                        obj.Date = Convert.ToString(ds.Tables[0].Rows[0]["Date"]);
                        obj.Week = Convert.ToString(ds.Tables[0].Rows[0]["Week"]);
                        obj.Day = Convert.ToString(ds.Tables[0].Rows[0]["Day"]);
                        obj.TaskCodeOption = Convert.ToInt32(ds.Tables[0].Rows[0]["GenerationType"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["GenerationType"]);
                        obj.FirstDate = Convert.ToDateTime(ds.Tables[0].Rows[0]["FirstDate"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["FirstDate"]);
                        obj.NextDate = Convert.ToDateTime(ds.Tables[0].Rows[0]["NextDate"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["NextDate"]);
                        obj.LastDate = Convert.ToDateTime(ds.Tables[0].Rows[0]["LastDate"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["LastDate"]);
                        obj.PPMFrequency = Convert.ToInt32(ds.Tables[0].Rows[0]["PPMFrequency"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["PPMFrequency"]);
                        obj.AgreedDate = Convert.ToDateTime(ds.Tables[0].Rows[0]["AgreedDate"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["AgreedDate"]);

                        //obj.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                    }
                    //if (ds.Tables[1] != null && ds.Tables[1].Rows.Count > 0)
                    //{

                    //    var TestAppMstDets = (from n in ds.Tables[1].AsEnumerable()
                    //                          select new PPMCheckListTestAppMstDetModel
                    //                          {
                    //                              PPMCheckListTAppId = Convert.ToInt32(n["PPMCheckListTAppId"]),
                    //                              PPMCheckListId = Convert.ToInt32(n["PPMCheckListId"]),
                    //                              Description = Convert.ToString(n["Description"]),
                    //                              Active = Convert.ToBoolean(n["Active"])
                    //                          }).ToList();

                    //    if (TestAppMstDets != null && TestAppMstDets.Count > 0)
                    //    {
                    //        obj.PPMCheckListTestAppMstDets = TestAppMstDets;

                    //    }
                    //}
                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return obj;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception)
            {
                throw;
            }

        }
        public EngPlannerTxn AssetFrequencyTaskCode(string Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                //PMFrequency > PFrequency
                EngPlannerTxn engPlanner = new EngPlannerTxn();

                EngPlannerTxn lovs = new EngPlannerTxn();
                List<PMFrequency> resultsPPMfinal = new List<PMFrequency>();
                List<PMFrequency> listinggrid = new List<PMFrequency>();
                var dbAccessDAL = new DBAccessDAL();
                var obj = new EngPlannerTxn();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                var pageIndex = obj.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                parameters.Add("@pAssetID", Id.ToString());
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                parameters.Add("@pFacilityId", _UserSession.FacilityId.ToString());
                DataSet ds = dbAccessDAL.GetDataSet("uspFM_EngAssetPlannerTaskCode_Fetch", parameters, DataSetparameters);

                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {

                    //PMFrequency lovigrids = new PMFrequency();

                    lovs.ServiceList = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                    //foreach (DataRow rows in ds.Tables[0].Rows)
                    //{
                    //    lovigrids.IsDefault = Convert.ToInt32(rows["IsDefault"]);
                    //    lovigrids.LovId = Convert.ToInt32(rows["LovId"]);
                    //    lovigrids.FieldValue = Convert.ToString(rows["FieldValue"]);
                    //    //lovigrids.TTaskCode = Convert.ToString(rows["TaskCode"]);
                    //    listinggrid.Add(lovigrids);
                    //}
                    //engPlanner.PPMFrequencyValue = lovigrids.FieldValue;
                    //resultsPPMfinal = resultsPPMfinal.Concat(listinggrid).ToList();
                    //engPlanner.PFrequency = resultsPPMfinal;
                    // result.Add(Department);
                }
                
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return lovs;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception)
            {
                throw;
            }
        }

        public EngPlannerTxn AssetTypeCodeFrequency(string Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                //PMFrequency > PFrequency
              
              
                EngPlannerTxn lovs = new EngPlannerTxn();
                List<PMFrequency> resultsPPMfinal = new List<PMFrequency>();
                List<PMFrequency> listinggrid = new List<PMFrequency>();
                var dbAccessDAL = new DBAccessDAL();
                var obj = new EngPlannerTxn();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                var pageIndex = obj.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                parameters.Add("@pTaskCodeid", Id.ToString());
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                parameters.Add("@pFacilityId", _UserSession.FacilityId.ToString());
                DataSet ds = dbAccessDAL.GetDataSet("uspFM_EngAssetPlannerTypeCodeFrequency_Fetch", parameters, DataSetparameters);

                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    foreach (DataRow rows in ds.Tables[0].Rows)
                    {
                        //lovs.AQuantityText = Convert.ToInt32(rows["AQuantityText"]);
                        lovs.PPFrequency = Convert.ToInt32(rows["PPMFrequency"]);
                        //lovs.FieldValue = Convert.ToString(rows["FieldValue"]);
                        //lovigrids.TTaskCode = Convert.ToString(rows["TaskCode"]);
                        
                    }
                  
                }

                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return lovs;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception)
            {
                throw;
            }
        }

        public EngPlannerTxn Popup(int Id, int pagesize, int pageindex)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();

                var obj = new EngPlannerTxn();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pUserAreaId", Id.ToString());
                //parameters.Add("@pPageIndex", pageindex.ToString());
                //parameters.Add("@pPageSize", pagesize.ToString());
                DataSet ds = dbAccessDAL.GetDataSet("uspFM_EngPlannerTxnAssets_GetByUserAreaId", parameters, DataSetparameters);
                if (ds != null)
                {
                    if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                    {

                        obj.RIPlannerPopUPDets = (from n in ds.Tables[0].AsEnumerable()
                                                  select new EngPlannerTxn
                                                  {
                                                      AssetNo = Convert.ToString(n["AssetNo"]),
                                                      AssetTypeCode = Convert.ToString(n["AssetTypeCode"]),
                                                      AssetTypeDescription = Convert.ToString(n["AssetTypeDescription"]),
                                                      TotalRecords = Convert.ToInt32(n["TotalRecords"]),
                                                      TotalPages = Convert.ToInt32(n["TotalPageCalc"])
                                                  }).ToList();

                        obj.RIPlannerPopUPDets.ForEach((x) =>
                        {
                            x.PageIndex = pageindex;
                            x.FirstRecord = ((pageindex - 1) * pagesize) + 1;
                            x.LastRecord = ((pageindex - 1) * pagesize) + pagesize;
                        });
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return obj;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception)
            {
                throw;
            }
        }

        public EngPlannerTxn Summary(int Service, int WorkGroup, int Year, int TOP, int pagesize, int pageindex)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();

                var obj = new EngPlannerTxn();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                if (TOP == 34)
                {
                    parameters.Add("@pServiceId", Service.ToString());
                    parameters.Add("@pWorkGroupid", WorkGroup.ToString());
                    parameters.Add("@pFacilityId", _UserSession.FacilityId.ToString());
                    parameters.Add("@pYear", Year.ToString());
                    // parameters.Add("@pTypeOfPlanner", TOP.ToString());
                    parameters.Add("@pPageIndex", pageindex.ToString());
                    parameters.Add("@pPageSize", pagesize.ToString());
                    DataSet ds = dbAccessDAL.GetDataSet("uspFM_EngPlanner_PPM_Summary", parameters, DataSetparameters);
                    if (ds != null)
                    {
                        if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                        {

                            obj.SummaryDets = (from n in ds.Tables[0].AsEnumerable()
                                               select new EngPlannerSummaryTxn
                                               {
                                                   AssetNo = Convert.ToString(n["AssetNo"]),
                                                   AssetDescription = Convert.ToString(n["AssetDescription"]),
                                                   TaskCode = Convert.ToString(n["TaskCode"]),
                                                   Week1 = Convert.ToBoolean(n["Week1"]),
                                                   Week2 = Convert.ToBoolean(n["Week2"]),
                                                   Week3 = Convert.ToBoolean(n["Week3"]),
                                                   Week4 = Convert.ToBoolean(n["Week4"]),
                                                   Week5 = Convert.ToBoolean(n["Week5"]),
                                                   Week6 = Convert.ToBoolean(n["Week6"]),
                                                   Week7 = Convert.ToBoolean(n["Week7"]),
                                                   Week8 = Convert.ToBoolean(n["Week8"]),
                                                   Week9 = Convert.ToBoolean(n["Week9"]),
                                                   Week10 = Convert.ToBoolean(n["Week10"]),
                                                   Week11 = Convert.ToBoolean(n["Week11"]),
                                                   Week12 = Convert.ToBoolean(n["Week12"]),
                                                   Week13 = Convert.ToBoolean(n["Week13"]),
                                                   Week14 = Convert.ToBoolean(n["Week14"]),
                                                   Week15 = Convert.ToBoolean(n["Week15"]),
                                                   Week16 = Convert.ToBoolean(n["Week16"]),
                                                   Week17 = Convert.ToBoolean(n["Week17"]),
                                                   Week18 = Convert.ToBoolean(n["Week18"]),
                                                   Week19 = Convert.ToBoolean(n["Week19"]),
                                                   Week20 = Convert.ToBoolean(n["Week20"]),
                                                   Week21 = Convert.ToBoolean(n["Week21"]),
                                                   Week22 = Convert.ToBoolean(n["Week22"]),
                                                   Week23 = Convert.ToBoolean(n["Week23"]),
                                                   Week24 = Convert.ToBoolean(n["Week24"]),
                                                   Week25 = Convert.ToBoolean(n["Week25"]),
                                                   Week26 = Convert.ToBoolean(n["Week26"]),
                                                   Week27 = Convert.ToBoolean(n["Week27"]),
                                                   Week28 = Convert.ToBoolean(n["Week28"]),
                                                   Week29 = Convert.ToBoolean(n["Week29"]),
                                                   Week30 = Convert.ToBoolean(n["Week30"]),
                                                   Week31 = Convert.ToBoolean(n["Week31"]),
                                                   Week32 = Convert.ToBoolean(n["Week32"]),
                                                   Week33 = Convert.ToBoolean(n["Week33"]),
                                                   Week34 = Convert.ToBoolean(n["Week34"]),
                                                   Week35 = Convert.ToBoolean(n["Week35"]),
                                                   Week36 = Convert.ToBoolean(n["Week36"]),
                                                   Week37 = Convert.ToBoolean(n["Week37"]),
                                                   Week38 = Convert.ToBoolean(n["Week38"]),
                                                   Week39 = Convert.ToBoolean(n["Week39"]),
                                                   Week40 = Convert.ToBoolean(n["Week40"]),
                                                   Week41 = Convert.ToBoolean(n["Week41"]),
                                                   Week42 = Convert.ToBoolean(n["Week42"]),
                                                   Week43 = Convert.ToBoolean(n["Week43"]),
                                                   Week44 = Convert.ToBoolean(n["Week44"]),
                                                   Week45 = Convert.ToBoolean(n["Week45"]),
                                                   Week46 = Convert.ToBoolean(n["Week46"]),
                                                   Week47 = Convert.ToBoolean(n["Week47"]),
                                                   Week48 = Convert.ToBoolean(n["Week48"]),
                                                   Week49 = Convert.ToBoolean(n["Week49"]),
                                                   Week50 = Convert.ToBoolean(n["Week50"]),
                                                   Week51 = Convert.ToBoolean(n["Week51"]),
                                                   Week52 = Convert.ToBoolean(n["Week52"]),
                                                   Week53 = Convert.ToBoolean(n["Week53"]),
                                                   TotalRecords = Convert.ToInt32(n["TotalRecords"]),
                                                   TotalPages = Convert.ToInt32(n["TotalPageCalc"])
                                               }).ToList();

                            obj.SummaryDets.ForEach((x) =>
                            {
                                x.PageIndex = pageindex;
                                x.FirstRecord = ((pageindex - 1) * pagesize) + 1;
                                x.LastRecord = ((pageindex - 1) * pagesize) + pagesize;
                            });
                        }
                    }
                }
                if (TOP == 36 || TOP == 198)
                {
                    parameters.Add("@pServiceId", Service.ToString());
                    parameters.Add("@pWorkGroupid", WorkGroup.ToString());
                    parameters.Add("@pFacilityId", _UserSession.FacilityId.ToString());
                    parameters.Add("@pYear", Year.ToString());
                    parameters.Add("@pTypeOfPlanner", TOP.ToString());
                    parameters.Add("@pPageIndex", pageindex.ToString());
                    parameters.Add("@pPageSize", pagesize.ToString());
                    DataSet ds = dbAccessDAL.GetDataSet("uspFM_EngPlanner_Other_Summary", parameters, DataSetparameters);
                    if (ds != null)
                    {
                        if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                        {

                            obj.SummaryDets = (from n in ds.Tables[0].AsEnumerable()
                                               select new EngPlannerSummaryTxn
                                               {
                                                   AssetNo = Convert.ToString(n["AssetNo"]),
                                                   AssetDescription = Convert.ToString(n["AssetDescription"]),
                                                   TaskCode = Convert.ToString(n["TaskCode"]),
                                                   Week1 = Convert.ToBoolean(n["Week1"]),
                                                   Week2 = Convert.ToBoolean(n["Week2"]),
                                                   Week3 = Convert.ToBoolean(n["Week3"]),
                                                   Week4 = Convert.ToBoolean(n["Week4"]),
                                                   Week5 = Convert.ToBoolean(n["Week5"]),
                                                   Week6 = Convert.ToBoolean(n["Week6"]),
                                                   Week7 = Convert.ToBoolean(n["Week7"]),
                                                   Week8 = Convert.ToBoolean(n["Week8"]),
                                                   Week9 = Convert.ToBoolean(n["Week9"]),
                                                   Week10 = Convert.ToBoolean(n["Week10"]),
                                                   Week11 = Convert.ToBoolean(n["Week11"]),
                                                   Week12 = Convert.ToBoolean(n["Week12"]),
                                                   Week13 = Convert.ToBoolean(n["Week13"]),
                                                   Week14 = Convert.ToBoolean(n["Week14"]),
                                                   Week15 = Convert.ToBoolean(n["Week15"]),
                                                   Week16 = Convert.ToBoolean(n["Week16"]),
                                                   Week17 = Convert.ToBoolean(n["Week17"]),
                                                   Week18 = Convert.ToBoolean(n["Week18"]),
                                                   Week19 = Convert.ToBoolean(n["Week19"]),
                                                   Week20 = Convert.ToBoolean(n["Week20"]),
                                                   Week21 = Convert.ToBoolean(n["Week21"]),
                                                   Week22 = Convert.ToBoolean(n["Week22"]),
                                                   Week23 = Convert.ToBoolean(n["Week23"]),
                                                   Week24 = Convert.ToBoolean(n["Week24"]),
                                                   Week25 = Convert.ToBoolean(n["Week25"]),
                                                   Week26 = Convert.ToBoolean(n["Week26"]),
                                                   Week27 = Convert.ToBoolean(n["Week27"]),
                                                   Week28 = Convert.ToBoolean(n["Week28"]),
                                                   Week29 = Convert.ToBoolean(n["Week29"]),
                                                   Week30 = Convert.ToBoolean(n["Week30"]),
                                                   Week31 = Convert.ToBoolean(n["Week31"]),
                                                   Week32 = Convert.ToBoolean(n["Week32"]),
                                                   Week33 = Convert.ToBoolean(n["Week33"]),
                                                   Week34 = Convert.ToBoolean(n["Week34"]),
                                                   Week35 = Convert.ToBoolean(n["Week35"]),
                                                   Week36 = Convert.ToBoolean(n["Week36"]),
                                                   Week37 = Convert.ToBoolean(n["Week37"]),
                                                   Week38 = Convert.ToBoolean(n["Week38"]),
                                                   Week39 = Convert.ToBoolean(n["Week39"]),
                                                   Week40 = Convert.ToBoolean(n["Week40"]),
                                                   Week41 = Convert.ToBoolean(n["Week41"]),
                                                   Week42 = Convert.ToBoolean(n["Week42"]),
                                                   Week43 = Convert.ToBoolean(n["Week43"]),
                                                   Week44 = Convert.ToBoolean(n["Week44"]),
                                                   Week45 = Convert.ToBoolean(n["Week45"]),
                                                   Week46 = Convert.ToBoolean(n["Week46"]),
                                                   Week47 = Convert.ToBoolean(n["Week47"]),
                                                   Week48 = Convert.ToBoolean(n["Week48"]),
                                                   Week49 = Convert.ToBoolean(n["Week49"]),
                                                   Week50 = Convert.ToBoolean(n["Week50"]),
                                                   Week51 = Convert.ToBoolean(n["Week51"]),
                                                   Week52 = Convert.ToBoolean(n["Week52"]),
                                                   Week53 = Convert.ToBoolean(n["Week53"]),
                                                   TotalRecords = Convert.ToInt32(n["TotalRecords"]),
                                                   TotalPages = Convert.ToInt32(n["TotalPageCalc"])
                                               }).ToList();

                            obj.SummaryDets.ForEach((x) =>
                            {
                                x.PageIndex = pageindex;
                                x.FirstRecord = ((pageindex - 1) * pagesize) + 1;
                                x.LastRecord = ((pageindex - 1) * pagesize) + pagesize;
                            });
                        }
                    }
                }
                if (TOP == 35)
                {
                    parameters.Add("@pServiceId", Service.ToString());
                    parameters.Add("@pWorkGroupid", WorkGroup.ToString());
                    parameters.Add("@pFacilityId", _UserSession.FacilityId.ToString());
                    parameters.Add("@pYear", Year.ToString());
                    parameters.Add("@pPageIndex", pageindex.ToString());
                    parameters.Add("@pPageSize", pagesize.ToString());
                    DataSet ds = dbAccessDAL.GetDataSet("uspFM_EngPlanner_RI_Summary", parameters, DataSetparameters);
                    if (ds != null)
                    {
                        if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                        {

                            obj.SummaryDets = (from n in ds.Tables[0].AsEnumerable()
                                               select new EngPlannerSummaryTxn
                                               {
                                                   UserAreaCode = Convert.ToString(n["UserAreaCode"]),
                                                   UserAreaName = Convert.ToString(n["UserAreaName"]),
                                                   Week1 = Convert.ToBoolean(n["Week1"]),
                                                   Week2 = Convert.ToBoolean(n["Week2"]),
                                                   Week3 = Convert.ToBoolean(n["Week3"]),
                                                   Week4 = Convert.ToBoolean(n["Week4"]),
                                                   Week5 = Convert.ToBoolean(n["Week5"]),
                                                   Week6 = Convert.ToBoolean(n["Week6"]),
                                                   Week7 = Convert.ToBoolean(n["Week7"]),
                                                   Week8 = Convert.ToBoolean(n["Week8"]),
                                                   Week9 = Convert.ToBoolean(n["Week9"]),
                                                   Week10 = Convert.ToBoolean(n["Week10"]),
                                                   Week11 = Convert.ToBoolean(n["Week11"]),
                                                   Week12 = Convert.ToBoolean(n["Week12"]),
                                                   Week13 = Convert.ToBoolean(n["Week13"]),
                                                   Week14 = Convert.ToBoolean(n["Week14"]),
                                                   Week15 = Convert.ToBoolean(n["Week15"]),
                                                   Week16 = Convert.ToBoolean(n["Week16"]),
                                                   Week17 = Convert.ToBoolean(n["Week17"]),
                                                   Week18 = Convert.ToBoolean(n["Week18"]),
                                                   Week19 = Convert.ToBoolean(n["Week19"]),
                                                   Week20 = Convert.ToBoolean(n["Week20"]),
                                                   Week21 = Convert.ToBoolean(n["Week21"]),
                                                   Week22 = Convert.ToBoolean(n["Week22"]),
                                                   Week23 = Convert.ToBoolean(n["Week23"]),
                                                   Week24 = Convert.ToBoolean(n["Week24"]),
                                                   Week25 = Convert.ToBoolean(n["Week25"]),
                                                   Week26 = Convert.ToBoolean(n["Week26"]),
                                                   Week27 = Convert.ToBoolean(n["Week27"]),
                                                   Week28 = Convert.ToBoolean(n["Week28"]),
                                                   Week29 = Convert.ToBoolean(n["Week29"]),
                                                   Week30 = Convert.ToBoolean(n["Week30"]),
                                                   Week31 = Convert.ToBoolean(n["Week31"]),
                                                   Week32 = Convert.ToBoolean(n["Week32"]),
                                                   Week33 = Convert.ToBoolean(n["Week33"]),
                                                   Week34 = Convert.ToBoolean(n["Week34"]),
                                                   Week35 = Convert.ToBoolean(n["Week35"]),
                                                   Week36 = Convert.ToBoolean(n["Week36"]),
                                                   Week37 = Convert.ToBoolean(n["Week37"]),
                                                   Week38 = Convert.ToBoolean(n["Week38"]),
                                                   Week39 = Convert.ToBoolean(n["Week39"]),
                                                   Week40 = Convert.ToBoolean(n["Week40"]),
                                                   Week41 = Convert.ToBoolean(n["Week41"]),
                                                   Week42 = Convert.ToBoolean(n["Week42"]),
                                                   Week43 = Convert.ToBoolean(n["Week43"]),
                                                   Week44 = Convert.ToBoolean(n["Week44"]),
                                                   Week45 = Convert.ToBoolean(n["Week45"]),
                                                   Week46 = Convert.ToBoolean(n["Week46"]),
                                                   Week47 = Convert.ToBoolean(n["Week47"]),
                                                   Week48 = Convert.ToBoolean(n["Week48"]),
                                                   Week49 = Convert.ToBoolean(n["Week49"]),
                                                   Week50 = Convert.ToBoolean(n["Week50"]),
                                                   Week51 = Convert.ToBoolean(n["Week51"]),
                                                   Week52 = Convert.ToBoolean(n["Week52"]),
                                                   Week53 = Convert.ToBoolean(n["Week53"]),
                                                   TotalRecords = Convert.ToInt32(n["TotalRecords"]),
                                                   TotalPages = Convert.ToInt32(n["TotalPageCalc"])
                                               }).ToList();

                            obj.SummaryDets.ForEach((x) =>
                            {
                                x.PageIndex = pageindex;
                                x.FirstRecord = ((pageindex - 1) * pagesize) + 1;
                                x.LastRecord = ((pageindex - 1) * pagesize) + pagesize;
                            });
                        }
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return obj;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception)
            {
                throw;
            }
        }
        public EngPlannerTxn Save(EngPlannerTxn model, out string ErrorMessage)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                if (model.StandardTaskDetId == 0)
                    model.StandardTaskDetId = null;
                if (model.EngineerId == 0)
                    model.EngineerId = null;
                if (model.AssetTypeCodeId == 0)
                    model.AssetTypeCodeId = null;
                if (model.Month == "NaN")
                    model.Month = null;
                if (model.Date == "NaN")
                    model.Date = null;
                if (model.Week == "NaN")
                    model.Week = null;
                if (model.Day == "NaN")
                    model.Day = null;
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@pPlannerId", Convert.ToString(model.PlannerId));
                parameters.Add("@CustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@ServiceId", Convert.ToString(model.ServiceId));
                parameters.Add("@WorkGroupId", Convert.ToString(model.WorkGroup));
                parameters.Add("@TypeOfPlanner", Convert.ToString(model.TypeOfPlanner));
                parameters.Add("@Year", Convert.ToString(model.Year));
                parameters.Add("@UserAreaId", Convert.ToString(model.UserAreaId));
                parameters.Add("@AssigneeCompanyStaffId", Convert.ToString(model.AssigneeId));
                parameters.Add("@FacilityStaffId", Convert.ToString(model.FacRepId));
                parameters.Add("@AssetClassificationId", Convert.ToString(model.AssetClarification));
                parameters.Add("@AssetTypeCodeId", Convert.ToString(model.AssetTypeCodeId));
                parameters.Add("@AssetId", Convert.ToString(model.AssetRegisterId));
                parameters.Add("@StandardTaskDetId", Convert.ToString(model.StandardTaskDetId));
                parameters.Add("@WarrantyType", Convert.ToString(model.WarrentyType));
                parameters.Add("@EngineerStaffId", Convert.ToString(model.EngineerId));
                parameters.Add("@ScheduleType", Convert.ToString(model.Schedule));
                parameters.Add("@Month", Convert.ToString(model.Month));
                parameters.Add("@Date", Convert.ToString(model.Date));
                parameters.Add("@Week", Convert.ToString(model.Week));
                parameters.Add("@Day", Convert.ToString(model.Day));
                parameters.Add("@Status", Convert.ToString(model.Status));
                parameters.Add("@WorkOrderType", Convert.ToString(model.WorkOrderType));
                parameters.Add("@GenerationType", Convert.ToString(model.TaskCodeOption));
                parameters.Add("@AgreedDate", model.AgreedDate != null ? model.AgreedDate.Value.ToString("yyyy-MM-dd") : null);

                string SP_Save = "";
                if (model.TaskCodeOption == 364)
                {
                    parameters.Add("@FirstDate", null);
                    SP_Save = "uspFM_EngPlannerTxn_Save";
                }
                else
                {
                    parameters.Add("@FirstDate", model.FirstDate != null ? model.FirstDate.Value.ToString("yyyy-MM-dd") : null);
                    SP_Save = "uspFM_Planner_Frequency_EngPlannerTxn_Save";

                }
                parameters.Add("@FrequencyType", Convert.ToString(model.FrequencyId));

                //DataTable QuantasksDt = new DataTable();
                //QuantasksDt.Columns.Add("PPMCheckListQNId", typeof(int));
                //QuantasksDt.Columns.Add("QuantitativeTasks", typeof(string));
                //QuantasksDt.Columns.Add("UOM", typeof(string));
                //QuantasksDt.Columns.Add("SetValues", typeof(string));
                //QuantasksDt.Columns.Add("LimitTolerance", typeof(string));
                //QuantasksDt.Columns.Add("Active", typeof(bool));
                //foreach (var task in model.PPMCheckListQuantasksMstDets)
                //{
                //    QuantasksDt.Rows.Add(task.PPMCheckListQNId, task.QuantitativeTasks, task.UOM, task.SetValues, task.LimitTolerance, task.Active);
                //}

                //  DataSetparameters.Add("@EngAssetPPMCheckListQuantasksMstDetType", QuantasksDt);


                DataTable dt = dbAccessDAL.GetDataTable(SP_Save, parameters, DataSetparameters);
                ErrorMessage = string.Empty;
                if (dt != null)
                {
                    foreach (DataRow row in dt.Rows)
                    {
                        ErrorMessage = Convert.ToString(row["ErrorMessage"]);
                        model.PlannerId = Convert.ToInt32(row["PlannerId"]);
                        model.Timestamp = row["Timestamp"] == DBNull.Value ? null : Convert.ToBase64String((byte[])(row["Timestamp"]));
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                if (ErrorMessage != "" && ErrorMessage != null)
                {
                    return model;
                }
                else
                {
                    return model;
                }

            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception ex)
            {
                throw;
            }
        }
        public bool Delete(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pPlannerId", Id.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("UspFM_EngPlannerTxn_Delete", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    string Message = Convert.ToString(dt.Rows[0]["Message"]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(Delete), Level.Info.ToString());
                return true;
            }

            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception)
            {
                throw;
            }
        }




        //public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        //{
        //    try
        //    {
        //        Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
        //        GridFilterResult filterResult = null;

        //        var multipleOrderBy = pageFilter.SortColumn.Split(',');
        //        var strOrderBy = string.Empty;
        //        foreach (var order in multipleOrderBy)
        //        {
        //            strOrderBy += order + " " + pageFilter.SortOrder + ",";
        //        }
        //        if (!string.IsNullOrEmpty(strOrderBy))
        //        {
        //            strOrderBy = strOrderBy.TrimEnd(',');
        //        }

        //        strOrderBy = string.IsNullOrEmpty(strOrderBy) ? pageFilter.SortColumn + " " + pageFilter.SortOrder : strOrderBy;

        //        var ds = new DataSet();
        //        var dbAccessDAL = new DBAccessDAL();

        //        var DataSetparameters = new Dictionary<string, DataTable>();
        //        var parameters = new Dictionary<string, string>();
        //        parameters.Add("@PageIndex", pageFilter.PageIndex.ToString());
        //        parameters.Add("@PageSize", pageFilter.PageSize.ToString());
        //        parameters.Add("@strCondition", pageFilter.QueryWhereCondition);
        //        parameters.Add("@strSorting", strOrderBy);
        //        DataTable dt = dbAccessDAL.GetDataTable("uspFM_EngPPMRegisterMst_GetAll", parameters, DataSetparameters);

        //        if (dt != null && dt.Rows.Count > 0)
        //        {
        //            var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
        //            var totalPages = (int)Math.Ceiling((float)totalRecords / (float)pageFilter.Rows);

        //            var commonDAL = new CommonDAL();
        //            var currentPageList = commonDAL.ToDynamicList(dt);
        //            filterResult = new GridFilterResult
        //            {
        //                TotalRecords = totalRecords,
        //                TotalPages = totalPages,
        //                RecordsList = currentPageList,
        //                CurrentPage = pageFilter.Page
        //            };
        //        }
        //        Log4NetLogger.LogExit(_FileName, nameof(GetAll), Level.Info.ToString());
        //        //return userRoles;
        //        return filterResult;
        //    }
        //    catch (DALException dalex)
        //    {
        //        throw new DALException(dalex);
        //    }
        //    catch (Exception)
        //    {
        //        throw;
        //    }
        //}


        public bool IsRecordModified(EngPlannerTxn model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsRecordModified), Level.Info.ToString());
                var dbAccessDAL = new DBAccessDAL();
                var recordModifed = false;

                if (model.PlannerId != 0)
                {
                    var DataSetparameters = new Dictionary<string, DataTable>();
                    var parameters = new Dictionary<string, string>();
                    parameters.Add("@Id", model.PlannerId.ToString());
                    DataTable dt = dbAccessDAL.GetDataTable("uspFM_EngPPMRegisterMst__GetTimestamp", parameters, DataSetparameters);

                    if (dt != null && dt.Rows.Count > 0)
                    {
                        var timestamp = Convert.ToBase64String((byte[])(dt.Rows[0]["Timestamp"]));
                        if (timestamp != model.Timestamp)
                        {
                            recordModifed = true;
                        }
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(IsRecordModified), Level.Info.ToString());
                return recordModifed;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception)
            {
                throw;
            }
        }

        public EngPlannerTxn ImportValidation(ref EngPlannerTxn model)
        {
            try
            {
                var result = new EngPlannerTxn();
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngPlannerTxn_Import";

                        cmd.Parameters.AddWithValue("@pPlannerId", model.PlannerId);
                        cmd.Parameters.AddWithValue("@pWorkOrderType", model.WorkOrderTypeName);
                        cmd.Parameters.AddWithValue("@pAssignee", model.Assignee);
                        cmd.Parameters.AddWithValue("@pAssetClassification", model.AssetClarificationName);
                        cmd.Parameters.AddWithValue("@pAssetNo", model.AssetNo);
                        cmd.Parameters.AddWithValue("@pPPMTaskCode", model.PPMTaskCode);
                        cmd.Parameters.AddWithValue("@pTypeCode", model.AssetTypeCode);
                        cmd.Parameters.AddWithValue("@pPPMType", model.TypeOfPlannerName);
                        cmd.Parameters.AddWithValue("@pSchedule", model.ScheduleType);
                        cmd.Parameters.AddWithValue("@pStatus", model.StatusType);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }

                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    result.WorkOrderType = ds.Tables[0].Rows[0]["WorkOrderTypeId"] == DBNull.Value ? 0 : Convert.ToInt32(ds.Tables[0].Rows[0]["WorkOrderTypeId"]);
                    result.AssigneeId = ds.Tables[0].Rows[0]["AssigneeId"] == DBNull.Value ? 0 : Convert.ToInt32(ds.Tables[0].Rows[0]["AssigneeId"]);
                    result.AssetClarification = ds.Tables[0].Rows[0]["AssetClassificationId"] == DBNull.Value ? 0 : Convert.ToInt32(ds.Tables[0].Rows[0]["AssetClassificationId"]);
                    result.AssetRegisterId = ds.Tables[0].Rows[0]["AssetId"] == DBNull.Value ? 0 : Convert.ToInt32(ds.Tables[0].Rows[0]["AssetId"]);
                    result.StandardTaskDetId = ds.Tables[0].Rows[0]["TaskCodeId"] == DBNull.Value ? 0 : Convert.ToInt32(ds.Tables[0].Rows[0]["TaskCodeId"]);
                    result.AssetTypeCodeId = ds.Tables[0].Rows[0]["AssetTypeCodeId"] == DBNull.Value ? 0 : Convert.ToInt32(ds.Tables[0].Rows[0]["AssetTypeCodeId"]);
                    result.WarrentyType = ds.Tables[0].Rows[0]["PPMTypeId"] == DBNull.Value ? 0 : Convert.ToInt32(ds.Tables[0].Rows[0]["PPMTypeId"]);
                    result.Schedule = ds.Tables[0].Rows[0]["ScheduleId"] == DBNull.Value ? 0 : Convert.ToInt32(ds.Tables[0].Rows[0]["ScheduleId"]);
                    result.Status = ds.Tables[0].Rows[0]["StatusId"] == DBNull.Value ? 0 : Convert.ToInt32(ds.Tables[0].Rows[0]["StatusId"]);
                    result.ErrorMessage = ds.Tables[0].Rows[0]["ErrorMessage"] == DBNull.Value ? null : Convert.ToString(ds.Tables[0].Rows[0]["ErrorMessage"]);
                }

                return result;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception ex)
            {
                throw;
            }
        }
    }
}
