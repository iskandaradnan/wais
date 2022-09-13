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

namespace CP.UETrack.DAL.DataAccess
{
    public class SearchDAL : ISearchDAL
    {
        private readonly string _FileName = nameof(SearchDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public List<UMStaffSearch> StaffMasterSearch(UMStaffSearch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(StaffMasterSearch), Level.Info.ToString());
                List<UMStaffSearch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["SearchPopupPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "UspFM_MstStaff_Search";

                        cmd.Parameters.AddWithValue("@pStaffName", SearchObject.StaffName ?? "");
                        cmd.Parameters.AddWithValue("@pFacilityName", SearchObject.FacilityName ?? "");
                        cmd.Parameters.AddWithValue("@pDesignation", SearchObject.Designation ?? "");
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
                                  //StaffEmployeeId = Convert.ToString(n["StaffEmployeeId"]),
                                  Designation = Convert.ToString(n["Designation"]),
                                  FacilityName = Convert.ToString(n["FacilityName"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }

                Log4NetLogger.LogExit(_FileName, nameof(StaffMasterSearch), Level.Info.ToString());
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
        public List<TypeCodeSearch> TypeCodeSearch(TypeCodeSearch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(TypeCodeSearch), Level.Info.ToString());
                List<TypeCodeSearch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["SearchPopupPageSize"]);
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
                        cmd.CommandText = "uspFM_EngAssetTypeCode_Search";

                        cmd.Parameters.AddWithValue("@pTypeCode", SearchObject.AssetTypeCode ?? "");
                        cmd.Parameters.AddWithValue("@pTypeCodeDescription", SearchObject.AssetTypeDescription ?? "");
                        cmd.Parameters.AddWithValue("@pAssetClassification", SearchObject.AssetClassificationCode ?? "");
                        cmd.Parameters.AddWithValue("@pAssetClassificationDescr", SearchObject.AssetClassificationDescription ?? "");
                        cmd.Parameters.AddWithValue("@pAssetClassificationId", SearchObject.AssetClassificationId);
                        cmd.Parameters.AddWithValue("@pPageIndex", pageIndex);
                        cmd.Parameters.AddWithValue("@pPageSize", pageSize);
                        cmd.Parameters.AddWithValue("@ScreenName", ScreenName);

                        cmd.Parameters.AddWithValue("@pCheckEquipmentFunctionDescription", SearchObject.CheckEquipmentFunctionDescription);
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);
                        if (_UserSession.UserDB == 0)
                        {
                            cmd.Parameters.AddWithValue("@pServiceId", SearchObject.TypeOfServices);
                        }
                        else
                        {
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
                                  AssetClassificationCode = Convert.ToString(n["AssetClassificationCode"]),
                                  AssetClassificationDescription = n.Field<string>("AssetClassificationDescription"),
                                  PPM = Convert.ToInt32(n["PPM"]) == 0 ? 100 : 99,
                                  RI = Convert.ToInt32(n["RI"]) == 0 ? 100 : 99,
                                  Other = Convert.ToInt32(n["Other"]) == 0 ? 100 : 99,
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }

                Log4NetLogger.LogExit(_FileName, nameof(TypeCodeSearch), Level.Info.ToString());
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
        public List<UserLocationCodeSearch> LocationCodeSearch(UserLocationCodeSearch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LocationCodeSearch), Level.Info.ToString());
                List<UserLocationCodeSearch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["SearchPopupPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_MstLocationUserLocation_Search";

                        cmd.Parameters.AddWithValue("@pUserLocationCode", SearchObject.UserLocationCode ?? "");
                        cmd.Parameters.AddWithValue("@pUserLocationName", SearchObject.UserLocationName ?? "");
                        cmd.Parameters.AddWithValue("@pUserAreaCode", SearchObject.UserAreaCode ?? "");
                        cmd.Parameters.AddWithValue("@pUserAreaName", SearchObject.UserAreaName ?? "");
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);
                        if (SearchObject.UserAreaId != 0)
                        {
                            cmd.Parameters.AddWithValue("@pUserAreaId", SearchObject.UserAreaId);
                        }
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

