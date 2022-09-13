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

namespace CP.UETrack.DAL.DataAccess.Implementations.HWMS
{
    public class TreatmentPlantDAL:ITreatmentPlantDAL
    {
        private readonly string _FileName = nameof(BlockDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public TreatmentPlantDAL()
        {

        }

        public TreatmetPlantDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();

                TreatmetPlantDropdown TreatmetPlantDropdown = new TreatmetPlantDropdown();

                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        var da = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_HWMS_TreatmentPlant_Dropdown";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pScreenName", "TreatmentPlant");

                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables[0] != null)
                        {
                            TreatmetPlantDropdown.OwnershipLovs = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }
                        if (ds.Tables[1] != null)
                        {
                            TreatmetPlantDropdown.StateLovs = dbAccessDAL.GetLovRecords(ds.Tables[1]);
                        }
                        if (ds.Tables[2] != null)
                        {
                            TreatmetPlantDropdown.MethodofDisposalLovs = dbAccessDAL.GetLovRecords(ds.Tables[2]);
                        }
                        if (ds.Tables[3] != null)
                        {
                            TreatmetPlantDropdown.StatusLovs = dbAccessDAL.GetLovRecords(ds.Tables[3]);
                        }
                        if (ds.Tables[4] != null)
                        {
                            TreatmetPlantDropdown.UnitLovs = dbAccessDAL.GetLovRecords(ds.Tables[4]);
                        }
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return TreatmetPlantDropdown;
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

        public TreatmetPlant Save(TreatmetPlant model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                var spName = string.Empty;
                var ds = new DataSet();
                
                var ds1 = new DataSet();
                var da2 = new SqlDataAdapter();
                 var ds2 = new DataSet(); 
                var dbAccessDAL = new DBAccessDAL();
                             
               
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_HWMS_TreatmetPlant_Save";

                        cmd.Parameters.AddWithValue("@TreatmentPlantId", model.TreatmentPlantId);
                        cmd.Parameters.AddWithValue("@Customerid", model.CustomerId);
                        cmd.Parameters.AddWithValue("@Facilityid", model.FacilityId);
                        cmd.Parameters.AddWithValue("@TreatmentPlantCode", model.TreatmentPlantCode);
                        cmd.Parameters.AddWithValue("@TreatmentPlantName", model.TreatmentPlantName);
                        cmd.Parameters.AddWithValue("@RegistrationNo", model.RegistrationNo);
                        cmd.Parameters.AddWithValue("@AdressLine1", model.AdressLine1);
                        cmd.Parameters.AddWithValue("@AdressLine2", model.AdressLine2);
                        cmd.Parameters.AddWithValue("@City", model.City);
                        cmd.Parameters.AddWithValue("@State", model.State);
                        cmd.Parameters.AddWithValue("@PostCode", model.PostCode);
                        cmd.Parameters.AddWithValue("@Ownership", model.Ownership);
                        cmd.Parameters.AddWithValue("@ContactNumber", model.ContactNumber);
                        cmd.Parameters.AddWithValue("@FaxNumber", model.FaxNumber);
                        cmd.Parameters.AddWithValue("@DOEFileNo", model.DOEFileNo);
                        cmd.Parameters.AddWithValue("@OwnerName", model.OwnerName);
                        cmd.Parameters.AddWithValue("@NumberOfStore", model.NumberOfStore);
                        cmd.Parameters.AddWithValue("@CapacityOfStorage", model.CapacityOfStorage);
                        cmd.Parameters.AddWithValue("@Remarks", model.Remarks);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);


