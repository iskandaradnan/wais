using CP.UETrack.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.UETrack.Models;
using CP.UETrack.Model.HWMS;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using UETrack.DAL;
using System.Dynamic;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.DAL.DataAccess.Contracts.HWMS;
using CP.UETrack.Model.Common;

namespace CP.UETrack.DAL.DataAccess.Implementations.HWMS
{
    public class VehicleDetailsDAL : IVehicleDetailsDAL
    {

        private readonly string _FileName = nameof(BlockDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public VehicleDetailsDAL()
        {

        }
        public VehicleDetailsDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                VehicleDetailsDropdown vehicleDetailsDropdown = new VehicleDetailsDropdown();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        var da = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_HWMS_VehicleDetails_DropDown";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pScreenName", "VehicleDetails");
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                        if (ds.Tables[0] != null)
                        {
                            vehicleDetailsDropdown.VehicleStatusLovs = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }
                        if (ds.Tables[1] != null)
                        {
                            vehicleDetailsDropdown.ClassGradeLovs = dbAccessDAL.GetLovRecords(ds.Tables[1]);
                        }
                        if (ds.Tables[2] != null)
                        {
                            vehicleDetailsDropdown.VehicleManufacturerLovs = dbAccessDAL.GetLovRecords(ds.Tables[2]);
                        }
                        if (ds.Tables[3] != null)
                        {
                            vehicleDetailsDropdown.IssuingBodyLovs = dbAccessDAL.GetLovRecords(ds.Tables[3]);
                        }
                        if (ds.Tables[4] != null)
                        {
                            vehicleDetailsDropdown.TreatmentPlantLovs = dbAccessDAL.GetLovRecords(ds.Tables[4]);
                        }
                        if (ds.Tables[5] != null)
                        {
                            vehicleDetailsDropdown.RouteLovs = dbAccessDAL.GetLovRecords(ds.Tables[5]);
                        }
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return vehicleDetailsDropdown;
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
        public VehicleDetails Save(VehicleDetails model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                var spName = string.Empty;


                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_HWMS_VehicleDetailsSave";

                        cmd.Parameters.AddWithValue("@VehicleId", model.VehicleId);
                        cmd.Parameters.AddWithValue("@CustomerId", model.CustomerId);
                        cmd.Parameters.AddWithValue("@FacilityId", model.FacilityId);
                        cmd.Parameters.AddWithValue("@VehicleNo", (model.VehicleNo));
                        cmd.Parameters.AddWithValue("@Manufacturer", model.Manufacturer);
                        cmd.Parameters.AddWithValue("@TreatmentPlant", model.TreatmentPlant);
                        cmd.Parameters.AddWithValue("@Status", model.Status);
                        cmd.Parameters.AddWithValue("@EffectiveFrom", model.EffectiveFrom);
                        cmd.Parameters.AddWithValue("@EffectiveTo", model.EffectiveTo);
                        cmd.Parameters.AddWithValue("@LoadWeight", model.LoadWeight);
                        cmd.Parameters.AddWithValue("@Route", model.Route);
                        
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                            cmd.Parameters.Clear();
                            model.VehicleId = Convert.ToInt32(ds.Tables[0].Rows[0]["VehicleId"]);

                            if(model.VehicleId == -1)
                            {
                                ErrorMessage = "Vehicle number already exists";
                            }
                            else
                            {
                                var ds1 = new DataSet();
                                cmd.CommandText = "Sp_HWMS_VehicleLicense_Save";

                                foreach (var Vehicle in model.VehicleDetailsList)
                                {
                                    cmd.Parameters.Clear();
                                    cmd.Parameters.AddWithValue("@LicenseCodeId", Vehicle.LicenseCodeId);
                                    cmd.Parameters.AddWithValue("@VehicleId", model.VehicleId);
                                    cmd.Parameters.AddWithValue("@LicenseCode", Vehicle.LicenseCode);
                                    cmd.Parameters.AddWithValue("@LicenseDescription", Vehicle.LicenseDescription);
                                    cmd.Parameters.AddWithValue("@LicenseNo", Vehicle.LicenseNo);
                                    cmd.Parameters.AddWithValue("@ClassGrade", Vehicle.ClassGrade);
                                    cmd.Parameters.AddWithValue("@IssuedBy", Vehicle.IssuedBy);
                                    cmd.Parameters.AddWithValue("@IssuedDate", Vehicle.IssuedDate);
                                    cmd.Parameters.AddWithValue("@ExpiryDate", Vehicle.ExpiryDate);
                                    cmd.Parameters.AddWithValue("@isDeleted", Vehicle.isDeleted);
                                    da.SelectCommand = cmd;
                                    da.Fill(ds);
                                }

                                model = Get(model.VehicleId);
                            }
                           
                        }
                    }
                }

                    Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                    return model;
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

        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                GridFilterResult filterResult = null;

                var multipleOrderBy = pageFilter.SortColumn.Split(',');
                var strOrderBy = string.Empty;
                foreach (var order in multipleOrderBy)
                {
                    strOrderBy += order + " " + pageFilter.SortOrder + ",";
                }
                if (!string.IsNullOrEmpty(strOrderBy))
                {
                    strOrderBy = strOrderBy.TrimEnd(',');
                }

                strOrderBy = string.IsNullOrEmpty(strOrderBy) ? pageFilter.SortColumn + " " + pageFilter.SortOrder : strOrderBy;
                var strCondition = string.Empty;
                var QueryCondition = pageFilter.QueryWhereCondition;
                if (string.IsNullOrEmpty(QueryCondition))
                {
                    strCondition = "FacilityId = " + _UserSession.FacilityId.ToString();
                }
                else
                {
                    strCondition = QueryCondition + " AND FacilityId = " + _UserSession.FacilityId.ToString();
                }
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_HWMS_VehicleDetails_GetAll";

                        cmd.Parameters.AddWithValue("@PageIndex", pageFilter.PageIndex);
                        cmd.Parameters.AddWithValue("@PageSize", pageFilter.PageSize);
                        cmd.Parameters.AddWithValue("@StrCondition", strCondition);
                        cmd.Parameters.AddWithValue("@StrSorting", strOrderBy);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalRecords"]);
                    var totalPages = (int)Math.Ceiling((float)totalRecords / (float)pageFilter.Rows);

                    var commonDAL = new CommonDAL();
                    var currentPageList = commonDAL.ToDynamicList(ds.Tables[0]);
                    filterResult = new GridFilterResult
                    {
                        TotalRecords = totalRecords,
                        TotalPages = totalPages,
                        RecordsList = currentPageList,
                        CurrentPage = pageFilter.Page
                    };
                }
                Log4NetLogger.LogExit(_FileName, nameof(GetAll), Level.Info.ToString());
                return filterResult;
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
        public VehicleDetails Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_HWMS_VehicleDetails_Get";
                        cmd.Parameters.AddWithValue("Id", Id);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                VehicleDetails _vehicleDetails = new VehicleDetails();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    DataRow dr = ds.Tables[0].Rows[0];

                    _vehicleDetails.VehicleId = Convert.ToInt32(dr["VehicleId"]);
                    _vehicleDetails.VehicleNo = dr["VehicleNo"].ToString();
                    _vehicleDetails.Manufacturer = dr["Manufacturer"].ToString();
                    _vehicleDetails.TreatmentPlant = dr["TreatmentPlant"].ToString();
                    _vehicleDetails.Status = dr["Status"].ToString();
                    _vehicleDetails.EffectiveFrom = Convert.ToDateTime(dr["EffectiveFrom"].ToString());
                    _vehicleDetails.EffectiveTo= dr["EffectiveTo"] == DBNull.Value ? default(DateTime?) : Convert.ToDateTime(dr["EffectiveTo"]);
                    _vehicleDetails.LoadWeight = Convert.ToInt32(dr["LoadWeight"].ToString());
                    _vehicleDetails.Route = dr["Route"].ToString();
                }
                if (ds.Tables[1] != null)
                {
                    if (ds.Tables[1].Rows.Count > 0)
                    {
                        List<LicenseVehicleDetails> _licenseDetails = new List<LicenseVehicleDetails>();
                        foreach (DataRow dr in ds.Tables[1].Rows)
                        {
                            LicenseVehicleDetails Auto = new LicenseVehicleDetails();                           
                            Auto.LicenseCodeId = Convert.ToInt32(dr["LicenseCodeId"].ToString());
                            Auto.LicenseCode = dr["LicenseCode"].ToString();
                            Auto.LicenseDescription = dr["LicenseDescription"].ToString();
                            Auto.LicenseNo = dr["LicenseNo"].ToString();
                            Auto.ClassGrade = dr["ClassGrade"].ToString();
                            Auto.IssuedBy = dr["IssuedBy"].ToString();
                            Auto.IssuedDate = Convert.ToDateTime(dr["IssuedDate"].ToString());
                            Auto.ExpiryDate = Convert.ToDateTime(dr["ExpiryDate"].ToString());
                            _licenseDetails.Add(Auto);
                        }
                        _vehicleDetails.VehicleDetailsList = _licenseDetails;
                    }
                }
                if (ds.Tables[2].Rows.Count > 0)
                {
                    List<Attachment> _attachmentList = new List<Attachment>();

                    foreach (DataRow dr in ds.Tables[2].Rows)
                    {
                        Attachment obj = new Attachment();

                        obj.AttachmentId = Convert.ToInt32(dr["AttachmentId"]);
                        obj.FileType = dr["FileType"].ToString();
                        obj.FileName = dr["FileName"].ToString();
                        obj.AttachmentName = dr["AttachmentName"].ToString();
                        obj.FilePath = dr["FilePath"].ToString();
                        _attachmentList.Add(obj);

                    }
                    _vehicleDetails.AttachmentList = _attachmentList;
                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return _vehicleDetails;
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
       
        public List<LicCodeDes> LicenseCodeFetch(LicCodeDes searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LicenseCodeFetch), Level.Info.ToString());
                List<LicCodeDes> result = null;
                var pageIndex = searchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new DBAccessDAL();
                var obj = new LicCodeDes();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pLicenseCode", searchObject.LicenseCode ?? "");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                parameters.Add("@pFacilityId", _UserSession.FacilityId.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("Sp_HWMS_LicenseCodeFetch", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in dt.AsEnumerable()
                              select new LicCodeDes
                              {
                                  LicenseId = Convert.ToInt32(n["LicenseId"]),
                                  LicenseCode = Convert.ToString(n["LicenseCode"]),
                                  LicenseDescription = Convert.ToString(n["LicenseDescription"]),
                                  IssuingBody = Convert.ToString(n["IssuingBody"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(LicenseCodeFetch), Level.Info.ToString());
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

        public VehicleDetails DescriptionData(string LicenseCode)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(DescriptionData), Level.Info.ToString());
                VehicleDetails vehilceDetails = new VehicleDetails();
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "SP_HWMS_VehicleDetails_Display_LicenseCode";
                        cmd.Parameters.AddWithValue("@LicenseCode", LicenseCode);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                List<LicenseVehicleDetails> VehicleDetailsAutoGenerateList1 = new List<LicenseVehicleDetails>();
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    LicenseVehicleDetails Auto = new LicenseVehicleDetails();
                    Auto.LicenseDescription = dr["LicenseDescription"].ToString();
                    Auto.IssuedBy = dr["IssuedBy"].ToString();

                    VehicleDetailsAutoGenerateList1.Add(Auto);
                }
                vehilceDetails.DDLicenseList = VehicleDetailsAutoGenerateList1;
                Log4NetLogger.LogExit(_FileName, nameof(DescriptionData), Level.Info.ToString());
                return vehilceDetails;
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
    }
}