                Log4NetLogger.LogExit(_FileName, nameof(LocationCodeSearch), Level.Info.ToString());
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
        public List<ManufacturerSearch> ManufacturerSearch(ManufacturerSearch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ManufacturerSearch), Level.Info.ToString());
                List<ManufacturerSearch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["SearchPopupPageSize"]);

                var spName = string.Empty;
                var isAssetStandardization = false;

                if (SearchObject.ScreenName == "AssetStandardization")
                {
                    spName = "uspFM_EngAssetStandardizationManufacturer_Search";
                    isAssetStandardization = true;
                }
                else
                {
                    spName = "uspFM_EngAssetManufacturer_Search";
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

                Log4NetLogger.LogExit(_FileName, nameof(ManufacturerSearch), Level.Info.ToString());
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
        public List<ModelSearch> ModelSearch(ModelSearch SearchObject)
        {
            try
            {
                var resu = _UserSession;
                Log4NetLogger.LogEntry(_FileName, nameof(ModelSearch), Level.Info.ToString());
                List<ModelSearch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["SearchPopupPageSize"]);

                var spName = string.Empty;
                var isAssetStandardization = false;

                if (SearchObject.ScreenName == "AssetStandardization")
                {
                    spName = "uspFM_EngAssetStandardizationModel_Search";
                    isAssetStandardization = true;
                }
                else
                {
                    spName = "uspFM_EngAssetModel_Search";
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
                        // cmd.Parameters.AddWithValue("@pServicesID", Convert.ToString(SearchObject.TypeOfServices));
                        if (_UserSession.UserDB == 0)
                        {
                            cmd.Parameters.AddWithValue("@pServiceId", SearchObject.TypeOfServices);
                        }
                        else
                        {
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
                              select new ModelSearch
                              {
                                  ModelId = Convert.ToInt32(n["ModelId"]),
                                  Model = Convert.ToString(n["Model"]),
                                  ManufacturerId = n.Field<int?>("ManufacturerId"),
                                  Manufacturer = Convert.ToString(n["Manufacturer"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }

                Log4NetLogger.LogExit(_FileName, nameof(ModelSearch), Level.Info.ToString());
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
        public List<EngAssetTypeCodeStandardTasksFetch> TaskCodeSearch(EngAssetTypeCodeStandardTasksFetch searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LocationCodeSearch), Level.Info.ToString());
                List<EngAssetTypeCodeStandardTasksFetch> result = null;
                var pageIndex = searchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["SearchPopupPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngAssetTypeCodeStandardTasksDet_Search";
                        cmd.Parameters.AddWithValue("@pAssetTaskCode", searchObject.TaskCode ?? "");
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
                              select new EngAssetTypeCodeStandardTasksFetch
                              {
                                  StandardTaskDetId = Convert.ToInt32(n["StandardTaskDetId"]),
                                  TaskCode = Convert.ToString(n["TaskCode"]),
                                  TaskDescription = Convert.ToString(n["TaskDescription"]),
                                  PPMFrequency = Convert.ToInt32(n["PPMFrequency"]),
                                  LovPPMFrequency = Convert.ToString(n["LovPPMFrequency"]),
                                  ManufacturerId = Convert.ToInt32(n["ManufacturerId"]),
                                  Manufacturer = Convert.ToString(n["Manufacturer"]),
                                  ModelId = Convert.ToInt32(n["ModelId"]),
                                  Model = Convert.ToString(n["Model"]),
                                  PpmHours = Convert.ToDecimal(n["PPMHours"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex,
                                  PPMChecklistNo = Convert.ToString(n["PPMChecklistNo"])
                              }).ToList();
                }

                Log4NetLogger.LogExit(_FileName, nameof(LocationCodeSearch), Level.Info.ToString());
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
        public List<AssetPreRegistrationNoSearch> AssetPreRegistrationNoSearch(AssetPreRegistrationNoSearch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(AssetPreRegistrationNoSearch), Level.Info.ToString());
                List<AssetPreRegistrationNoSearch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["SearchPopupPageSize"]);
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngTestingandCommissioningTxnDet_Search";

                        cmd.Parameters.AddWithValue("@pAssetPreRegistrationNo", SearchObject.AssetPreRegistrationNo ?? "");
                        cmd.Parameters.AddWithValue("@pAssetClassificationId", SearchObject.AssetClassificationId);
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);
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

                Log4NetLogger.LogExit(_FileName, nameof(AssetPreRegistrationNoSearch), Level.Info.ToString());
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
        public List<LevelFetchModel> LevelCodeSearch(LevelFetchModel SearchObject)
        {
            try
            {
                List<LevelFetchModel> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["SearchPopupPageSize"]);

                var dbAccessDAL = new DBAccessDAL();
                var obj = new EngAssetClassification();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pLevelCode", SearchObject.LevelCode ?? "");
                parameters.Add("@pLevelName", SearchObject.LevelName ?? "");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_MstLocationLevel_Search", parameters, DataSetparameters);
                if (dt != null)
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
        public List<CompanyStaffFetchModel> CompanyStaffSearch(CompanyStaffFetchModel searchObject)
        {
            try
            {
                List<CompanyStaffFetchModel> result = null;
                var pageIndex = searchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["SearchPopupPageSize"]);

                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pStaffName", searchObject.StaffName ?? "");
                parameters.Add("@pFacilityName", searchObject.FacilityName ?? "");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_MstStaff_Company_Search", parameters, DataSetparameters);
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
                                  StaffName = Convert.ToString(n["StaffName"]),
                                  FacilityName = Convert.ToString(n["FacilityName"]),
                                  Designation = Convert.ToString(n["Designation"]),
                                  ContactNumber = n.Field<string>("ContactNo"),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }
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
        public List<FacilityStaffFetchModel> FacilityStaffSearch(FacilityStaffFetchModel searchObject)
        {
            try
            {
                List<FacilityStaffFetchModel> result = null;
                var pageIndex = searchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["SearchPopupPageSize"]);

                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pStaffName", searchObject.StaffName ?? "");
                parameters.Add("@pFacilityName", searchObject.FacilityName ?? "");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_MstStaff_Facility_Search", parameters, DataSetparameters);
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
                                  Designation = Convert.ToString(n["Designation"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }
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
        public List<WarrantyManagementSearch> WarrantyManagementSearch(WarrantyManagementSearch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(WarrantyManagementSearch), Level.Info.ToString());
                List<WarrantyManagementSearch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["SearchPopupPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngAsset_WarrantyMgmt_Search";

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
                                  TnCRefNo = Convert.ToString(n["TnCRefNo"]),
                                  AssetClassification = Convert.ToString(n["AssetClassification"]),
                                  TypeCode = Convert.ToString(n["TypeCode"]),
                                  AssetDescription = Convert.ToString(n["AssetDescription"]),
                                  WarrantyStartDate = Convert.ToDateTime(n["WarrantyStartDate"]),
                                  WarrantyEndDate = Convert.ToDateTime(n["WarrantyEndDate"]),
                                  WarrantyPeriod = Convert.ToInt32(n["WarrantyPeriod"]),
                                  PurchaseCost = Convert.ToDecimal(n["PurchaseCost"]),
                                  DWFee = Convert.ToDecimal(n["DWFee"]),
                                  PWFee = Convert.ToDecimal(n["PWFee"]),
                                  WarrantyDownTime = Convert.ToInt32(n["WarrantyDownTime"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }

                Log4NetLogger.LogExit(_FileName, nameof(WarrantyManagementSearch), Level.Info.ToString());
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
        public List<UserAreaFetch> UserAreaSearch(UserAreaFetch searchObject)
        {
            try
            {
                List<UserAreaFetch> result = null;
                var pageIndex = searchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["SearchPopupPageSize"]);

                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pUserAreaCode", searchObject.UserAreaCode ?? "");
                parameters.Add("@pUserAreaName", searchObject.UserAreaName ?? "");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_MstLocationUserArea_Search", parameters, DataSetparameters);
                if (dt != null)
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
                                  BlockId = Convert.ToInt32(n["BlockId"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }
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
        public List<StockAdjustmentFetchModel> StockAdjustmentFetchModel(StockAdjustmentFetchModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(StockAdjustmentFetchModel), Level.Info.ToString());
                List<StockAdjustmentFetchModel> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["SearchPopupPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngSpareParts_Search";

                        cmd.Parameters.AddWithValue("@pSparePartNo", SearchObject.PartNo ?? "");
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
                              select new StockAdjustmentFetchModel
                              {

                                  StockAdjustmentId = Convert.ToInt32(n["StockAdjustmentId"]),
                                  StockAdjustmentDetId = Convert.ToInt32(n["StockAdjustmentDetId"]),
                                  PartNo = Convert.ToString(n["PartNo"]),
                                  PartDescription = Convert.ToString(n["PartDescription"]),
                                  ItemCode = Convert.ToString(n["ItemCode"]),
                                  ItemDescription = Convert.ToString(n["ItemDescription"]),
                                  SparePartsId = Convert.ToInt32(n["SparePartsId"]),
                                  QuantityFacility = Convert.ToDecimal(n["QuantityFacility"]),
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
            catch (Exception)
            {
                throw;
            }
        }
        public List<ParentAssetNoSearch> AssetNoSearch(ParentAssetNoSearch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(AssetNoSearch), Level.Info.ToString());
                List<ParentAssetNoSearch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["SearchPopupPageSize"]);

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
                            cmd.CommandText = "uspFM_EngAssetPlanner_Search";
                        }
                        else if (SearchObject.TypeOfPlanner == 36 || SearchObject.TypeOfPlanner == 198 || SearchObject.TypeOfPlanner == 343)
                        {
                            cmd.CommandText = "uspFM_EngAssetOthersPlanner_search";
                        }
                        else
                        {
                            cmd.CommandText = "uspFM_EngAsset_Search";
                        }

                        if (SearchObject.TypeOfPlanner == 34)
                        {
                            cmd.Parameters.AddWithValue("@pAssetNo", SearchObject.AssetNo ?? "");
                            cmd.Parameters.AddWithValue("@pAssetDescription", SearchObject.AssetDescription ?? "");
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
                            cmd.Parameters.AddWithValue("@pAssetDescription", SearchObject.AssetDescription ?? "");
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
                            cmd.Parameters.AddWithValue("@pAssetDescription", SearchObject.AssetDescription ?? "");
                            cmd.Parameters.AddWithValue("@pCurrentAssetId", SearchObject.CurrentAssetId);
                            cmd.Parameters.AddWithValue("@pPageIndex", pageIndex);
                            cmd.Parameters.AddWithValue("@pPageSize", pageSize);
                            cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);
                            cmd.Parameters.AddWithValue("@pIsFromAssetRegister", SearchObject.IsFromAssetRegister);
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
                                      Asset_Name = Convert.ToString(n["Asset_Name"]),
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
                                      Asset_Name = Convert.ToString(n["Asset_Name"]),
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
                                      Asset_Name = Convert.ToString(n["Asset_Name"]),
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

                Log4NetLogger.LogExit(_FileName, nameof(AssetNoSearch), Level.Info.ToString());
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
        public List<AssetRegisterWarrantyProviderGrid> SearchforContractorcode(AssetRegisterWarrantyProviderGrid SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(AssetNoSearch), Level.Info.ToString());
                List<AssetRegisterWarrantyProviderGrid> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["SearchPopupPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_MstContractorandVendor_Search";

                        cmd.Parameters.AddWithValue("@pContractorCode", SearchObject.SSMNo ?? "");

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

                Log4NetLogger.LogExit(_FileName, nameof(AssetNoSearch), Level.Info.ToString());
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
        public List<AssetClassificationFetch> AssetClassificationCodeSearch(AssetClassificationFetch searchObject)
        {
            try
            {
                List<AssetClassificationFetch> result = null;
                var pageIndex = searchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["SearchPopupPageSize"]);

                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pAssetClassificationCode", searchObject.AssetClassificationCode ?? "");
                parameters.Add("@pAssetClassificationDescription", searchObject.AssetClassificationDescription ?? "");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                parameters.Add("@pServicesID", Convert.ToString(searchObject.TypeOfServices));
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EngAssetClassification_Search", parameters, DataSetparameters);
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
        public List<ItemCodeFetch> ItemCodeSearch(ItemCodeFetch searchObject)
        {
            try
            {
                List<ItemCodeFetch> result = null;
                var pageIndex = searchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["SearchPopupPageSize"]);

                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pItemNo", searchObject.ItemNo ?? "");
                parameters.Add("@pItemDescription", searchObject.ItemDescription ?? "");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_FMItemMaster_Search", parameters, DataSetparameters);
                if (dt != null)
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
        public List<BERAssetNoFetch> BERAssetSearch(BERAssetNoFetch searchObject)
        {
            try
            {
                List<BERAssetNoFetch> result = null;
                var pageIndex = searchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["SearchPopupPageSize"]);

                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pAssetNo", searchObject.AssetNo ?? "");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_BERAsset_Search", parameters, DataSetparameters);
                if (dt != null)
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
                                  PurchaseCost = n.Field<decimal?>("PurchaseCostRM"),
                                  PurchaseDate = Convert.ToDateTime(n["PurchaseDate"] == System.DBNull.Value ? null : n["PurchaseDate"]),
                                  CurrentValue = n.Field<decimal?>("CurrentValue"),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex,
                                  AssetAge = n.Field<decimal?>("AssetAge"),
                                  StillwithInLifeSpan = n.Field<int?>("StillwithInLifeSpan"),
                              }).ToList();
                }
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
        public List<BERRejectedNoFetch> BERRejectedNoSearch(BERRejectedNoFetch searchObject)
        {
            List<BERRejectedNoFetch> result = null;
            if (searchObject.BERStage==0)
            {
                searchObject.BERStage = 2;
                result = ARPRejectedNoSearch(searchObject);
            }
            else
            {
           
            try
            {
               
                var pageIndex = searchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["SearchPopupPageSize"]);

                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pBERNo", searchObject.BERno ?? "");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                parameters.Add("@pBERStage", Convert.ToString(searchObject.BERStage));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));

                DataTable dt = dbAccessDAL.GetDataTable("uspFM_BERDocNo_Rejected_Search", parameters, DataSetparameters);
                if (dt != null)
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
            return result;
        }

        public List<BERRejectedNoFetch> ARPRejectedNoSearch(BERRejectedNoFetch searchObject)
        {

            try
            {
                List<BERRejectedNoFetch> result = null;
                var pageIndex = searchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["SearchPopupPageSize"]);

                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pBERNo", searchObject.BERno ?? "");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                parameters.Add("@pBERStage", Convert.ToString(searchObject.BERStage));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));

                DataTable dt = dbAccessDAL.GetDataTable("uspFM_ARPDocNo_Rejected_Search", parameters, DataSetparameters);
                if (dt != null)
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
                return result;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception dalex)
            {
                throw new DALException(dalex);
            }
        }
        
        public List<AssetQRCodePrintFetchModel> AssetQRCodePrintFetchModel(AssetQRCodePrintFetchModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(AssetQRCodePrintFetchModel), Level.Info.ToString());
                List<AssetQRCodePrintFetchModel> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["SearchPopupPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngAssetQR_Search";

                        cmd.Parameters.AddWithValue("@pAssetNo", SearchObject.AssetNo ?? "");
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
            catch (Exception)
            {
                throw;
            }
        }
        public List<UserLocationQRCodePrintingFetchModel> UserLocationQRCodePrintingFetchModel(UserLocationQRCodePrintingFetchModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(UserLocationQRCodePrintingFetchModel), Level.Info.ToString());
                List<UserLocationQRCodePrintingFetchModel> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["SearchPopupPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_MstLocationBlockQR_Search";

                        cmd.Parameters.AddWithValue("@pBlockCode", SearchObject.BlockCode ?? "");
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
                              select new UserLocationQRCodePrintingFetchModel
                              {

                                  BlockId = Convert.ToInt32(n["BlockId"]),
                                  BlockCode = Convert.ToString(n["BlockCode"]),
                                  BlockName = Convert.ToString(n["BlockName"]),
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

                Log4NetLogger.LogExit(_FileName, nameof(UserLocationQRCodePrintingFetchModel), Level.Info.ToString());
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
        public List<CRMWorkorderRequestFetch> CRMWorkorderRequestFetch(CRMWorkorderRequestFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(CRMWorkorderRequestFetch), Level.Info.ToString());
                List<CRMWorkorderRequestFetch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["SearchPopupPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_CRMRequestNo_Search";

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
            catch (Exception)
            {
                throw;
            }
        }
        public List<TAndCCRMRequestNoFetchSearch> TAndCCRMRequestNoSearch(TAndCCRMRequestNoFetchSearch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(TAndCCRMRequestNoSearch), Level.Info.ToString());
                List<TAndCCRMRequestNoFetchSearch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["SearchPopupPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_TAndCCRMRequestNo_Search";

                        cmd.Parameters.AddWithValue("@pRequestNo", SearchObject.RequestNo ?? "");
                        cmd.Parameters.AddWithValue("@pRequestDescription", SearchObject.RequestDescription ?? "");
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
                                  RequestDescription = Convert.ToString(n["RequestDescription"]),
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

                Log4NetLogger.LogExit(_FileName, nameof(TAndCCRMRequestNoSearch), Level.Info.ToString());
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
        public List<PortAssetFetchModel> PorteringWorkOrderNoSearch(PortAssetFetchModel searchObject)
        {
            try
            {
                List<PortAssetFetchModel> result = null;
                var pageIndex = searchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["SearchPopupPageSize"]);

                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
             //   parameters.Add("@pAssetNo", searchObject.AssetNo ?? "");
                parameters.Add("@pMaintenanceWorkNo", searchObject.MaintenanceWorkNo ?? "");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                parameters.Add("@pAssetId", Convert.ToString(searchObject.AssetId));
                //  parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EngMaintenanceWorkOrderTxnPortering_Search", parameters, DataSetparameters);
                if (dt != null)
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
                                  IsLoaner = Convert.ToBoolean(n["IsLoaner"]),
                                  UserAreaId = Convert.ToInt32(n["UserAreaId"]),
                                  UserLocationId = Convert.ToInt32(n["UserLocationId"]),
                                  FacilityName = Convert.ToString(n["FacilityName"]),
                                  BlockName = Convert.ToString(n["BlockName"]),
                                  LevelName = Convert.ToString(n["LevelName"]),
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
        public List<PortAssetFetchModel> PorteringAssetNoSearch(PortAssetFetchModel searchObject)
        {
            try
            {
                List<PortAssetFetchModel> result = null;
                var pageIndex = searchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["SearchPopupPageSize"]);

                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pAssetNo", searchObject.AssetNo ?? "");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_PorteringAsset_Search", parameters, DataSetparameters);
                if (dt != null)
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
                                  IsLoaner = Convert.ToBoolean(n["IsLoaner"]),
                                  UserAreaId = Convert.ToInt32(n["UserAreaId"]),
                                  UserLocationId = Convert.ToInt32(n["UserLocationId"]),
                                  FacilityName = Convert.ToString(n["FacilityName"]),
                                  BlockName = Convert.ToString(n["BlockName"]),
                                  LevelName = Convert.ToString(n["LevelName"]),
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
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["SearchPopupPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EODAsset_Search";
                        
                        cmd.Parameters.AddWithValue("@pAssetNo", SearchObject.AssetNo ?? "");
                        cmd.Parameters.AddWithValue("@pCategorySystemId", SearchObject.CategorySystemId ?? 0);
                        cmd.Parameters.AddWithValue("@pRecordDate", SearchObject.RecordDate );
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
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["SearchPopupPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EODManufacturer_Search";
                        
                        cmd.Parameters.AddWithValue("@pManufacturer", SearchObject.Manufacturer ??"" );
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
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["SearchPopupPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EODModel_Search";
                        
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
        public List<CustomerFetch> CustomerCodeSearch(CustomerFetch searchObject)
        {
            try
            {
                List<CustomerFetch> result = null;
                var pageIndex = searchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["SearchPopupPageSize"]);

                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pCustomerCode", searchObject.CustomerCode ?? "");
                parameters.Add("@pCustomerName", searchObject.CustomerName ?? "");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_MstCustomer_Search", parameters, DataSetparameters);
                if (dt != null)
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
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["SearchPopupPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_CRMAsset_Search";
                        
                        cmd.Parameters.AddWithValue("@pModelId", SearchObject.ModelId);
                        cmd.Parameters.AddWithValue("@pManufacturerId", SearchObject.ManufacturerId);
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
            catch (Exception)
            {
                throw;
            }
        }
        public List<CRMWorkorderStaffFetch> CRMWorkorderStaffFetch(CRMWorkorderStaffFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(CRMWorkorderStaffFetch), Level.Info.ToString());
                List<CRMWorkorderStaffFetch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["SearchPopupPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_StaffSpecialization_Company_Search";

                        cmd.Parameters.AddWithValue("@pStaffName", SearchObject.StaffName ?? "");
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
                                  StaffId = Convert.ToInt32(n["StaffMasterId"]),

                                  StaffName = Convert.ToString(n["StaffName"]),
                                  FacilityName = Convert.ToString(n["FacilityName"]),
                                  PhoneNumber = Convert.ToString(n["ContactNo"]),
                                  Designation = Convert.ToString(n["Designation"]),
                                  UserDesignationId = Convert.ToInt32(n["DesignationId"]),
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
            catch (Exception)
            {
                throw;
            }
        }
        public List<ContractorNameSearch> ContractorNameSearch(ContractorNameSearch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ContractorNameSearch), Level.Info.ToString());
                List<ContractorNameSearch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["SearchPopupPageSize"]);

                var ds = new DataSet();
                // var dbAccessDAL = new DBAccessDAL();
                var dbAccessDAL = new MASTERDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_MstContractorName_Search";
                        
                        cmd.Parameters.AddWithValue("@pContractorName", SearchObject.ContractorName ?? "");
                        cmd.Parameters.AddWithValue("@pContractorCode", SearchObject.SSMRegistrationCode ?? "");
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

                Log4NetLogger.LogExit(_FileName, nameof(ContractorNameSearch), Level.Info.ToString());
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
        public List<BookingFetch> BookingWorkOrderNoSearch(BookingFetch searchObject)
        {
            try
            {
                List<BookingFetch> result = null;
                var pageIndex = searchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["SearchPopupPageSize"]);

                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                //   parameters.Add("@pAssetNo", searchObject.AssetNo ?? "");
                parameters.Add("@pMaintenanceWorkNo", searchObject.MaintenanceWorkNo ?? "");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                parameters.Add("@pAssetId", Convert.ToString(searchObject.AssetId));
                //  parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                DataTable dt = dbAccessDAL.GetDataTable("UspFM_EngLoanerTestEquipmentBookingTxn_WorkOderNo_Search", parameters, DataSetparameters);
                if (dt != null)
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
                                  BookingStartDate = n.Field<DateTime?>("BookingStartFrom"),
                                  BookingEndDate = n.Field<DateTime?>("BookingEnd"),
                                  AssetDescription = Convert.ToString(n["AssetDescription"]),
                                  TypeOfAsset = n.Field<int?>("TypeOfAsset"),
                                  FacilityId = Convert.ToInt32(n["FacilityId"]),                                
                                  FacilityName = Convert.ToString(n["FacilityName"]),                                
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex,
                                  //AssetTypeCode = Convert.ToString(n["AssetTypeCode"]),
                                  //AssetTypeDescription = Convert.ToString(n["AssetTypeDescription"]),
                                //  NumberofDays = n.Field<int?>("DaysCount"),
                              }).ToList();
                }
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
        public List<BookingFetch> BookingAssetNoSearch(BookingFetch searchObject)
        {
            try
            {
                List<BookingFetch> result = null;
                var pageIndex = searchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["SearchPopupPageSize"]);

                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pAssetNo", searchObject.AssetNo ?? "");
                parameters.Add("@pAssetTypeCode", searchObject.AssetTypeCode ?? "");
                parameters.Add("@pAssetTypeDescription", searchObject.AssetTypeDescription ?? "");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
            //    parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                DataTable dt = dbAccessDAL.GetDataTable("UspFM_EngLoanerTestEquipmentBookingTxnAsset_Search", parameters, DataSetparameters);
                if (dt != null)
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
                                  AssetDescription = Convert.ToString(n["AssetDescription"]),
                                  TypeOfAsset = n.Field<int?>("TypeOfAsset"),
                                  FacilityId = Convert.ToInt32(n["FacilityId"]),                               
                                  FacilityName = Convert.ToString(n["FacilityName"]),
                                  BookingStartDate = n.Field<DateTime?>("BookingStartFrom"),
                                  BookingEndDate = n.Field<DateTime?>("BookingEnd"),
                                  CalibrationdueDate= n.Field<DateTime?>("calibrationduedate"),                                  
                                  AssetTypeCode = Convert.ToString(n["AssetTypeCode"]),
                                  AssetTypeDescription = Convert.ToString(n["AssetTypeDescription"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex,
                                  NumberofDays = Convert.ToString(n["DaysCount"]),
                                  Model = Convert.ToString(n["Model"]),
                                  Manufacturer = Convert.ToString(n["Manufacturer"]),
                              }).ToList();
                }
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
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["SearchPopupPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_UserTrainingStaffs_Search";
                        
                        cmd.Parameters.AddWithValue("@pStaffName", SearchObject.StaffName ?? "");
                        cmd.Parameters.AddWithValue("@pFacilityId", SearchObject.FacilityId );
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
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["SearchPopupPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_MstQAPQualityCause_Search";
                        
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
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["SearchPopupPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_QAPCarTxn_Search";
                        
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
        public List<UserShiftLeaveDetailsFetch> UserShiftLeaveDetailsSearch(UserShiftLeaveDetailsFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(UserShiftLeaveDetailsSearch), Level.Info.ToString());
                List<UserShiftLeaveDetailsFetch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["SearchPopupPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {

                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_StaffShiftDet_Search";

                        cmd.Parameters.AddWithValue("@pStaffName", SearchObject.StaffName ?? "");
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);
                        cmd.Parameters.AddWithValue("@pDesignation", SearchObject.Designation);
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

                Log4NetLogger.LogExit(_FileName, nameof(UserShiftLeaveDetailsSearch), Level.Info.ToString());
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
        public List<AreaFetch> BlockCascCodeSearch(AreaFetch SearchObject)
        {
            try
            {
                List<AreaFetch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["SearchPopupPageSize"]);

                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pBlockCode", SearchObject.BlockCode ?? "");
                parameters.Add("@pBlockName", SearchObject.BlockName ?? "");
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                DataTable dt = dbAccessDAL.GetDataTable("UspFM_BlockCsc_Search", parameters, DataSetparameters);
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

        public List<AreaFetch> QCPPMCodeSearch(AreaFetch SearchObject)
        {
            try
            {
                List<AreaFetch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["SearchPopupPageSize"]);

                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pCauseCode", SearchObject.CauseCode ?? "");
                parameters.Add("@pDescription", SearchObject.Description ?? "");
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                //DataTable dt = dbAccessDAL.GetDataTable("UspFM_BlockCsc_Search", parameters, DataSetparameters);
                DataTable dt = dbAccessDAL.GetDataTable("UspFM_QcPPM_Search", parameters, DataSetparameters);
                
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in dt.AsEnumerable()
                              select new AreaFetch
                              {
                                  QualityCauseId = Convert.ToInt32(n["QualityCauseId"]),
                                  Description = Convert.ToString(n["Description"]),
                                  CauseCode = Convert.ToString(n["CauseCode"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }
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
        public List<AreaFetch> LevelCascCodeSearch(AreaFetch SearchObject)
        {
            try
            {
                List<AreaFetch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["SearchPopupPageSize"]);

                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pLevelCode", SearchObject.LevelCode ?? "");
                parameters.Add("@pLevelName", SearchObject.LevelName ?? "");
                parameters.Add("@pBlockId", Convert.ToString(SearchObject.BlockId));
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                DataTable dt = dbAccessDAL.GetDataTable("UspFM_LevelCsc_Search", parameters, DataSetparameters);
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
        public List<AreaFetch> AreaCascCodeSearch(AreaFetch SearchObject)
        {
            try
            {
                List<AreaFetch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["SearchPopupPageSize"]);

                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pUserAreaCode", SearchObject.UserAreaCode ?? "");
                parameters.Add("@pUserAreaName", SearchObject.UserAreaName ?? "");
                parameters.Add("@pLevelId", Convert.ToString(SearchObject.LevelId));
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                DataTable dt = dbAccessDAL.GetDataTable("UspFM_AreaCsc_Search", parameters, DataSetparameters);
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
        public List<UserLocationCodeSearch> BookingLocationSearch(UserLocationCodeSearch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LocationCodeSearch), Level.Info.ToString());
                List<UserLocationCodeSearch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["SearchPopupPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_BookingUserLocation_Search";

                        cmd.Parameters.AddWithValue("@pUserLocationCode", SearchObject.UserLocationCode ?? "");
                        cmd.Parameters.AddWithValue("@pUserLocationName", SearchObject.UserLocationName ?? "");
                        cmd.Parameters.AddWithValue("@pUserAreaCode", SearchObject.UserAreaCode ?? "");
                        cmd.Parameters.AddWithValue("@pUserAreaName", SearchObject.UserAreaName ?? "");
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
                                  FacilityName = n.Field<string>("FacilityName"),
                                  FacilityCode = n.Field<string>("FacilityCode"),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }

                Log4NetLogger.LogExit(_FileName, nameof(LocationCodeSearch), Level.Info.ToString());
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


    }// 
}
