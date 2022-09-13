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
using UETrack.DAL;

namespace CP.UETrack.DAL.DataAccess.Implementations.BEMS
{
    public class FacilityDAL : IFacilityDAL
    {
        private readonly static string fileName = nameof(CustomerDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
         Blocks facility = new Blocks();
        #region Data Access Methods

        public FacilityLovs Load()
        {
            Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());
                FacilityLovs facility = new FacilityLovs();
                string lovs = "TypeOfContractValue,EquipmentFunctionDescriptionValue";
                var dbAccessDAL = new DBAccessDAL();
                var obj = new EngAssetClassification();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pLovKey", lovs);
                DataSet ds = dbAccessDAL.GetDataSet("uspFM_Dropdown", parameters, DataSetparameters);
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    facility.TypeofNomenclatureLovs = dbAccessDAL.GetLovRecords(ds.Tables[0], "EquipmentFunctionDescriptionValue");
                    facility.TypeofContractLovs = dbAccessDAL.GetLovRecords(ds.Tables[0], "TypeOfContractValue");

                }
                var DataSetparameters1 = new Dictionary<string, DataTable>();
                var parameters1 = new Dictionary<string, string>();

                var customerId = _UserSession.CustomerId;

                var lovkey = customerId.ToString();

                parameters1.Add("@pLovKey", lovkey);
                parameters1.Add("@pTableName", "MstLocationFacilityLovs");
                DataSet ds1 = dbAccessDAL.GetDataSet("uspFM_Dropdown_Others", parameters1, DataSetparameters1);
                if (ds1 != null && ds1.Tables[0] != null && ds1.Tables[0].Rows.Count > 0)
                {
                    facility.Customers = (from n in ds1.Tables[0].AsEnumerable()
                                          select new CustomerLovs
                                          {
                                              CustomerId = n.Field<int>("CustomerId"),
                                              CustomerName = n.Field<string>("CustomerName"),
                                              CustomerCode = n.Field<string>("CustomerCode")
                                          }).ToList();
                    //facility.CustomerId = Convert.ToInt16(ds1.Tables[0].Rows[0]["CustomerId"]);
                    //facility.CustomerName = Convert.ToString(ds1.Tables[0].Rows[0]["CustomerName"]);
                    //facility.CustomerCode = Convert.ToString(ds1.Tables[0].Rows[0]["CustomerCode"]);

                }
               // Check_Cross_data();
                Log4NetLogger.LogExit(fileName, nameof(Load), Level.Info.ToString());
                return facility;
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


