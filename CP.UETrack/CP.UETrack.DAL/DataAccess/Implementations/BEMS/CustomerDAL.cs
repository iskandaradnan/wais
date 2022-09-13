using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using CP.UETrack.Models.BEMS;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using UETrack.DAL;

namespace CP.UETrack.DAL.DataAccess.Implementations.BEMS
{
    public class CustomerDAL : ICustomerDAL
    {

        private readonly static string fileName = nameof(CustomerDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        private static Random random = new Random();
        #region Data Access Methods
        public CustomerMstViewModel Get(int CustomerId)
        {
            Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var custObj = new CustomerMstViewModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@CustomerId", CustomerId.ToString());
                DataSet ds = dbAccessDAL.GetDataSet("UspFM_CustomerMst_Get", parameters, DataSetparameters);
                if (ds != null && ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                {
                    custObj.CustomerType = ds.Tables[0].Rows[0]["CustomerType"].ToString();
                    custObj.CustomerId = Convert.ToInt16(ds.Tables[0].Rows[0]["CustomerId"]);
                    custObj.CustomerName = ds.Tables[0].Rows[0]["CustomerName"].ToString();
                    custObj.CustomerCode = ds.Tables[0].Rows[0]["CustomerCode"].ToString();
                    //custObj.ContactNo = Convert.ToString(ds.Tables[0].Rows[0]["ContactNo"]);
                    custObj.Address = ds.Tables[0].Rows[0]["Address"].ToString();
                    custObj.Latitude = Convert.ToDecimal(ds.Tables[0].Rows[0]["Latitude"]);
                    custObj.Longitude = Convert.ToDecimal(ds.Tables[0].Rows[0]["Longitude"]);
                    //custObj.ActiveFromDate = Convert.ToDateTime(ds.Tables[0].Rows[0]["ActiveFromDate"]);
                    //custObj.ActiveFromDateUTC = Convert.ToDateTime(ds.Tables[0].Rows[0]["ActiveFromDateUTC"]);
                    //custObj.ActiveToDate = ds.Tables[0].Rows[0]["ActiveToDate"] != DBNull.Value ? (Convert.ToDateTime(ds.Tables[0].Rows[0]["ActiveToDate"])) : (DateTime?)null;
                    //custObj.ActiveToDateUTC = ds.Tables[0].Rows[0]["ActiveToDateUTC"] != DBNull.Value ? (Convert.ToDateTime(ds.Tables[0].Rows[0]["ActiveToDateUTC"])) : (DateTime?)null;
                    custObj.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                    custObj.Address2 = ds.Tables[0].Rows[0]["Address2"].ToString();
                    custObj.Postcode = ds.Tables[0].Rows[0]["Postcode"].ToString();
                    custObj.Active = Convert.ToBoolean(ds.Tables[0].Rows[0]["Active"]);
                    custObj.ContactNo = ds.Tables[0].Rows[0]["ContactNo"].ToString();
                    custObj.FaxNo = ds.Tables[0].Rows[0]["FaxNo"].ToString();
                    custObj.Remarks = ds.Tables[0].Rows[0]["Remarks"].ToString();
                    custObj.State = ds.Tables[0].Rows[0]["State"].ToString();
                    custObj.Country = ds.Tables[0].Rows[0]["Country"].ToString();
                    custObj.ContractPeriodInYears = ds.Tables[0].Rows[0]["ContractPeriodInYears"] != DBNull.Value ? (Convert.ToDecimal(ds.Tables[0].Rows[0]["ContractPeriodInYears"])) : (Decimal?)null;
                    //   custObj.TypeOfContractLovId = Convert.ToInt32(ds.Tables[0].Rows[0]["TypeOfContractLovId"]);
                    custObj.Base64StringLogo = ds.Tables[0].Rows[0]["Logo"] != DBNull.Value ? (Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Logo"]))) : null;
                    custObj.HiddenId = Convert.ToString(ds.Tables[0].Rows[0]["GuId"]);
                }
                if (ds != null && ds.Tables[1] != null && ds.Tables[1].Rows.Count > 0)
                {
                    var contactInfoList = (from n in ds.Tables[1].AsEnumerable()
                                           select new MstCustomerContactInfo
                                           {
                                               CustomerContactInfoId = Convert.ToInt32(n["CustomerContactInfoId"]),
                                               Name = Convert.ToString(n["Name"]),
                                               Designation = Convert.ToString(n["Designation"]),
                                               ContactNo = Convert.ToString(n["ContactNo"]),
                                               Email = Convert.ToString(n["Email"]),
                                               Active = true
                                           }).ToList();

                    if (contactInfoList != null && contactInfoList.Count > 0)
                    {
                        custObj.ContactInfoList = contactInfoList;
                    }
                }
                Log4NetLogger.LogExit(fileName, nameof(Get), Level.Info.ToString());
                return custObj;

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

        public CustomerMstViewModel Load()
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());
                CustomerMstViewModel cusobj = null;

                //var ds = new DataSet();
                var servicesDS = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {

                        //Get services
                        var da2 = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_GetCustomer_Type";
                        cmd.Parameters.Clear();
                        //  cmd.Parameters.AddWithValue("@UserRegistrationId", _UserSession.UserId);
                        da2.SelectCommand = cmd;
                        da2.Fill(servicesDS);
                    }
                }
                if (servicesDS.Tables.Count != 0)
                {
                    cusobj = new CustomerMstViewModel();
                    //assetClassificationLovs.StatusList = dbAccessDAL.GetLovRecords(ds.Tables[0]);

                    cusobj.Services = dbAccessDAL.GetLovRecords(servicesDS.Tables[0]);
                }
                Log4NetLogger.LogExit(fileName, nameof(Load), Level.Info.ToString());
                return cusobj;
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
        public CustomerMstViewModel Save(CustomerMstViewModel Cust, out string ErrorMessage)
        {
            BlockMstViewModel Block = new BlockMstViewModel();
            Block.FEMS = _UserSession.FEMS;
            Block.BEMS = _UserSession.BEMS;
            Log4NetLogger.LogEntry(fileName, Cust.Operation, Level.Info.ToString());
            try
            {
                ErrorMessage = string.Empty;
                //byte[] image = null;
                //if (Cust.Base64StringLogo != null)
                //{
                //    image = Encoding.Unicode.GetBytes(Cust.Base64StringLogo);
                //}
                var dbAccessDAL = new DBAccessDAL();
                var model = new CustomerMstViewModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@CustomerId", Convert.ToString(Cust.CustomerId));
                parameters.Add("@CustomerName", Convert.ToString(Cust.CustomerName.Trim()));
                parameters.Add("@CustomerCode", Convert.ToString(Cust.CustomerCode));
                parameters.Add("@Address", Convert.ToString(Cust.Address));
                parameters.Add("@Latitude", Convert.ToString(Cust.Latitude));
                parameters.Add("@Longitude", Convert.ToString(Cust.Longitude));
                parameters.Add("@CustomerType", Convert.ToString(Cust.CustomerType));
                // parameters.Add("@ActiveFromDate", Cust.ActiveFromDate != null ? Cust.ActiveFromDate.ToString("yyyy-MM-dd") : null);
                // parameters.Add("@ActiveFromDateUTC ", Cust.ActiveFromDateUTC != null ? Cust.ActiveFromDateUTC.ToString("yyyy-MM-dd") : null);
                //parameters.Add("@ActiveToDate", Cust.ActiveToDate != null ? Cust.ActiveToDate.Value.ToString("yyyy-MM-dd") : null);
                // parameters.Add("@ActiveToDateUTC", Cust.ActiveToDateUTC != null ? Cust.ActiveToDateUTC.Value.ToString("yyyy-MM-dd") : null);
                parameters.Add("@Userid", Convert.ToString(_UserSession.UserId));
                // parameters.Add("@ContactNo", Convert.ToString(Cust.ContactNo));
                //parameters.Add("@ContactNo", Convert.ToString(Cust.ContactNo));

                parameters.Add("@Address2", Convert.ToString(Cust.Address2));
                parameters.Add("@Postcode", Convert.ToString(Cust.Postcode));
                parameters.Add("@State", Convert.ToString(Cust.State));
                parameters.Add("@Country", Convert.ToString(Cust.Country));
                parameters.Add("@ContractPeriodInYears", Convert.ToString(Cust.ContractPeriodInYears));
                // parameters.Add("@TypeOfContractLovId", Convert.ToString(Cust.TypeOfContractLovId));
                parameters.Add("@pContactNo", Convert.ToString(Cust.ContactNo));
                parameters.Add("@pFaxNo", Convert.ToString(Cust.FaxNo));
                parameters.Add("@pRemarks", Convert.ToString(Cust.Remarks));
                parameters.Add("@pLogo", Cust.Base64StringLogo);
                parameters.Add("@pActive", Cust.Active == true ? "true" : "false");

                DataTable custDt = new DataTable();
                custDt.Columns.Add("CustomerContactInfoId", typeof(int));
                custDt.Columns.Add("CustomerId", typeof(int));
                custDt.Columns.Add("Name", typeof(string));
                custDt.Columns.Add("Designation", typeof(string));
                custDt.Columns.Add("ContactNo", typeof(string));
                custDt.Columns.Add("Email", typeof(string));
                custDt.Columns.Add("UserId", typeof(int));
                custDt.Columns.Add("Active", typeof(bool));
                // custDt.Columns.Add("Active", typeof(bool));
                // List<int> MaintaininceFlagList = model.MaintenanceFlag.Split(',').Select(int.Parse).ToList();
                foreach (var cont in Cust.ContactInfoList)
                {
                    custDt.Rows.Add(cont.CustomerContactInfoId, model.CustomerId,
                        cont.Name, cont.Designation,
                        cont.ContactNo, cont.Email,
                        _UserSession.UserId, cont.Active == true ? "true" : "false");
                }
                DataSetparameters.Add("@CustomerContactInfoUDT", custDt);
                DataTable ds = dbAccessDAL.GetDataTable("UspFM_CustomerMst_Save", parameters, DataSetparameters);
                if (ds != null)
                {
                    foreach (DataRow row in ds.Rows)
                    {
                        var CustomerId = Convert.ToInt32(row["CustomerId"]);
                        if (CustomerId != 0)
                        {
                            model.CustomerId = CustomerId;
                            model.HiddenId = Convert.ToString(ds.Rows[0]["GuId"]);
                        }
                        ErrorMessage = Convert.ToString(row["ErrorMessage"]);
                    }

                    // ---inser into mapping DB
                    //----creating individual Models
                    CustomerMstViewModel FEMSCust = new CustomerMstViewModel();
                        FEMSCust = Cust;
                    CustomerMstViewModel BEMSCust = new CustomerMstViewModel();
                        BEMSCust = Cust;

                Log4NetLogger.LogExit(fileName, Cust.Operation, Level.Info.ToString());
                    //-insert into mapping table
                    if (Cust.CustomerId==0)
                {
                    using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ToString()))
                    {
                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.Connection = con;
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.CommandText = "Master_CustomerMst_Save";

                            SqlParameter parameter = new SqlParameter();
                            cmd.Parameters.Add("@CustomerId", SqlDbType.Int).Value = model.CustomerId;

                            // cmd.Parameters.Add(parameter);
                            var da = new SqlDataAdapter();
                            da.SelectCommand = cmd;
                            da.Fill(ds);
                        }
                    }
                }
                    else
                {
                    Blocks Mapping = new Blocks();
                    Mapping = GET_Customar_Mapping_IDS(Cust.CustomerId);
                    FEMSCust.CustomerId = Mapping.FEMS_B_ID;
                    BEMSCust.CustomerId = Mapping.BEMS_B_ID;
                }
                 //   Cust.CustomerId = model.CustomerId;
                    FEMSSave(FEMSCust, out ErrorMessage, model.CustomerId);
                    BEMSSave(BEMSCust, out ErrorMessage, model.CustomerId);

                }


               
                return model;
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
        public void Delete(int CustomerId, out string ErrorMessage)
        {
            Log4NetLogger.LogEntry(fileName, nameof(Delete), Level.Info.ToString());
            try
            {
                ErrorMessage = string.Empty;
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pCustomerId", CustomerId.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_MstCustomer_Delete", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    ErrorMessage = Convert.ToString(dt.Rows[0]["ErrorMessage"]);
                }
                Log4NetLogger.LogExit(fileName, nameof(Delete), Level.Info.ToString());

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
        public bool IsRecordModified(CustomerMstViewModel Customer)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(IsRecordModified), Level.Info.ToString());
                var dbAccessDAL = new DBAccessDAL();
                var recordModifed = false;

                if (Customer.CustomerId != 0)
                {
                    var DataSetparameters = new Dictionary<string, DataTable>();
                    var parameters = new Dictionary<string, string>();
                    parameters.Add("@CustomerId", Customer.CustomerId.ToString());
                    DataTable dt = dbAccessDAL.GetDataTable("UspFM_CustomerMst_GetTimestamp", parameters, DataSetparameters);

                    if (dt != null && dt.Rows.Count > 0)
                    {
                        var timestamp = Convert.ToBase64String((byte[])(dt.Rows[0]["Timestamp"]));
                        if (timestamp != Customer.Timestamp)
                        {
                            recordModifed = true;
                        }
                    }
                }

                Log4NetLogger.LogExit(fileName, nameof(IsRecordModified), Level.Info.ToString());
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
        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(GetAll), Level.Info.ToString());
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

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_MstCustomer_GetAll";