                        if (ds.Tables.Count != 0)
                        {
                            if (ds.Tables[0].Rows[0][0].ToString() == "-1")
                            {                                
                                ErrorMessage = "TreatmentPlantCode already exists";
                            }
                            else
                            {
                                model.TreatmentPlantId = Convert.ToInt32(ds.Tables[0].Rows[0]["TreatmentPlantId"]);

                                cmd.Parameters.Clear();
                                cmd.Connection = con;
                                cmd.CommandType = CommandType.StoredProcedure;                                
                                cmd.CommandText = "Sp_HWMS_TreatmetPlant_LicenseDetails_Save";                               

                                foreach (var License in model.TreatmetPlantLicenseDetails)
                                {
                                    cmd.Parameters.AddWithValue("@LicenseCodeId", License.LicenseId);
                                    cmd.Parameters.AddWithValue("@LicenseCode", License.LicenseCode);
                                    cmd.Parameters.AddWithValue("@LicenseDescription", License.LicenseDescription);
                                    cmd.Parameters.AddWithValue("@LicenseNo", License.LicenseNo);
                                    cmd.Parameters.AddWithValue("@Class", License.Class);
                                    cmd.Parameters.AddWithValue("@IssueDate", License.IssueDate);
                                    cmd.Parameters.AddWithValue("@ExpiryDate", License.ExpiryDate);
                                    cmd.Parameters.AddWithValue("@TreatmentPlantId", model.TreatmentPlantId);
                                    cmd.Parameters.AddWithValue("@isDeleted", License.isDeleted);

                                    var da1 = new SqlDataAdapter();
                                    da1.SelectCommand = cmd;
                                    da1.Fill(ds1);
                                    cmd.Parameters.Clear();
                                }

                                cmd.Parameters.Clear();
                                cmd.CommandType = CommandType.StoredProcedure;
                                cmd.CommandText = "Sp_HWMS_TreatmetPlant_DisposalType_Save";

                                foreach (var Disposal in model.TreatmetPlantDisposalType)
                                {
                                    cmd.Parameters.AddWithValue("@DisposalTypeId", Disposal.DisposalTypeId);
                                    cmd.Parameters.AddWithValue("@MethodofDisposal", Disposal.MethodofDisposal);
                                    cmd.Parameters.AddWithValue("@Status", Disposal.Status);
                                    cmd.Parameters.AddWithValue("@DesignCapacity", Disposal.DesignCapacity);
                                    cmd.Parameters.AddWithValue("@LicensedCapacity", Disposal.LicensedCapacity);
                                    cmd.Parameters.AddWithValue("@Unit", Disposal.Unit);
                                    cmd.Parameters.AddWithValue("@TreatmentPlantId", model.TreatmentPlantId);
                                    cmd.Parameters.AddWithValue("@isDeleted", Disposal.isDeleted);

                                    da2.SelectCommand = cmd;
                                    da2.Fill(ds2);
                                    cmd.Parameters.Clear();

                                }

                                model = Get(model.TreatmentPlantId);
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
                        cmd.CommandText = "Sp_HWMS_TreatmentPlant_GetAll";

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
                //return Blocks;
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
        public List<VehicleDetail> VehicleDetailsFetch(int TreatmentPlantId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(VehicleDetailsFetch), Level.Info.ToString());

                var ds = new DataSet();

                var dbAccessDAL = new DBAccessDAL();

                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_HWMS_TreatmentPlant_VehicleDetails_Get";
                        cmd.Parameters.AddWithValue("@TreatmentPlantId", TreatmentPlantId);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                TreatmetPlant TreatmetPlant = new TreatmetPlant();
                List<VehicleDetail> _VehicleDetail = new List<VehicleDetail>();

               
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    VehicleDetail Vehicle = new VehicleDetail();

                    Vehicle.VehicleNo = dr["VehicleNo"].ToString();
                    Vehicle.Manufacturer = dr["Manufacturer"].ToString();
                    Vehicle.LoadWeight = dr["LoadWeight"].ToString();
                    Vehicle.EffectiveDate = Convert.ToDateTime(dr["EffectiveFrom"].ToString());
                    Vehicle.Status = dr["Status"].ToString();
                   
                    _VehicleDetail.Add(Vehicle);
                }
                TreatmetPlant.VehicleDetailList = _VehicleDetail;

                Log4NetLogger.LogExit(_FileName, nameof(VehicleDetailsFetch), Level.Info.ToString());
                return _VehicleDetail;
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
        public List<DriverDetail> DriverDetailsFetch(int TreatmentPlantId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(DriverDetailsFetch), Level.Info.ToString());

                var ds = new DataSet();

                var dbAccessDAL = new DBAccessDAL();

                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_HWMS_TreatmentPlant_DriverDetails_Get";
                        cmd.Parameters.AddWithValue("@TreatmentPlantId", TreatmentPlantId);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                TreatmetPlant TreatmetPlant = new TreatmetPlant();
                List<DriverDetail> _DriverDetail = new List<DriverDetail>();


                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    DriverDetail Driver = new DriverDetail();

                    Driver.DriverCode = dr["DriverCode"].ToString();
                    Driver.DriverName = dr["DriverName"].ToString();
                    Driver.EffectiveDate = Convert.ToDateTime(dr["EffectiveFrom"].ToString());
                    Driver.Status = dr["Status"].ToString();

                    Driver.ClassGrade = dr["ClassGrade"].ToString();                   
                    Driver.IssuedBy = dr["IssuedBy"].ToString();
                    Driver.IssuedDate = Convert.ToDateTime(dr["IssuedDate"].ToString());


                    _DriverDetail.Add(Driver);
                }
                TreatmetPlant.DriverDetailList  = _DriverDetail;

                Log4NetLogger.LogExit(_FileName, nameof(VehicleDetailsFetch), Level.Info.ToString());
                return _DriverDetail;
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
        public TreatmetPlant Get(int Id)
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
                        cmd.CommandText = "Sp_HWMS_TreatmetPlant_Get";
                        cmd.Parameters.AddWithValue("Id", Id);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                TreatmetPlant _TreatmetPlant = new TreatmetPlant();