        public MstLocationFacilityViewModel Get(int facilityId)
        {
            Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var facilityObj = new MstLocationFacilityViewModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@FacilityId", facilityId.ToString());
                parameters.Add("@Operation", "Get");
                DataSet ds = dbAccessDAL.GetDataSet("UspFM_MstLocationFacility_Get", parameters, DataSetparameters);
                if (ds != null && ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                {
                    facilityObj.FacilityId = Convert.ToInt16(ds.Tables[0].Rows[0]["FacilityId"]);
                    facilityObj.CustomerId = Convert.ToInt16(ds.Tables[0].Rows[0]["CustomerId"]);
                    facilityObj.CustomerName = Convert.ToString(ds.Tables[0].Rows[0]["CustomerName"]);
                    facilityObj.CustomerCode = Convert.ToString(ds.Tables[0].Rows[0]["CustomerCode"]);
                    facilityObj.FacilityName = ds.Tables[0].Rows[0]["FacilityName"].ToString();
                    facilityObj.FacilityCode = ds.Tables[0].Rows[0]["FacilityCode"].ToString();
                    facilityObj.Address = ds.Tables[0].Rows[0]["Address"].ToString();
                    facilityObj.Latitude = Convert.ToDecimal(ds.Tables[0].Rows[0]["Latitude"]);
                    facilityObj.Longitude = Convert.ToDecimal(ds.Tables[0].Rows[0]["Longitude"]);
                    facilityObj.ActiveFrom = ds.Tables[0].Rows[0]["ActiveFrom"] != DBNull.Value ? (Convert.ToDateTime(ds.Tables[0].Rows[0]["ActiveFrom"])) : (DateTime?)null;
                    facilityObj.ActiveFromUTC = ds.Tables[0].Rows[0]["ActiveFromUTC"] != DBNull.Value ? (Convert.ToDateTime(ds.Tables[0].Rows[0]["ActiveFromUTC"])) : (DateTime?)null;
                    facilityObj.ActiveTo = ds.Tables[0].Rows[0]["ActiveTo"] != DBNull.Value ? (Convert.ToDateTime(ds.Tables[0].Rows[0]["ActiveTo"])) : (DateTime?)null;
                    facilityObj.ActiveToUTC = ds.Tables[0].Rows[0]["ActiveToUTC"] != DBNull.Value ? (Convert.ToDateTime(ds.Tables[0].Rows[0]["ActiveToUTC"])) : (DateTime?)null;
                    facilityObj.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                    facilityObj.Address2 = ds.Tables[0].Rows[0]["Address2"].ToString();
                    facilityObj.Postcode = ds.Tables[0].Rows[0]["Postcode"].ToString();
                    facilityObj.State = ds.Tables[0].Rows[0]["State"].ToString();
                    facilityObj.Country = ds.Tables[0].Rows[0]["Country"].ToString();
                    facilityObj.ContactNo = ds.Tables[0].Rows[0]["ContactNo"].ToString();
                    facilityObj.FaxNo = ds.Tables[0].Rows[0]["FaxNo"].ToString();
                    facilityObj.ContractPeriodInYears = Convert.ToInt32(ds.Tables[0].Rows[0]["ContractPeriodInMonths"]);
                    facilityObj.IsContractPeriodChanged = ds.Tables[0].Rows[0]["IsContractPeriodChanged"] != DBNull.Value ? (Convert.ToInt16(ds.Tables[0].Rows[0]["IsContractPeriodChanged"])) : (int?)null;
                    facilityObj.InitialProjectCost = ds.Tables[0].Rows[0]["InitialProjectCost"] != DBNull.Value ? (Convert.ToDecimal(ds.Tables[0].Rows[0]["InitialProjectCost"])) : (Decimal?)null;
                    facilityObj.WeeklyHolidayValues = ds.Tables[0].Rows[0]["WeeklyHoliday"].ToString();
                    facilityObj.WarrantyRenewalNoticeDays = ds.Tables[0].Rows[0]["WarrantyRenewalNoticeDays"] != DBNull.Value ? (Convert.ToInt16(ds.Tables[0].Rows[0]["WarrantyRenewalNoticeDays"])) : (int?)null;
                    facilityObj.MonthlyServiceFee = ds.Tables[0].Rows[0]["MonthlyServiceFee"] != DBNull.Value ? (Convert.ToDecimal(ds.Tables[0].Rows[0]["MonthlyServiceFee"])) : (Decimal?)null;
                    facilityObj.HWMS= Convert.ToInt16(ds.Tables[0].Rows[0]["HWMS"]);
                    facilityObj.CLS = Convert.ToInt16(ds.Tables[0].Rows[0]["CLS"]);
                    facilityObj.LLS = Convert.ToInt16(ds.Tables[0].Rows[0]["LLS"]);
                    facilityObj.BEMS = Convert.ToInt16(ds.Tables[0].Rows[0]["BEMS"]);
                    facilityObj.FEMS = Convert.ToInt16(ds.Tables[0].Rows[0]["FEMS"]);
                    if (!string.IsNullOrEmpty(facilityObj.WeeklyHolidayValues))
                    {
                        facilityObj.WeeklyHolidays = facilityObj.WeeklyHolidayValues.Split(',').Select(int.Parse).ToList();
                    }
                    //facilityObj.LifeExpectancy = ds.Tables[0].Rows[0]["LifeExpectancy"] != DBNull.Value ? (Convert.ToInt16(ds.Tables[0].Rows[0]["LifeExpectancy"])) : (int?)null;
                    facilityObj.TypeOfNomenclature = ds.Tables[0].Rows[0]["TypeOfNomenclature"] != DBNull.Value ? (Convert.ToInt16(ds.Tables[0].Rows[0]["TypeOfNomenclature"])) : (int?)null;

                    facilityObj.Base64StringLogo = ds.Tables[0].Rows[0]["Logo"] != DBNull.Value ? (Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Logo"]))) : null;

                }
                facilityObj.HiddenId = Convert.ToString(ds.Tables[0].Rows[0]["GuId"]);
                if (ds != null && ds.Tables[1] != null && ds.Tables[1].Rows.Count > 0)
                {
                    var contactInfoList = (from n in ds.Tables[1].AsEnumerable()
                                           select new MstLocationFacilityContactInfo
                                           {
                                               FacilityContactInfoId = Convert.ToInt32(n["FacilityContactInfoId"]),
                                               Name = Convert.ToString(n["Name"]),
                                               Designation = Convert.ToString(n["Designation"]),
                                               ContactNo = Convert.ToString(n["ContactNo"]),
                                               Email = Convert.ToString(n["Email"]),
                                               Active = true
                                           }).ToList();

                    if (contactInfoList != null && contactInfoList.Count > 0)
                    {
                        facilityObj.ContactInfoList = contactInfoList;

                    }
                }
                Log4NetLogger.LogExit(fileName, nameof(Get), Level.Info.ToString());
                return facilityObj;

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
        public MstLocationFacilityViewModel Save(MstLocationFacilityViewModel facility)
        {
            int facilityid = 0;
            Blocks FacilitysIDSMapping=  Check_Cross_data(facility.CustomerId);
            Log4NetLogger.LogEntry(fileName, nameof(Save), Level.Info.ToString());
            try
            {
                facility.ActiveTo = ((DateTime)facility.ActiveFrom).AddMonths(facility.ContractPeriodInYears);
                var isSaveMode = facility.FacilityId == 0 ? true : false; 

                string specialsatiovalies = string.Empty;
                if (facility.WeeklyHolidays != null && facility.WeeklyHolidays.Count > 0)
                {
                    specialsatiovalies = string.Join(",", facility.WeeklyHolidays.Select(i => i.ToString()).ToArray());
                }
                //temporary customer value 
                if (facility.ContractPeriodInYears > 0 && facility.InitialProjectCost > 0)
                {
                    var msf = (facility.InitialProjectCost / Convert.ToInt16(facility.ContractPeriodInYears));
                    facility.MonthlyServiceFee = Math.Round(Convert.ToDecimal(msf), 2);
                }
                var dbAccessDAL = new DBAccessDAL();
                var model = new MstLocationFacilityViewModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@FacilityId", Convert.ToString(facility.FacilityId));
                parameters.Add("@CustomerId", Convert.ToString(facility.CustomerId));
                parameters.Add("@FacilityName", Convert.ToString(facility.FacilityName));
                parameters.Add("@FacilityCode", Convert.ToString(facility.FacilityCode));
                parameters.Add("@Address", Convert.ToString(facility.Address));
                parameters.Add("@Latitude", Convert.ToString(facility.Latitude));
                parameters.Add("@Longitude", Convert.ToString(facility.Longitude));
                parameters.Add("@ActiveFrom", facility.ActiveFrom != null ? facility.ActiveFrom.Value.ToString("yyyy-MM-dd") : null);
                parameters.Add("@ActiveFromUTC ", facility.ActiveFromUTC != null ? facility.ActiveFromUTC.Value.ToString("yyyy-MM-dd") : null);
                parameters.Add("@ActiveTo", facility.ActiveTo != null ? facility.ActiveTo.Value.ToString("yyyy-MM-dd") : null);
                parameters.Add("@ActiveToUTC", facility.ActiveToUTC != null ? facility.ActiveToUTC.Value.ToString("yyyy-MM-dd") : null);
                parameters.Add("@UserID", Convert.ToString(_UserSession.UserId));

                parameters.Add("@Address2", Convert.ToString(facility.Address2));
                parameters.Add("@Postcode", Convert.ToString(facility.Postcode));
                parameters.Add("@State", Convert.ToString(facility.State));
                parameters.Add("@Country", Convert.ToString(facility.Country));
                parameters.Add("@ContractPeriodInMonths", Convert.ToString(facility.ContractPeriodInYears));
                parameters.Add("@pInitialProjectCost", Convert.ToString(facility.InitialProjectCost));
                parameters.Add("@MonthlyServiceFee", Convert.ToString(facility.MonthlyServiceFee != null ? facility.MonthlyServiceFee : null));
                parameters.Add("@WeeklyHoliday", Convert.ToString(specialsatiovalies));
                // parameters.Add("@LifeExpectancy", Convert.ToString(facility.LifeExpectancy));
                parameters.Add("@TypeOfNomenclature", Convert.ToString(facility.TypeOfNomenclature));

                parameters.Add("@pLogo", facility.Base64StringLogo);
                parameters.Add("@pContactNo", Convert.ToString(facility.ContactNo));
                parameters.Add("@pFaxNo", Convert.ToString(facility.FaxNo));
                parameters.Add("@pWarrantyRenewalNoticeDays", Convert.ToString(facility.WarrantyRenewalNoticeDays));
                parameters.Add("@FEMS", facility.FEMS.ToString());
                parameters.Add("@BEMS", facility.BEMS.ToString());
                parameters.Add("@CLS", facility.CLS.ToString());
                parameters.Add("@LLS", facility.LLS.ToString());
                parameters.Add("@HWMS", facility.HWMS.ToString());
                DataTable tempDT = new DataTable();
                tempDT.Columns.Add("FacilityContactInfoId", typeof(int));
                tempDT.Columns.Add("CustomerId", typeof(int));
                tempDT.Columns.Add("FacilityId", typeof(int));
                tempDT.Columns.Add("Name", typeof(string));
                tempDT.Columns.Add("Designation", typeof(string));
                tempDT.Columns.Add("ContactNo", typeof(string));
                tempDT.Columns.Add("Email", typeof(string));
                tempDT.Columns.Add("UserId", typeof(int));
                tempDT.Columns.Add("Active", typeof(bool));
                // custDt.Columns.Add("Active", typeof(bool));
                // List<int> MaintaininceFlagList = model.MaintenanceFlag.Split(',').Select(int.Parse).ToList();
                foreach (var cont in facility.ContactInfoList)
                {
                    tempDT.Rows.Add(cont.FacilityContactInfoId, facility.CustomerId, cont.FacilityId,
                        cont.Name, cont.Designation,
                        cont.ContactNo, cont.Email,
                        _UserSession.UserId, cont.Active == true ? "true" : "false");
                }
                DataSetparameters.Add("@ContactInfoUDT", tempDT);
                //-----------chec insert or update------/


                //--------------update-----------------/
                DataTable ds = dbAccessDAL.GetDataTable("UspFM_MstLocationFacility_Save", parameters, DataSetparameters);
                if (ds != null)
                {
                    foreach (DataRow row in ds.Rows)
                    {
                       model.FacilityId = Convert.ToInt32(row["FacilityId"]);
                        facilityid= Convert.ToInt32(row["FacilityId"]);
                        model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    }
                    model.HiddenId = Convert.ToString(ds.Rows[0]["GuId"]);
                    if (isSaveMode)
                    {
                        model.IsContractPeriodChanged = 3; // temp value to show that the value is binded at save time, not in update 
                    }

                }
                //Check_Cross_data(model.FacilityId);
                if (facility.FEMS == 1)
                {
                    facility.CustomerId = FacilitysIDSMapping.FEMS_B_ID;
                    FEMSSave(facility, facilityid);
                }
               if (facility.BEMS == 1)                    
                {
                    facility.CustomerId = FacilitysIDSMapping.BEMS_B_ID;
                    BEMSSave(facility, facilityid);
                }
                model.FacilityId = facilityid;
                    Log4NetLogger.LogExit(fileName, nameof(Save), Level.Info.ToString());
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

     
        public FacilityVariation AddVariation(FacilityVariation obj)
        {
            Log4NetLogger.LogEntry(fileName, nameof(Save), Level.Info.ToString());
            try
            {

                //temporary customer value 

                var dbAccessDAL = new DBAccessDAL();
                var model = new FacilityVariation();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pFacilityId", Convert.ToString(obj.FacilityId));

                DataTable ds = dbAccessDAL.GetDataTable("uspFM_VmVariationTxnVVFReCalc_GetAll", parameters, DataSetparameters);
                if (ds != null && ds.Rows.Count > 0)
                {                    
                    model.varationAssetCount = Convert.ToInt32(ds.Rows[0]["varationAssetCount"]);
                  //  model.Timestamp = Convert.ToBase64String((byte[])(ds.Rows[0]["Timestamp"]));                    
                }
                model.FacilityId = obj.FacilityId;
                Log4NetLogger.LogExit(fileName, nameof(Save), Level.Info.ToString());
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



        public void Delete(int FacilityId, out string ErrorMessage)
        {
            Log4NetLogger.LogEntry(fileName, nameof(Delete), Level.Info.ToString());
            try
            {
                ErrorMessage = string.Empty;
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pFacilityId", FacilityId.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("UspFM_MstLocationFacility_Delete", parameters, DataSetparameters);
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

        public bool IsRecordModified(MstLocationFacilityViewModel facility)
        {
            try
            {

                Log4NetLogger.LogEntry(fileName, nameof(IsRecordModified), Level.Info.ToString());
                var dbAccessDAL = new DBAccessDAL();
                var recordModifed = false;

                if (facility.FacilityId != 0)
                {

                    var DataSetparameters = new Dictionary<string, DataTable>();
                    var parameters = new Dictionary<string, string>();
                    parameters.Add("@FacilityId", facility.FacilityId.ToString());
                    parameters.Add("@Operation", "GetTimestamp");
                    DataTable dt = dbAccessDAL.GetDataTable("UspFM_MstLocationFacility_Get", parameters, DataSetparameters);

                    if (dt != null && dt.Rows.Count > 0)
                    {
                        var timestamp = Convert.ToBase64String((byte[])(dt.Rows[0]["Timestamp"]));
                        if (timestamp != facility.Timestamp)
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
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@PageIndex", pageFilter.PageIndex.ToString());
                parameters.Add("@PageSize", pageFilter.PageSize.ToString());
                parameters.Add("@strCondition", pageFilter.QueryWhereCondition);
                parameters.Add("@strSorting", strOrderBy);
                DataTable dt = dbAccessDAL.GetDataTable("UspFM_MstLocationFacility_GetAll", parameters, DataSetparameters);

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
                Log4NetLogger.LogExit(fileName, nameof(GetAll), Level.Info.ToString());
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
        public bool IsFacilityCodeDuplicate(MstLocationFacilityViewModel facility)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(IsFacilityCodeDuplicate), Level.Info.ToString());

                var IsDuplicate = true;
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@FacilityId", facility.FacilityId.ToString());
                parameters.Add("@FacilityCode", facility.FacilityCode.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("UspFM_MstLocationFacility_ValCode", parameters, DataSetparameters);
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
        #endregion
        public Blocks Check_Cross_data(int Customer_ids)
        {
            Blocks facilitys = new Blocks();
            var dbAccessDAL = new DBAccessDAL();
            DataTable dts = new DataTable();
            using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = con;
                    cmd.CommandType = CommandType.Text;
                    cmd.CommandText = "select * from MstCustomer_Mapping where CustomerId=" + Customer_ids;

                    //cmd.Parameters.Add(new SqlParameter("@HeppmCheckListId", HeppmCheckListId));
                    //cmd.Parameters.Add(new SqlParameter("@Version_No", version));
                    
                    var da = new SqlDataAdapter();

                    da.SelectCommand = cmd;
                    da.Fill(dts);

                }
            }

            foreach (DataRow row in dts.Rows)
            {
                facilitys.FEMS_B_ID = Convert.ToInt32(row["FEMS_ID"]);
                facilitys.BEMS_B_ID = Convert.ToInt32(row["BEMS_ID"]);
            }

            return facilitys;

            }
        public void Update_Mapping(int Master_FacilityID, int Module_ID, int Module_Type)
        {
            try
            {
                var ds = new DataSet();
                // inserting into Master DB
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ToString()))//
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Master_MstLocationFacility_All";

                        SqlParameter parameter = new SqlParameter();
                        cmd.Parameters.Add("@Master_FacilityID", SqlDbType.Int).Value = Master_FacilityID;
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

        public MstLocationFacilityViewModel FEMSSave(MstLocationFacilityViewModel facility,int MasterID)
        {
            int FEMS_FacilityID=0;
            Log4NetLogger.LogEntry(fileName, nameof(Save), Level.Info.ToString());
            try
            {
                facility.ActiveTo = ((DateTime)facility.ActiveFrom).AddMonths(facility.ContractPeriodInYears);
                var isSaveMode = facility.FacilityId == 0 ? true : false;

                string specialsatiovalies = string.Empty;
                if (facility.WeeklyHolidays != null && facility.WeeklyHolidays.Count > 0)
                {
                    specialsatiovalies = string.Join(",", facility.WeeklyHolidays.Select(i => i.ToString()).ToArray());
                }
                //temporary customer value 
                if (facility.ContractPeriodInYears > 0 && facility.InitialProjectCost > 0)
                {
                    var msf = (facility.InitialProjectCost / Convert.ToInt16(facility.ContractPeriodInYears));
                    facility.MonthlyServiceFee = Math.Round(Convert.ToDecimal(msf), 2);
                }
                var dbAccessDAL = new MASTERFEMSDBAccessDAL();
                var model = new MstLocationFacilityViewModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@FacilityId", Convert.ToString(facility.FacilityId));
                parameters.Add("@CustomerId", Convert.ToString(facility.CustomerId));
                parameters.Add("@FacilityName", Convert.ToString(facility.FacilityName));
                parameters.Add("@FacilityCode", Convert.ToString(facility.FacilityCode));
                parameters.Add("@Address", Convert.ToString(facility.Address));
                parameters.Add("@Latitude", Convert.ToString(facility.Latitude));
                parameters.Add("@Longitude", Convert.ToString(facility.Longitude));
                parameters.Add("@ActiveFrom", facility.ActiveFrom != null ? facility.ActiveFrom.Value.ToString("yyyy-MM-dd") : null);
                parameters.Add("@ActiveFromUTC ", facility.ActiveFromUTC != null ? facility.ActiveFromUTC.Value.ToString("yyyy-MM-dd") : null);
                parameters.Add("@ActiveTo", facility.ActiveTo != null ? facility.ActiveTo.Value.ToString("yyyy-MM-dd") : null);
                parameters.Add("@ActiveToUTC", facility.ActiveToUTC != null ? facility.ActiveToUTC.Value.ToString("yyyy-MM-dd") : null);
                parameters.Add("@UserID", Convert.ToString(_UserSession.UserId));

                parameters.Add("@Address2", Convert.ToString(facility.Address2));
                parameters.Add("@Postcode", Convert.ToString(facility.Postcode));
                parameters.Add("@State", Convert.ToString(facility.State));
                parameters.Add("@Country", Convert.ToString(facility.Country));
                parameters.Add("@ContractPeriodInMonths", Convert.ToString(facility.ContractPeriodInYears));
                parameters.Add("@pInitialProjectCost", Convert.ToString(facility.InitialProjectCost));
                parameters.Add("@MonthlyServiceFee", Convert.ToString(facility.MonthlyServiceFee != null ? facility.MonthlyServiceFee : null));
                parameters.Add("@WeeklyHoliday", Convert.ToString(specialsatiovalies));
                // parameters.Add("@LifeExpectancy", Convert.ToString(facility.LifeExpectancy));
                parameters.Add("@TypeOfNomenclature", Convert.ToString(facility.TypeOfNomenclature));

                parameters.Add("@pLogo", facility.Base64StringLogo);
                parameters.Add("@pContactNo", Convert.ToString(facility.ContactNo));
                parameters.Add("@pFaxNo", Convert.ToString(facility.FaxNo));
                parameters.Add("@pWarrantyRenewalNoticeDays", Convert.ToString(facility.WarrantyRenewalNoticeDays));            
                DataTable tempDT = new DataTable();
                tempDT.Columns.Add("FacilityContactInfoId", typeof(int));
                tempDT.Columns.Add("CustomerId", typeof(int));
                tempDT.Columns.Add("FacilityId", typeof(int));
                tempDT.Columns.Add("Name", typeof(string));
                tempDT.Columns.Add("Designation", typeof(string));
                tempDT.Columns.Add("ContactNo", typeof(string));
                tempDT.Columns.Add("Email", typeof(string));
                tempDT.Columns.Add("UserId", typeof(int));
                tempDT.Columns.Add("Active", typeof(bool));
                // custDt.Columns.Add("Active", typeof(bool));
                // List<int> MaintaininceFlagList = model.MaintenanceFlag.Split(',').Select(int.Parse).ToList();
                foreach (var cont in facility.ContactInfoList)
                {
                    tempDT.Rows.Add(cont.FacilityContactInfoId, facility.CustomerId, cont.FacilityId,
                        cont.Name, cont.Designation,
                        cont.ContactNo, cont.Email,
                        _UserSession.UserId, cont.Active == true ? "true" : "false");
                }
                DataSetparameters.Add("@ContactInfoUDT", tempDT);

                DataTable ds = dbAccessDAL.GetMasterDataTable("UspFM_MstLocationFacility_Save", parameters, DataSetparameters);
                if (ds != null)
                {
                    foreach (DataRow row in ds.Rows)
                    {
                        FEMS_FacilityID = Convert.ToInt32(row["FacilityId"]);
                        model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    }
                    model.HiddenId = Convert.ToString(ds.Rows[0]["GuId"]);
                    if (isSaveMode)
                    {
                        model.IsContractPeriodChanged = 3; // temp value to show that the value is binded at save time, not in update 
                    }
                    if (model.FacilityId != 0)
                    {

                    }
                    else
                    {
                        Update_Mapping(MasterID, FEMS_FacilityID, 1);
                    }
                    
                }
                //Check_Cross_data(model.FacilityId);
                Log4NetLogger.LogExit(fileName, nameof(Save), Level.Info.ToString());
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
        public MstLocationFacilityViewModel BEMSSave(MstLocationFacilityViewModel facility, int MasterID)
        {
            int BEMS_FacilityID = 0;
            Log4NetLogger.LogEntry(fileName, nameof(Save), Level.Info.ToString());
            try
            {
                facility.ActiveTo = ((DateTime)facility.ActiveFrom).AddMonths(facility.ContractPeriodInYears);
                var isSaveMode = facility.FacilityId == 0 ? true : false;

                string specialsatiovalies = string.Empty;
                if (facility.WeeklyHolidays != null && facility.WeeklyHolidays.Count > 0)
                {
                    specialsatiovalies = string.Join(",", facility.WeeklyHolidays.Select(i => i.ToString()).ToArray());
                }
                //temporary customer value 
                if (facility.ContractPeriodInYears > 0 && facility.InitialProjectCost > 0)
                {
                    var msf = (facility.InitialProjectCost / Convert.ToInt16(facility.ContractPeriodInYears));
                    facility.MonthlyServiceFee = Math.Round(Convert.ToDecimal(msf), 2);
                }
                var dbAccessDAL = new MASTERBEMSDBAccessDAL();
                var model = new MstLocationFacilityViewModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@FacilityId", Convert.ToString(facility.FacilityId));
                parameters.Add("@CustomerId", Convert.ToString(facility.CustomerId));
                parameters.Add("@FacilityName", Convert.ToString(facility.FacilityName));
                parameters.Add("@FacilityCode", Convert.ToString(facility.FacilityCode));
                parameters.Add("@Address", Convert.ToString(facility.Address));
                parameters.Add("@Latitude", Convert.ToString(facility.Latitude));
                parameters.Add("@Longitude", Convert.ToString(facility.Longitude));
                parameters.Add("@ActiveFrom", facility.ActiveFrom != null ? facility.ActiveFrom.Value.ToString("yyyy-MM-dd") : null);
                parameters.Add("@ActiveFromUTC ", facility.ActiveFromUTC != null ? facility.ActiveFromUTC.Value.ToString("yyyy-MM-dd") : null);
                parameters.Add("@ActiveTo", facility.ActiveTo != null ? facility.ActiveTo.Value.ToString("yyyy-MM-dd") : null);
                parameters.Add("@ActiveToUTC", facility.ActiveToUTC != null ? facility.ActiveToUTC.Value.ToString("yyyy-MM-dd") : null);
                parameters.Add("@UserID", Convert.ToString(_UserSession.UserId));

                parameters.Add("@Address2", Convert.ToString(facility.Address2));
                parameters.Add("@Postcode", Convert.ToString(facility.Postcode));
                parameters.Add("@State", Convert.ToString(facility.State));
                parameters.Add("@Country", Convert.ToString(facility.Country));
                parameters.Add("@ContractPeriodInMonths", Convert.ToString(facility.ContractPeriodInYears));
                parameters.Add("@pInitialProjectCost", Convert.ToString(facility.InitialProjectCost));
                parameters.Add("@MonthlyServiceFee", Convert.ToString(facility.MonthlyServiceFee != null ? facility.MonthlyServiceFee : null));
                parameters.Add("@WeeklyHoliday", Convert.ToString(specialsatiovalies));
                // parameters.Add("@LifeExpectancy", Convert.ToString(facility.LifeExpectancy));
                parameters.Add("@TypeOfNomenclature", Convert.ToString(facility.TypeOfNomenclature));

                parameters.Add("@pLogo", facility.Base64StringLogo);
                parameters.Add("@pContactNo", Convert.ToString(facility.ContactNo));
                parameters.Add("@pFaxNo", Convert.ToString(facility.FaxNo));
                parameters.Add("@pWarrantyRenewalNoticeDays", Convert.ToString(facility.WarrantyRenewalNoticeDays));
                DataTable tempDT = new DataTable();
                tempDT.Columns.Add("FacilityContactInfoId", typeof(int));
                tempDT.Columns.Add("CustomerId", typeof(int));
                tempDT.Columns.Add("FacilityId", typeof(int));
                tempDT.Columns.Add("Name", typeof(string));
                tempDT.Columns.Add("Designation", typeof(string));
                tempDT.Columns.Add("ContactNo", typeof(string));
                tempDT.Columns.Add("Email", typeof(string));
                tempDT.Columns.Add("UserId", typeof(int));
                tempDT.Columns.Add("Active", typeof(bool));
                // custDt.Columns.Add("Active", typeof(bool));
                // List<int> MaintaininceFlagList = model.MaintenanceFlag.Split(',').Select(int.Parse).ToList();
                foreach (var cont in facility.ContactInfoList)
                {
                    tempDT.Rows.Add(cont.FacilityContactInfoId, facility.CustomerId, cont.FacilityId,
                        cont.Name, cont.Designation,
                        cont.ContactNo, cont.Email,
                        _UserSession.UserId, cont.Active == true ? "true" : "false");
                }
                DataSetparameters.Add("@ContactInfoUDT", tempDT);

                DataTable ds = dbAccessDAL.GetMasterDataTable("UspFM_MstLocationFacility_Save", parameters, DataSetparameters);
                if (ds != null)
                {
                    foreach (DataRow row in ds.Rows)
                    {
                        BEMS_FacilityID = Convert.ToInt32(row["FacilityId"]);
                        model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    }
                    model.HiddenId = Convert.ToString(ds.Rows[0]["GuId"]);
                    if (isSaveMode)
                    {
                        model.IsContractPeriodChanged = 3; // temp value to show that the value is binded at save time, not in update 
                    }
                   
                    if (isSaveMode)
                    {
                        model.IsContractPeriodChanged = 3; // temp value to show that the value is binded at save time, not in update 
                    }
                    if (model.FacilityId != 0)
                    {

                    }
                    else
                    {
                        Update_Mapping(MasterID, BEMS_FacilityID, 2);
                    }
                }
                //Check_Cross_data(model.FacilityId);
                Log4NetLogger.LogExit(fileName, nameof(Save), Level.Info.ToString());
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

    }
}
