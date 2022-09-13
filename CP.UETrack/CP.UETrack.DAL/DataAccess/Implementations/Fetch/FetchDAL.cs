using CP.UETrack.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using UETrack.DAL;
using CP.UETrack.Model.BEMS;
using CP.UETrack.Model.FetchModels;
using CP.UETrack.Model.VM;
using static CP.UETrack.Model.FetchModels.ModelSearching;
using CP.UETrack.Model.LLS;
using System.Globalization;
using CP.Framework.Common.StateManagement;

namespace CP.UETrack.DAL.DataAccess
{

    public class FetchDAL : IFetchDAL
    {
        private readonly string _FileName = nameof(FetchDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        readonly ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        public List<UMStaffSearch> FetchStaffMaster(UMStaffSearch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                List<UMStaffSearch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_MstStaff_Fetch";

                        cmd.Parameters.AddWithValue("@pStaffName", SearchObject.StaffName ?? "a");
                        cmd.Parameters.AddWithValue("@pPageIndex", pageIndex);
                        cmd.Parameters.AddWithValue("@pPageSize", pageSize);
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + ds.Tables[0].Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in ds.Tables[0].AsEnumerable()
                              select new UMStaffSearch
                              {
                                  StaffMasterId = Convert.ToInt32(n["StaffMasterId"]),
                                  StaffName = Convert.ToString(n["StaffName"]),
                                  DesignationId = n.Field<int?>("DesignationId"),
                                  Designation = Convert.ToString(n["Designation"]),
                                  StaffEmail = Convert.ToString(n["Email"] == System.DBNull.Value ? null : n["Email"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();

                }

                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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
        public List<EngAssetTypeCodeStandardTasksFetch> FetchTaskCode(EngAssetTypeCodeStandardTasksFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                List<EngAssetTypeCodeStandardTasksFetch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngAssetTypeCodeStandardTasksDet_Fetch";

                        cmd.Parameters.AddWithValue("@pAssetTaskCode", SearchObject.TaskCode ?? "");

                        cmd.Parameters.AddWithValue("@pPageIndex", pageIndex);
                        cmd.Parameters.AddWithValue("@pPageSize", pageSize);
                        if (SearchObject.TypeOfPlanner == 34)
                            cmd.Parameters.AddWithValue("@AssetTypeCodeId", SearchObject.hdnAssetTypeCodeId);
                        else
                            cmd.Parameters.AddWithValue("@AssetTypeCodeId", null);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + ds.Tables[0].Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in ds.Tables[0].AsEnumerable()
                              select new EngAssetTypeCodeStandardTasksFetch
                              {
                                  StandardTaskDetId = Convert.ToInt32(n["StandardTaskDetId"]),
                                  TaskCode = Convert.ToString(n["TaskCode"]),
                                  TaskDescription = Convert.ToString(n["TaskDescription"] ),
                                  // PPMFrequency = Convert.ToInt32(n["PPMFrequency"]),
                                  LovPPMFrequency = Convert.ToString(n["LovPPMFrequency"]),
                                  ManufacturerId = Convert.ToInt32(n["ManufacturerId"]),
                                  Manufacturer = Convert.ToString(n["Manufacturer"]),
                                  Model = Convert.ToString(n["Model"]),
                                  PpmHours = Convert.ToDecimal(n["PPMHours"]),
                                  PPMFrequency = Convert.ToInt16(n["PPMFrequency"] == System.DBNull.Value ? null : n["PPMFrequency"]),
                                  PPMFrequencyValue = Convert.ToString(n["PPMFrequencyValue"] == System.DBNull.Value ? null : n["PPMFrequencyValue"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex,
                                  PPMChecklistNo = Convert.ToString(n["PPMChecklistNo"]),
                              }).ToList();
                }

                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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
        public List<ItemMstFetchEntity> FetchItemMstdetais(ItemMstFetchEntity SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                var result = new List<ItemMstFetchEntity>();
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);

                var ds = new DataSet();
                //string connection = "Data Source=10.249.5.52;Initial Catalog=uetrackbemsdbPreProd;User ID=uesa;Password=nWQy@xrtz+G*";
                var dbAccessDAL = new DBAccessDAL();
                //var dbAccessDAL = new BEMSDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngSparePartsPartNo_Fetch";        // Stock Update Register

                        cmd.Parameters.AddWithValue("@pSparePartNo", SearchObject.Partno ?? "a");
                        cmd.Parameters.AddWithValue("@pPageIndex", pageIndex);
                        cmd.Parameters.AddWithValue("@pPageSize", pageSize);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + ds.Tables[0].Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in ds.Tables[0].AsEnumerable()
                              select new ItemMstFetchEntity
                              {
                                  SparePartsId = n.Field<int>("SparePartsId"),
                                  Partno = n.Field<string>("PartNo"),
                                  PartDescription = n.Field<string>("PartDescription"),
                                  ItemId = n.Field<int>("ItemId"),
                                  ItemCode = n.Field<string>("ItemNo"),
                                  ItemDescription = n.Field<string>("ItemDescription"),
                                  PartSource = n.Field<string>("PartSource"),
                                  LifeSpanOptionId = n.Field<int?>("LifeSpanOptionId"),
                                  EstimatedLifeSpanOption = n.Field<string>("LifeSpanOptionValue"),
                                  EstimatedLifeSpanType = n.Field<string>("LifeSpanOptionValue"),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();

                }

                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception e)
            {
                throw;
            }
        }
        public List<TypeCodeSearch> TypeCodeFetch(TypeCodeSearch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(TypeCodeFetch), Level.Info.ToString());
                List<TypeCodeSearch> result = null;
                var TOP = SearchObject.TypeOfPlanner;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var ScreenName = string.Empty;
                if (!string.IsNullOrEmpty(SearchObject.ScreenName))
                {
                    ScreenName = SearchObject.ScreenName;
                }
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngAssetTypeCode_Fetch";

                        cmd.Parameters.AddWithValue("@pTypeCode", SearchObject.AssetTypeCode ?? "a");
                        cmd.Parameters.AddWithValue("@pAssetClassificationId", SearchObject.AssetClassificationId);
                        cmd.Parameters.AddWithValue("@ScreenName", ScreenName);
                        cmd.Parameters.AddWithValue("@pPageIndex", pageIndex);
                        cmd.Parameters.AddWithValue("@pPageSize", pageSize);
                        cmd.Parameters.AddWithValue("@pPlannerFlag", TOP);

                        cmd.Parameters.AddWithValue("@pCheckEquipmentFunctionDescription", SearchObject.CheckEquipmentFunctionDescription);
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);
                        if (_UserSession.UserDB == 0)
                        {
                            cmd.Parameters.AddWithValue("@pServiceId", SearchObject.TypeOfServices);
                        }
                        else if( _UserSession.UserDB == 1)
                        {
                           
                            cmd.Parameters.AddWithValue("@pServiceId", 2);

                        }
                        else 
                        {

                            cmd.Parameters.AddWithValue("@pServiceId", 1);

                        }


                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + ds.Tables[0].Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in ds.Tables[0].AsEnumerable()
                              select new TypeCodeSearch
                              {
                                  AssetTypeCodeId = Convert.ToInt32(n["AssetTypeCodeId"]),
                                  AssetTypeCode = Convert.ToString(n["AssetTypeCode"]),
                                  AssetTypeDescription = Convert.ToString(n["AssetTypeDescription"]),
                                  AssetClassificationId = n.Field<int>("AssetClassificationId"),
                                  PPM = Convert.ToInt32(n["PPM"]) == 0 ? 100 : 99,
                                  RI = Convert.ToInt32(n["RI"]) == 0 ? 100 : 99,
                                  Other = Convert.ToInt32(n["Other"]) == 0 ? 100 : 99,
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();

                }

                Log4NetLogger.LogExit(_FileName, nameof(TypeCodeFetch), Level.Info.ToString());
                return result;
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

      

        public List<UserLocationCodeSearch> LocationCodeFetch(UserLocationCodeSearch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LocationCodeFetch), Level.Info.ToString());
                List<UserLocationCodeSearch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_MstLocationUserLocation_Fetch";

                        cmd.Parameters.AddWithValue("@pUserLocationCode", SearchObject.UserLocationCode ?? "");
                        if (SearchObject.UserAreaId != 0)
                        {
                            cmd.Parameters.AddWithValue("@pUserAreaId", SearchObject.UserAreaId);
                        }
                        cmd.Parameters.AddWithValue("@pPageIndex", pageIndex);
                        cmd.Parameters.AddWithValue("@pPageSize", pageSize);
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + ds.Tables[0].Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in ds.Tables[0].AsEnumerable()
                              select new UserLocationCodeSearch
                              {
                                  UserLocationId = Convert.ToInt32(n["UserLocationId"]),
                                  UserLocationCode = Convert.ToString(n["UserLocationCode"]),
                                  UserLocationName = Convert.ToString(n["UserLocationName"]),
                                  UserAreaId = n.Field<int>("UserAreaId"),
                                  UserAreaCode = Convert.ToString(n["UserAreaCode"]),
                                  UserAreaName = Convert.ToString(n["UserAreaName"]),
                                  LevelName = n.Field<string>("LevelName"),
                                  LevelCode = n.Field<string>("LevelCode"),
                                  BlockName = n.Field<string>("BlockName"),
                                  BlockCode = n.Field<string>("BlockCode"),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();

                }

                Log4NetLogger.LogExit(_FileName, nameof(LocationCodeFetch), Level.Info.ToString());
                return result;
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

        public List<ManufacturerSearch> ManufacturerFetch(ManufacturerSearch SearchObject)
        {
            try
            {
               Log4NetLogger.LogEntry(_FileName, nameof(ManufacturerFetch), Level.Info.ToString());
                List<ManufacturerSearch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);

                var spName = string.Empty;
                var isAssetStandardization = false;

                if (SearchObject.ScreenName == "AssetStandardization")
                {
                    spName = "uspFM_EngAssetStandardizationManufacturer_Fetch";
                    isAssetStandardization = true;
                }
                else
                {
                    spName = "uspFM_EngAssetManufacturer_Fetch";
                }

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = spName;

                        if (!isAssetStandardization)
                        {
                            cmd.Parameters.AddWithValue("@pAssetTypeCodeId", SearchObject.TypeCodeId);
                            cmd.Parameters.AddWithValue("@pModelId", SearchObject.ModelId);
                        }
                        cmd.Parameters.AddWithValue("@pManufacturer", SearchObject.Manufacturer ?? "");
                        cmd.Parameters.AddWithValue("@pPageIndex", pageIndex);
                        cmd.Parameters.AddWithValue("@pPageSize", pageSize);
                        cmd.Parameters.AddWithValue("@pServiceId", SearchObject.UserAreaCode);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + ds.Tables[0].Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in ds.Tables[0].AsEnumerable()
                              select new ManufacturerSearch
                              {
                                  ManufacturerId = Convert.ToInt32(n["ManufacturerId"]),
                                  Manufacturer = Convert.ToString(n["Manufacturer"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }

                Log4NetLogger.LogExit(_FileName, nameof(ManufacturerFetch), Level.Info.ToString());
                return result;
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


        public List<ModelSearch> ModelFetch(ModelSearch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ModelFetch), Level.Info.ToString());
                List<ModelSearch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);

                var spName = string.Empty;
                var isAssetStandardization = false;

                if (SearchObject.ScreenName == "AssetStandardization")
                {
                    spName = "uspFM_EngAssetStandardizationModel_Fetch";
                    isAssetStandardization = true;
                }
                else if (SearchObject.ScreenName == "ParameterMap")
                {
                    spName = "uspFM_EngParameterMappingModel_Fetch";
                }
                else
                {
                    spName = "c";
                }

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = spName;

                        if (!isAssetStandardization)
                        {
                            cmd.Parameters.AddWithValue("@pAssetTypeCodeId", SearchObject.TypeCodeId);
                        }
                        cmd.Parameters.AddWithValue("@pModel", SearchObject.Model ?? "");
                        cmd.Parameters.AddWithValue("@pPageIndex", pageIndex);
                        cmd.Parameters.AddWithValue("@pPageSize", pageSize);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + ds.Tables[0].Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in ds.Tables[0].AsEnumerable()
                              select new ModelSearch
                              {
                                  ModelId = Convert.ToInt32(n["ModelId"]),
                                  ManufacturerId = n.Field<int?>("ManufacturerId"),
                                  //  n.Field<int?>(n["ManufacturerId"])  
                                  //Convert.ToInt32(n["ManufacturerId"]),
                                  Model = Convert.ToString(n["Model"]),
                                  Manufacturer = Convert.ToString(n["Manufacturer"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();

                }

                Log4NetLogger.LogExit(_FileName, nameof(ModelFetch), Level.Info.ToString());
                return result;
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
        public List<RescheduleWOFetchModel> FetchRescheduleWOdetails(RescheduleWOFetchModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchRescheduleWOdetails), Level.Info.ToString());
                List<RescheduleWOFetchModel> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngMaintenanceWorkOrderTxn_Fetch";

                        cmd.Parameters.AddWithValue("@pWorkOrderNo", SearchObject.WorkOrderNo);
                        cmd.Parameters.AddWithValue("@pPageIndex", pageIndex);
                        cmd.Parameters.AddWithValue("@pPageSize", pageSize);
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + ds.Tables[0].Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in ds.Tables[0].AsEnumerable()
                              select new RescheduleWOFetchModel
                              {
                                  WorkOrderId = n.Field<int>("WorkOrderId"),
                                  WorkOrderNo = n.Field<string>("MaintenanceWorkNo"),
                                  WorkOrderDate = n.Field<DateTime>("MaintenanceWorkDateTime"),
                                  AssetId = n.Field<int>("AssetId"),
                                  AssetNo = n.Field<string>("AssetNo"),
                                  AssetDescription = n.Field<string>("AssetDescription"),
                                  TypeOfWorkOrderId = n.Field<int>("TypeOfWorkOrder"),
                                  TypeOfWorkOrderName = n.Field<string>("TypeOfWorkOrderName"),
                                  MaintenanceDetails = n.Field<string>("MaintenanceDetails"),
                                  TargetDate = n.Field<DateTime?>("TargetDateTime"),
                                  NextScheduleDate = n.Field<DateTime?>("NextScheduleDateTime"),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();

                }

                Log4NetLogger.LogExit(_FileName, nameof(FetchRescheduleWOdetails), Level.Info.ToString());
                return result;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception e)
            {
                throw;
            }
        }
        public List<AssetPreRegistrationNoSearch> AssetPreRegistrationNoFetch(AssetPreRegistrationNoSearch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(AssetPreRegistrationNoFetch), Level.Info.ToString());
                List<AssetPreRegistrationNoSearch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngTestingandCommissioningTxnDet_Fetch";

                        cmd.Parameters.AddWithValue("@pAssetPreRegistrationNo", SearchObject.AssetPreRegistrationNo ?? "");
                        cmd.Parameters.AddWithValue("@pAssetClassificationId", SearchObject.AssetClassificationId);
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId.ToString());
                        cmd.Parameters.AddWithValue("@pIsLoaner", SearchObject.IsLoaner);

                        cmd.Parameters.AddWithValue("@pPageIndex", pageIndex);
                        cmd.Parameters.AddWithValue("@pPageSize", pageSize);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + ds.Tables[0].Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in ds.Tables[0].AsEnumerable()
                              select new AssetPreRegistrationNoSearch
                              {
                                  TestingandCommissioningDetId = Convert.ToInt32(n["TestingandCommissioningDetId"]),
                                  AssetPreRegistrationNo = Convert.ToString(n["AssetPreRegistrationNo"]),
                                  TandCDate = Convert.ToDateTime(n["TandCDate"]),
                                  ServiceStartDate = n.Field<DateTime?>("ServiceStartDate"),
                                  PurchaseDate = n.Field<DateTime?>("PurchaseDate"),
                                  PurchaseCost = n.Field<decimal?>("PurchaseCost"),
                                  WarrantyStartDate = n.Field<DateTime?>("WarrantyStartDate"),
                                  WarrantyEndDate = n.Field<DateTime?>("WarrantyEndDate"),
                                  WarrantyDuration = n.Field<int?>("WarrantyDuration"),
                                  MainSupplierName = n.Field<string>("MainSupplierName"),
                                  AssetAge = n.Field<decimal?>("AssetAge"),
                                  YearsInService = n.Field<decimal?>("YearsInService"),
                                  PurchaseOrderNo = n.Field<string>("PurchaseOrderNo"),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();

                }