                if (ds.Tables[0].Rows.Count > 0)
                {
                    DataRow dr = ds.Tables[0].Rows[0];

                    _TreatmetPlant.TreatmentPlantId =  Convert.ToInt32(dr["TreatmentPlantId"]);
                    _TreatmetPlant.TreatmentPlantCode = dr["TreatmentPlantCode"].ToString();
                    _TreatmetPlant.TreatmentPlantName = dr["TreatmentPlantName"].ToString();
                    _TreatmetPlant.RegistrationNo = dr["RegistrationNo"].ToString();
                    _TreatmetPlant.AdressLine1 = dr["AdressLine1"].ToString();
                    _TreatmetPlant.AdressLine2 = dr["AdressLine2"].ToString();
                    _TreatmetPlant.City = dr["City"].ToString();
                    _TreatmetPlant.State = dr["State"].ToString();
                    _TreatmetPlant.PostCode = dr["PostCode"].ToString();
                    _TreatmetPlant.Ownership = dr["Ownership"].ToString();
                    _TreatmetPlant.ContactNumber =Convert.ToInt64( dr["ContactNumber"].ToString());
                    _TreatmetPlant.FaxNumber = dr["FaxNumber"].ToString();
                    _TreatmetPlant.DOEFileNo = dr["DOEFileNo"].ToString();
                    _TreatmetPlant.OwnerName = dr["OwnerName"].ToString();
                    _TreatmetPlant.NumberOfStore =Convert.ToInt32( dr["NumberOfStore"].ToString());
                    _TreatmetPlant.CapacityOfStorage =Convert.ToInt32( dr["CapacityOfStorage"].ToString());
                    _TreatmetPlant.Remarks = dr["Remarks"].ToString();
                    
                }
                if (ds.Tables[1] != null)
                {
                    if (ds.Tables[1].Rows.Count > 0)
                    {
                        List<TreatmetPlantDisposalType> _TreatmetPlantDisposalType = new List<TreatmetPlantDisposalType>();
                        foreach (DataRow dr in ds.Tables[1].Rows)
                        {
                            TreatmetPlantDisposalType DisposalType = new TreatmetPlantDisposalType();
                            DisposalType.DisposalTypeId =Convert.ToInt32( dr["DisposalTypeId"].ToString());
                            DisposalType.MethodofDisposal = dr["MethodofDisposal"].ToString();
                            DisposalType.Status = Convert.ToInt32(dr["Status"].ToString());
                            DisposalType.DesignCapacity = dr["DesignCapacity"].ToString();
                            DisposalType.LicensedCapacity = dr["LicensedCapacity"].ToString();
                            DisposalType.Unit = dr["Unit"].ToString();

                            _TreatmetPlantDisposalType.Add(DisposalType);
                        }
                        _TreatmetPlant.TreatmetPlantDisposalType = _TreatmetPlantDisposalType;
                    }
                }
                if (ds.Tables[2] != null)
                {
                    if (ds.Tables[2].Rows.Count > 0)
                    {
                        List<TreatmetPlantLicenseDetails> TreatmetPlantLicenseDetails = new List<TreatmetPlantLicenseDetails>();
                        foreach (DataRow dr in ds.Tables[2].Rows)
                        {
                            TreatmetPlantLicenseDetails LicenseDetails = new TreatmetPlantLicenseDetails();
                            LicenseDetails.LicenseId =Convert.ToInt32( dr["LicenseCodeId"].ToString());
                            LicenseDetails.LicenseCode = dr["LicenseCode"].ToString();
                            LicenseDetails.LicenseDescription = dr["LicenseDescription"].ToString();
                            LicenseDetails.LicenseNo = dr["LicenseNo"].ToString();
                            LicenseDetails.Class = dr["Class"].ToString();
                            LicenseDetails.IssueDate =Convert.ToDateTime( dr["IssueDate"].ToString());                          
                            LicenseDetails.ExpiryDate = Convert.ToDateTime(dr["ExpiryDate"].ToString());

                            TreatmetPlantLicenseDetails.Add(LicenseDetails);
                        }
                        _TreatmetPlant.TreatmetPlantLicenseDetails = TreatmetPlantLicenseDetails;
                    }
                }
                
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return _TreatmetPlant;
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
        public List<TreatmetPlantLicenseDetails> LicenseCodeFetch(TreatmetPlantLicenseDetails searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LicenseCodeFetch), Level.Info.ToString());
                List<TreatmetPlantLicenseDetails> result = null;
                var pageIndex = searchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new DBAccessDAL();
                var obj = new TreatmetPlantLicenseDetails();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@LicenseCode", searchObject.LicenseCode ?? "");
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
                              select new TreatmetPlantLicenseDetails
                              {
                                  LicenseId = Convert.ToInt32(n["LicenseId"]),
                                  LicenseCode = Convert.ToString(n["LicenseCode"]),                                  
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
       
    }
}
