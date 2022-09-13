using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.HWMS;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using CP.UETrack.Model.Common;
using CP.UETrack.Model.HWMS;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UETrack.DAL;
namespace CP.UETrack.DAL.DataAccess.Implementations.HWMS
{
    public class DriverDetailsDAL : IDriverDetailsDAL
    {

        private readonly string _FileName = nameof(BlockDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public DriverDetailsDropdownList Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                // DeptAreaDetails approvedChemicalList = new DeptAreaDetails();
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                DriverDetailsDropdownList driverDetailsDropdown = new DriverDetailsDropdownList();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        var da = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_HWMS_DriverDetails_DropDown";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pScreenName", "DriverDetails");
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                        if (ds.Tables[0] != null)
                        {
                            driverDetailsDropdown.DriverStatusLovs = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }
                        if (ds.Tables[1] != null)
                        {
                            driverDetailsDropdown.ClassGradeLovs = dbAccessDAL.GetLovRecords(ds.Tables[1]);
                        }
                        if (ds.Tables[2] != null)
                        {
                            driverDetailsDropdown.IssuingBodyLovs = dbAccessDAL.GetLovRecords(ds.Tables[2]);
                        }
                        if (ds.Tables[3] != null)
                        {
                            driverDetailsDropdown.TreatmentPlantLovs = dbAccessDAL.GetLovRecords(ds.Tables[3]);
                        }
                        if (ds.Tables[4] != null)
                        {
                            driverDetailsDropdown.RouteLovs = dbAccessDAL.GetLovRecords(ds.Tables[4]);
                        }
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return driverDetailsDropdown;
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

        public DriverDetails Save(DriverDetails model, out string ErrorMessage)
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
                        cmd.CommandText = "Sp_HWMS_DriverDetails_Save";

