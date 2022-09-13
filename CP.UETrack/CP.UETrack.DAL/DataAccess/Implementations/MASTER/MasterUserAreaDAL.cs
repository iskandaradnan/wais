using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
//using CP.UETrack.DAL.DataAccess.Contracts.MASTER;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using UETrack.DAL;
using CP.UETrack.DAL.DataAccess;
using System.Configuration;
using CP.UETrack.DAL.DataAccess.Implementations.BEMS;

namespace CP.UETrack.DAL.DataAccess
{
    public class MasterUserAreaDAL : IMasterUserAreaDAL
    {
        private readonly string _FileName = nameof(AccountDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        int FEMS, BEMS, FEMS_Level, BEMS_Level;
        int Area_ID, FEMS_Area_ID, BEMS_Area_ID;
        int ups = 0;
        public class User_Area
        {
            public int FEMS_UA_ID { get; set; }
            public int BEMS_UA_ID { get; set; }
        }
        public MasterUserAreaDAL()
        {

        }
     
        public MstLocationUserAreaViewModel Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new MstLocationUserAreaViewModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                var date = DateTime.Now;
                var currentDate = date.Date; 
                parameters.Add("@Id", Id.ToString());
                DataTable dt = dbAccessDAL.GetMASTERDataTable("UspFM_MstLocationUserArea_GetById", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                  
                    obj.BlockCode = Convert.ToString(dt.Rows[0]["BlockCode"]);
                    obj.BlockName = Convert.ToString(dt.Rows[0]["BlockName"]);
                    obj.UserAreaId = Convert.ToInt16(dt.Rows[0]["UserAreaId"]);
                    obj.UserAreaCode = Convert.ToString(dt.Rows[0]["UserAreaCode"]);
                    obj.UserAreaName = Convert.ToString(dt.Rows[0]["UserAreaName"]);
                    obj.UserLevelCode = Convert.ToString(dt.Rows[0]["UserLevelCode"]);
                    obj.UserLevelName = Convert.ToString(dt.Rows[0]["UserLevelName"]);
                    obj.LevelId = Convert.ToInt16(dt.Rows[0]["LevelId"]);
                    obj.BlockId = Convert.ToInt16(dt.Rows[0]["BlockId"]);
                    obj.FacilityId = Convert.ToInt16(dt.Rows[0]["FacilityId"]);
                    obj.CustomerId = Convert.ToInt16(dt.Rows[0]["CustomerId"]);
                    obj.Active = Convert.ToBoolean(dt.Rows[0]["Active"]);
                    obj.CompanyStaffId = Convert.ToInt32(dt.Rows[0]["CompanyStaffId"]);
                    obj.HospitalStaffId = Convert.ToInt32(dt.Rows[0]["HospitalStaffId"]);
                    obj.HospitalStaffName = Convert.ToString(dt.Rows[0]["HospitalStaffName"]);
                    obj.CompanyStaffName = Convert.ToString(dt.Rows[0]["CompanyStaffName"]);
                    obj.Remarks = Convert.ToString(dt.Rows[0]["Remarks"]);
                    obj.ActiveFromDate = Convert.ToDateTime(dt.Rows[0]["ActiveFromDate"]);
                    obj.ActiveFromDateUTC = Convert.ToDateTime(dt.Rows[0]["ActiveFromDateUTC"]);
                    obj.ActiveToDate = dt.Rows[0]["ActiveToDate"] != DBNull.Value ? (Convert.ToDateTime(dt.Rows[0]["ActiveToDate"])) : (DateTime?)null;
                    obj.ActiveToDateUTC = dt.Rows[0]["ActiveToDateUTC"] != DBNull.Value ? (Convert.ToDateTime(dt.Rows[0]["ActiveToDateUTC"])) : (DateTime?)null;
                    obj.Timestamp = Convert.ToBase64String((byte[])(dt.Rows[0]["Timestamp"]));
                    obj.HiddenId = Convert.ToString(dt.Rows[0]["GuId"]);
                    obj.isStartDateFuture = obj.ActiveFromDate.Date > currentDate ? true : false;
                    obj.Category = Convert.ToInt32(dt.Rows[0]["Category"]);
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
        public MstLocationUserAreaViewModel Save(MstLocationUserAreaViewModel model)
        {
            ups = model.UserAreaId;
            User_Area UserAreaIDs = new User_Area();

            Blocks Facility_Mapping_IDS = new Blocks();
            Blocks Customar_Mapping_IDS = new Blocks();
            CustomerDAL customer = new CustomerDAL();
            MasterBlockDAL MBD = new MasterBlockDAL();
            Facility_Mapping_IDS = MBD.GET_Facility_Mapping_IDS(_UserSession.FacilityId);
            Customar_Mapping_IDS = customer.GET_Customar_Mapping_IDS(_UserSession.CustomerId);


            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            try
            {
                var commonDAL = new CommonDAL();
                var ErrorMessage = string.Empty;
                var date = DateTime.Now;
                var CurrentDate = date.Date;
                var isFutureDate = model.ActiveFromDate.Date > CurrentDate ? true : false;
              //  byte[] image = commonDAL.GenerateQRCode(model.UserAreaName);
                var isAddMode = model.UserAreaId == 0;
                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new EngAssetClassification();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@UserAreaId",Convert.ToString( model.UserAreaId));
                parameters.Add("@UserAreaCode", Convert.ToString(model.UserAreaCode));
                parameters.Add("@UserAreaName", Convert.ToString(model.UserAreaName));
                parameters.Add("@LevelId", Convert.ToString(model.LevelId));
                parameters.Add("@CustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@BlockId", Convert.ToString(model.BlockId));
                parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@Active", model.Active == true ? "true" : "false");
                parameters.Add("@HospitalStaffId", Convert.ToString(model.HospitalStaffId));
                parameters.Add("@CompanyStaffId", Convert.ToString(model.CompanyStaffId));
                parameters.Add("@Remarks", Convert.ToString(model.Remarks));
                parameters.Add("@UserId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@ActiveFromDate", model.ActiveFromDate != null ? model.ActiveFromDate.ToString("yyyy-MM-dd") : null);
                parameters.Add("@ActiveFromDateUTC", model.ActiveFromDate != null ? model.ActiveFromDate.ToString("yyyy-MM-dd") : null);
                parameters.Add("@ActiveToDate", model.ActiveToDate != null ? model.ActiveToDate.Value.ToString("yyyy-MM-dd") : null);
                parameters.Add("@ActiveToDateUTC", model.ActiveToDate != null ? model.ActiveToDate.Value.ToString("yyyy-MM-dd") : null);
                parameters.Add("@Category", Convert.ToString(model.Category));

                //parameters.Add("@pQRCode", Convert.ToBase64String(image));

                ///-------------Get Modules FEMS OR BEMS OR CLS
                ///


                var dss = new DataSet();
                var MasterdbAccessDAL = new MASTERDBAccessDAL();
                using (SqlConnection con = new SqlConnection(MasterdbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Get_MasterServices_byBlockId";
                        cmd.Parameters.AddWithValue("MasterBlockID", model.BlockId);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(dss);
                    }
                }
                if (dss.Tables.Count != 0)
                {

                    FEMS = Convert.ToInt32(dss.Tables[0].Rows[0]["FEMS"]);
                    BEMS = Convert.ToInt32(dss.Tables[0].Rows[0]["BEMS"]);
                }
                dss.Clear();
                ///----------------Get modules FEMS )R BEMS OR CLS IDS OF LEVEL
                ///
               // var MasterdbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(MasterdbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Get_MasterServices_byLevelId";
                        cmd.Parameters.AddWithValue("MasterLevelID", model.LevelId);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(dss);
                    }
                }
                if (dss.Tables.Count != 0)
                {

                    FEMS_Level = Convert.ToInt32(dss.Tables[0].Rows[0]["FEMS"]);
                    BEMS_Level = Convert.ToInt32(dss.Tables[0].Rows[0]["BEMS"]);
                }
             //   Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                //----Insert into Master DB

                DataTable ds = MasterdbAccessDAL.GetMASTERDataTable("UspFM_MstLocationUserArea_Save", parameters, DataSetparameters);
                if (ds != null)
                {
                    foreach (DataRow row in ds.Rows)
                    {
                        model.UserAreaId = Convert.ToInt32(row["UserAreaId"]);
                        Area_ID = model.UserAreaId;
                        //model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));

                        if (ErrorMessage == string.Empty)
                        {
                            //assetRegister.QRCode = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["QRCode"]));
                            model.Timestamp = Convert.ToBase64String((byte[])(ds.Rows[0]["Timestamp"]));
                            model.HiddenId = Convert.ToString(ds.Rows[0]["GuId"]);
                            model.UserAreaCode = Convert.ToString(ds.Rows[0]["UserAreaCode"]);
                            model.isStartDateFuture = isFutureDate; 
                        }
                        //if (isAddMode)
                        //{
                        //    byte[] image = commonDAL.GenerateQRCode(model.UserAreaCode + " + " + model.HiddenId.ToUpper());
                        //    UpdateQRCode(model, image);
                        //}

                    }
                }
                ds = new DataTable();
                ds.Clear();
                ///--------CHeck Inser or Update
                ///
               
                if (ups==0)
                {
                // insert into mapping table
                using (SqlConnection con = new SqlConnection(MasterdbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Master_AreaMst_Save";

                        SqlParameter parameter = new SqlParameter();
                        cmd.Parameters.Add("@AreaId", SqlDbType.Int).Value = Area_ID;

                        // cmd.Parameters.Add(parameter);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }

                    ///
                    ///----------------Insert into FEMS DB
                    ///
                    UserAreaIDs.BEMS_UA_ID = 0;
                    UserAreaIDs.FEMS_UA_ID = 0;
                }
                else
                {
                    UserAreaIDs = Get_User_Areaids(Area_ID);
                }
                ds.Clear();
                if (FEMS != 0)
                {
                    parameters.Clear();
                    parameters.Add("@UserAreaId", Convert.ToString(UserAreaIDs.FEMS_UA_ID));
                    parameters.Add("@UserAreaCode", Convert.ToString(model.UserAreaCode));
                    parameters.Add("@UserAreaName", Convert.ToString(model.UserAreaName));
                    parameters.Add("@LevelId", Convert.ToString(FEMS_Level));
                   // parameters.Add("@CustomerId", Convert.ToString(Customar_Mapping_IDS.FEMS_B_ID));
                    parameters.Add("@BlockId", Convert.ToString(FEMS));
                    // parameters.Add("@FacilityId", Convert.ToString(Facility_Mapping_IDS.FEMS_B_ID));
                    parameters.Add("@CustomerId", Convert.ToString(_UserSession.CustomerId));
                    parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));
                    parameters.Add("@Active", model.Active == true ? "true" : "false");
                    parameters.Add("@HospitalStaffId", Convert.ToString(model.HospitalStaffId));
                    parameters.Add("@CompanyStaffId", Convert.ToString(model.CompanyStaffId));
                    parameters.Add("@Remarks", Convert.ToString(model.Remarks));
                    parameters.Add("@UserId", Convert.ToString(_UserSession.UserId));
                    parameters.Add("@ActiveFromDate", model.ActiveFromDate != null ? model.ActiveFromDate.ToString("yyyy-MM-dd") : null);
                    parameters.Add("@ActiveFromDateUTC", model.ActiveFromDate != null ? model.ActiveFromDate.ToString("yyyy-MM-dd") : null);
                    parameters.Add("@ActiveToDate", model.ActiveToDate != null ? model.ActiveToDate.Value.ToString("yyyy-MM-dd") : null);
                    parameters.Add("@ActiveToDateUTC", model.ActiveToDate != null ? model.ActiveToDate.Value.ToString("yyyy-MM-dd") : null);
                    parameters.Add("@Category", Convert.ToString(model.Category));
                    // parameters["BlockId"] = FEMS.ToString();
                    // parameters["LevelId"] = FEMS_Level.ToString();
                    var FEMSdbAccessDAL = new MASTERFEMSDBAccessDAL();
                    ds = FEMSdbAccessDAL.GetMasterDataTable("UspFM_MstLocationUserArea_Save", parameters, DataSetparameters);
                    if (ds != null)
                    {
                        foreach (DataRow row in ds.Rows)
                        {
                            FEMS_Area_ID = Convert.ToInt32(row["UserAreaId"]);
                            // Area_ID = model.UserAreaId;
                            //model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));

                            if (ErrorMessage == string.Empty)
                            {
                                //assetRegister.QRCode = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["QRCode"]));
                                model.Timestamp = Convert.ToBase64String((byte[])(ds.Rows[0]["Timestamp"]));
                                model.HiddenId = Convert.ToString(ds.Rows[0]["GuId"]);
                                model.UserAreaCode = Convert.ToString(ds.Rows[0]["UserAreaCode"]);
                                model.isStartDateFuture = isFutureDate;
                            }
                            //if (isAddMode)
                            //{
                            //    byte[] image = FEMSdbAccessDAL.GenerateQRCode(model.UserAreaCode + " + " + model.HiddenId.ToUpper());
                            //    FEMSUpdateQRCode(model, image);
                            //}

                        }
                    }
                    if (ups == 0)
                    {
                        Update_FEMS(Area_ID, FEMS_Area_ID, 1);
                    }
                    else
                    {
                    }
                }
                ds.Clear();
                if (BEMS != 0)
                {
                    parameters.Clear();
                    parameters.Add("@UserAreaId", Convert.ToString(UserAreaIDs.BEMS_UA_ID));
                    parameters.Add("@UserAreaCode", Convert.ToString(model.UserAreaCode));
                    parameters.Add("@UserAreaName", Convert.ToString(model.UserAreaName));
                    parameters.Add("@LevelId", Convert.ToString(BEMS_Level));
                   
                    parameters.Add("@BlockId", Convert.ToString(BEMS));
                    //parameters.Add("@CustomerId", Convert.ToString(Customar_Mapping_IDS.BEMS_B_ID));
                    //parameters.Add("@FacilityId", Convert.ToString(Facility_Mapping_IDS.BEMS_B_ID));
                    parameters.Add("@CustomerId", Convert.ToString(_UserSession.CustomerId));
                    parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));
                    parameters.Add("@Active", model.Active == true ? "true" : "false");
                    parameters.Add("@HospitalStaffId", Convert.ToString(model.HospitalStaffId));
                    parameters.Add("@CompanyStaffId", Convert.ToString(model.CompanyStaffId));
                    parameters.Add("@Remarks", Convert.ToString(model.Remarks));
                    parameters.Add("@UserId", Convert.ToString(_UserSession.UserId));
                    parameters.Add("@ActiveFromDate", model.ActiveFromDate != null ? model.ActiveFromDate.ToString("yyyy-MM-dd") : null);
                    parameters.Add("@ActiveFromDateUTC", model.ActiveFromDate != null ? model.ActiveFromDate.ToString("yyyy-MM-dd") : null);
                    parameters.Add("@ActiveToDate", model.ActiveToDate != null ? model.ActiveToDate.Value.ToString("yyyy-MM-dd") : null);
                    parameters.Add("@ActiveToDateUTC", model.ActiveToDate != null ? model.ActiveToDate.Value.ToString("yyyy-MM-dd") : null);
                    parameters.Add("@Category", Convert.ToString(model.Category));
                    
                    //parameters["BlockId"] = BEMS.ToString();
                    //parameters["LevelId"] = BEMS_Level.ToString();
                    var DBAccessDAL = new MASTERBEMSDBAccessDAL();
                    ds = DBAccessDAL.GetMasterDataTable("UspFM_MstLocationUserArea_Save", parameters, DataSetparameters);
                    if (ds != null)
                    {
                        foreach (DataRow row in ds.Rows)
                        {
                            BEMS_Area_ID = Convert.ToInt32(row["UserAreaId"]);
                            // Area_ID = model.UserAreaId;
                            //model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));

                            if (ErrorMessage == string.Empty)
                            {
                                //assetRegister.QRCode = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["QRCode"]));
                                model.Timestamp = Convert.ToBase64String((byte[])(ds.Rows[0]["Timestamp"]));
                                model.HiddenId = Convert.ToString(ds.Rows[0]["GuId"]);
                                model.UserAreaCode = Convert.ToString(ds.Rows[0]["UserAreaCode"]);
                                model.isStartDateFuture = isFutureDate;
                            }
                            //if (isAddMode)
                            //{
                            //    byte[] image = DBAccessDAL.GenerateQRCode(model.UserAreaCode + " + " + model.HiddenId.ToUpper());
                            //    BEMSUpdateQRCode(model, image);
                            //}

                        }
                    }
                    if (ups == 0)
                    {
                        Update_FEMS(Area_ID, BEMS_Area_ID, 2);
                    }
                    else
                    {
                    }
                }
                    Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());


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
        public void Update_FEMS(int Master_AreaID, int Module_ID, int Module_Type)
        {
            try
            {
                var ds = new DataSet();
                // inserting into Master DB
                var dbAccessDAL = new MASTERDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Master_Update_Area_All";

                        SqlParameter parameter = new SqlParameter();
                        cmd.Parameters.Add("@Master_AreaID", SqlDbType.Int).Value = Master_AreaID;
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
        public User_Area Get_User_Areaids(int Master_User_Aser_IDS)
        {
            User_Area UAersids = new User_Area();
            var dss = new DataSet();
            var MasterdbAccessDAL = new MASTERDBAccessDAL();
            using (SqlConnection con = new SqlConnection(MasterdbAccessDAL.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = con;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "Get_MasterServices_byUserAreaId";
                    cmd.Parameters.AddWithValue("@UserAreaID", Master_User_Aser_IDS);
                    var da = new SqlDataAdapter();
                    da.SelectCommand = cmd;
                    da.Fill(dss);
                }
            }
            if (dss.Tables.Count != 0)
            {

                UAersids.FEMS_UA_ID = Convert.ToInt32(dss.Tables[0].Rows[0]["FEMS"]);
                UAersids.BEMS_UA_ID = Convert.ToInt32(dss.Tables[0].Rows[0]["BEMS"]);
            }
            // Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
            return UAersids;

        }
        public void UpdateQRCode(MstLocationUserAreaViewModel model, byte[] QRCodeImage)
        {
            var ds = new DataSet();
            var dbAccessDAL = new MASTERDBAccessDAL();
          
            using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = con;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "uspFM_MstLocationUserAreaQR_Update";
                    cmd.Parameters.AddWithValue("@pUserAreaId", model.UserAreaId);
                    cmd.Parameters.AddWithValue("@pQRCode", QRCodeImage);

                    var da = new SqlDataAdapter();
                    da.SelectCommand = cmd;
                    da.Fill(ds);

                    if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        model.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                    }
                }
            }
        }

        public void Delete(int Id, out string ErrorMessage)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            try
            {
                 ErrorMessage = string.Empty;
                var dbAccessDAL = new MASTERDBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pUserAreaId", Id.ToString());
                DataTable dt = dbAccessDAL.GetMASTERDataTable("uspFM_MstLocationUserArea_Delete", parameters, DataSetparameters);
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
        public void FEMSUpdateQRCode(MstLocationUserAreaViewModel model, byte[] QRCodeImage)
        {
            var ds = new DataSet();
            var dbAccessDAL = new MASTERFEMSDBAccessDAL();

            using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = con;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "uspFM_MstLocationUserAreaQR_Update";
                    cmd.Parameters.AddWithValue("@pUserAreaId", model.UserAreaId);
                    cmd.Parameters.AddWithValue("@pQRCode", QRCodeImage);

                    var da = new SqlDataAdapter();
                    da.SelectCommand = cmd;
                    da.Fill(ds);

                    if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        model.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                    }
                }
            }
        }
        public void BEMSUpdateQRCode(MstLocationUserAreaViewModel model, byte[] QRCodeImage)
        {
            var ds = new DataSet();
            var dbAccessDAL = new MASTERBEMSDBAccessDAL();

            using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = con;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "uspFM_MstLocationUserAreaQR_Update";
                    cmd.Parameters.AddWithValue("@pUserAreaId", model.UserAreaId);
                    cmd.Parameters.AddWithValue("@pQRCode", QRCodeImage);

                    var da = new SqlDataAdapter();
                    da.SelectCommand = cmd;
                    da.Fill(ds);

                    if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        model.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                    }
                }
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
                var dbAccessDAL = new MASTERDBAccessDAL();

                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@PageIndex", pageFilter.PageIndex.ToString());
                parameters.Add("@PageSize", pageFilter.PageSize.ToString());
                parameters.Add("@strCondition", strCondition);
                parameters.Add("@strSorting", strOrderBy);
                DataTable dt = dbAccessDAL.GetMASTERDataTable("UspFM_MstLocationUserArea_GetAll", parameters, DataSetparameters);

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
                throw ex;
            }
        }
        public bool IsUserAreaDuplicate(MstLocationUserAreaViewModel model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsUserAreaDuplicate), Level.Info.ToString());

                var IsDuplicate = true;
                var dbAccessDAL = new MASTERDBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@Id", model.UserAreaId.ToString());
                parameters.Add("@UserAreaCode", model.UserAreaCode.ToString());
                parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));               
                DataTable dt = dbAccessDAL.GetMASTERDataTable("UspFM_MstLocationUserArea_ValCode", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    IsDuplicate = Convert.ToBoolean(dt.Rows[0]["IsDuplicate"]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(IsUserAreaDuplicate), Level.Info.ToString());
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
        public bool IsRecordModified(MstLocationUserAreaViewModel model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsRecordModified), Level.Info.ToString());
                var dbAccessDAL = new MASTERDBAccessDAL();
                var recordModifed = false;
                if (model.UserAreaId != 0)
                {
                    var DataSetparameters = new Dictionary<string, DataTable>();
                    var parameters = new Dictionary<string, string>();
                    parameters.Add("@Id", model.UserAreaId.ToString());
                    DataTable dt = dbAccessDAL.GetMASTERDataTable("UspFM_MstLocationUserArea_GetTimestamp", parameters, DataSetparameters);

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
        public bool AreAllLocationsInactive(int userAreaId)
        {
            try
            {
                var isExisting = true; 
                Log4NetLogger.LogEntry(_FileName, nameof(IsRecordModified), Level.Info.ToString());
                var dbAccessDAL = new MASTERDBAccessDAL();              
                if (userAreaId != 0)
                {
                    var DataSetparameters = new Dictionary<string, DataTable>();
                    var parameters = new Dictionary<string, string>();
                    parameters.Add("@pUserAreaId", Convert.ToString(userAreaId));
                    DataTable dt = dbAccessDAL.GetMASTERDataTable("UspFM_MstLocationUserArea_ActiveCheck", parameters, DataSetparameters);

                    if (dt != null && dt.Rows.Count > 0)
                    {
                         isExisting = Convert.ToBoolean((dt.Rows[0]["isExisting"]));
                      
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(IsRecordModified), Level.Info.ToString());
                return isExisting;
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

        public AreaLovs Load(int id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var model = new AreaLovs();
                var modeles = new AreaLovs();

                //CategoryValues category = null;
                var dal = new LevelDAL();
                var obj = dal.Get(id);

                model.LevelId = id;
                model.BlockId = obj.BlockId;
                model.FacilityId = obj.FacilityId;
                model.LevelName = obj.LevelName;
                model.LevelCode = obj.LevelCode;
                model.BlockCode = obj.BlockCode;
                model.BlockName = obj.BlockName;

                //var ds = new DataSet();
                //var dbAccessDAL = new DBAccessDAL();
                //using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                //{
                //    using (SqlCommand cmd = new SqlCommand())
                //    {
                //        cmd.Connection = con;
                //        cmd.CommandType = CommandType.StoredProcedure;
                //        cmd.CommandText = "uspFM_Dropdown_Others";
                //        cmd.Parameters.AddWithValue("@pLovKey", "CategoryValues");
                //        var da = new SqlDataAdapter();
                //        da.SelectCommand = cmd;
                //        da.Fill(ds);

                        

                //    }
                //}
                //if (ds.Tables.Count != 0)
                //{
                //    category.Category = dbAccessDAL.GetLovRecords(ds.Tables[0], "CategoryValues");
                   
                //}
              
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());

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
    }
}
