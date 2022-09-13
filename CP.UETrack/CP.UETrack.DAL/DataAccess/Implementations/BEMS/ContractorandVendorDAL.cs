using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using UETrack.DAL;

namespace CP.UETrack.DAL.DataAccess.Implementations.BEMS
{
    public class ContractorandVendorDAL : IContractorandVendorDAL
    {
        private readonly string _FileName = nameof(AccountDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public ContractorandVendorDAL()
        {

        }
        public ContractorandVendorLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                ContractorandVendorLovs contractorandVendorLovs = null;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "UspBEMS_MstContractorandVendor_GetLovs";
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0)
                {
                    contractorandVendorLovs = new ContractorandVendorLovs();
                    contractorandVendorLovs.StatusList = dbAccessDAL.GetLovRecords(ds.Tables[0]);

                    if (ds.Tables[1] != null && ds.Tables[1].Rows.Count > 0)
                        contractorandVendorLovs.SpecializationList = dbAccessDAL.GetMultiSelectDDRecords(ds.Tables[1]);
                    if (ds.Tables[2] != null && ds.Tables[2].Rows.Count > 0)
                        contractorandVendorLovs.CountryList = dbAccessDAL.GetLovRecords(ds.Tables[2]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return contractorandVendorLovs;
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
        public MstContractorandVendorViewModel Get(int ContractorId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var obj = new MstContractorandVendorViewModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@ContractorId", ContractorId.ToString());
                DataSet ds = dbAccessDAL.GetDataSet("UspBEMS_MstContractorandVendor_Get", parameters, DataSetparameters);
                if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                {
                    obj.ContractorId = Convert.ToInt16(ds.Tables[0].Rows[0]["ContractorId"]);
                    obj.SSMRegistrationCode = Convert.ToString(ds.Tables[0].Rows[0]["SSMRegistrationCode"]);
                    obj.ContractorName = Convert.ToString(ds.Tables[0].Rows[0]["ContractorName"]);
                    obj.SpecializationValues = Convert.ToString(ds.Tables[0].Rows[0]["Specialization"]);
                    obj.Address = ds.Tables[0].Rows[0]["Address"].ToString();
                    obj.State = Convert.ToString(ds.Tables[0].Rows[0]["State"]);   
                    obj.FaxNo = Convert.ToString(ds.Tables[0].Rows[0]["FaxNo"]);
                    obj.Remarks = Convert.ToString(ds.Tables[0].Rows[0]["Remarks"]);
                    obj.ContactNo = ds.Tables[0].Rows[0]["ContactNo"].ToString();
                    obj.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                    obj.Active = Convert.ToBoolean(ds.Tables[0].Rows[0]["Active"]);
                    obj.Address2 = Convert.ToString( ds.Tables[0].Rows[0]["Address2"]);
                    obj.Postcode = Convert.ToString(ds.Tables[0].Rows[0]["Postcode"]);
                   // obj.Country = Convert.ToString(ds.Tables[0].Rows[0]["Country"]);
                    obj.CountryId = Convert.ToInt32(ds.Tables[0].Rows[0]["CountryId"]);
                    obj.NoOfUserAccess = ds.Tables[0].Rows[0]["NoOfUserAccess"] != DBNull.Value ? Convert.ToInt32(ds.Tables[0].Rows[0]["NoOfUserAccess"]) : (int?)null;
                    obj.HiddenId = Convert.ToString(ds.Tables[0].Rows[0]["GuId"]);
                    if (!string.IsNullOrEmpty(obj.SpecializationValues))
                    {
                        obj.Specialization = obj.SpecializationValues.Split(',').Select(int.Parse).ToList();
                    }
                }
                if (ds != null && ds.Tables[1] != null && ds.Tables[1].Rows.Count > 0)
                {
                    var contactInfoList = (from n in ds.Tables[1].AsEnumerable()
                                           select new MstContractorandVendorContactInfo
                                           {
                                               ContractorContactInfoId = Convert.ToInt32(n["ContractorContactInfoId"]),
                                               Name = Convert.ToString(n["Name"]),
                                               Designation = Convert.ToString(n["Designation"]),
                                               ContactNo = Convert.ToString(n["ContactNo"]),
                                               Email = Convert.ToString(n["Email"]),
                                               Active = true
                                           }).ToList();

                    if (contactInfoList != null && contactInfoList.Count > 0)
                    {
                        obj.ContactInfoList = contactInfoList;
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
        public MstContractorandVendorViewModel SaveUpdate(MstContractorandVendorViewModel contractor)
        {
            Log4NetLogger.LogEntry(_FileName, contractor.Operation, Level.Info.ToString());
            try
            {
                string specialsatiovalies = string.Empty;
                if (contractor.Specialization != null && contractor.Specialization.Count > 0)
                {
                    specialsatiovalies = string.Join(",", contractor.Specialization.Select(i => i.ToString()).ToArray());
                }
                var dbAccessDAL = new DBAccessDAL();
                var BEMSdbAccessDAL = new MASTERBEMSDBAccessDAL();
                var FEMSdbAccessDAL = new MASTERFEMSDBAccessDAL();
                var model = new MstContractorandVendorViewModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@ContractorId", Convert.ToString(contractor.ContractorId));
                parameters.Add("@CustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@SSMRegistrationCode", Convert.ToString(contractor.SSMRegistrationCode));
                parameters.Add("@ContractorName", Convert.ToString(contractor.ContractorName));
                //  parameters.Add("@ContractorStatus", Convert.ToString(contractor.ContractorStatus));
                parameters.Add("@Active", contractor.Active == true ? "true" : "false");
                parameters.Add("@Specialization", Convert.ToString(specialsatiovalies));
                parameters.Add("@Address", Convert.ToString(contractor.Address));
                parameters.Add("@State", Convert.ToString(contractor.State));
   
                parameters.Add("@FaxNo", Convert.ToString(contractor.FaxNo));
                parameters.Add("@Remarks", Convert.ToString(contractor.Remarks));
                parameters.Add("@UserId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@Address2", Convert.ToString(contractor.Address2));
                parameters.Add("@Postcode", Convert.ToString(contractor.Postcode));
                parameters.Add("@Country", Convert.ToString(contractor.CountryId));
                parameters.Add("@NoOfUserAccess", Convert.ToString(contractor.NoOfUserAccess));
                parameters.Add("@pContactNo", Convert.ToString(contractor.ContactNo));
                DataTable custDt = new DataTable();
                custDt.Columns.Add("ContractorContactInfoId", typeof(int));
                custDt.Columns.Add("ContractorId", typeof(int));
                custDt.Columns.Add("Name", typeof(string));
                custDt.Columns.Add("Designation", typeof(string));
                custDt.Columns.Add("ContactNo", typeof(string));
                custDt.Columns.Add("Email", typeof(string));
                custDt.Columns.Add("Active", typeof(bool));
                // custDt.Columns.Add("Active", typeof(bool));
                // List<int> MaintaininceFlagList = model.MaintenanceFlag.Split(',').Select(int.Parse).ToList();
                foreach (var cont in contractor.ContactInfoList)
                {
                    custDt.Rows.Add(cont.ContractorContactInfoId, contractor.ContractorId,
                        cont.Name, cont.Designation,
                        cont.ContactNo, cont.Email, cont.Active == true ? "true" : "false"
                    );
                }
                DataSetparameters.Add("@ContractorContactInfoUDT", custDt);
                DataTable ds = dbAccessDAL.GetDataTable("UspBEMS_MstContractorandVendor_Save", parameters, DataSetparameters);
                if (ds != null)
                {
                    foreach (DataRow row in ds.Rows)
                    {
                        model.ContractorId = Convert.ToInt32(row["ContractorId"]);
                        model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                      
                    }
                    model.HiddenId = Convert.ToString(ds.Rows[0]["GuId"]);
                }

                DataTable ds1 = BEMSdbAccessDAL.GetMasterDataTable("UspBEMS_MstContractorandVendor_Save", parameters, DataSetparameters);
                if (ds1 != null)
                {
                    foreach (DataRow row in ds.Rows)
                    {
                        model.ContractorId = Convert.ToInt32(row["ContractorId"]);
                        model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));

                    }
                    model.HiddenId = Convert.ToString(ds.Rows[0]["GuId"]);
                }

                DataTable ds2 = FEMSdbAccessDAL.GetMasterDataTable("UspBEMS_MstContractorandVendor_Save", parameters, DataSetparameters);
                if (ds2 != null)
                {
                    foreach (DataRow row in ds.Rows)
                    {
                        model.ContractorId = Convert.ToInt32(row["ContractorId"]);
                        model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));

                    }
                    model.HiddenId = Convert.ToString(ds.Rows[0]["GuId"]);
                }

                Log4NetLogger.LogExit(_FileName, contractor.Operation, Level.Info.ToString());
                return model;
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
        public void Delete(int ContractorId, out string ErrorMessage)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            try
            {
                ErrorMessage = string.Empty;
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pContractorId", ContractorId.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_MstContractorandVendor_Delete", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    ErrorMessage = Convert.ToString(dt.Rows[0]["ErrorMessage"]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(Delete), Level.Info.ToString());

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

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();

                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@PageIndex", pageFilter.PageIndex.ToString());
                parameters.Add("@PageSize", pageFilter.PageSize.ToString());
                parameters.Add("@strCondition", pageFilter.QueryWhereCondition);
                parameters.Add("@strSorting", strOrderBy);
                DataTable dt = dbAccessDAL.GetDataTable("UspBEMS_MstContractorandVendor_GetAll", parameters, DataSetparameters);

                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var totalPages = (int)Math.Ceiling((float)totalRecords / (float)pageFilter.Rows);

                    var commonDAL = new CommonDAL();
                    var currentPageList = commonDAL.ToDynamicList(dt);
                    filterResult = new GridFilterResult
                    {
                        TotalRecords = totalRecords,
                        TotalPages = totalPages,
                        RecordsList = currentPageList,
                        CurrentPage = pageFilter.Page
                    };
                }
                Log4NetLogger.LogExit(_FileName, nameof(GetAll), Level.Info.ToString());
                //return userRoles;
                return filterResult;
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
        public bool IsContractorRegCodeDuplicate(MstContractorandVendorViewModel model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsContractorRegCodeDuplicate), Level.Info.ToString());

                var IsDuplicate = true;
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@ContractorId", model.ContractorId.ToString());
                parameters.Add("@SSMRegistrationCode", model.SSMRegistrationCode.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("UspFM_MstContractorandVendor_ValCode", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    IsDuplicate = Convert.ToBoolean(dt.Rows[0]["IsDuplicate"]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(IsContractorRegCodeDuplicate), Level.Info.ToString());
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
        public bool IsRecordModified(MstContractorandVendorViewModel model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsRecordModified), Level.Info.ToString());
                var dbAccessDAL = new DBAccessDAL();
                var recordModifed = false;

                if (model.ContractorId != 0)
                {
                    var DataSetparameters = new Dictionary<string, DataTable>();
                    var parameters = new Dictionary<string, string>();
                    parameters.Add("@ContractorId", model.ContractorId.ToString());
                    DataTable dt = dbAccessDAL.GetDataTable("UspFM_MstContractorandVendor_GetTimestamp", parameters, DataSetparameters);

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

    }
}