                        cmd.Parameters.AddWithValue("@DriverId", model.DriverId);
                        cmd.Parameters.AddWithValue("@CustomerId", model.CustomerId);
                        cmd.Parameters.AddWithValue("@FacilityId", model.FacilityId);
                        cmd.Parameters.AddWithValue("@DriverCode", model.DriverCode);
                        cmd.Parameters.AddWithValue("@DriverName", model.DriverName);
                        cmd.Parameters.AddWithValue("@TreatmentPlant", model.TreatmentPlant);
                        cmd.Parameters.AddWithValue("@Status", model.Status);
                        cmd.Parameters.AddWithValue("@EffectiveFrom", model.EffectiveFrom);
                        cmd.Parameters.AddWithValue("@EffectiveTo", model.EffectiveTo);
                        cmd.Parameters.AddWithValue("@ContactNo", model.ContactNo);
                        cmd.Parameters.AddWithValue("@Route", model.Route);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                        if (ds.Tables.Count != 0)
                        {
                            cmd.Parameters.Clear();
                            

                            if (ds.Tables[0].Rows[0]["DriverId"].ToString() == "-1")
                            {
                                ErrorMessage = "DriverCode already exists";
                            }
                            else
                            {
                                model.DriverId = Convert.ToInt32(ds.Tables[0].Rows[0]["DriverId"]);
                                var ds1 = new DataSet();
                                cmd.CommandText = "Sp_HWMS_DriverDetailsLicense_Save";

                                foreach (var use in model.DriverDetailsList)
                                {
                                    cmd.Parameters.AddWithValue("@LicenseCodeId", use.LicenseCodeId);
                                    cmd.Parameters.AddWithValue("@DriverId", model.DriverId);
                                    cmd.Parameters.AddWithValue("@LicenseCode", use.LicenseCode);
                                    cmd.Parameters.AddWithValue("@Description", use.Description);
                                    cmd.Parameters.AddWithValue("@LicenseNo", use.LicenseNo);
                                    cmd.Parameters.AddWithValue("@ClassGrade", use.ClassGrade);
                                    cmd.Parameters.AddWithValue("@IssuedBy", use.IssuedBy);
                                    cmd.Parameters.AddWithValue("@IssuedDate", use.IssuedDate);
                                    cmd.Parameters.AddWithValue("@ExpiryDate", use.ExpiryDate);
                                    cmd.Parameters.AddWithValue("@isDeleted", use.isDeleted);
                                    var da1 = new SqlDataAdapter();
                                    da1.SelectCommand = cmd;
                                    da1.Fill(ds1);
                                    cmd.Parameters.Clear();
                                    
                                }

                                model = Get(model.DriverId);
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
                        cmd.CommandText = "Sp_HWMS_DriverDetails_GetAll";

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


        public DriverDetails Get(int Id)
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
                        cmd.CommandText = "Sp_HWMS_DriverDetails_Get";
                        cmd.Parameters.AddWithValue("@DriverId", Id);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                DriverDetails _driverDetails = new DriverDetails();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    DataRow dr = ds.Tables[0].Rows[0];

                    _driverDetails.DriverId = Convert.ToInt32(dr["DriverId"]);
                    _driverDetails.DriverCode = dr["DriverCode"].ToString();
                    _driverDetails.DriverName = dr["DriverName"].ToString();
                    _driverDetails.TreatmentPlant = dr["TreatmentPlant"].ToString();
                    _driverDetails.Status = dr["Status"].ToString();
                    _driverDetails.EffectiveFrom = Convert.ToDateTime(dr["EffectiveFrom"].ToString());
                    _driverDetails.EffectiveTo = dr["EffectiveTo"] == DBNull.Value ? default(DateTime?) : Convert.ToDateTime(dr["EffectiveTo"]);
                    _driverDetails.ContactNo = dr["ContactNo"].ToString();
                    _driverDetails.Route = dr["Route"].ToString();
                }
                if (ds.Tables[1] != null)
                {
                    if (ds.Tables[1].Rows.Count > 0)
                    {
                        List<LicenseDetails> _licenseDetails = new List<LicenseDetails>();
                        foreach (DataRow dr in ds.Tables[1].Rows)
                        {
                            LicenseDetails Auto = new LicenseDetails();

                            Auto.LicenseCodeId = Convert.ToInt32(dr["LicenseCodeId"]);                            
                            Auto.LicenseCode = dr["LicenseCode"].ToString();
                            Auto.Description = dr["Description"].ToString();
                            Auto.LicenseNo = dr["LicenseNo"].ToString();
                            Auto.ClassGrade = dr["ClassGrade"].ToString();
                            Auto.IssuedBy = dr["IssuedBy"].ToString();
                            Auto.IssuedDate = Convert.ToDateTime(dr["IssuedDate"].ToString());
                            Auto.ExpiryDate = Convert.ToDateTime(dr["ExpiryDate"].ToString());
                            _licenseDetails.Add(Auto);
                        }
                        _driverDetails.DriverDetailsList = _licenseDetails;
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
                    _driverDetails.AttachmentList = _attachmentList;
                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return _driverDetails;
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
       
        public DriverDetails DescriptionData(string LicenseCode)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(DescriptionData), Level.Info.ToString());
                DriverDetails driverDetails = new DriverDetails();
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_HWMS_DriverDetails_Display_LicenseCode";
                        cmd.Parameters.AddWithValue("@LicenseCode", LicenseCode);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                List<LicenseDetails> DriverDetailsAutoGenerateList1 = new List<LicenseDetails>();

                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    LicenseDetails Auto = new LicenseDetails();
                    Auto.Description = dr["Description"].ToString();
                    //Auto.IssuedBy = dr["IssuedBy"].ToString();

                    DriverDetailsAutoGenerateList1.Add(Auto);
                }
                driverDetails.DDLicenseList = DriverDetailsAutoGenerateList1;
                Log4NetLogger.LogExit(_FileName, nameof(DescriptionData), Level.Info.ToString());
                return driverDetails;
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