                Log4NetLogger.LogExit(_FileName, nameof(AssetPreRegistrationNoFetch), Level.Info.ToString());
                return result;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception e)
            {
                throw;
            }
        }
        public List<AssetRegisterWarrantyProviderGrid> FetchWarrantyProvider(AssetRegisterWarrantyProviderGrid SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                var result = new List<AssetRegisterWarrantyProviderGrid>();
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);

                var ds = new DataSet();

                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_MstContractorandVendor_Fetch";

                        cmd.Parameters.AddWithValue("@pContractorCode", SearchObject.SSMNo?? "");
                        cmd.Parameters.AddWithValue("@pPageIndex", pageIndex);
                        cmd.Parameters.AddWithValue("@pPageSize", pageSize);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + ds.Tables[0].Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in ds.Tables[0].AsEnumerable()
                              select new AssetRegisterWarrantyProviderGrid
                              {
                                  ContractorId = n.Field<int>("ContractorId"),
                                  SSMNo = n.Field<string>("SSMRegistrationCode"),
                                  ContractorName = n.Field<string>("ContractorName"),
                                  ContactPerson = n.Field<string>("ContactPerson"),
                                  ContactNo = n.Field<string>("ContactNo"),
                                  Email = n.Field<string>("Email"),
                                  FaxNo = n.Field<string>("FaxNo"),
                                  Address = n.Field<string>("Address"),
                                  Designation = n.Field<string>("Designation"),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();

                }

                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception e)
            {
                throw e;
            }
        }
        public List<CompanyStaffFetchModel> CompanyStaffFetch(CompanyStaffFetchModel searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                List<CompanyStaffFetchModel> result = null;
                var pageIndex = searchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new DBAccessDAL();
                var obj = new FacilityStaffFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pStaffName", searchObject.StaffName ?? "");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                parameters.Add("@pFacilityId", _UserSession.FacilityId.ToString());

                DataTable dt = dbAccessDAL.GetDataTable("uspFM_MstStaff_Company_Fetch", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in dt.AsEnumerable()
                              select new CompanyStaffFetchModel
                              {
                                  StaffMasterId = Convert.ToInt32(n["StaffMasterId"]),
                                  //StaffEmployeeId = Convert.ToString(n["StaffEmployeeId"]),
                                  StaffName = Convert.ToString(n["StaffName"]),
                                  FacilityName = Convert.ToString(n["FacilityName"]),
                                  ContactNumber = Convert.ToString(n["ContactNo"] == System.DBNull.Value ? null : n["ContactNo"]),
                                  Designation = Convert.ToString(n["Designation"] == System.DBNull.Value ? null : n["Designation"]),
                                  DesignationId = n.Field<int?>("DesignationId"),
                                  Experience = Convert.ToInt32(n["Experience"] == System.DBNull.Value ? null : n["Experience"]),
                                  Email = Convert.ToString(n["Email"] == System.DBNull.Value ? null : n["Email"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();

                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception exp)
            {
                throw;
            }
        }
        public List<FacilityStaffFetchModel> FacilityStaffFetch(FacilityStaffFetchModel searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                List<FacilityStaffFetchModel> result = null;
                var pageIndex = searchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new DBAccessDAL();
                var obj = new FacilityStaffFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pStaffName", searchObject.StaffName ?? "");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                parameters.Add("@pFacilityId", _UserSession.FacilityId.ToString());

                DataTable dt = dbAccessDAL.GetDataTable("uspFM_MstStaff_Facility_Fetch", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in dt.AsEnumerable()
                              select new FacilityStaffFetchModel
                              {
                                  StaffMasterId = Convert.ToInt32(n["StaffMasterId"]),
                                  //StaffEmployeeId = Convert.ToString(n["StaffEmployeeId"]),
                                  StaffName = Convert.ToString(n["StaffName"]),
                                  FacilityName = Convert.ToString(n["FacilityName"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();

                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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
        public List<LevelFetchModel> LevelCodeFetch(LevelFetchModel searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                List<LevelFetchModel> result = null;
                var pageIndex = searchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new DBAccessDAL();

                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pLevelCode", searchObject.LevelCode ?? "");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                parameters.Add("@pFacilityId", _UserSession.FacilityId.ToString());

                DataTable dt = dbAccessDAL.GetDataTable("uspFM_MstLocationLevel_Fetch", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in dt.AsEnumerable()
                              select new LevelFetchModel
                              {
                                  LevelId = Convert.ToInt32(n["LevelId"]),
                                  LevelCode = Convert.ToString(n["LevelCode"]),
                                  LevelName = Convert.ToString(n["LevelName"]),
                                  BlockId = Convert.ToInt32(n["BlockId"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();


                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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
        public List<WarrantyManagementSearch> AssetNoFetch(WarrantyManagementSearch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(AssetNoFetch), Level.Info.ToString());
                List<WarrantyManagementSearch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngAsset_WarrantyMgmt_Fetch";

                        cmd.Parameters.AddWithValue("@pAssetNo", SearchObject.AssetNo ?? "");
                        cmd.Parameters.AddWithValue("@pPageIndex", pageIndex);
                        cmd.Parameters.AddWithValue("@pPageSize", pageSize);
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + ds.Tables[0].Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in ds.Tables[0].AsEnumerable()
                              select new WarrantyManagementSearch
                              {

                                  AssetId = Convert.ToInt32(n["AssetId"]),
                                  AssetNo = Convert.ToString(n["AssetNo"]),
                                  TnCRefNo = Convert.ToString(n["TandCDocumentNo"]),
                                  AssetClassification = Convert.ToString(n["AssetClassificationCode"]),
                                  TypeCode = Convert.ToString(n["AssetTypeCode"]),
                                  AssetDescription = Convert.ToString(n["AssetTypeDescription"]),
                                  WarrantyStartDate = Convert.ToDateTime(n["WarrantyStartDate"]),
                                  WarrantyEndDate = Convert.ToDateTime(n["WarrantyEndDate"]),
                                  WarrantyPeriod = Convert.ToInt32(n["WarrantyDuration"]),
                                  PurchaseCost = Convert.ToDecimal(n["PurchaseCostRM"]),
                                  DWFee = Convert.ToDecimal(n["MonthlyProposedFeeDW"]),
                                  PWFee = Convert.ToDecimal(n["MonthlyProposedFeePW"]),
                                  WarrantyDownTime = Convert.ToInt32(n["DowntimeHoursMin"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }

                Log4NetLogger.LogExit(_FileName, nameof(AssetNoFetch), Level.Info.ToString());
                return result;
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
        public List<UserAreaFetch> UserAreaFetch(UserAreaFetch searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                List<UserAreaFetch> result = null;
                var pageIndex = searchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pUserAreaCode", searchObject.UserAreaCode ?? "");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                parameters.Add("@pFacilityId", _UserSession.FacilityId.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_MstLocationUserArea_Fetch", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in dt.AsEnumerable()
                              select new UserAreaFetch
                              {
                                  UserAreaId = Convert.ToInt32(n["UserAreaId"]),
                                  LevelId = Convert.ToInt32(n["LevelId"]),
                                  UserAreaCode = Convert.ToString(n["UserAreaCode"]),
                                  UserAreaName = Convert.ToString(n["UserAreaName"]),
                                  AssetCount = Convert.ToString(n["AssetCount"]),
                                  BlockId = Convert.ToInt32(n["BlockId"]),
                                  CompRepId = Convert.ToInt32(n["CustomerUserId"]),
                                  FacRepId = Convert.ToInt32(n["FacilityUserId"]),
                                  CompRep = Convert.ToString(n["CompanyRepresentative"]),
                                  FacRep = Convert.ToString(n["FacilityRepresentative"]),
                                  CompRepEmail = Convert.ToString(n["CompanyRepresentativeEmail"]),
                                  FacRepEmail = Convert.ToString(n["FacilityRepresentativeEmail"]),
                                  //---Added for LLs---
                                  ActiveFromDate = Convert.ToDateTime(n["ActiveFromDate"]),
                                  ActiveToDate = Convert.ToDateTime(n["ActiveToDate"] == System.DBNull.Value ? null : n["ActiveToDate"]),
                                  //-------------------
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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
        public List<StockAdjustmentFetchModel> StockAdjustmentFetchModel(StockAdjustmentFetchModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(StockAdjustmentFetchModel), Level.Info.ToString());
                List<StockAdjustmentFetchModel> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngStockUpdateRegisterTxnDet_Fetch";     //   Stock Adjustment

                        cmd.Parameters.AddWithValue("@pSparePartNo", SearchObject.PartNo ?? "");
                        cmd.Parameters.AddWithValue("@pPageIndex", pageIndex);
                        cmd.Parameters.AddWithValue("@pPageSize", pageSize);
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + ds.Tables[0].Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in ds.Tables[0].AsEnumerable()
                              select new StockAdjustmentFetchModel
                              {

                                  //StockAdjustmentId = Convert.ToInt32(n["StockAdjustmentId"]),
                                  // StockAdjustmentDetId = Convert.ToInt32(n["StockAdjustmentDetId"]),
                                  PartNo = Convert.ToString(n["PartNo"]),
                                  PartDescription = Convert.ToString(n["PartDescription"]),
                                  ItemCode = Convert.ToString(n["ItemNo"]),
                                  ItemDescription = Convert.ToString(n["ItemDescription"]),
                                  BinNo = Convert.ToString(n["BinNo"]),
                                  SparePartsId = Convert.ToInt32(n["SparePartsId"]),
                                  SparePartTypeName = Convert.ToString(n["SparePartTypeName"]),
                                  QuantityFacility = Convert.ToDecimal(n["Quantity"]),
                                  StockUpdateDetId = Convert.ToInt32(n["StockUpdateDetId"]),
                                  Cost = Convert.ToDecimal(n["Cost"]),
                                  PurchaseCost = Convert.ToDecimal(n["PurchaseCost"]),
                                  InvoiceNo = Convert.ToString(n["InvoiceNo"]),
                                  VendorName = Convert.ToString(n["VendorName"]),
                                  //PartCategory = Convert.ToInt32(n["PartCategory"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }

                Log4NetLogger.LogExit(_FileName, nameof(StockAdjustmentFetchModel), Level.Info.ToString());
                return result;
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
        public List<ParentAssetNoSearch> AssetNoFetch(ParentAssetNoSearch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(AssetNoFetch), Level.Info.ToString());
               List<ParentAssetNoSearch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        if (SearchObject.TypeOfPlanner == 34)
                        {
                            cmd.CommandText = "uspFM_EngAssetPlanner_Fetch";
                        }
                        else if (SearchObject.TypeOfPlanner == 36 || SearchObject.TypeOfPlanner == 198 || SearchObject.TypeOfPlanner == 343)
                        {
                            cmd.CommandText = "uspFM_EngAssetOthersPlanner_Fetch";
                        }
                        else
                        {
                            cmd.CommandText = "uspFM_EngAsset_Fetch";
                        }
                        if (SearchObject.TypeOfPlanner == 34)
                        {
                            cmd.Parameters.AddWithValue("@pAssetNo", SearchObject.AssetNo ?? "");
                            cmd.Parameters.AddWithValue("@pCurrentAssetId", SearchObject.CurrentAssetId);
                            cmd.Parameters.AddWithValue("@pPageIndex", pageIndex);
                            cmd.Parameters.AddWithValue("@pPageSize", pageSize);
                            cmd.Parameters.AddWithValue("@pAssetTypeCodeId", SearchObject.TypeCode);
                            cmd.Parameters.AddWithValue("@pAssetClassificationId", SearchObject.AssetClarification);
                            cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);
                            cmd.Parameters.AddWithValue("@pYear", SearchObject.Year);
                        }
                        else if (SearchObject.TypeOfPlanner == 36 || SearchObject.TypeOfPlanner == 198 || SearchObject.TypeOfPlanner == 343)
                        {
                            cmd.Parameters.AddWithValue("@pAssetNo", SearchObject.AssetNo ?? "");
                            cmd.Parameters.AddWithValue("@pAssetTypeCodeId", SearchObject.TypeCode);
                            cmd.Parameters.AddWithValue("@pTypeOfPlanner", SearchObject.TypeOfPlanner);
                            cmd.Parameters.AddWithValue("@pPageIndex", pageIndex);
                            cmd.Parameters.AddWithValue("@pPageSize", pageSize);
                            cmd.Parameters.AddWithValue("@pAssetClassificationId", SearchObject.AssetClarification);
                            cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);
                        }
                        else
                        {
                            cmd.Parameters.AddWithValue("@pAssetNo", SearchObject.AssetNo ?? "");
                            cmd.Parameters.AddWithValue("@pCurrentAssetId", SearchObject.CurrentAssetId);
                            cmd.Parameters.AddWithValue("@pPageIndex", pageIndex);
                            cmd.Parameters.AddWithValue("@pPageSize", pageSize);
                            cmd.Parameters.AddWithValue("@pAssetTypeCodeId", SearchObject.TypeCode);
                            cmd.Parameters.AddWithValue("@pAssetClassificationId", SearchObject.AssetClarification);
                            cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);
                            cmd.Parameters.AddWithValue("@pTypeOfAsset", SearchObject.CategoryId);
                            cmd.Parameters.AddWithValue("@pIsFromAssetRegister", SearchObject.IsFromAssetRegister);
                            cmd.Parameters.AddWithValue("@pTypeofPlanner", SearchObject.TypeOfPlanner);
                        }

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + ds.Tables[0].Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    if (SearchObject.TypeOfPlanner == 34)
                    {
                        result = (from n in ds.Tables[0].AsEnumerable()
                                  select new ParentAssetNoSearch
                                  {

                                      AssetId = Convert.ToInt32(n["AssetId"]),
                                      AssetNo = Convert.ToString(n["AssetNo"]),
                                      AssetDescription = Convert.ToString(n["AssetDescription"]),
                                      AssetClarification = Convert.ToInt32(n["AssetClassificationId"]),
                                      AssetClarificationCode = Convert.ToString(n["AssetClassificationCode"]),
                                      ContractTypeValue = Convert.ToString(n["ContractTypeValue"] == System.DBNull.Value ? null : n["ContractTypeValue"]),
                                      Model = Convert.ToString(n["Model"]),
                                      Level = Convert.ToString(n["LevelCode"]),
                                      Block = Convert.ToString(n["BlockCode"]),
                                      Manufacturer = Convert.ToString(n["Manufacturer"]),
                                      SerialNumber = Convert.ToString(n["SerialNo"]),
                                      UserAreaId = Convert.ToInt32(n["UserAreaId"] == System.DBNull.Value ? null : n["UserAreaId"]),
                                      ManufacturerId = Convert.ToInt32(n["ManufacturerId"]),
                                      UserAreaCode = Convert.ToString(n["UserAreaCode"]),
                                      UserAreaName = Convert.ToString(n["UserAreaName"]),
                                      UserLocationId = Convert.ToInt32(n["UserLocationId"] == System.DBNull.Value ? null : n["UserLocationId"]),
                                      UserLocationCode = Convert.ToString(n["UserLocationCode"]),
                                      UserLocationName = Convert.ToString(n["UserLocationName"]),
                                      TypeCodeID = Convert.ToInt32(n["AssetTypeCodeId"]),
                                      TypeCode = Convert.ToString(n["AssetTypeCode"]),
                                      TypeCodeDescription = Convert.ToString(n["AssetTypeDescription"]),
                                      WarrentyEndDate = Convert.ToDateTime(n["WarrantyEndDate"] == System.DBNull.Value ? null : n["WarrantyEndDate"]),
                                      WarrentyType = Convert.ToInt32(n["TypeofAsset"]),
                                      SupplierName = Convert.ToString(n["MainSupplier"] == System.DBNull.Value ? null : n["MainSupplier"]),
                                      ContractEndDate = n.Field<DateTime?>("ContractEndDate"),
                                      ContractorName = Convert.ToString(n["ContractorName"] == System.DBNull.Value ? null : n["ContractorName"]),
                                      ContactNumber = Convert.ToString(n["ContactNumber"] == System.DBNull.Value ? null : n["ContactNumber"]),
                                      WorkOrderType = Convert.ToInt32(n["WorkOrderType"]),
                                      TaskCode = n.Field<string>("TaskCode"),
                                      TaskCodeId = n.Field<int?>("TaskCodeId"),
                                      PPMFrequencyValue = n.Field<string>("PPMFrequencyValue"),
                                      TotalRecords = totalRecords,
                                      FirstRecord = firstRecord,
                                      LastRecord = lastRecord,
                                      LastPageIndex = lastPageIndex
                                  }).ToList();
                    }
                    else if (SearchObject.TypeOfPlanner == 36 || SearchObject.TypeOfPlanner == 198 || SearchObject.TypeOfPlanner == 343)
                    {
                        result = (from n in ds.Tables[0].AsEnumerable()
                                  select new ParentAssetNoSearch
                                  {

                                      AssetId = Convert.ToInt32(n["AssetId"]),
                                      AssetNo = Convert.ToString(n["AssetNo"]),
                                      Asset_Name = Convert.ToString(n["AssetName"]),
                                      AssetDescription = Convert.ToString(n["AssetDescription"]),
                                      AssetClarification = Convert.ToInt32(n["AssetClassificationId"]),
                                      ContractTypeValue = Convert.ToString(n["ContractTypeValue"] == System.DBNull.Value ? null : n["ContractTypeValue"]),
                                      Model = Convert.ToString(n["Model"]),
                                      Manufacturer = Convert.ToString(n["Manufacturer"]),
                                      SerialNumber = Convert.ToString(n["SerialNo"]),
                                      UserAreaId = Convert.ToInt32(n["UserAreaId"]),
                                      ManufacturerId = Convert.ToInt32(n["ManufacturerId"]),
                                      ModelId = Convert.ToInt32(n["ModelId"]),
                                      UserAreaCode = Convert.ToString(n["UserAreaCode"]),
                                      UserAreaName = Convert.ToString(n["UserAreaName"]),
                                      UserLocationId = Convert.ToInt32(n["UserLocationId"]),
                                      UserLocationCode = Convert.ToString(n["UserLocationCode"]),
                                      UserLocationName = Convert.ToString(n["UserLocationName"]),
                                      TypeCodeID = Convert.ToInt32(n["AssetTypeCodeId"]),
                                      TypeCode = Convert.ToString(n["AssetTypeCode"]),
                                      WarrentyEndDate = Convert.ToDateTime(n["WarrantyEndDate"] == System.DBNull.Value ? null : n["WarrantyEndDate"]),
                                      SupplierName = Convert.ToString(n["MainSupplier"] == System.DBNull.Value ? null : n["MainSupplier"]),
                                      ContractEndDate = Convert.ToDateTime(n["ContractEndDate"] == System.DBNull.Value ? null : n["ContractEndDate"]),
                                      ContractorName = Convert.ToString(n["ContractorName"] == System.DBNull.Value ? null : n["ContractorName"]),
                                      ContactNumber = Convert.ToString(n["ContactNumber"] == System.DBNull.Value ? null : n["ContactNumber"]),
                                      TaskCode = n.Field<string>("TaskCode"),
                                      TaskCodeId = n.Field<int?>("TaskCodeId"),
                                      TotalRecords = totalRecords,
                                      FirstRecord = firstRecord,
                                      LastRecord = lastRecord,
                                      LastPageIndex = lastPageIndex
                                  }).ToList();

                    }
                    else
                    {
                        result = (from n in ds.Tables[0].AsEnumerable()
                                  select new ParentAssetNoSearch
                                  {

                                      AssetId = Convert.ToInt32(n["AssetId"]),
                                      AssetNo = Convert.ToString(n["AssetNo"]),
                                      Asset_Name = Convert.ToString(n["Asset_Name"]),
                                      AssetDescription = Convert.ToString(n["AssetDescription"]),
                                      AssetClarification = Convert.ToInt32(n["AssetClassificationId"]),
                                      ContractTypeValue = Convert.ToString(n["ContractTypeValue"] == System.DBNull.Value ? null : n["ContractTypeValue"]),
                                      Model = Convert.ToString(n["Model"]),
                                      Manufacturer = Convert.ToString(n["Manufacturer"]),
                                      SerialNumber = Convert.ToString(n["SerialNo"]),
                                      UserAreaId = Convert.ToInt32(n["UserAreaId"] == System.DBNull.Value ? null : n["UserAreaId"]),
                                      ManufacturerId = Convert.ToInt32(n["ManufacturerId"]),
                                      ModelId = Convert.ToInt32(n["ModelId"]),
                                      UserAreaCode = Convert.ToString(n["UserAreaCode"]),
                                      UserAreaName = Convert.ToString(n["UserAreaName"]),
                                      UserLocationId = Convert.ToInt32(n["UserLocationId"] == System.DBNull.Value ? null : n["UserLocationId"]),
                                      UserLocationCode = Convert.ToString(n["UserLocationCode"]),
                                      UserLocationName = Convert.ToString(n["UserLocationName"]),
                                      TypeCodeID = Convert.ToInt32(n["AssetTypeCodeId"]),
                                      TypeCode = Convert.ToString(n["AssetTypeCode"]),
                                      WarrentyEndDate = Convert.ToDateTime(n["WarrantyEndDate"] == System.DBNull.Value ? null : n["WarrantyEndDate"]),
                                      SupplierName = Convert.ToString(n["MainSupplier"] == System.DBNull.Value ? null : n["MainSupplier"]),
                                      ContractEndDate = Convert.ToDateTime(n["ContractEndDate"] == System.DBNull.Value ? null : n["ContractEndDate"]),
                                      ContractorName = Convert.ToString(n["ContractorName"] == System.DBNull.Value ? null : n["ContractorName"]),
                                      ContactNumber = Convert.ToString(n["ContactNumber"] == System.DBNull.Value ? null : n["ContactNumber"]),
                                      TotalRecords = totalRecords,
                                      FirstRecord = firstRecord,
                                      LastRecord = lastRecord,
                                      LastPageIndex = lastPageIndex
                                  }).ToList();

                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(AssetNoFetch), Level.Info.ToString());
                return result;
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
        public List<ParentAssetNoSearch> FacilityWorkAssetNoFetch(ParentAssetNoSearch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FacilityWorkAssetNoFetch), Level.Info.ToString());
                List<ParentAssetNoSearch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        if (SearchObject.TypeOfPlanner == 34)
                            cmd.CommandText = "uspFM_EngAssetPlanner_Fetch";
                        else
                            cmd.CommandText = "uspFM_EngAsset_Fetch_FAcilityWorkshop";
                        if (SearchObject.TypeOfPlanner == 34)
                        {
                            cmd.Parameters.AddWithValue("@pAssetNo", SearchObject.AssetNo ?? "");
                            cmd.Parameters.AddWithValue("@pCurrentAssetId", SearchObject.CurrentAssetId);
                            cmd.Parameters.AddWithValue("@pPageIndex", pageIndex);
                            cmd.Parameters.AddWithValue("@pPageSize", pageSize);
                            cmd.Parameters.AddWithValue("@pAssetTypeCodeId", SearchObject.TypeCode);
                            cmd.Parameters.AddWithValue("@pAssetClassificationId", SearchObject.AssetClarification);
                            cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);
                        }
                        else
                        {
                            cmd.Parameters.AddWithValue("@pAssetNo", SearchObject.AssetNo ?? "");
                            cmd.Parameters.AddWithValue("@pCurrentAssetId", SearchObject.CurrentAssetId);
                            cmd.Parameters.AddWithValue("@pPageIndex", pageIndex);
                            cmd.Parameters.AddWithValue("@pPageSize", pageSize);
                            cmd.Parameters.AddWithValue("@pAssetTypeCodeId", SearchObject.TypeCode);
                            cmd.Parameters.AddWithValue("@pAssetClassificationId", SearchObject.AssetClarification);
                            cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);
                            cmd.Parameters.AddWithValue("@pTypeOfAsset", SearchObject.CategoryId);
                            cmd.Parameters.AddWithValue("@pIsFromAssetRegister", SearchObject.IsFromAssetRegister);
                            cmd.Parameters.AddWithValue("@pTypeofPlanner", SearchObject.TypeOfPlanner);
                        }

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + ds.Tables[0].Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    if (SearchObject.TypeOfPlanner == 34)
                    {
                        result = (from n in ds.Tables[0].AsEnumerable()
                                  select new ParentAssetNoSearch
                                  {

                                      AssetId = Convert.ToInt32(n["AssetId"]),
                                      AssetNo = Convert.ToString(n["AssetNo"]),
                                      AssetDescription = Convert.ToString(n["AssetDescription"]),
                                      AssetClarification = Convert.ToInt32(n["AssetClassificationId"]),
                                      AssetClarificationCode = Convert.ToString(n["AssetClassificationCode"]),
                                      ContractTypeValue = Convert.ToString(n["ContractTypeValue"] == System.DBNull.Value ? null : n["ContractTypeValue"]),
                                      Model = Convert.ToString(n["Model"]),
                                      Level = Convert.ToString(n["LevelCode"]),
                                      Block = Convert.ToString(n["BlockCode"]),
                                      Manufacturer = Convert.ToString(n["Manufacturer"]),
                                      SerialNumber = Convert.ToString(n["SerialNo"]),
                                      UserAreaId = Convert.ToInt32(n["UserAreaId"]),
                                      ManufacturerId = Convert.ToInt32(n["ManufacturerId"]),
                                      ModelId = Convert.ToInt32(n["ModelId"]),
                                      UserAreaCode = Convert.ToString(n["UserAreaCode"]),
                                      UserAreaName = Convert.ToString(n["UserAreaName"]),
                                      UserLocationId = Convert.ToInt32(n["UserLocationId"]),
                                      UserLocationCode = Convert.ToString(n["UserLocationCode"]),
                                      UserLocationName = Convert.ToString(n["UserLocationName"]),
                                      TypeCodeID = Convert.ToInt32(n["AssetTypeCodeId"]),
                                      TypeCode = Convert.ToString(n["AssetTypeCode"]),
                                      TypeCodeDescription = Convert.ToString(n["AssetTypeDescription"]),
                                      WarrentyEndDate = Convert.ToDateTime(n["WarrantyEndDate"] == System.DBNull.Value ? null : n["WarrantyEndDate"]),
                                      WarrentyType = Convert.ToInt32(n["TypeofAsset"]),
                                      SupplierName = Convert.ToString(n["MainSupplier"] == System.DBNull.Value ? null : n["MainSupplier"]),
                                      ContractEndDate = Convert.ToDateTime(n["ContractEndDate"] == System.DBNull.Value ? null : n["ContractEndDate"]),
                                      ContractorName = Convert.ToString(n["ContractorName"] == System.DBNull.Value ? null : n["ContractorName"]),
                                      ContactNumber = Convert.ToString(n["ContactNumber"] == System.DBNull.Value ? null : n["ContactNumber"]),
                                      WorkOrderType = Convert.ToInt32(n["WorkOrderType"]),
                                      TotalRecords = totalRecords,
                                      FirstRecord = firstRecord,
                                      LastRecord = lastRecord,
                                      LastPageIndex = lastPageIndex
                                  }).ToList();
                    }
                    else
                    {
                        result = (from n in ds.Tables[0].AsEnumerable()
                                  select new ParentAssetNoSearch
                                  {

                                      AssetId = Convert.ToInt32(n["AssetId"]),
                                      AssetNo = Convert.ToString(n["AssetNo"]),
                                      AssetDescription = Convert.ToString(n["AssetDescription"]),
                                      AssetClarification = Convert.ToInt32(n["AssetClassificationId"]),
                                      ContractTypeValue = Convert.ToString(n["ContractTypeValue"] == System.DBNull.Value ? null : n["ContractTypeValue"]),
                                      Model = Convert.ToString(n["Model"]),
                                      Manufacturer = Convert.ToString(n["Manufacturer"]),
                                      SerialNumber = Convert.ToString(n["SerialNo"]),
                                      UserAreaId = Convert.ToInt32(n["UserAreaId"]),
                                      ManufacturerId = Convert.ToInt32(n["ManufacturerId"]),
                                      ModelId = Convert.ToInt32(n["ModelId"]),
                                      UserAreaCode = Convert.ToString(n["UserAreaCode"]),
                                      UserAreaName = Convert.ToString(n["UserAreaName"]),
                                      UserLocationId = Convert.ToInt32(n["UserLocationId"]),
                                      UserLocationCode = Convert.ToString(n["UserLocationCode"]),
                                      UserLocationName = Convert.ToString(n["UserLocationName"]),
                                      TypeCodeID = Convert.ToInt32(n["AssetTypeCodeId"]),
                                      TypeCode = Convert.ToString(n["AssetTypeCode"]),
                                      WarrentyEndDate = Convert.ToDateTime(n["WarrantyEndDate"] == System.DBNull.Value ? null : n["WarrantyEndDate"]),
                                      SupplierName = Convert.ToString(n["MainSupplier"] == System.DBNull.Value ? null : n["MainSupplier"]),
                                      ContractEndDate = Convert.ToDateTime(n["ContractEndDate"] == System.DBNull.Value ? null : n["ContractEndDate"]),
                                      ContractorName = Convert.ToString(n["ContractorName"] == System.DBNull.Value ? null : n["ContractorName"]),
                                      ContactNumber = Convert.ToString(n["ContactNumber"] == System.DBNull.Value ? null : n["ContactNumber"]),
                                      TotalRecords = totalRecords,
                                      FirstRecord = firstRecord,
                                      LastRecord = lastRecord,
                                      LastPageIndex = lastPageIndex
                                  }).ToList();

                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(AssetNoFetch), Level.Info.ToString());
                return result;
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
        public List<AssetClassificationFetch> AssetClassificationCodeFetch(AssetClassificationFetch searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                List<AssetClassificationFetch> result = null;
                var pageIndex = searchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new DBAccessDAL();
                var obj = new FacilityStaffFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pAssetClassificationCode", searchObject.AssetClassificationCode ?? "");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                parameters.Add("@pServiceId", Convert.ToString(searchObject.TypeOfServices));

                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EngAssetClassification_Fetch", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in dt.AsEnumerable()
                              select new AssetClassificationFetch
                              {
                                  AssetClassificationId = Convert.ToInt32(n["AssetClassificationId"]),
                                  AssetClassificationCode = Convert.ToString(n["AssetClassificationCode"]),
                                  AssetClassificationDescription = Convert.ToString(n["AssetClassificationDescription"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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
        public List<ItemCodeFetch> ItemCodeFetch(ItemCodeFetch searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                List<ItemCodeFetch> result = null;
                var pageIndex = searchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new DBAccessDAL();
                var obj = new ItemCodeFetch();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pItemNo", searchObject.ItemNo ?? "");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));

                DataTable dt = dbAccessDAL.GetDataTable("uspFM_FMItemMaster_Fetch", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in dt.AsEnumerable()
                              select new ItemCodeFetch
                              {
                                  ItemId = Convert.ToInt32(n["ItemId"]),
                                  ItemNo = Convert.ToString(n["ItemNo"]),
                                  ItemDescription = Convert.ToString(n["ItemDescription"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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
        public List<SNFAssetFetchEntity> SNFAssetFetch(SNFAssetFetchEntity searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(SNFAssetFetch), Level.Info.ToString());
                List<SNFAssetFetchEntity> result = null;
                var pageIndex = searchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new DBAccessDAL();
                var obj = new SNFAssetFetchEntity();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pAssetNo", searchObject.AssetNo ?? "");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                parameters.Add("@pFacilityId", _UserSession.FacilityId.ToString());

                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EngAssetSNF_Fetch", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in dt.AsEnumerable()
                              select new SNFAssetFetchEntity
                              {
                                  AssetId = Convert.ToInt32(n["AssetId"]),
                                  AssetNo = Convert.ToString(n["AssetNo"]),
                                  PurchaseDate = n.Field<DateTime?>("PurchaseDate"),
                                  PurchaseCostRM = n.Field<decimal?>("PurchaseCostRM"),
                                  ServiceStartDate = n.Field<DateTime>("ServiceStartDate"),
                                  WarrantyStartDate = n.Field<DateTime?>("WarrantyStartDate"),
                                  WarrantyEndDate = n.Field<DateTime?>("WarrantyEndDate"),
                                  WarrantyStatus = n.Field<string>("WarrantyStatus"),
                                  WarrantyDuration = n.Field<decimal?>("WarrantyDuration"),
                                  MainSupplierCode = n.Field<string>("MainSupplierCode"),
                                  MainSupplier = n.Field<string>("MainSupplier"),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(SNFAssetFetch), Level.Info.ToString());
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
        public List<PPMCheckListFetchItem> FetchCheckListItemDetails(PPMCheckListFetchItem searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                List<PPMCheckListFetchItem> result = null;
                var pageIndex = searchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new DBAccessDAL();
                var obj = new PPMCheckListFetchItem();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pItemNo", searchObject.Name ?? "");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));

                DataTable dt = dbAccessDAL.GetDataTable("uspFM_FMItemMaster_Fetch", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in dt.AsEnumerable()
                              select new PPMCheckListFetchItem
                              {
                                  ChecklistItemId = Convert.ToInt32(n["ItemId"]),
                                  Name = Convert.ToString(n["ItemNo"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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
        public List<SNFfetchEntity> FetchSNFDetails(SNFfetchEntity searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                List<SNFfetchEntity> result = null;
                var pageIndex = searchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new DBAccessDAL();
                var obj = new PPMCheckListFetchItem();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pSNFDocNo", searchObject.SNFDocNo ?? "");
                parameters.Add("@pAssetId", searchObject.AssetId.ToString());
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                parameters.Add("@pFacilityId", _UserSession.FacilityId.ToString());

                DataTable dt = dbAccessDAL.GetDataTable("uspFM_SNF_Fetch", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in dt.AsEnumerable()
                              select new SNFfetchEntity
                              {
                                  TestingandCommissioningId = Convert.ToInt32(n["TestingandCommissioningId"]),
                                  SNFDocNo = Convert.ToString(n["SNFDocumentNo"]),
                                  AssetId = Convert.ToInt32(n["AssetId"]),
                                  VariationStatusLovId = Convert.ToInt32(n["VariationStatusLovId"]),
                                  PurchaseProjectCost = n.Field<decimal?>("PurchaseProjectCost"),
                                  VariationDate = n.Field<DateTime>("VariationDate"),
                                  StartServiceDate = n.Field<DateTime?>("StartServiceDate"),
                                  StopServiceDate = n.Field<DateTime?>("StopServiceDate"),
                                  CommissioningDate = n.Field<DateTime>("CommissioningDate"),
                                  WarrantyEndDate = n.Field<DateTime?>("WarrantyEndDate"),
                                  VariationMonth = n.Field<int>("VariationMonth"),
                                  VariationYear = n.Field<int>("VariationYear"),
                                  VariationApprovedStatusLovId = n.Field<int?>("VariationApprovedStatusLovId"),
                                  VariationStatusLovName = n.Field<string>("VariationStatusLovName"),
                                  PurchaseDate = n["PurchaseDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime((n["PurchaseDate"])),
                                  ContractLpoNo = n.Field<string>("ContractLpoNo"),
                                  //AuthorizedStatus=n.Field<bool?>("AuthorizedStatus"),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception exc)
            {
                throw;
            }
        }
        public List<BERAssetNoFetch> BERAssetNoFetch(BERAssetNoFetch searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                List<BERAssetNoFetch> result = null;
                var pageIndex = searchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pAssetNo", searchObject.AssetNo ?? "");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                parameters.Add("@pFacilityId", _UserSession.FacilityId.ToString());



                var _service = 0;
                switch (_UserSession.ModuleId)
                {
                    case 3:
                        {
                            _service = 2;
                            break;
                        }

                    case 13:
                        {
                            _service = 1;
                            break;
                        }
                    case 19:
                        {
                            _service = 6;
                            break;
                        }
                }


                DataTable dt = dbAccessDAL.GetDataTableUsingServiceId("uspFM_BERAsset_Fetch", parameters, DataSetparameters, _service);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in dt.AsEnumerable()
                              select new BERAssetNoFetch
                              {
                                  AssetId = Convert.ToInt32(n["AssetId"]),
                                  AssetNo = Convert.ToString(n["AssetNo"]),
                                  AssetDescription = Convert.ToString(n["AssetDescription"]),
                                  UserLocationCode = Convert.ToString(n["UserLocationCode"]),
                                  UserLocationName = Convert.ToString(n["UserLocationName"]),
                                  Manufacturer = Convert.ToString(n["Manufacturer"]),
                                  Model = Convert.ToString(n["Model"]),
                                  SupplierName = Convert.ToString(n["MainSupplier"]),
                                  PurchaseCost = n.Field<decimal?>("PurchaseCostRM"),   // Convert.ToDecimal(n["PurchaseCostRM"]),
                                  PurchaseDate = Convert.ToDateTime(n["PurchaseDate"] == DBNull.Value ? null : n["PurchaseDate"]),
                                  CurrentValue = n.Field<decimal?>("CurrentValue"),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex,
                                  AssetAge = n.Field<decimal?>("AssetAge"),
                                  StillwithInLifeSpan = n.Field<int?>("StillwithInLifeSpan"),
                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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
        public List<BERRejectedNoFetch> BERRejectedNoFetch(BERRejectedNoFetch searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                List<BERRejectedNoFetch> result = null;
                var pageIndex = searchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new DBAccessDAL();

                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pBERNo", searchObject.BERno ?? "");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                parameters.Add("@pBERStage", Convert.ToString(searchObject.BERStage));
                parameters.Add("@pFacilityId", _UserSession.FacilityId.ToString());

                DataTable dt = dbAccessDAL.GetDataTable("uspFM_BERDocNo_Rejected_Fetch", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in dt.AsEnumerable()
                              select new BERRejectedNoFetch
                              {
                                  RejectedApplicationId = Convert.ToInt32(n["ApplicationId"]),
                                  BERno = Convert.ToString(n["BERno"]),
                                  BERStatusLovId = Convert.ToInt32(n["BERStatusLovId"]),
                                  BERStatusName = Convert.ToString(n["BERStatusName"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();


                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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
        public List<AssetQRCodePrintFetchModel> AssetQRCodePrintFetchModel(AssetQRCodePrintFetchModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(AssetQRCodePrintFetchModel), Level.Info.ToString());
                List<AssetQRCodePrintFetchModel> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngAssetQR_Fetch";

                        cmd.Parameters.AddWithValue("@pAssetNo", SearchObject.AssetNo ?? "");
                        cmd.Parameters.AddWithValue("@pPageIndex", pageIndex);
                        cmd.Parameters.AddWithValue("@pPageSize", pageSize);
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + ds.Tables[0].Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in ds.Tables[0].AsEnumerable()
                              select new AssetQRCodePrintFetchModel
                              {

                                  AssetId = Convert.ToInt32(n["AssetId"]),
                                  AssetNo = Convert.ToString(n["AssetNo"]),
                                  AssetDescription = Convert.ToString(n["AssetDescription"]),
                                  UserAreaName = Convert.ToString(n["UserAreaName"]),
                                  UserLocationName = Convert.ToString(n["UserLocationName"]),
                                  AssetTypeCodeId = Convert.ToInt32(n["AssetTypeCodeId"]),
                                  UserAreaId = Convert.ToInt32(n["UserAreaId"]),
                                  UserLocationId = Convert.ToInt32(n["UserLocationId"]),
                                  AssetTypeCode = Convert.ToString(n["AssetTypeCode"]),
                                  Manufacturer = Convert.ToString(n["Manufacturer"]),
                                  Model = Convert.ToString(n["Model"]),
                                  ContractType = Convert.ToString(n["ContractType"]),
                                  AssetQRCode = (n["AssetQRCode"]) == System.DBNull.Value ? null : Convert.ToBase64String((byte[])(n["AssetQRCode"])),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }

                Log4NetLogger.LogExit(_FileName, nameof(AssetQRCodePrintFetchModel), Level.Info.ToString());
                return result;
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
        public List<UserLocationQRCodePrintingFetchModel> UserLocationQRCodePrintingFetchModel(UserLocationQRCodePrintingFetchModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(UserLocationQRCodePrintingFetchModel), Level.Info.ToString());
                List<UserLocationQRCodePrintingFetchModel> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_MstLocationBlockQR_Fetch";

                        cmd.Parameters.AddWithValue("@pUserLocationName", SearchObject.UserLocationName ?? "");
                        cmd.Parameters.AddWithValue("@pPageIndex", pageIndex);
                        cmd.Parameters.AddWithValue("@pPageSize", pageSize);
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + ds.Tables[0].Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in ds.Tables[0].AsEnumerable()
                              select new UserLocationQRCodePrintingFetchModel
                              {

                                  BlockId = Convert.ToInt32(n["BlockId"]),
                                  BlockCode = Convert.ToString(n["BlockCode"]),
                                  BlockName = Convert.ToString(n["BlockName"]),
                                  LevelId = Convert.ToInt32(n["LevelId"]),
                                  LevelName = Convert.ToString(n["LevelName"]),
                                  UserAreaId = Convert.ToInt32(n["UserAreaId"]),
                                  UserAreaCode = Convert.ToString(n["UserAreaCode"]),
                                  UserAreaName = Convert.ToString(n["UserAreaName"]),
                                  UserLocationId = Convert.ToInt32(n["UserLocationId"]),
                                  UserLocationCode = Convert.ToString(n["UserLocationCode"]),
                                  UserLocationName = Convert.ToString(n["UserLocationName"]),
                                  DeptQRCode = Convert.ToBase64String((byte[])(n["UserAreaQRCode"])),
                                  UserLocQRCode = (n["UserLocationQRCode"]) == System.DBNull.Value ? null : Convert.ToBase64String((byte[])(n["UserLocationQRCode"])),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }

                Log4NetLogger.LogExit(_FileName, nameof(UserLocationQRCodePrintingFetchModel), Level.Info.ToString());
                return result;
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
        public List<UserAreaQRCodePrintingFetchModel> UserAreaQRCodePrintingFetchModel(UserAreaQRCodePrintingFetchModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(UserAreaQRCodePrintingFetchModel), Level.Info.ToString());
                List<UserAreaQRCodePrintingFetchModel> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_MstLocationBlockQRArea_Fetch";

                        cmd.Parameters.AddWithValue("@pUserAreaName", SearchObject.UserAreaName ?? "");
                        cmd.Parameters.AddWithValue("@pPageIndex", pageIndex);
                        cmd.Parameters.AddWithValue("@pPageSize", pageSize);
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + ds.Tables[0].Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in ds.Tables[0].AsEnumerable()
                              select new UserAreaQRCodePrintingFetchModel
                              {

                                  BlockId = Convert.ToInt32(n["BlockId"]),
                                  BlockCode = Convert.ToString(n["BlockCode"]),
                                  BlockName = Convert.ToString(n["BlockName"]),
                                  LevelId = Convert.ToInt32(n["LevelId"]),
                                  LevelName = Convert.ToString(n["LevelName"]),
                                  UserAreaId = Convert.ToInt32(n["UserAreaId"]),
                                  UserAreaCode = Convert.ToString(n["UserAreaCode"]),
                                  UserAreaName = Convert.ToString(n["UserAreaName"]),
                                  //UserLocationId = Convert.ToInt32(n["UserLocationId"]),
                                  //UserLocationCode = Convert.ToString(n["UserLocationCode"]),
                                  //UserLocationName = Convert.ToString(n["UserLocationName"]),
                                  DeptQRCode = (n["UserAreaQRCode"]) == System.DBNull.Value ? null : Convert.ToBase64String((byte[])(n["UserAreaQRCode"])),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }

                Log4NetLogger.LogExit(_FileName, nameof(UserAreaQRCodePrintingFetchModel), Level.Info.ToString());
                return result;
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
        public List<CRMWorkorderRequestFetch> CRMWorkorderRequestFetch(CRMWorkorderRequestFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(CRMWorkorderRequestFetch), Level.Info.ToString());
                List<CRMWorkorderRequestFetch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_CRMRequestNo_Fetch";

                        cmd.Parameters.AddWithValue("@pRequestNo", SearchObject.RequestNo ?? "");
                        cmd.Parameters.AddWithValue("@pPageIndex", pageIndex);
                        cmd.Parameters.AddWithValue("@pPageSize", pageSize);
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + ds.Tables[0].Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in ds.Tables[0].AsEnumerable()
                              select new CRMWorkorderRequestFetch
                              {

                                  CRMRequestId = Convert.ToInt32(n["CRMRequestId"]),
                                  RequestNo = Convert.ToString(n["RequestNo"]),
                                  RequestDateTime = n.Field<DateTime>("RequestDateTime"),
                                  TypeOfRequest = Convert.ToInt32(n["TypeOfRequest"]),
                                  TypeOfRequestValue = Convert.ToString(n["TypeOfRequestValue"]),
                                  ModifiedDateUTC = n.Field<DateTime>("ModifiedDateUTC"),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }

                Log4NetLogger.LogExit(_FileName, nameof(CRMWorkorderRequestFetch), Level.Info.ToString());
                return result;
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
        public List<TAndCCRMRequestNoFetchSearch> TAndCCRMRequestNoFetch(TAndCCRMRequestNoFetchSearch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(TAndCCRMRequestNoFetch), Level.Info.ToString());
                List<TAndCCRMRequestNoFetchSearch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_TAndCCRMRequestNo_Fetch";

                        cmd.Parameters.AddWithValue("@pRequestNo", SearchObject.RequestNo ?? "");
                        cmd.Parameters.AddWithValue("@pPageIndex", pageIndex);
                        cmd.Parameters.AddWithValue("@pPageSize", pageSize);
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + ds.Tables[0].Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in ds.Tables[0].AsEnumerable()
                              select new TAndCCRMRequestNoFetchSearch
                              {

                                  CRMRequestId = Convert.ToInt32(n["CRMRequestId"]),
                                  RequestNo = Convert.ToString(n["RequestNo"]),
                                  RequestDate = n.Field<DateTime>("RequestDateTime").Date,
                                  TargetDate = n.Field<DateTime>("TargetDate"),
                                  UserLocationId = Convert.ToInt32(n["UserLocationId"]),
                                  UserLocationName = Convert.ToString(n["UserLocationName"]),
                                  UserAreaId = n.Field<int>("UserAreaId"),
                                  UserAreaName = Convert.ToString(n["UserAreaName"]),
                                  LevelName = n.Field<string>("LevelName"),
                                  BlockName = n.Field<string>("BlockName"),
                                  CRMRequesterId = n.Field<int>("Requester"),
                                  RequesterEmail = n.Field<string>("ReqEmail"),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }

                Log4NetLogger.LogExit(_FileName, nameof(TAndCCRMRequestNoFetch), Level.Info.ToString());
                return result;
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
        public List<PortAssetFetchModel> PorteringAssetNoFetch(PortAssetFetchModel fetchObj)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                List<PortAssetFetchModel> result = null;
                var pageIndex = fetchObj.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new DBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pAssetNo", fetchObj.AssetNo ?? "");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                parameters.Add("@pFacilityId", _UserSession.FacilityId.ToString());

                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EngAssetPortering_Fetch", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in dt.AsEnumerable()
                              select new PortAssetFetchModel
                              {
                                  AssetId = Convert.ToInt32(n["AssetId"]),
                                  AssetNo = Convert.ToString(n["AssetNo"]),
                                  AssetDescription = Convert.ToString(n["AssetDescription"]),
                                  CustomerId = Convert.ToInt32(n["CustomerId"]),
                                  FacilityId = Convert.ToInt32(n["FacilityId"]),
                                  BlockId = Convert.ToInt32(n["BlockId"]),
                                  LevelId = Convert.ToInt32(n["LevelId"]),
                                  UserAreaId = Convert.ToInt32(n["UserAreaId"]),
                                  UserLocationId = Convert.ToInt32(n["UserLocationId"]),
                                  FacilityName = Convert.ToString(n["FacilityName"]),
                                  BlockName = Convert.ToString(n["BlockName"]),
                                  LevelName = Convert.ToString(n["LevelName"]),
                                  IsLoaner = Convert.ToBoolean(n["IsLoaner"]),
                                  UserAreaName = Convert.ToString(n["UserAreaName"]),
                                  UserLocationName = Convert.ToString(n["UserLocationName"]),
                                  BookingStartDate = n.Field<DateTime?>("BookingStartFrom"),
                                  BookingEndDate = n.Field<DateTime?>("BookingEnd"),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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
        public List<PortAssetFetchModel> PorteringWorkOrderNoFetch(PortAssetFetchModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                List<PortAssetFetchModel> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new DBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pMaintenanceWorkNo", SearchObject.MaintenanceWorkNo ?? "");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                parameters.Add("@pAssetId", Convert.ToString(SearchObject.AssetId));

                // parameters.Add("@pFacilityId", _UserSession.FacilityId.ToString());

                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EngMaintenanceWorkOrderTxnPortering_Fetch", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in dt.AsEnumerable()
                              select new PortAssetFetchModel
                              {
                                  WorkOrderId = Convert.ToInt32(n["WorkOrderId"]),
                                  MaintenanceWorkNo = Convert.ToString(n["MaintenanceWorkNo"]),
                                  AssetId = Convert.ToInt32(n["AssetId"]),
                                  AssetNo = Convert.ToString(n["AssetNo"]),
                                  AssetDescription = Convert.ToString(n["AssetDescription"]),
                                  CustomerId = Convert.ToInt32(n["CustomerId"]),
                                  FacilityId = Convert.ToInt32(n["FacilityId"]),
                                  BlockId = Convert.ToInt32(n["BlockId"]),
                                  LevelId = Convert.ToInt32(n["LevelId"]),
                                  UserAreaId = Convert.ToInt32(n["UserAreaId"]),
                                  UserLocationId = Convert.ToInt32(n["UserLocationId"]),
                                  FacilityName = Convert.ToString(n["FacilityName"]),
                                  BlockName = Convert.ToString(n["BlockName"]),
                                  LevelName = Convert.ToString(n["LevelName"]),
                                  UserAreaName = Convert.ToString(n["UserAreaName"]),
                                  UserLocationName = Convert.ToString(n["UserLocationName"]),
                                  BookingStartDate = n.Field<DateTime?>("BookingStartFrom"),
                                  IsLoaner = Convert.ToBoolean(n["IsLoaner"]),
                                  BookingEndDate = n.Field<DateTime?>("BookingEnd"),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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
        public List<EODCaptureAssetFetch> EODCaptureAssetFetch(EODCaptureAssetFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(EODCaptureAssetFetch), Level.Info.ToString());
                List<EODCaptureAssetFetch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EODAsset_Fetch";

                        cmd.Parameters.AddWithValue("@pAssetNo", SearchObject.AssetNo ?? "");
                        cmd.Parameters.AddWithValue("@pCategorySystemId", SearchObject.CategorySystemId ?? 0);
                        cmd.Parameters.AddWithValue("@pRecordDate", SearchObject.RecordDate);
                        cmd.Parameters.AddWithValue("@pPageIndex", pageIndex);
                        cmd.Parameters.AddWithValue("@pPageSize", pageSize);
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + ds.Tables[0].Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in ds.Tables[0].AsEnumerable()
                              select new EODCaptureAssetFetch
                              {

                                  AssetId = Convert.ToInt32(n["AssetId"]),
                                  AssetNo = Convert.ToString(n["AssetNo"]),
                                  AssetDescription = Convert.ToString(n["AssetDescription"]),
                                  AssetTypeCodeId = Convert.ToInt32(n["AssetTypeCodeId"]),
                                  AssetTypeCode = Convert.ToString(n["AssetTypeCode"]),
                                  AssetTypeDescription = Convert.ToString(n["AssetTypeDescription"]),
                                  UserAreaId = Convert.ToInt32(n["UserAreaId"]),
                                  UserAreaCode = Convert.ToString(n["UserAreaCode"]),
                                  UserAreaName = Convert.ToString(n["UserAreaName"]),
                                  UserLocationId = Convert.ToInt32(n["UserLocationId"]),
                                  UserLocationCode = Convert.ToString(n["UserLocationCode"]),
                                  UserLocationName = Convert.ToString(n["UserLocationName"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }

                Log4NetLogger.LogExit(_FileName, nameof(EODCaptureAssetFetch), Level.Info.ToString());
                return result;
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
        public List<EODCaptureManufacturer> EODCaptureManufacturer(EODCaptureManufacturer SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(EODCaptureManufacturer), Level.Info.ToString());
                List<EODCaptureManufacturer> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EODManufacturer_Fetch";

                        cmd.Parameters.AddWithValue("@pManufacturer", SearchObject.Manufacturer ?? "");
                        cmd.Parameters.AddWithValue("@pCategorySystemId", SearchObject.CategorySystemId ?? 0);
                        cmd.Parameters.AddWithValue("@pPageIndex", pageIndex);
                        cmd.Parameters.AddWithValue("@pPageSize", pageSize);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + ds.Tables[0].Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in ds.Tables[0].AsEnumerable()
                              select new EODCaptureManufacturer
                              {

                                  ManufacturerId = Convert.ToInt32(n["ManufacturerId"]),
                                  Manufacturer = Convert.ToString(n["Manufacturer"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }

                Log4NetLogger.LogExit(_FileName, nameof(EODCaptureManufacturer), Level.Info.ToString());
                return result;
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
        public List<EODCaptureModel> EODCaptureModel(EODCaptureModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(EODCaptureModel), Level.Info.ToString());
                List<EODCaptureModel> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EODModel_Fetch";

                        cmd.Parameters.AddWithValue("@pModel", SearchObject.Model ?? "");
                        cmd.Parameters.AddWithValue("@pCategorySystemId", SearchObject.CategorySystemId ?? 0);
                        cmd.Parameters.AddWithValue("@pManufacturerId", SearchObject.ManufacturerId ?? 0);
                        cmd.Parameters.AddWithValue("@pPageIndex", pageIndex);
                        cmd.Parameters.AddWithValue("@pPageSize", pageSize);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + ds.Tables[0].Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in ds.Tables[0].AsEnumerable()
                              select new EODCaptureModel
                              {

                                  ModelId = Convert.ToInt32(n["ModelId"]),
                                  Model = Convert.ToString(n["Model"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }

                Log4NetLogger.LogExit(_FileName, nameof(EODCaptureModel), Level.Info.ToString());
                return result;
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
        public List<CustomerFetch> CustomerCodeFetch(CustomerFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(CustomerCodeFetch), Level.Info.ToString());
                List<CustomerFetch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pCustomerCode", SearchObject.CustomerCode ?? "");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));

                DataTable dt = dbAccessDAL.GetDataTable("uspFM_MstCustomer_Fetch", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in dt.AsEnumerable()
                              select new CustomerFetch
                              {
                                  CustomerId = Convert.ToInt32(n["CustomerId"]),
                                  CustomerName = Convert.ToString(n["CustomerName"]),
                                  CustomerCode = Convert.ToString(n["CustomerCode"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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
        public List<CRMRequestAssetFetch> CRMRequestAssetFetch(CRMRequestAssetFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(CRMRequestAssetFetch), Level.Info.ToString());
                List<CRMRequestAssetFetch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_CRMAsset_Fetch";

                        cmd.Parameters.AddWithValue("@pModelId", SearchObject.ModelId);
                        cmd.Parameters.AddWithValue("@pManufacturerId", SearchObject.ManufacturerId);
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);
                        cmd.Parameters.AddWithValue("@pPageIndex", pageIndex);
                        cmd.Parameters.AddWithValue("@pPageSize", pageSize);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + ds.Tables[0].Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in ds.Tables[0].AsEnumerable()
                              select new CRMRequestAssetFetch
                              {

                                  AssetId = Convert.ToInt32(n["AssetId"]),
                                  AssetNo = Convert.ToString(n["AssetNo"]),
                                  AssetDescription = Convert.ToString(n["AssetDescription"]),
                                  SoftwareVersion = Convert.ToString(n["SoftwareVersion"]),
                                  SoftwareKey = Convert.ToString(n["SoftwareKey"]),
                                  SerialNo = Convert.ToString(n["SerialNo"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }

                Log4NetLogger.LogExit(_FileName, nameof(CRMRequestAssetFetch), Level.Info.ToString());
                return result;
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
        public List<CRMWorkorderStaffFetch> CRMWorkorderStaffFetch(CRMWorkorderStaffFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(CRMWorkorderStaffFetch), Level.Info.ToString());
                List<CRMWorkorderStaffFetch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_StaffSpecialization_Company_Fetch";

                        cmd.Parameters.AddWithValue("@pStaffName", SearchObject.StaffName ?? "a");
                        cmd.Parameters.AddWithValue("@pPageIndex", pageIndex);
                        cmd.Parameters.AddWithValue("@pPageSize", pageSize);
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);
                        cmd.Parameters.AddWithValue("@pTypeOfRequest", SearchObject.TypeOfRequest);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + ds.Tables[0].Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in ds.Tables[0].AsEnumerable()
                              select new CRMWorkorderStaffFetch
                              {

                                  // UserRegistrationId = Convert.ToInt32(n["UserRegistrationId"]),
                                  StaffId = n.Field<int?>("StaffMasterId"),

                                  StaffName = Convert.ToString(n["StaffName"] == DBNull.Value ? "" : (Convert.ToString(n["StaffName"]))),
                                  FacilityName = Convert.ToString(n["FacilityName"] == DBNull.Value ? "" : (Convert.ToString(n["FacilityName"]))),
                                  PhoneNumber = Convert.ToString(n["ContactNo"] == DBNull.Value ? "" : (Convert.ToString(n["ContactNo"]))),
                                  Designation = Convert.ToString(n["Designation"] == DBNull.Value ? "" : (Convert.ToString(n["Designation"]))),
                                  UserDesignationId = n.Field<int?>("DesignationId"),
                                  StaffEmail = Convert.ToString(n["Email"] == DBNull.Value ? "" : (Convert.ToString(n["Email"]))),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }

                Log4NetLogger.LogExit(_FileName, nameof(CRMWorkorderStaffFetch), Level.Info.ToString());
                return result;
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
        public List<ContractorNameSearch> ContractorNameFetch(ContractorNameSearch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ContractorNameFetch), Level.Info.ToString());
                List<ContractorNameSearch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);

                var ds = new DataSet();
                //   var dbAccessDAL = new DBAccessDAL();
                var dbAccessDAL = new MASTERDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_MstContractorName_Fetch";

                        cmd.Parameters.AddWithValue("@pContractorName", SearchObject.ContractorName ?? "");
                        cmd.Parameters.AddWithValue("@pPageIndex", pageIndex);
                        cmd.Parameters.AddWithValue("@pPageSize", pageSize);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + ds.Tables[0].Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in ds.Tables[0].AsEnumerable()
                              select new ContractorNameSearch
                              {

                                  ContractorId = Convert.ToInt32(n["ContractorId"]),
                                  ContractorName = Convert.ToString(n["ContractorName"]),
                                  SSMRegistrationCode = Convert.ToString(n["SSMRegistrationCode"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }

                Log4NetLogger.LogExit(_FileName, nameof(ContractorNameFetch), Level.Info.ToString());
                return result;
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
        public List<BookingFetch> BookingAssetNoFetch(BookingFetch fetchObj)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                List<BookingFetch> result = null;
                var pageIndex = fetchObj.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new DBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pAssetNo", fetchObj.AssetNo ?? "");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                // parameters.Add("@pFacilityId", _UserSession.FacilityId.ToString());

                DataTable dt = dbAccessDAL.GetDataTable("UspFM_EngLoanerTestEquipmentBookingTxnAsset_Fetch", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in dt.AsEnumerable()
                              select new BookingFetch
                              {
                                  AssetId = Convert.ToInt32(n["AssetId"]),
                                  AssetNo = Convert.ToString(n["AssetNo"]),
                                  AssetTypeCode = Convert.ToString(n["AssetTypeCode"]),
                                  AssetTypeDescription = Convert.ToString(n["AssetTypeDescription"]),
                                  AssetDescription = Convert.ToString(n["AssetDescription"]),
                                  TypeOfAsset = n.Field<int?>("TypeOfAsset"),
                                  FacilityId = Convert.ToInt32(n["FacilityId"]),
                                  FacilityName = Convert.ToString(n["FacilityName"]),
                                  BookingStartDate = n.Field<DateTime?>("BookingStartFrom"),
                                  BookingEndDate = n.Field<DateTime?>("BookingEnd"),
                                  CompanyRepId = Convert.ToInt32(n["CompanyStaffId"]),
                                  CompanyRepEmail = Convert.ToString(n["CompanyStaffEmail"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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
        public List<BookingFetch> BookingWorkOrderNoFetch(BookingFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                List<BookingFetch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new DBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pMaintenanceWorkNo", SearchObject.MaintenanceWorkNo ?? "");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                parameters.Add("@pAssetId", Convert.ToString(SearchObject.AssetId));
                // parameters.Add("@pFacilityId", _UserSession.FacilityId.ToString());

                DataTable dt = dbAccessDAL.GetDataTable("UspFM_EngLoanerTestEquipmentBookingTxn_WorkOderNo_Fetch", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in dt.AsEnumerable()
                              select new BookingFetch
                              {
                                  WorkOrderId = Convert.ToInt32(n["WorkOrderId"]),
                                  MaintenanceWorkNo = Convert.ToString(n["MaintenanceWorkNo"]),
                                  AssetId = Convert.ToInt32(n["AssetId"]),
                                  AssetNo = Convert.ToString(n["AssetNo"]),
                                  AssetDescription = Convert.ToString(n["AssetDescription"]),
                                  CustomerId = Convert.ToInt32(n["CustomerId"]),
                                  FacilityId = Convert.ToInt32(n["FacilityId"]),
                                  BookingStartDate = n.Field<DateTime?>("BookingStartFrom"),
                                  TypeOfAsset = n.Field<int?>("TypeOfAsset"),
                                  BookingEndDate = n.Field<DateTime?>("BookingEnd"),
                                  FacilityName = Convert.ToString(n["FacilityName"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex,
                                  ////AssetTypeCode = Convert.ToString(n["AssetTypeCode"]),
                                  ////AssetTypeDescription = Convert.ToString(n["AssetTypeDescription"]),
                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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
        public List<UserShiftLeaveDetailsFetch> UserShiftLeaveDetailsFetch(UserShiftLeaveDetailsFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(UserShiftLeaveDetailsFetch), Level.Info.ToString());
                List<UserShiftLeaveDetailsFetch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_StaffShiftDet_Fetch";

                        cmd.Parameters.AddWithValue("@pStaffName", SearchObject.StaffName ?? "");
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);
                        cmd.Parameters.AddWithValue("@pPageIndex", pageIndex);
                        cmd.Parameters.AddWithValue("@pPageSize", pageSize);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + ds.Tables[0].Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in ds.Tables[0].AsEnumerable()
                              select new UserShiftLeaveDetailsFetch
                              {

                                  UserRegistrationId = Convert.ToInt32(n["UserRegistrationId"]),
                                  StaffName = Convert.ToString(n["StaffName"]),
                                  MobileNumber = Convert.ToString(n["MobileNumber"]),
                                  UserType = Convert.ToString(n["UserType"]),
                                  AccessLevel = Convert.ToString(n["AccessLevel"]),
                                  Role = Convert.ToString(n["Role"]),
                                  Designation = Convert.ToString(n["Designation"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }

                Log4NetLogger.LogExit(_FileName, nameof(UserShiftLeaveDetailsFetch), Level.Info.ToString());
                return result;
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
        public List<UserTainingParticipantFetch> UserTainingParticipantFetch(UserTainingParticipantFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(UserTainingParticipantFetch), Level.Info.ToString());
                List<UserTainingParticipantFetch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_UserTrainingStaffs_Fetch";

                        cmd.Parameters.AddWithValue("@pStaffName", SearchObject.StaffName ?? "");
                        cmd.Parameters.AddWithValue("@pFacilityId", SearchObject.FacilityId);
                        cmd.Parameters.AddWithValue("@pTrainingScheduleId", SearchObject.TrainingScheduleId);
                        cmd.Parameters.AddWithValue("@pPageIndex", pageIndex);
                        cmd.Parameters.AddWithValue("@pPageSize", pageSize);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + ds.Tables[0].Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in ds.Tables[0].AsEnumerable()
                              select new UserTainingParticipantFetch
                              {

                                  StaffMasterId = Convert.ToInt32(n["StaffMasterId"]),
                                  StaffName = Convert.ToString(n["StaffName"]),
                                  Designation = Convert.ToString(n["Designation"]),
                                  FacilityName = Convert.ToString(n["FacilityName"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }

                Log4NetLogger.LogExit(_FileName, nameof(UserTainingParticipantFetch), Level.Info.ToString());
                return result;
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
        public List<FilureSymptomCodeFetch> FilureSymptomCodeFetch(FilureSymptomCodeFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FilureSymptomCodeFetch), Level.Info.ToString());
                List<FilureSymptomCodeFetch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_MstQAPQualityCause_Fetch";

                        cmd.Parameters.AddWithValue("@pCauseCode", SearchObject.FailureSymptomCode ?? "");
                        cmd.Parameters.AddWithValue("@pPageIndex", pageIndex);
                        cmd.Parameters.AddWithValue("@pPageSize", pageSize);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + ds.Tables[0].Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in ds.Tables[0].AsEnumerable()
                              select new FilureSymptomCodeFetch
                              {

                                  QualityCauseId = Convert.ToInt32(n["QualityCauseId"]),
                                  FailureSymptomCode = Convert.ToString(n["FailureSymptomCode"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }

                Log4NetLogger.LogExit(_FileName, nameof(FilureSymptomCodeFetch), Level.Info.ToString());
                return result;
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
        public List<FollowupCarFetch> FollowupCarFetch(FollowupCarFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                List<FollowupCarFetch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_QAPCarTxn_Fetch";

                        cmd.Parameters.AddWithValue("@pCARNumber", SearchObject.CARNumber ?? "");
                        cmd.Parameters.AddWithValue("@pCARId", SearchObject.CarIdOriginal ?? "");
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);
                        cmd.Parameters.AddWithValue("@pIndicatorId", SearchObject.IndicatorId);
                        cmd.Parameters.AddWithValue("@pPageIndex", pageIndex);
                        cmd.Parameters.AddWithValue("@pPageSize", pageSize);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + ds.Tables[0].Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in ds.Tables[0].AsEnumerable()
                              select new FollowupCarFetch
                              {

                                  CarId = Convert.ToInt32(n["CarId"]),
                                  CARNumber = Convert.ToString(n["CARNumber"]),
                                  FromDate = n.Field<DateTime?>("FromDate"),
                                  ToDate = n.Field<DateTime?>("ToDate"),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }

                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                return result;
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
        public List<AreaFetch> BlockCascCodeFetch(AreaFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                List<AreaFetch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new DBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pBlockCode", SearchObject.BlockCode ?? "");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                // parameters.Add("@pFacilityId", _UserSession.FacilityId.ToString());

                DataTable dt = dbAccessDAL.GetDataTable("UspFM_BlockCsc_Fetch", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in dt.AsEnumerable()
                              select new AreaFetch
                              {
                                  FacilityId = Convert.ToInt32(n["FacilityId"]),
                                  FacilityName = Convert.ToString(n["FacilityName"]),
                                  FacilityCode = Convert.ToString(n["FacilityCode"]),
                                  BlockId = Convert.ToInt32(n["BlockId"]),
                                  BlockCode = Convert.ToString(n["BlockCode"]),
                                  BlockName = Convert.ToString(n["BlockName"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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

        //public List<AreaFetch> UserAreaCascCodeFetch(AreaFetch SearchObject)
        //{
        //    try
        //    {
        //        Log4NetLogger.LogEntry(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
        //        List<AreaFetch> result = null;
        //        var pageIndex = SearchObject.PageIndex;
        //        var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
        //        var dbAccessDAL = new DBAccessDAL();
        //        var obj = new PortAssetFetchModel();
        //        var DataSetparameters = new Dictionary<string, DataTable>();
        //        var parameters = new Dictionary<string, string>();
        //        parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
        //        parameters.Add("@pBlockCode", SearchObject.BlockCode ?? "");
        //        parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
        //        parameters.Add("@pPageSize", Convert.ToString(pageSize));
        //        // parameters.Add("@pFacilityId", _UserSession.FacilityId.ToString());

        //        DataTable dt = dbAccessDAL.GetDataTable("UspFM_BlockCsc_Fetch", parameters, DataSetparameters);
        //        if (dt != null && dt.Rows.Count > 0)
        //        {
        //            var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
        //            var firstRecord = (pageIndex - 1) * pageSize + 1;
        //            var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
        //            var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

        //            result = (from n in dt.AsEnumerable()
        //                      select new AreaFetch
        //                      {
        //                          FacilityId = Convert.ToInt32(n["FacilityId"]),
        //                          FacilityName = Convert.ToString(n["FacilityName"]),
        //                          FacilityCode = Convert.ToString(n["FacilityCode"]),
        //                          BlockId = Convert.ToInt32(n["BlockId"]),
        //                          BlockCode = Convert.ToString(n["BlockCode"]),
        //                          BlockName = Convert.ToString(n["BlockName"]),
        //                          TotalRecords = totalRecords,
        //                          FirstRecord = firstRecord,
        //                          LastRecord = lastRecord,
        //                          LastPageIndex = lastPageIndex
        //                      }).ToList();
        //        }
        //        Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
        //        return result;
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
        public List<AreaFetch> LevelCascCodeFetch(AreaFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                List<AreaFetch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new DBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pBlockId", Convert.ToString(SearchObject.BlockId));
                parameters.Add("@pLevelCode", SearchObject.LevelCode ?? "");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));

                DataTable dt = dbAccessDAL.GetDataTable("UspFM_LevelCsc_Fetch", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in dt.AsEnumerable()
                              select new AreaFetch
                              {
                                  FacilityId = Convert.ToInt32(n["FacilityId"]),
                                  FacilityName = Convert.ToString(n["FacilityName"]),
                                  FacilityCode = Convert.ToString(n["FacilityCode"]),
                                  BlockId = Convert.ToInt32(n["BlockId"]),
                                  BlockCode = Convert.ToString(n["BlockCode"]),
                                  BlockName = Convert.ToString(n["BlockName"]),

                                  LevelId = Convert.ToInt32(n["LevelId"]),
                                  LevelCode = Convert.ToString(n["LevelCode"]),
                                  LevelName = Convert.ToString(n["LevelName"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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
        public List<AreaFetch> AreaCascCodeFetch(AreaFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                List<AreaFetch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new DBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pUserAreaCode", SearchObject.UserAreaCode ?? "");
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pLevelId", Convert.ToString(SearchObject.LevelId));
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));

                DataTable dt = dbAccessDAL.GetDataTable("UspFM_AreaCsc_Fetch", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in dt.AsEnumerable()
                              select new AreaFetch
                              {
                                  FacilityId = Convert.ToInt32(n["FacilityId"]),
                                  FacilityName = Convert.ToString(n["FacilityName"]),
                                  FacilityCode = Convert.ToString(n["FacilityCode"]),
                                  BlockId = Convert.ToInt32(n["BlockId"]),
                                  BlockCode = Convert.ToString(n["BlockCode"]),
                                  BlockName = Convert.ToString(n["BlockName"]),
                                  LevelId = Convert.ToInt32(n["LevelId"]),
                                  LevelCode = Convert.ToString(n["LevelCode"]),
                                  LevelName = Convert.ToString(n["LevelName"]),
                                  UserAreaId = Convert.ToInt32(n["UserAreaId"]),
                                  UserAreaCode = Convert.ToString(n["UserAreaCode"]),
                                  UserAreaName = Convert.ToString(n["UserAreaName"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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

        public List<UserLocationCodeSearch> BookingLocationFetch(UserLocationCodeSearch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LocationCodeFetch), Level.Info.ToString());
                List<UserLocationCodeSearch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_BookingUserLocation_Fetch";

                        cmd.Parameters.AddWithValue("@pUserLocationCode", SearchObject.UserLocationCode ?? "");
                        cmd.Parameters.AddWithValue("@pPageIndex", pageIndex);
                        cmd.Parameters.AddWithValue("@pPageSize", pageSize);
                        cmd.Parameters.AddWithValue("@pFacilityId", SearchObject.FacilityId);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + ds.Tables[0].Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in ds.Tables[0].AsEnumerable()
                              select new UserLocationCodeSearch
                              {
                                  UserLocationId = Convert.ToInt32(n["UserLocationId"]),
                                  UserAreaId = n.Field<int>("UserAreaId"),
                                  LevelId = n.Field<int>("LevelId"),
                                  BlockId = n.Field<int>("BlockId"),
                                  //FacilityId = n.Field<int>("FacilityId"),
                                  UserLocationCode = Convert.ToString(n["UserLocationCode"]),
                                  UserLocationName = Convert.ToString(n["UserLocationName"]),
                                  UserAreaCode = Convert.ToString(n["UserAreaCode"]),
                                  UserAreaName = Convert.ToString(n["UserAreaName"]),
                                  LevelName = n.Field<string>("LevelName"),
                                  LevelCode = n.Field<string>("LevelCode"),
                                  BlockName = n.Field<string>("BlockName"),
                                  BlockCode = n.Field<string>("BlockCode"),
                                  //FacilityName = n.Field<string>("FacilityName"),
                                  //FacilityCode = n.Field<string>("FacilityCode"),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();

                }

                Log4NetLogger.LogExit(_FileName, nameof(LocationCodeFetch), Level.Info.ToString());
                return result;
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

        public List<CRMRequestType> CRMFetchRequestTypedetais(CRMRequestType fetchObj)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(CRMFetchRequestTypedetais), Level.Info.ToString());
                List<CRMRequestType> result = null;
                var pageIndex = fetchObj.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new DBAccessDAL();
                var obj = new CRMRequestType();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pRequestType", fetchObj.CRMrequesttype ?? "");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));

                DataTable dt = dbAccessDAL.GetDataTable("UspFM_CRMRequestType_Fetch", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in dt.AsEnumerable()
                              select new CRMRequestType
                              {
                                  LovId = Convert.ToInt32(n["LovId"]),
                                  CRMrequesttype = Convert.ToString(n["FieldValue"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(CRMFetchRequestTypedetais), Level.Info.ToString());
                return result;
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

        public List<ItemMstFetchEntity> FetchItemNo(ItemMstFetchEntity SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
                var result = new List<ItemMstFetchEntity>();
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngSparePartsItemNo_Fetch";        // Stock Update Register

                        cmd.Parameters.AddWithValue("@ItemCode", SearchObject.ItemCode);
                        cmd.Parameters.AddWithValue("@pPageIndex", pageIndex);
                        cmd.Parameters.AddWithValue("@pPageSize", pageSize);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + ds.Tables[0].Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in ds.Tables[0].AsEnumerable()
                              select new ItemMstFetchEntity
                              {
                                  ItemId = n.Field<int>("ItemId"),
                                  ItemCode = n.Field<string>("ItemNo"),
                                  ItemDescription = n.Field<string>("ItemDescription"),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();

                }

                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception e)
            {
                throw;
            }
        }

        public List<ItemMstFetchEntity> FetchPartNo(ItemMstFetchEntity SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                var result = new List<ItemMstFetchEntity>();
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_PartNo_Fetch";        // Stock Update Register
                        cmd.Parameters.AddWithValue("@pItemId", SearchObject.ItemId);
                        cmd.Parameters.AddWithValue("@pPartNo", SearchObject.Partno);
                        cmd.Parameters.AddWithValue("@pPageIndex", pageIndex);
                        cmd.Parameters.AddWithValue("@pPageSize", pageSize);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + ds.Tables[0].Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in ds.Tables[0].AsEnumerable()
                              select new ItemMstFetchEntity
                              {
                                  SparePartsId = n.Field<int>("SparePartsId"),
                                  Partno = n.Field<string>("PartNo"),
                                  PartDescription = n.Field<string>("PartDescription"),
                                  ItemId = n.Field<int>("ItemId"),
                                  ItemCode = n.Field<string>("ItemNo"),
                                  ItemDescription = n.Field<string>("ItemDescription"),
                                  //PartSource = n.Field<string>("PartSource"),
                                  //LifeSpanOptionId = n.Field<int?>("LifeSpanOptionId"),
                                  //EstimatedLifeSpanOption = n.Field<string>("LifeSpanOptionValue"),
                                  //EstimatedLifeSpanType = n.Field<string>("LifeSpanOptionValue"),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();

                }

                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception e)
            {
                throw;
            }
        }

        public int Get_FID()
        {
            int servicesid = 0;
            if (_UserSession.UserDB == 2)
            {
                servicesid = 1;
            }
            else
            {
                if (_UserSession.UserDB == 1)
                {
                    servicesid = 2;
                }
                else
                {

                }
            }

            return servicesid;
        }

        #region LLS FETCH and Search
        public List<UserAreaFetch> DepartmentCascCodeFetch(UserAreaFetch searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                List<UserAreaFetch> result = null;
                List<UserAreaFetch> results = null;
                var pageIndex = searchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@UserAreaCode", searchObject.UserAreaCode ?? "a");
                parameters.Add("@pFacilityId", _UserSession.FacilityId.ToString());
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                DataTable dt = dbAccessDAL.GetDataTable("LLSUserAreaDetailsMst_FetchUserAreaCode", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    #region swap dateformat
                    //var sss = dt.Rows[3]["ActiveFromDate"].ToString();
                    //string phrase = "The quick brown fox jumps over the lazy dog."; 
                    //string[] words = sss.Split('/');
                    //string[] wordss = words[2].Split(' ');


                    //var yyyy = wordss[0];
                    //var mm = words[1];
                    //var day = words[0];
                    //int Year = Convert.ToInt32(yyyy);
                    //int Month = Convert.ToInt32(day); 
                    //int Day = Convert.ToInt32(mm);
                    //DateTime dtt = new DateTime(Year, Month, Day);
                    #endregion
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in dt.AsEnumerable()
                              select new UserAreaFetch
                              {
                                  UserAreaId = Convert.ToInt32(n["UserAreaId"]),
                                  UserAreaCode = Convert.ToString(n["UserAreaCode"]),
                                  UserAreaName = Convert.ToString(n["UserAreaName"]),
                                  ActiveFromDate = Convert.ToDateTime(n["ActiveFromDate"]),
                                  ActiveToDate = Convert.ToDateTime(n["ActiveToDate"] != DBNull.Value ? (Convert.ToDateTime(dt.Rows[0]["ActiveToDate"])) : (DateTime?)null),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }

                else
                {
                    Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                }

                return result;
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

        public List<UserAreaFetchs> LLSUserAreaDetailsLocationMstDet_FetchLocCode(UserAreaFetchs searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LLSUserAreaDetailsLocationMstDet_FetchLocCode), Level.Info.ToString());
                List<UserAreaFetchs> result = null;
                var pageIndex = searchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                UserAreaFetchs Search = new UserAreaFetchs();
                parameters.Add("@UserAreaId", Convert.ToString(searchObject.UserAreaCode));
                parameters.Add("@UserLocationCode", searchObject.UserLocationCode ?? "a");
                parameters.Add("@pFacilityId", _UserSession.FacilityId.ToString());
                parameters.Add("@pPageIndex", pageIndex.ToString());
                parameters.Add("@pPageSize", pageSize.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("LLSUserAreaDetailsLocationMstDet_FetchLocCode", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in dt.AsEnumerable()
                              select new UserAreaFetchs
                              {
                                  UserLocationId = Convert.ToInt32(n["UserLocationId"]),
                                  UserLocationCode = Convert.ToString(n["UserLocationCode"]),
                                  UserLocationName = Convert.ToString(n["UserLocationName"]),
                                  //-------------------
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }

                else
                {
                    Log4NetLogger.LogExit(_FileName, nameof(LLSUserAreaDetailsLocationMstDet_FetchLocCode), Level.Info.ToString());
                }
                return result;
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
        public List<LinenItemCodeFetch> LinenItemCascCodeFetch(LinenItemCodeFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LinenItemCascCodeFetch), Level.Info.ToString());
                List<LinenItemCodeFetch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pLinenCode", SearchObject.LinenCode ?? "a");
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));


                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSUserAreaDetailsLinenItemMstDet_FetchLinenCode", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in dt.AsEnumerable()
                              select new LinenItemCodeFetch
                              {
                                  FacilityId = Convert.ToInt32(n["FacilityId"]),
                                  LinenCode = Convert.ToString(n["LinenCode"]),
                                  LinenItemId = Convert.ToInt32(n["LinenItemId"]),
                                  LinenDescription = Convert.ToString(n["LinenDescription"]),
                                  //UserAreaName = Convert.ToString(n["UserAreaName"]),
                                  //ActiveFromDate = Convert.ToDateTime(n["ActiveFromDate"]),
                                  //ActiveToDate = Convert.ToDateTime(n["ActiveToDate"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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
        public List<LocationCodeFetch> LocationCascCodeFetch(LocationCodeFetch SearchObject)
        {


            try
            {
               
                Log4NetLogger.LogEntry(_FileName, nameof(LocationCascCodeFetch), Level.Info.ToString());
                List<LocationCodeFetch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                UserAreaFetch Search = new UserAreaFetch();
                parameters.Add("@UserAreaId", Convert.ToString(SearchObject.UserAreaCode));
                parameters.Add("@UserLocationCode", SearchObject.UserLocationCode ?? "a");
                parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));

                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSUserAreaDetailsLinenItemMstDet_FetchLocCode", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;


                    result = (from n in dt.AsEnumerable()
                              select new LocationCodeFetch
                              {
                                  //FacilityId = Convert.ToInt32(n["FacilityId"]),
                                  //UserAreaId = Convert.ToInt32(n["UserAreaId"]),
                                  UserLocationCode = Convert.ToString(n["UserLocationCode"]),
                                  UserLocationName = Convert.ToString(n["UserLocationName"]),
                                  UserLocationId = Convert.ToInt32(n["UserLocationId"]),
                                  LLSUserAreaLocationId = Convert.ToInt32(n["LLSUserAreaLocationId"]),
                                  LLSUserAreaId = Convert.ToInt32(n["LLSUserAreaId"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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
        public List<CleanLinenRequestModel> Cleanlinenrequest_UserareaCodeFetch(CleanLinenRequestModel searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                List<CleanLinenRequestModel> result = null;
                var pageIndex = searchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new MASTERDBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pUserAreaCode", searchObject.UserAreaCode ?? "a");
                parameters.Add("@pFacilityId", _UserSession.FacilityId.ToString());
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSCleanLinenRequestTxn_FetchUserAreaCode", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;
                    result = (from n in dt.AsEnumerable()
                              select new CleanLinenRequestModel
                              {
                                  LLSUserAreaId = Convert.ToInt32(n["LLSUserAreaId"]),
                                  UserAreaCode = Convert.ToString(n["UserAreaCode"]),
                                  UserAreaName = Convert.ToString(n["UserAreaName"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }

                else
                {
                    Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                }
                return result;
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

        public List<CleanLinenRequestModel> CleanLinenRequestTxn_FetchLocCode(CleanLinenRequestModel searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                List<CleanLinenRequestModel> result = null;
                var pageIndex = searchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new MASTERDBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@UserAreaId", Convert.ToString(searchObject.UserAreaCode));
                parameters.Add("@LocationCode", searchObject.UserLocationCode ?? "a");
                parameters.Add("@FacilityId", _UserSession.FacilityId.ToString());
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSCleanLinenRequestTxn_FetchLocCode", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;
                    result = (from n in dt.AsEnumerable()
                              select new CleanLinenRequestModel
                              {
                                  LLSUserAreaLocationId = Convert.ToInt32(n["LLSUserAreaLocationId"]),
                                  UserLocationCode = Convert.ToString(n["UserLocationCode"]),
                                  UserLocationName = Convert.ToString(n["UserLocationName"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }

                else
                {
                    Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                }
                return result;
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
        public List<CleanLinenRequestModel> Cleanlinenrequest_FetchrequestBy(CleanLinenRequestModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Cleanlinenrequest_FetchrequestBy), Level.Info.ToString());
                List<CleanLinenRequestModel> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                parameters.Add("@StaffName", SearchObject.StaffName ?? "a");


                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSCleanLinenRequestTxn_FetchRequestedBy ", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in dt.AsEnumerable()
                              select new CleanLinenRequestModel
                              {
                                  UserRegistrationId = Convert.ToInt32(n["UserRegistrationId"]),
                                  StaffName = Convert.ToString(n["StaffName"]),
                                  Designation = Convert.ToString(n["Designation"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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
        public List<LocationCodeFetch> Cleanlinenrequestlinenitem_LinenCodeFetch(LocationCodeFetch SearchObject)
        {

            try
            {

                Log4NetLogger.LogEntry(_FileName, nameof(Cleanlinenrequestlinenitem_LinenCodeFetch), Level.Info.ToString());
                List<LocationCodeFetch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                UserAreaFetch Search = new UserAreaFetch();
                var abc = Search.UserAreaCode;
                parameters.Add("@LinenCode", SearchObject.LinenCode ?? "a");
                parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                parameters.Add("@pUserLocCode", Convert.ToString(SearchObject.UserAreaCode));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSCleanLinenRequestLinenItemTxnDet_FetchLinenCode", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;
                    result = (from n in dt.AsEnumerable()
                              select new LocationCodeFetch
                              {
                                  LinenItemId = Convert.ToInt32(n["LinenItemId"]),
                                  LinenCode = Convert.ToString(n["LinenCode"]),
                                  LinenDescription = Convert.ToString(n["LinenDescription"]),
                                  AgreedShelfLevel = Convert.ToString(n["AgreedShelfLevel"]),
                                  StoreBalance = Convert.ToString(n["StoreBalance"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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
        public List<LocationCodeFetch> CleanLinenRequestLinenBag_FetchLaundryBag(LocationCodeFetch SearchObject)
        {

            try
            {

                Log4NetLogger.LogEntry(_FileName, nameof(CleanLinenRequestLinenBag_FetchLaundryBag), Level.Info.ToString());
                List<LocationCodeFetch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                UserAreaFetch Search = new UserAreaFetch();
                var abc = Search.UserAreaCode;
                parameters.Add("@UserAreaId", Convert.ToString(SearchObject.UserAreaCode));
                parameters.Add("@UserLocationCode", SearchObject.UserLocationCode ?? "a");
                parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));

                //parameters.Add("@pPageSize", Convert.ToString(pageSize));

                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSCleanLinenRequestLinenBagTxnDet_FetchLaundryBag", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    //var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    //var firstRecord = (pageIndex - 1) * pageSize + 1;
                    //var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    //var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in dt.AsEnumerable()
                              select new LocationCodeFetch
                              {
                                  //FacilityId = Convert.ToInt32(n["FacilityId"]),
                                  UserLocationCode = Convert.ToString(n["UserLocationCode"]),
                                  UserLocationId = Convert.ToInt32(n["UserLocationId"]),
                                  //TotalRecords = totalRecords,
                                  //FirstRecord = firstRecord,
                                  //LastRecord = lastRecord,
                                  //LastPageIndex = lastPageIndex
                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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
        public List<LinenConemnationModel> LinenInjectionTxnDet_FetchLinenCode(LinenConemnationModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LinenInjectionTxnDet_FetchLinenCode), Level.Info.ToString());
                List<LinenConemnationModel> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@LinenCode", SearchObject.LinenCode ?? "a");
                parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSLinenInjectionTxnDet_FetchLinenCode", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;
                    result = (from n in dt.AsEnumerable()
                              select new LinenConemnationModel
                              {
                                  LinenItemId = Convert.ToInt32(n["LinenItemId"]),
                                  LinenCode = Convert.ToString(n["LinenCode"]),
                                  LinenDescription = Convert.ToString(n["LinenDescription"]),
                                   LinenPrice= Convert.ToDecimal(n["LinenPrice"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex

                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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

        public List<CleanLinenDespatchModel> CleanLinenDespatchTxn_FetchReceivedBy(CleanLinenDespatchModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LinenInjectionTxnDet_FetchLinenCode), Level.Info.ToString());
                List<CleanLinenDespatchModel> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                CleanLinenDespatchModel Search = new CleanLinenDespatchModel();
                //parameters.Add("@UserAreaId", Convert.ToString(SearchObject.UserAreaCode));
                parameters.Add("@StaffName", SearchObject.ReceivedBy ?? "a");
                parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                //parameters.Add("@pPageSize", Convert.ToString(pageSize));

                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSCleanLinenDespatchTxn_FetchReceivedBy", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {

                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;
                    result = (from n in dt.AsEnumerable()
                              select new CleanLinenDespatchModel
                              {
                                  UserRegistrationId = Convert.ToInt32(n["UserRegistrationId"]),
                                  ReceivedBy = Convert.ToString(n["StaffName"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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

        public List<CleanLinenDespatchModel> CleanLinenDespatchTxnDet_FetchLinenCode(CleanLinenDespatchModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(CleanLinenDespatchTxnDet_FetchLinenCode), Level.Info.ToString());
                List<CleanLinenDespatchModel> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                CleanLinenDespatchModel Search = new CleanLinenDespatchModel();
                //parameters.Add("@UserAreaId", Convert.ToString(SearchObject.UserAreaCode));
                parameters.Add("@LinenCode", SearchObject.LinenCode ?? "a");
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                //parameters.Add("@pPageSize", Convert.ToString(pageSize));

                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSCleanLinenDespatchTxnDet_FetchLinenCode", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in dt.AsEnumerable()
                              select new CleanLinenDespatchModel
                              {
                                  LinenItemId = Convert.ToInt32(n["LinenItemId"]),
                                  LinenCode = Convert.ToString(n["LinenCode"]),
                                  LinenDescription = Convert.ToString(n["LinenDescription"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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

        #region CleanLinenIssue
        public List<CleanLinenIssueModel> CleanLinenIssueTxn_FetchCLRDocNo(CleanLinenIssueModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(CleanLinenIssueTxn_FetchCLRDocNo), Level.Info.ToString());
                List<CleanLinenIssueModel> result = null;
                List<cleanLinenLaundryValueList> Lresult = null;
                List<LLinenIssueItemList> Txnresult = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                CleanLinenDespatchModel Search = new CleanLinenDespatchModel();
                parameters.Add("@DocumentNo", SearchObject.DocumentNo ?? "c");
                parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                DataSet DS = dbAccessDAL.MasterGetDataSet("LLSCleanLinenIssueTxn_FetchCLRDocNo", parameters, DataSetparameters);
                //DataTable ds1 = dbAccessDAL.GetMASTERDataTable("LLSCleanLinenIssueTxn_FetchCLRDocNoNew", parameters, DataSetparameters);
                DataTable dt; // = dbAccessDAL.GetMASTERDataTable("LLSCleanLinenIssueTxn_FetchCLRDocNoNew", parameters, DataSetparameters);
                DataTable dt_Req_quantity;
                DataTable dt_Req_LinenItemTxnDet;
                DataTable dt1;
                DataTable dt2;
                dt = DS.Tables[0];
                dt1 = DS.Tables[1];
                dt2 = DS.Tables[2];
                dt_Req_quantity = DS.Tables[1];
                dt_Req_LinenItemTxnDet = DS.Tables[2];
                if (dt_Req_quantity != null && dt_Req_quantity.Rows.Count > 0)
                {
                    Lresult = (from n in dt_Req_quantity.AsEnumerable()
                               select new cleanLinenLaundryValueList
                               {
                                   LovId = Convert.ToInt32(n["LaundryBag"]),
                                   RequestedQuantity = Convert.ToInt32(n["RequestedQuantity"]),
                                   CleanLinenRequestId = Convert.ToInt32(n["CleanLinenRequestId"]),
                               }).ToList();
                }
                if (dt_Req_LinenItemTxnDet != null && dt_Req_LinenItemTxnDet.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;
                    Txnresult = (from n in dt_Req_LinenItemTxnDet.AsEnumerable()
                                 select new LLinenIssueItemList
                                 {
                                     LinenitemId = Convert.ToInt32(n["LinenItemId"]),
                                     BalanceOnShelf = Convert.ToInt32(n["BalanceOnShelf"]),
                                     RequestedQuantity = Convert.ToInt32(n["RequestedQuantity"]),
                                     TotalRecords = totalRecords,
                                     FirstRecord = firstRecord,
                                     LastRecord = lastRecord,
                                     LastPageIndex = lastPageIndex

                                 }).ToList();
                }
                if (dt != null && dt.Rows.Count > 0)
                {
                    result = (from n in dt.AsEnumerable()
                              select new CleanLinenIssueModel
                              {

                                  RequestDateTime = Convert.ToDateTime(n["RequestDateTime"]),
                                  LLSUserAreaId = Convert.ToInt32(n["LLSUserAreaId"]),
                                  LLSUserAreaLocationId = Convert.ToInt32(n["LLSUserAreaLocationId"]),
                                  CleanLinenRequestId = Convert.ToInt32(n["CleanLinenRequestId"]),
                                  DocumentNo = Convert.ToString(n["DocumentNo"]),
                                  UserAreaCode = Convert.ToString(n["UserAreaCode"]),
                                  UserAreaName = Convert.ToString(n["UserAreaName"]),
                                  UserLocationCode = Convert.ToString(n["UserLocationCode"]),
                                  UserLocationName = Convert.ToString(n["UserLocationName"]),
                                  RequestedBy = Convert.ToString(n["RequestedBy"]),
                                  Designation = Convert.ToString(n["Designation"]),
                                  TotalBagRequested = Convert.ToInt32(n["TotalBagRequested"]),
                                  TotalItemRequested = Convert.ToInt32(n["TotalItemRequested"]),
                                  //Priority = Convert.ToInt32(n["Priority"]),
                              }).ToList();
                }

                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                // result[0].CleanLinenRequestModels.AddRange(Lresult);
                return result;
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

        public List<CleanLinenIssueModel> CleanLinenIssueTxn_Fetch1stReceivedBy(CleanLinenIssueModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(CleanLinenIssueTxn_Fetch1stReceivedBy), Level.Info.ToString());
                List<CleanLinenIssueModel> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                CleanLinenDespatchModel Search = new CleanLinenDespatchModel();
                parameters.Add("@StaffName", SearchObject.StaffName ?? "a");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                //parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSCleanLinenIssueTxn_Fetch1stReceivedBy", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;
                    result = (from n in dt.AsEnumerable()
                              select new CleanLinenIssueModel
                              {
                                  UserRegistrationId = Convert.ToInt32(n["UserRegistrationId"]),
                                  StaffName = Convert.ToString(n["StaffName"]),
                                  Designation = Convert.ToString(n["Designation"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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

        public List<CleanLinenIssueModel> CleanLinenIssueTxn_Fetch2ndReceivedBy(CleanLinenIssueModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(CleanLinenIssueTxn_Fetch2ndReceivedBy), Level.Info.ToString());
                List<CleanLinenIssueModel> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                CleanLinenDespatchModel Search = new CleanLinenDespatchModel();
                parameters.Add("@StaffName", SearchObject.StaffName ?? "a");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSCleanLinenIssueTxn_Fetch2ndReceivedBy", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;
                    result = (from n in dt.AsEnumerable()
                              select new CleanLinenIssueModel
                              {
                                  UserRegistrationId = Convert.ToInt32(n["UserRegistrationId"]),
                                  StaffName = Convert.ToString(n["StaffName"]),
                                  Designation = Convert.ToString(n["Designation"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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
        public List<CleanLinenIssueModel> CleanLinenIssueTxn_FetchVerifier(CleanLinenIssueModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(CleanLinenIssueTxn_FetchVerifier), Level.Info.ToString());
                List<CleanLinenIssueModel> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                CleanLinenDespatchModel Search = new CleanLinenDespatchModel();
                parameters.Add("@StaffName", SearchObject.StaffName ?? "a");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                //parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSCleanLinenIssueTxn_FetchVerifier", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;
                    result = (from n in dt.AsEnumerable()
                              select new CleanLinenIssueModel
                              {
                                  UserRegistrationId = Convert.ToInt32(n["UserRegistrationId"]),
                                  StaffName = Convert.ToString(n["StaffName"]),
                                  Designation = Convert.ToString(n["Designation"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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
        public List<CleanLinenIssueModel> CleanLinenIssueTxn_FetchDeliveredBy(CleanLinenIssueModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(CleanLinenIssueTxn_FetchDeliveredBy), Level.Info.ToString());
                List<CleanLinenIssueModel> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                CleanLinenDespatchModel Search = new CleanLinenDespatchModel();
                parameters.Add("@StaffName", SearchObject.StaffName ?? "a");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                //parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSCleanLinenIssueTxn_FetchDeliveredBy", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;
                    result = (from n in dt.AsEnumerable()
                              select new CleanLinenIssueModel
                              {
                                  UserRegistrationId = Convert.ToInt32(n["UserRegistrationId"]),
                                  StaffName = Convert.ToString(n["StaffName"]),
                                  Designation = Convert.ToString(n["Designation"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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
        public List<CleanLinenIssueModel> CleanLinenIssueLinenBagTxnDet_FetchLaundryBag(CleanLinenIssueModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(CleanLinenIssueLinenBagTxnDet_FetchLaundryBag), Level.Info.ToString());
                List<CleanLinenIssueModel> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                CleanLinenDespatchModel Search = new CleanLinenDespatchModel();
                parameters.Add("@StaffName", SearchObject.StaffName ?? "a");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                //parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSCleanLinenIssueLinenBagTxnDet_FetchLaundryBag", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;
                    result = (from n in dt.AsEnumerable()
                              select new CleanLinenIssueModel
                              {
                                  UserRegistrationId = Convert.ToInt32(n["CleanLinenRequestId"]),
                                  StaffName = Convert.ToString(n["DocumentNo"]),
                                  Designation = Convert.ToString(n["Designation"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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
        #endregion

        public List<LinenAdjustmentsModel> LinenAdjustmentTxn_FetchAuthorisedBy(LinenAdjustmentsModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LinenAdjustmentTxn_FetchAuthorisedBy), Level.Info.ToString());
                List<LinenAdjustmentsModel> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@StaffName", SearchObject.StaffName ?? "a");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                //parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSLinenAdjustmentTxn_FetchAuthorisedBy", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;
                    result = (from n in dt.AsEnumerable()
                              select new LinenAdjustmentsModel
                              {
                                  UserRegistrationId = Convert.ToInt32(n["UserRegistrationId"]),
                                  StaffName = Convert.ToString(n["StaffName"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex

                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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

        public List<LinenAdjustmentsModel> LinenAdjustmentTxn_FetchInventoryDocNo(LinenAdjustmentsModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LinenAdjustmentTxn_FetchInventoryDocNo), Level.Info.ToString());
                List<LinenAdjustmentsModel> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@DocumentNo", SearchObject.DocumentNo ?? "a");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                //parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSLinenAdjustmentTxn_FetchInventoryDocNo", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;
                    result = (from n in dt.AsEnumerable()
                              select new LinenAdjustmentsModel
                              {
                                  LinenInventoryIds = Convert.ToInt32(n["LinenInventoryId"]),
                                  DocumentNo = Convert.ToString(n["DocumentNo"]),
                                  Date = Convert.ToDateTime(n["Date"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex

                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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

        public List<LinenAdjustmentsModel> LinenAdjustmentTxnDet_FetchLinenCode(LinenAdjustmentsModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LinenAdjustmentTxn_FetchInventoryDocNo), Level.Info.ToString());
                List<LinenAdjustmentsModel> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);

                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@LinenCode", SearchObject.LinenCode ?? "a");
                parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSLinenAdjustmentTxnDet_FetchLinenCode", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;
                    result = (from n in dt.AsEnumerable()
                              select new LinenAdjustmentsModel
                              {
                                  LinenItemId = Convert.ToInt32(n["LinenItemId"]),
                                  LinenCode = Convert.ToString(n["LinenCode"]),
                                  LinenDescription = Convert.ToString(n["LinenDescription"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex

                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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

        public List<VehicleDetailsModel> VehicleDetailsMstDet_FetchLicenseCode(VehicleDetailsModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(VehicleDetailsMstDet_FetchLicenseCode), Level.Info.ToString());
                List<VehicleDetailsModel> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@LicenseCode", SearchObject.LicenseCode ?? "a");
                parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSVehicleDetailsMstDet_FetchLicenseCode", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in dt.AsEnumerable()
                              select new VehicleDetailsModel
                              {
                                  LicenseTypeDetId = Convert.ToInt32(n["LicenseTypeDetId"]),
                                  LicenseCode = Convert.ToString(n["LicenseCode"]),
                                  LicenseDescription = Convert.ToString(n["LicenseDescription"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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

        public List<DriverDetailsModel> DriverDetailsMstDet_FetchLicenseCode(DriverDetailsModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(VehicleDetailsMstDet_FetchLicenseCode), Level.Info.ToString());
                List<DriverDetailsModel> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@LicenseCode", SearchObject.LicenseCode ?? "a");
                parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSDriverDetailsMstDet_FetchLicenseCode", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;
                    result = (from n in dt.AsEnumerable()
                              select new DriverDetailsModel
                              {
                                  LicenseTypeDetId = Convert.ToInt32(n["LicenseTypeDetId"]),
                                  LicenseCode = Convert.ToString(n["LicenseCode"]),
                                  LicenseDescription = Convert.ToString(n["LicenseDescription"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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

        public List<LinenRepairModel> LinenRepairTxn_FetchRepairedBy(LinenRepairModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(CleanLinenIssueTxn_Fetch2ndReceivedBy), Level.Info.ToString());
                List<LinenRepairModel> result = null;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();

                parameters.Add("@StaffName", SearchObject.StaffName ?? "a");
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSLinenRepairTxn_FetchRepairedBy", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    result = (from n in dt.AsEnumerable()
                              select new LinenRepairModel
                              {
                                  UserRegistrationId = Convert.ToInt32(n["UserRegistrationId"]),
                                  StaffName = Convert.ToString(n["StaffName"]),
                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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

        public List<LinenRepairModel> LinenRepairTxn_FetchCheckedBy(LinenRepairModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(CleanLinenIssueTxn_Fetch2ndReceivedBy), Level.Info.ToString());
                List<LinenRepairModel> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();

                parameters.Add("@StaffName", SearchObject.StaffName ?? "a");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSLinenRepairTxn_FetchCheckedBy", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;
                    result = (from n in dt.AsEnumerable()
                              select new LinenRepairModel
                              {
                                  UserRegistrationId = Convert.ToInt32(n["UserRegistrationId"]),
                                  StaffName = Convert.ToString(n["StaffName"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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

        public List<LinenRepairModel> LinenRepairTxnDet_FetchLinenCode(LinenRepairModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LinenRepairTxnDet_FetchLinenCode), Level.Info.ToString());
                List<LinenRepairModel> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@LinenCode", SearchObject.LinenCode ?? "a");
                parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSLinenRepairTxnDet_FetchLinenCode", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;
                    result = (from n in dt.AsEnumerable()
                              select new LinenRepairModel
                              {
                                  LinenItemId = Convert.ToInt32(n["LinenItemId"]),
                                  LinenCode = Convert.ToString(n["LinenCode"]),
                                  LinenDescription = Convert.ToString(n["LinenDescription"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex


                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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

        public List<CentralLinenStoreHousekeepingModel> CentralLinenStoreHKeepingTxn_FetchYear(CentralLinenStoreHousekeepingModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LinenRepairTxnDet_FetchLinenCode), Level.Info.ToString());
                List<CentralLinenStoreHousekeepingModel> result = null;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                //parameters.Add("@LinenCode", SearchObject.LinenCode ?? "");
                parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSCentralLinenStoreHKeepingTxn_FetchYear", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    result = (from n in dt.AsEnumerable()
                              select new CentralLinenStoreHousekeepingModel
                              {
                                  //LinenItemId = Convert.ToInt32(n["LinenItemId"]),
                                  //LinenCode = Convert.ToString(n["LinenCode"]),
                                  //LinenDescription = Convert.ToString(n["LinenDescription"])

                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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

        public List<CentralLinenStoreHousekeepingModel> CentralLinenStoreHKeepingTxn_FetchMonth(CentralLinenStoreHousekeepingModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LinenRepairTxnDet_FetchLinenCode), Level.Info.ToString());
                List<CentralLinenStoreHousekeepingModel> result = null;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                //parameters.Add("@LinenCode", SearchObject.LinenCode ?? "");
                parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSCentralLinenStoreHKeepingTxn_FetchMonth", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    result = (from n in dt.AsEnumerable()
                              select new CentralLinenStoreHousekeepingModel
                              {
                                  //LinenItemId = Convert.ToInt32(n["LinenItemId"]),
                                  //LinenCode = Convert.ToString(n["LinenCode"]),
                                  //LinenDescription = Convert.ToString(n["LinenDescription"])

                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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

        public List<CentralLinenStoreHousekeepingModel> CentralLinenStoreHKeepingTxnDet_FetchDate(CentralLinenStoreHousekeepingModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(CentralLinenStoreHKeepingTxnDet_FetchDate), Level.Info.ToString());
                List<CentralLinenStoreHousekeepingModel> result = null;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pYear", SearchObject.Year.ToString());
                parameters.Add("@pMonthName", SearchObject.Month);
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSCentralLinenStoreHKeepingTxnDet_FetchDate", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    result = (from n in dt.AsEnumerable()
                              select new CentralLinenStoreHousekeepingModel
                              {

                                  Year = Convert.ToString(n["Year"]),
                                  Month = Convert.ToString(n["month"])

                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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

        public List<soildLinencollectionsModel> SoiledLinenCollectionTxn_FetchLaundryPlant(soildLinencollectionsModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(SoiledLinenCollectionTxn_FetchLaundryPlant), Level.Info.ToString());
                List<soildLinencollectionsModel> result = null;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                //parameters.Add("@LinenCode", SearchObject.LinenCode ?? "");
                parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSSoiledLinenCollectionTxn_FetchLaundryPlant", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    result = (from n in dt.AsEnumerable()
                              select new soildLinencollectionsModel
                              {
                                  //LinenItemId = Convert.ToInt32(n["LinenItemId"]),
                                  //LinenCode = Convert.ToString(n["LinenCode"]),
                                  //LinenDescription = Convert.ToString(n["LinenDescription"])

                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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

        public List<CentralLinenStoreHousekeepingModel> SoiledLinenCollectionTxnDet_FetchUserAreaCode(CentralLinenStoreHousekeepingModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(SoiledLinenCollectionTxnDet_FetchUserAreaCode), Level.Info.ToString());
                List<CentralLinenStoreHousekeepingModel> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@UserAreaCode", SearchObject.UserAreaCode ?? "a");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSSoiledLinenCollectionTxnDet_FetchUserAreaCode ", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;
                    result = (from n in dt.AsEnumerable()
                              select new CentralLinenStoreHousekeepingModel
                              {
                                  LLSUserAreaId = Convert.ToInt32(n["LLSUserAreaId"]),
                                  UserAreaCode = Convert.ToString(n["UserAreaCode"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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

        public List<CentralLinenStoreHousekeepingModel> SoiledLinenCollectionTxnDet_FetchLocCode(CentralLinenStoreHousekeepingModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(SoiledLinenCollectionTxnDet_FetchLocCode), Level.Info.ToString());
                List<CentralLinenStoreHousekeepingModel> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@UserAreaCode", Convert.ToString(SearchObject.UserAreaCode));
                parameters.Add("@UserLocationCode", SearchObject.UserLocationCode ?? "a");
                parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSSoiledLinenCollectionTxnDet_FetchLocCode", parameters, DataSetparameters);
                
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;
                    result = (from n in dt.AsEnumerable()
                              select new CentralLinenStoreHousekeepingModel
                              {
                                  LLSUserAreaLocationId = Convert.ToInt32(n["LLSUserAreaLocationId"]),
                                  UserLocationCode = Convert.ToString(n["UserLocationCode"]),
                                  //LinenDescription = Convert.ToString(n["LinenDescription"])
                                  FirstScheduleStartTime = TimeSpan.Parse(handlenull(n["1stScheduleStartTime"].ToString())),
                                  SecondScheduleEndTime = TimeSpan.Parse(handlenull(n["1stScheduleEndTime"].ToString())),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex

                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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


        string handlenull(string inp)
        {
            if (inp.Length < 1)
            {
                inp = "00:00:00";
            }
            else
            { }
            return inp;
        }
        public List<soildLinencollectionsModel> SoiledLinenCollectionTxnDet_FetchCollectionSchedule(soildLinencollectionsModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(SoiledLinenCollectionTxnDet_FetchCollectionSchedule), Level.Info.ToString());
                List<soildLinencollectionsModel> result = null;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                // parameters.Add("@LinenCode", SearchObject.LinenCode ?? "");
                parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSSoiledLinenCollectionTxnDet_FetchCollectionSchedule", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    result = (from n in dt.AsEnumerable()
                              select new soildLinencollectionsModel
                              {
                                  //LinenItemId = Convert.ToInt32(n["LinenItemId"]),
                                  //LinenCode = Convert.ToString(n["LinenCode"]),
                                  //LinenDescription = Convert.ToString(n["LinenDescription"])

                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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

        public List<soildLinencollectionsModel> SoiledLinenCollectionTxnDet_FetchVerifiedBy(soildLinencollectionsModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(SoiledLinenCollectionTxnDet_FetchVerifiedBy), Level.Info.ToString());
                List<soildLinencollectionsModel> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@StaffName", SearchObject.StaffName ?? "a");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSSoiledLinenCollectionTxnDet_FetchVerifiedBy", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;
                    result = (from n in dt.AsEnumerable()
                              select new soildLinencollectionsModel
                              {
                                  UserRegistrationId = Convert.ToInt32(n["UserRegistrationId"]),
                                  StaffName = Convert.ToString(n["StaffName"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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

        public List<LinenConemnationModel> LinenCondemnationTxn_FetchVerifiedBy(LinenConemnationModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(CleanLinenIssueTxn_Fetch2ndReceivedBy), Level.Info.ToString());
                List<LinenConemnationModel> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();

                parameters.Add("@StaffName", SearchObject.StaffName ?? "a");
                parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSLinenCondemnationTxn_FetchVerifiedBy", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;
                    result = (from n in dt.AsEnumerable()
                              select new LinenConemnationModel
                              {
                                  UserRegistrationId = Convert.ToInt32(n["UserRegistrationId"]),
                                  StaffName = Convert.ToString(n["StaffName"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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
        public List<LinenConemnationModel> LinenCondemnationTxn_FetchInspectedBy(LinenConemnationModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(CleanLinenIssueTxn_Fetch2ndReceivedBy), Level.Info.ToString());
                List<LinenConemnationModel> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();

                parameters.Add("@StaffName", SearchObject.StaffName ?? "a");
                parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSLinenCondemnationTxn_FetchInspectedBy", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;
                    result = (from n in dt.AsEnumerable()
                              select new LinenConemnationModel
                              {
                                  UserRegistrationId = Convert.ToInt32(n["UserRegistrationId"]),
                                  StaffName = Convert.ToString(n["StaffName"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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

        public List<LinenConemnationModel> LinenCondemnationTxnDet_FetchLinenCode(LinenConemnationModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LinenCondemnationTxnDet_FetchLinenCode), Level.Info.ToString());
                List<LinenConemnationModel> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@LinenCode", SearchObject.LinenCode ?? "a");
                parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSLinenCondemnationTxnDet_FetchLinenCode", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;
                    result = (from n in dt.AsEnumerable()
                              select new LinenConemnationModel
                              {
                                  LinenItemId = Convert.ToInt32(n["LinenItemId"]),
                                  LinenCode = Convert.ToString(n["LinenCode"]),
                                  LinenDescription = Convert.ToString(n["LinenDescription"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex

                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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

        public List<LinenRejectReplacementModel> LinenRejectReplacementTxn_FetchCLINo(LinenRejectReplacementModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LinenRejectReplacementTxn_FetchCLINo), Level.Info.ToString());
                List<LinenRejectReplacementModel> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@CLINo", SearchObject.CLINo ?? "a");
                parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSLinenRejectReplacementTxn_FetchCLINo", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;
                    result = (from n in dt.AsEnumerable()
                              select new LinenRejectReplacementModel
                              {
                                  CleanLinenIssueId = Convert.ToInt32(n["CleanLinenIssueId"]),
                                  CLINo = Convert.ToString(n["CLINo"]),
                                  Remarks = Convert.ToString(n["Remarks"]),
                                  UserAreaCode = Convert.ToString(n["UserAreaCode"]),
                                  UserLocationCode = Convert.ToString(n["UserLocationCode"]),
                                  UserAreaName = Convert.ToString(n["UserAreaName"]),
                                  UserLocationName = Convert.ToString(n["UserLocationName"]),
                                  LLSUserAreaId = Convert.ToInt32(n["LLSUserAreaId"]),
                                  LLSUserAreaLocationId = Convert.ToInt32(n["LLSUserAreaLocationId"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex

                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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

        public List<LinenRejectReplacementModel> LinenRejectReplacementTxn_FetchUserAreaCode(LinenRejectReplacementModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LinenRejectReplacementTxn_FetchUserAreaCode), Level.Info.ToString());
                List<LinenRejectReplacementModel> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@UserAreaCode", SearchObject.UserAreaCode ?? "a");
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSLinenRejectReplacementTxn_FetchUserAreaCode ", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in dt.AsEnumerable()
                              select new LinenRejectReplacementModel
                              {
                                  LLSUserAreaId = Convert.ToInt32(n["LLSUserAreaId"]),
                                  UserAreaCode = Convert.ToString(n["UserAreaCode"]),
                                  UserAreaName = Convert.ToString(n["UserAreaName"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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

        public List<LinenRejectReplacementModel> LinenRejectReplacementTxn_FetchLocCode(LinenRejectReplacementModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LinenRejectReplacementTxn_FetchLocCode), Level.Info.ToString());
                List<LinenRejectReplacementModel> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();

                parameters.Add("@UserLocationCode", SearchObject.UserLocationCode ?? "a");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSLinenRejectReplacementTxn_FetchLocCode", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;
                    result = (from n in dt.AsEnumerable()
                              select new LinenRejectReplacementModel
                              {
                                  UserLocationCode = Convert.ToString(n["UserLocationCode"]),
                                  UserLocationName = Convert.ToString(n["UserLocationName"]),
                                  LLSUserAreaLocationId = Convert.ToInt32(n["LLSUserAreaLocationId"]),
                                  LLSUserAreaId = Convert.ToInt32(n["LLSUserAreaId"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex

                                  //LinenDescription = Convert.ToString(n["LinenDescription"])

                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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

        public List<LinenRejectReplacementModel> LinenRejectReplacementTxnDet_FetchLinenCode(LinenRejectReplacementModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LinenRejectReplacementTxnDet_FetchLinenCode), Level.Info.ToString());
                List<LinenRejectReplacementModel> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();

                parameters.Add("@LinenCode", SearchObject.LinenCode ?? "a");
                parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSLinenRejectReplacementTxnDet_FetchLinenCode", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;
                    result = (from n in dt.AsEnumerable()
                              select new LinenRejectReplacementModel
                              {
                                  LinenCode = Convert.ToString(n["LinenCode"]),
                                  LinenItemId = Convert.ToInt32(n["LinenItemId"]),
                                  LinenDescription = Convert.ToString(n["LinenDescription"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex

                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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

        public List<LinenRejectReplacementModel> LinenRejectReplacementTxn_FetchRejectedBy(LinenRejectReplacementModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LinenRejectReplacementTxn_FetchRejectedBy), Level.Info.ToString());
                List<LinenRejectReplacementModel> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();

                parameters.Add("@StaffName", SearchObject.StaffName ?? "a");
                parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSLinenRejectReplacementTxn_FetchRejectedBy", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;
                    result = (from n in dt.AsEnumerable()
                              select new LinenRejectReplacementModel
                              {
                                  StaffName = Convert.ToString(n["StaffName"]),
                                  UserRegistrationId = Convert.ToInt32(n["UserRegistrationId"]),
                                  Designation = Convert.ToString(n["Designation"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex


                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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

        public List<LinenRejectReplacementModel> LinenRejectReplacementTxn_FetchReceivedBy(LinenRejectReplacementModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LinenRejectReplacementTxn_FetchReceivedBy), Level.Info.ToString());
                List<LinenRejectReplacementModel> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();

                parameters.Add("@StaffName", SearchObject.StaffName ?? "a");
                parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSLinenRejectReplacementTxn_FetchReceivedBy", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;
                    result = (from n in dt.AsEnumerable()
                              select new LinenRejectReplacementModel
                              {
                                  StaffName = Convert.ToString(n["StaffName"]),
                                  UserRegistrationId = Convert.ToInt32(n["UserRegistrationId"]),
                                  Designation = Convert.ToString(n["Designation"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex


                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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

        public List<LinenConemnationModel> LLSLinenInjectionTxn_FetchDONo(LinenConemnationModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LLSLinenInjectionTxn_FetchDONo), Level.Info.ToString());
                List<LinenConemnationModel> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();

                parameters.Add("@DONO", SearchObject.DONo ?? "a");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));


                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSLinenInjectionTxn_FetchDONo", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;
                    result = (from n in dt.AsEnumerable()
                              select new LinenConemnationModel
                              {
                                  DONo = Convert.ToString(n["DONO"]),
                                  PONo = Convert.ToString(n["PONO"]),
                                  DODate = Convert.ToDateTime(n["DODATE"]),
                                  DOId = Convert.ToInt32(n["DOId"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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

        public List<UserAreaFetch> LLSLinenInventoryTxn_FetchUserAreaCode(UserAreaFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LLSLinenInventoryTxn_FetchUserAreaCode), Level.Info.ToString());
                List<UserAreaFetch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();

                parameters.Add("@UserAreaCode", SearchObject.UserAreaCode ?? "a");
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSLinenInventoryTxn_FetchUserAreaCode", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;
                    result = (from n in dt.AsEnumerable()
                              select new UserAreaFetch
                              {
                                  LLSUserAreaId = Convert.ToInt32(n["LLSUserAreaId"]),
                                  UserAreaCode = Convert.ToString(n["UserAreaCode"]),
                                  UserAreaName = Convert.ToString(n["UserAreaName"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex

                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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

        public List<UserAreaFetch> LLSLinenInventoryTxn_FetchVerifiedBy(UserAreaFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LLSLinenInventoryTxn_FetchVerifiedBy), Level.Info.ToString());
                List<UserAreaFetch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();

                parameters.Add("@StaffName", SearchObject.StaffName ?? "a");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                //parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSLinenInventoryTxn_FetchVerifiedBy", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;
                    result = (from n in dt.AsEnumerable()
                              select new UserAreaFetch
                              {
                                  StaffName = Convert.ToString(n["StaffName"]),
                                  UserRegistrationId = Convert.ToInt32(n["UserRegistrationId"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex

                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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

        public List<UserAreaFetch> LLSLinenInventoryTxnDet_FetchLinenCode(UserAreaFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LLSLinenInventoryTxnDet_FetchLinenCode), Level.Info.ToString());
                List<UserAreaFetch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();

                parameters.Add("@pLinenCode", SearchObject.LinenCode ?? "a");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSLinenInventoryTxnDet_FetchLinenCode", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;
                    result = (from n in dt.AsEnumerable()
                              select new UserAreaFetch
                              {
                                  LinenCode = Convert.ToString(n["LinenCode"]),
                                  LinenItemId = Convert.ToInt32(n["LinenItemId"]),
                                  LinenDescription = Convert.ToString(n["LinenDescription"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex

                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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

        public List<UserAreaFetch> LLSLinenInventoryTxnDet_FetchLinenCodeUserArea(UserAreaFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LLSLinenInventoryTxnDet_FetchLinenCodeUserArea), Level.Info.ToString());
                List<UserAreaFetch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new PortAssetFetchModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@LocationCode", Convert.ToString(SearchObject.UserAreaCode));
                parameters.Add("@LinenCode", SearchObject.LinenCode ?? "a");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSCleanLinenInventoryTxnDet_FetchLinenCode", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;
                    result = (from n in dt.AsEnumerable()
                              select new UserAreaFetch
                              {
                                  LinenCode = Convert.ToString(n["LinenCode"]),
                                  LinenItemId = Convert.ToInt32(n["LinenItemId"]),
                                  LinenDescription = Convert.ToString(n["LinenDescription"]),
                                  UserAreaCode = Convert.ToString(n["UserAreaCode"]),
                                  UserLocationCode = Convert.ToString(n["UserLocationCode"]),
                                  //AgreedShelfLevel= Convert.ToInt32(n["AgreedShelfLevel"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex

                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchStaffMaster), Level.Info.ToString());
                return result;
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

        #endregion

        public List<Arp> ArpBerNo(Arp SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ArpBerNo), Level.Info.ToString());
                List<Arp> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new DBAccessDAL();

                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pBERNo", SearchObject.BERno ?? "a");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                parameters.Add("@pBERStage", Convert.ToString(SearchObject.BERStage));
                parameters.Add("@pFacilityId", _UserSession.FacilityId.ToString());

                DataTable dt = dbAccessDAL.GetDataTable("uspFM_BERDocNo_APPROVED_Fetch", parameters, DataSetparameters);

               
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in dt.AsEnumerable()
                              select new Arp
                              {
                                  ApplicationId = Convert.ToInt32(n["ApplicationId"]),
                                  AssetId = Convert.ToInt32(n["AssetId"]),
                                  BERno = Convert.ToString(n["BERno"]),
                                  BERStatusLovId = Convert.ToInt32(n["BERStatusLovId"]),
                                  BERStatusName = Convert.ToString(n["BERStatusName"]),
                                  AssetNo = Convert.ToString(n["AssetNo"]),
                                  AssetName = Convert.ToString(n["AssetName"]),
                                  BatchNo = Convert.ToString(n["BatchNo"]),
                                  ApplicationDate= Convert.ToDateTime(n["ApplicationDate"]),
                                  AssetTypeCode = Convert.ToString(n["AssetTypeCode"]),
                                  AssetDescription = Convert.ToString(n["AssetDescription"]),
                                  UserAreaName = Convert.ToString(n["UserAreaName"]),
                                  UserAreaId= Convert.ToInt32(n["UserAreaId"]),
                                  UserLocationName = Convert.ToString(n["UserLocationName"]),
                                  UserLocationId = Convert.ToInt32(n["UserLocationId"]),
                                  ItemCode = Convert.ToString(n["ItemNo"]),
                                  BER1Remarks = Convert.ToString(n["BER1Remarks"]),
                                  PurchaseCostRM = Convert.ToString(n["PurchaseCostRM"]),
                                  PurchaseDate = Convert.ToDateTime(n["PurchaseDate"]),
                                  AssetTypeCodeId= Convert.ToInt32(n["AssetTypeCodeId"]),
                                  Package_Code = Convert.ToString(n["Package_Code"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();


                }

                Log4NetLogger.LogExit(_FileName, nameof(ArpBerNo), Level.Info.ToString());
                return result;
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
        public List<Arp> ArpAssetNo(Arp SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ArpAssetNo), Level.Info.ToString());
                List<Arp> result = null;


                Log4NetLogger.LogExit(_FileName, nameof(ArpAssetNo), Level.Info.ToString());
                return result;
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

        


        public List<CRMWorkorderStaffFetch> CrmAssetNoFetch(CRMWorkorderStaffFetch SearchObject)
        {
            try
            {
                
                Log4NetLogger.LogEntry(_FileName, nameof(CrmAssetNoFetch), Level.Info.ToString());
                List<CRMWorkorderStaffFetch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                //var ds = new DataSet();
                DataTable dt = new DataTable();
                DataSet ds = new DataSet();
                CRMRequestEntity entity = new CRMRequestEntity();
                var dbAccessDAL = new DBAccessDAL();
                var BEMSdbAccessDAL = new MASTERBEMSDBAccessDAL();
                var FEMSdbAccessDAL = new MASTERFEMSDBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pAssetNo", SearchObject.AssetNo ?? "a");
                parameters.Add("@pManufacturerId", Convert.ToString(null));
                parameters.Add("@pModelId", Convert.ToString(null));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
               
                if (SearchObject.UserAreaCode == "1")
                {

                    dt = FEMSdbAccessDAL.GetMasterDataTable("uspFM_CRM_FemsAsset_Fetch", parameters, DataSetparameters);
                }
                else
                {
                    if (SearchObject.UserAreaCode == "2")
                    {
                        dt = BEMSdbAccessDAL.GetMasterDataTable("uspFM_CRM_BemsAsset_Fetch", parameters, DataSetparameters);
                    }
                    else
                    {
                        //dt = dbAccessDAL.MASTERGetDataTable("uspFM_CRM_MasterAsset_Fetch", parameters, DataSetparameters);
                    }
                }
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = result = (from n in dt.AsEnumerable()
                                       select new CRMWorkorderStaffFetch
                                       {
                                           AssetId = Convert.ToInt32(n["AssetId"]),
                                           AssetNo = Convert.ToString(n["AssetNo"]),
                                           UserLocationCode = Convert.ToString(n["UserLocationCode"]),
                                           UserLocationId = Convert.ToInt32(n["UserLocationId"]),                                         
                                           UserLocationName = Convert.ToString(n["UserLocationName"]),
                                           UserAreaId = n.Field<int>("UserAreaId"),
                                           UserAreaCode = Convert.ToString(n["UserAreaCode"]),
                                           UserAreaName = Convert.ToString(n["UserAreaName"]),
                                           LevelName = n.Field<string>("LevelName"),
                                           LevelCode = n.Field<string>("LevelCode"),
                                           BlockName = n.Field<string>("BlockName"),
                                           BlockCode = n.Field<string>("BlockCode"),
                                           TotalRecords = totalRecords,
                                           FirstRecord = firstRecord,
                                           LastRecord = lastRecord,
                                           LastPageIndex = lastPageIndex
                                       }).ToList();



                }
                Log4NetLogger.LogExit(_FileName, nameof(CrmAssetNoFetch), Level.Info.ToString());
                return result;
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