                        cmd.Parameters.AddWithValue("@PageIndex", pageFilter.PageIndex);
                        cmd.Parameters.AddWithValue("@PageSize", pageFilter.PageSize);
                        cmd.Parameters.AddWithValue("@strCondition", pageFilter.QueryWhereCondition);
                        cmd.Parameters.AddWithValue("@strSorting", strOrderBy);

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
                Log4NetLogger.LogExit(fileName, nameof(GetAll), Level.Info.ToString());
                //return userRoles;
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
        public bool IsCustomerCodeDuplicate(CustomerMstViewModel customer)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(IsCustomerCodeDuplicate), Level.Info.ToString());

                var IsDuplicate = true;
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@CustomerId", customer.CustomerId.ToString());
                parameters.Add("@CustomerCode", customer.CustomerCode.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("UspFM_MstCustomer_ValCode", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    IsDuplicate = Convert.ToBoolean(dt.Rows[0]["IsDuplicate"]);
                }
                return IsDuplicate;
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
        public ActiveFacility GetFacilityList(int customerId)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(IsCustomerCodeDuplicate), Level.Info.ToString());
                ActiveFacility obj = new ActiveFacility();
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@CustomerId", customerId.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("UspFM_MstCustomer_FaciltyList", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var list = (from n in dt.AsEnumerable()
                                select new ActiveFacility
                                {
                                    FacilityId = Convert.ToInt32(n["FacilityId"]),
                                    FacilityName = Convert.ToString(n["FacilityName"]),
                                    FacilityCode = Convert.ToString(n["FacilityCode"]),
                                    ActiveFromDate = Convert.ToDateTime(n["ActiveFromDate"]),
                                    ActiveToDate = n.Field<DateTime?>("ActiveToDate"),

                                }).ToList();

                    if (list != null && list.Count > 0)
                    {
                        obj.ActiveFacilityList = list;
                    }
                }
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
        public ReportsAndRecordsList SaveReportsAndRecords(ReportsAndRecordsList ReportsAndRecords, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_MstCustomerReport_Save";

                        SqlParameter parameter = new SqlParameter();

                        if (ReportsAndRecords.ReportsAndRecords != null)
                        {
                            DataTable dataTable = new DataTable("udt_MstCustomerReport");
                            dataTable.Columns.Add("CustomerReportId", typeof(int));
                            dataTable.Columns.Add("CustomerId", typeof(int));
                            dataTable.Columns.Add("ReportName", typeof(string));
                            dataTable.Columns.Add("UserId", typeof(int));
                            dataTable.Columns.Add("IsDeleted", typeof(bool));
                            cmd.Parameters.Add("@pErrorMessage", SqlDbType.NVarChar);
                            cmd.Parameters["@pErrorMessage"].Size = 1000;
                            cmd.Parameters["@pErrorMessage"].Direction = ParameterDirection.Output;

                            foreach (var item in ReportsAndRecords.ReportsAndRecords)
                            {
                                dataTable.Rows.Add(item.CustomerReportId, item.CustomerId, item.ReportName,
                                                    _UserSession.UserId, item.IsDeleted);
                            }

                            parameter.ParameterName = "@pMstCustomerReport";
                            parameter.SqlDbType = SqlDbType.Structured;
                            parameter.Value = dataTable;
                            cmd.Parameters.Add(parameter);
                        }

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                        ErrorMessage = cmd.Parameters["@pErrorMessage"].Value.ToString();
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    ReportsAndRecords.ReportsAndRecords = (from n in ds.Tables[0].AsEnumerable()
                                                           select new ReportRecord
                                                           {
                                                               CustomerReportId = n.Field<int>("CustomerReportId"),
                                                               ReportName = n.Field<string>("ReportName")
                                                           }).ToList();
                }

                Log4NetLogger.LogExit(fileName, nameof(Save), Level.Info.ToString());
                return ReportsAndRecords;
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

        public ReportsAndRecordsList GetReportsAndRecords(int CustomerId)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(GetReportsAndRecords), Level.Info.ToString());
                var reportsAndRecordsList = new ReportsAndRecordsList();

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_MstCustomerReport_GetById";
                        cmd.Parameters.AddWithValue("@pCustomerId", CustomerId);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    reportsAndRecordsList.ReportsAndRecords = (from n in ds.Tables[0].AsEnumerable()
                                                               select new ReportRecord
                                                               {
                                                                   CustomerReportId = n.Field<int>("CustomerReportId"),
                                                                   ReportName = n.Field<string>("ReportName")
                                                               }).ToList();
                }
                Log4NetLogger.LogExit(fileName, nameof(GetReportsAndRecords), Level.Info.ToString());
                return reportsAndRecordsList;
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
        #endregion

        public CustomerMstViewModel FEMSSave(CustomerMstViewModel Cust, out string ErrorMessage,int Master_CustomerId)
        {
            Log4NetLogger.LogEntry(fileName, Cust.Operation, Level.Info.ToString());
            try
            {
                ErrorMessage = string.Empty;
                //byte[] image = null;
                //if (Cust.Base64StringLogo != null)
                //{
                //    image = Encoding.Unicode.GetBytes(Cust.Base64StringLogo);
                //}
                var dbAccessDAL = new MASTERFEMSDBAccessDAL();
                var model = new CustomerMstViewModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@CustomerId", Convert.ToString(Cust.CustomerId));
                parameters.Add("@CustomerName", Convert.ToString(Cust.CustomerName.Trim()));
                parameters.Add("@CustomerCode", Convert.ToString(Cust.CustomerCode));
                parameters.Add("@Address", Convert.ToString(Cust.Address));
                parameters.Add("@Latitude", Convert.ToString(Cust.Latitude));
                parameters.Add("@Longitude", Convert.ToString(Cust.Longitude));
                // parameters.Add("@ActiveFromDate", Cust.ActiveFromDate != null ? Cust.ActiveFromDate.ToString("yyyy-MM-dd") : null);
                // parameters.Add("@ActiveFromDateUTC ", Cust.ActiveFromDateUTC != null ? Cust.ActiveFromDateUTC.ToString("yyyy-MM-dd") : null);
                //parameters.Add("@ActiveToDate", Cust.ActiveToDate != null ? Cust.ActiveToDate.Value.ToString("yyyy-MM-dd") : null);
                // parameters.Add("@ActiveToDateUTC", Cust.ActiveToDateUTC != null ? Cust.ActiveToDateUTC.Value.ToString("yyyy-MM-dd") : null);
                parameters.Add("@Userid", Convert.ToString(_UserSession.UserId));
                // parameters.Add("@ContactNo", Convert.ToString(Cust.ContactNo));
                //parameters.Add("@ContactNo", Convert.ToString(Cust.ContactNo));

                parameters.Add("@Address2", Convert.ToString(Cust.Address2));
                parameters.Add("@Postcode", Convert.ToString(Cust.Postcode));
                parameters.Add("@State", Convert.ToString(Cust.State));
                parameters.Add("@Country", Convert.ToString(Cust.Country));
                parameters.Add("@ContractPeriodInYears", Convert.ToString(Cust.ContractPeriodInYears));
                // parameters.Add("@TypeOfContractLovId", Convert.ToString(Cust.TypeOfContractLovId));
                parameters.Add("@pContactNo", Convert.ToString(Cust.ContactNo));
                parameters.Add("@pFaxNo", Convert.ToString(Cust.FaxNo));
                parameters.Add("@pRemarks", Convert.ToString(Cust.Remarks));
                parameters.Add("@pLogo", Cust.Base64StringLogo);
                parameters.Add("@pActive", Cust.Active == true ? "true" : "false");

                DataTable custDt = new DataTable();
                custDt.Columns.Add("CustomerContactInfoId", typeof(int));
                custDt.Columns.Add("CustomerId", typeof(int));
                custDt.Columns.Add("Name", typeof(string));
                custDt.Columns.Add("Designation", typeof(string));
                custDt.Columns.Add("ContactNo", typeof(string));
                custDt.Columns.Add("Email", typeof(string));
                custDt.Columns.Add("UserId", typeof(int));
                custDt.Columns.Add("Active", typeof(bool));
                // custDt.Columns.Add("Active", typeof(bool));
                // List<int> MaintaininceFlagList = model.MaintenanceFlag.Split(',').Select(int.Parse).ToList();
                foreach (var cont in Cust.ContactInfoList)
                {
                    custDt.Rows.Add(cont.CustomerContactInfoId, model.CustomerId,
                        cont.Name, cont.Designation,
                        cont.ContactNo, cont.Email,
                        _UserSession.UserId, cont.Active == true ? "true" : "false");
                }
                DataSetparameters.Add("@CustomerContactInfoUDT", custDt);
                DataTable ds = dbAccessDAL.GetMasterDataTable("UspFM_CustomerMst_Save", parameters, DataSetparameters);
                if (ds != null)
                {
                    int FEMS_C_ID=0;
                    foreach (DataRow row in ds.Rows)
                    {
                        var CustomerId = Convert.ToInt32(row["CustomerId"]);
                        if (CustomerId != 0)
                        {
                            FEMS_C_ID = CustomerId;
                            model.HiddenId = Convert.ToString(ds.Rows[0]["GuId"]);
                        }
                        ErrorMessage = Convert.ToString(row["ErrorMessage"]);
                    }
                    if (Cust.CustomerId != 0)
                    {

                    }
                    else
                    {
                        Update_Mapping(Master_CustomerId, FEMS_C_ID, 1);
                    }


                }
                Log4NetLogger.LogExit(fileName, Cust.Operation, Level.Info.ToString());
                return model;
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
        public CustomerMstViewModel BEMSSave(CustomerMstViewModel Cust, out string ErrorMessage, int Master_CustomerId)
        {
            Log4NetLogger.LogEntry(fileName, Cust.Operation, Level.Info.ToString());
            try
            {
                ErrorMessage = string.Empty;
                //byte[] image = null;
                //if (Cust.Base64StringLogo != null)
                //{
                //    image = Encoding.Unicode.GetBytes(Cust.Base64StringLogo);
                //}
                var dbAccessDAL = new MASTERBEMSDBAccessDAL();
                var model = new CustomerMstViewModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@CustomerId", Convert.ToString(Cust.CustomerId));
                parameters.Add("@CustomerName", Convert.ToString(Cust.CustomerName.Trim()));
                parameters.Add("@CustomerCode", Convert.ToString(Cust.CustomerCode));
                parameters.Add("@Address", Convert.ToString(Cust.Address));
                parameters.Add("@Latitude", Convert.ToString(Cust.Latitude));
                parameters.Add("@Longitude", Convert.ToString(Cust.Longitude));
                // parameters.Add("@ActiveFromDate", Cust.ActiveFromDate != null ? Cust.ActiveFromDate.ToString("yyyy-MM-dd") : null);
                // parameters.Add("@ActiveFromDateUTC ", Cust.ActiveFromDateUTC != null ? Cust.ActiveFromDateUTC.ToString("yyyy-MM-dd") : null);
                //parameters.Add("@ActiveToDate", Cust.ActiveToDate != null ? Cust.ActiveToDate.Value.ToString("yyyy-MM-dd") : null);
                // parameters.Add("@ActiveToDateUTC", Cust.ActiveToDateUTC != null ? Cust.ActiveToDateUTC.Value.ToString("yyyy-MM-dd") : null);
                parameters.Add("@Userid", Convert.ToString(_UserSession.UserId));
                // parameters.Add("@ContactNo", Convert.ToString(Cust.ContactNo));
                //parameters.Add("@ContactNo", Convert.ToString(Cust.ContactNo));

                parameters.Add("@Address2", Convert.ToString(Cust.Address2));
                parameters.Add("@Postcode", Convert.ToString(Cust.Postcode));
                parameters.Add("@State", Convert.ToString(Cust.State));
                parameters.Add("@Country", Convert.ToString(Cust.Country));
                parameters.Add("@ContractPeriodInYears", Convert.ToString(Cust.ContractPeriodInYears));
                // parameters.Add("@TypeOfContractLovId", Convert.ToString(Cust.TypeOfContractLovId));
                parameters.Add("@pContactNo", Convert.ToString(Cust.ContactNo));
                parameters.Add("@pFaxNo", Convert.ToString(Cust.FaxNo));
                parameters.Add("@pRemarks", Convert.ToString(Cust.Remarks));
                parameters.Add("@pLogo", Cust.Base64StringLogo);
                parameters.Add("@pActive", Cust.Active == true ? "true" : "false");

                DataTable custDt = new DataTable();
                custDt.Columns.Add("CustomerContactInfoId", typeof(int));
                custDt.Columns.Add("CustomerId", typeof(int));
                custDt.Columns.Add("Name", typeof(string));
                custDt.Columns.Add("Designation", typeof(string));
                custDt.Columns.Add("ContactNo", typeof(string));
                custDt.Columns.Add("Email", typeof(string));
                custDt.Columns.Add("UserId", typeof(int));
                custDt.Columns.Add("Active", typeof(bool));
                // custDt.Columns.Add("Active", typeof(bool));
                // List<int> MaintaininceFlagList = model.MaintenanceFlag.Split(',').Select(int.Parse).ToList();
                foreach (var cont in Cust.ContactInfoList)
                {
                    custDt.Rows.Add(cont.CustomerContactInfoId, model.CustomerId,
                        cont.Name, cont.Designation,
                        cont.ContactNo, cont.Email,
                        _UserSession.UserId, cont.Active == true ? "true" : "false");
                }
                DataSetparameters.Add("@CustomerContactInfoUDT", custDt);
                DataTable ds = dbAccessDAL.GetMasterDataTable("UspFM_CustomerMst_Save", parameters, DataSetparameters);
                if (ds != null)
                {
                    int BEMS_C_ID = 0;
                    foreach (DataRow row in ds.Rows)
                    {
                        var CustomerId = Convert.ToInt32(row["CustomerId"]);
                        if (CustomerId != 0)
                        {
                            BEMS_C_ID = CustomerId;
                            model.HiddenId = Convert.ToString(ds.Rows[0]["GuId"]);
                        }
                        ErrorMessage = Convert.ToString(row["ErrorMessage"]);
                    }
                    if (Cust.CustomerId != 0)
                    {

                    }
                    else
                    {
                        Update_Mapping(Master_CustomerId, BEMS_C_ID, 2);
                    }


                }
                Log4NetLogger.LogExit(fileName, Cust.Operation, Level.Info.ToString());
                return model;
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

        public int GetFEMS(int CustomerId)
        {
            Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
            try
            {
                int result = 0;
                var dbAccessDAL = new MASTERFEMSDBAccessDAL();
                var custObj = new CustomerMstViewModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@CustomerId", CustomerId.ToString());
                DataSet ds = dbAccessDAL.GetDataSet("UspFM_CustomerMst_Get", parameters, DataSetparameters);
                if (ds != null && ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                {
                    foreach (DataRow row in ds.Tables[0].Rows)
                    {
                        result = Convert.ToInt32(row["CustomerId"]);
                       // result = 1;
                    }
             }
                Log4NetLogger.LogExit(fileName, nameof(Get), Level.Info.ToString());
                return result; ;

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
        public int GetBEMS(int CustomerId)
        {
            Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
            try
            {
                int result = 0;
                var dbAccessDAL = new MASTERBEMSDBAccessDAL();
                var custObj = new CustomerMstViewModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@CustomerId", CustomerId.ToString());
                DataSet ds = dbAccessDAL.GetDataSet("UspFM_CustomerMst_Get", parameters, DataSetparameters);
                if (ds != null && ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                {
                    foreach (DataRow row in ds.Tables[0].Rows)
                    {
                        result = Convert.ToInt32(row["CustomerId"]);
                        // result = 1;
                    }
                }
                Log4NetLogger.LogExit(fileName, nameof(Get), Level.Info.ToString());
                return result; ;

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
        public static string RandomString(int length)
        {
            const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            return new string(Enumerable.Repeat(chars, length)
              .Select(s => s[random.Next(s.Length)]).ToArray());
        }
        public void Update_Mapping(int Master_CustomerID, int Module_ID, int Module_Type)
        {
            try
            {
                var ds = new DataSet();
                // inserting into Master DB
                var dbAccessDAL = new MASTERDBAccessDAL();
                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ToString()))//
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Master_Update_Customer_All";

                        SqlParameter parameter = new SqlParameter();
                        cmd.Parameters.Add("@CustomerId", SqlDbType.Int).Value = Master_CustomerID;
                        cmd.Parameters.Add("@Module_ID", SqlDbType.Int).Value = Module_ID;
                        cmd.Parameters.Add("@Module_Type", SqlDbType.Int).Value = Module_Type;
                        // cmd.Parameters.Add(parameter);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
            }
            catch (Exception)
            {

                throw;
            }


        }
        public Blocks GET_Customar_Mapping_IDS(int Customar_Mapping_IDS)
        {
            ///-------------Get Modules FEMS OR BEMS Block IDS to update
            ///

            Blocks Blok_get = new Blocks();
            var dss = new DataSet();
            var MasterdbAccessDAL = new MASTERDBAccessDAL();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ToString()))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = con;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "Get_Services_byCustomerId";
                    cmd.Parameters.AddWithValue("@CustomerId", Customar_Mapping_IDS);
                    var da = new SqlDataAdapter();
                    da.SelectCommand = cmd;
                    da.Fill(dss);
                }
            }
            if (dss.Tables.Count != 0)
            {

                Blok_get.FEMS_B_ID = Convert.ToInt32(dss.Tables[0].Rows[0]["FEMS_ID"]);
                Blok_get.BEMS_B_ID = Convert.ToInt32(dss.Tables[0].Rows[0]["BEMS_ID"]);
            }
            // Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
            return Blok_get;
        }
        public List<CustomerMstViewModel> customerslists()
        {
            List<CustomerMstViewModel> allcustomerMstViewModelss = new List<CustomerMstViewModel>();
          //  allcustomerMstViewModelss = null;




            return allcustomerMstViewModelss;
        }

    }
}

