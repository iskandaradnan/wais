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
using CP.UETrack.DAL.DataAccess.Implementations.BEMS;

namespace CP.UETrack.DAL.DataAccess
{
    public class MasterUserLocationDAL : IMasterUserLocationDAL
    {
        private readonly string _FileName = nameof(MasterUserLocationDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        int UserLocationID, FEMS_UserLocationID, BEMS_UserLocationID, FEMS, BEMS, FEMS_Level, BEMS_Level;
        int Level_ID, FEMS_Level_ID, BEMS_Level_ID, FEMS_Area_ID, BEMS_Area_ID,Area_ID;
        int ups = 0;
        public class User_Location
        {
            public int FEMS_UL_ID { get; set; }
            public int BEMS_UL_ID { get; set; }
        }
        public MasterUserLocationDAL()
        {
        }
        public MstLocationUserLocationLovs Load(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dal = new MasterUserAreaDAL();
                var obj = new MstLocationUserLocationLovs();

               var result = dal.Get(Id);

                obj.UserAreaId = Id;
                obj.UserAreaCode = result.UserAreaCode;
                obj.UserAreaName = result.UserAreaName;
                obj.FacilityId = result.FacilityId;
                obj.BlockId = result.BlockId;
                obj.BlockCode = result.BlockCode;
                obj.BlockName = result.BlockName;
                obj.LevelCode = result.UserLevelCode;
                obj.LevelName = result.UserLevelName;

                obj.LevelId = result.LevelId;              
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
        public MstLocationUserLocation Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var date = DateTime.Now;
                var currentDate = date.Date;
                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new MstLocationUserLocation();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@Id", Id.ToString());
                DataTable dt = dbAccessDAL.GetMASTERDataTable("UspFM_MstLocationUserLocation_GetById", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    obj.UserLocationId = Convert.ToInt16(dt.Rows[0]["UserLocationId"]);
                    obj.UserAreaId = Convert.ToInt16(dt.Rows[0]["UserAreaId"]);
                    obj.UserAreaCode = Convert.ToString(dt.Rows[0]["UserAreaCode"]);
                    obj.UserAreaName = Convert.ToString(dt.Rows[0]["UserAreaName"]);
                    obj.UserLocationCode = Convert.ToString(dt.Rows[0]["UserLocationCode"]);
                    obj.UserLocationName = Convert.ToString(dt.Rows[0]["UserLocationName"]);
                    obj.LevelId = Convert.ToInt16(dt.Rows[0]["LevelId"]);
                    obj.BlockId = Convert.ToInt16(dt.Rows[0]["BlockId"]);
                    obj.BlockCode = Convert.ToString(dt.Rows[0]["BlockCode"]);
                    obj.BlockName = Convert.ToString(dt.Rows[0]["BlockName"]);
                    obj.LevelCode = Convert.ToString(dt.Rows[0]["LevelCode"]);
                    obj.LevelName = Convert.ToString(dt.Rows[0]["LevelName"]);
                    obj.Active = Convert.ToBoolean(dt.Rows[0]["Active"]);
                    obj.ActiveFromDate = Convert.ToDateTime(dt.Rows[0]["ActiveFromDate"]);
                    obj.ActiveFromDateUTC = Convert.ToDateTime(dt.Rows[0]["ActiveFromDateUTC"]);
                    obj.ActiveToDate = dt.Rows[0]["ActiveToDate"] != DBNull.Value ? (Convert.ToDateTime(dt.Rows[0]["ActiveToDate"])) : (DateTime?)null;
                    obj.ActiveToDateUTC = dt.Rows[0]["ActiveToDateUTC"] != DBNull.Value ? (Convert.ToDateTime(dt.Rows[0]["ActiveToDateUTC"])) : (DateTime?)null;
                    obj.AuthorizedStaffId = Convert.ToInt32(dt.Rows[0]["AuthorizedStaffId"]);
                    obj.AuthorizedStaffName = Convert.ToString(dt.Rows[0]["AuthorizedStaffName"]);
                    obj.Timestamp = Convert.ToBase64String((byte[])(dt.Rows[0]["Timestamp"]));
                    obj.CompanyStaffId = Convert.ToInt32(dt.Rows[0]["CompanyStaffId"]);                    
                    obj.CompanyStaffName = Convert.ToString(dt.Rows[0]["CompanyStaffName"]);
                    obj.HiddenId = Convert.ToString(dt.Rows[0]["GuId"]);
                    obj.isStartDateFuture = obj.ActiveFromDate.Date > currentDate ? true : false;
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
        public MstLocationUserLocation Save(MstLocationUserLocation model)
        {
            MstLocationUserLocation modelmas = new MstLocationUserLocation();
              ups = model.UserLocationId;
            User_Location User_A_L_IDS = new User_Location();
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
              //  byte[] image = commonDAL.GenerateQRCode(model.UserLocationName + _UserSession.FacilityCode);
                var isAddMode = model.UserLocationId == 0;
                var date = DateTime.Now;
                var CurrentDate = date.Date;
                var isFutureDate = model.ActiveFromDate.Date > CurrentDate ? true : false;
                var ds = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "UspFM_MstLocationUserLocation_Save";

                        SqlParameter parameter = new SqlParameter();
                        cmd.Parameters.AddWithValue("@pUserLocationId", model.UserLocationId);
                        cmd.Parameters.AddWithValue("@CustomerId", _UserSession.CustomerId);
                        cmd.Parameters.AddWithValue("@FacilityId", _UserSession.FacilityId);
                        cmd.Parameters.AddWithValue("@BlockId", model.BlockId);
                        cmd.Parameters.AddWithValue("@LevelId", model.LevelId);
                        cmd.Parameters.AddWithValue("@UserAreaId", model.UserAreaId);
                        cmd.Parameters.AddWithValue("@UserLocationCode", model.UserLocationCode);
                        cmd.Parameters.AddWithValue("@UserLocationName", model.UserLocationName);
                        cmd.Parameters.AddWithValue("@ActiveFromDate", model.ActiveFromDate != null ? model.ActiveFromDate.ToString("yyyy-MM-dd") : null);
                        cmd.Parameters.AddWithValue("@ActiveFromDateUTC", model.ActiveFromDate != null ? model.ActiveFromDate.ToString("yyyy-MM-dd") : null);
                        cmd.Parameters.AddWithValue("@ActiveToDate", model.ActiveToDate != null ? model.ActiveToDate.Value.ToString("yyyy-MM-dd") : null);
                        cmd.Parameters.AddWithValue("@ActiveToDateUTC", model.ActiveToDate != null ? model.ActiveToDate.Value.ToString("yyyy-MM-dd") : null);
                        cmd.Parameters.AddWithValue("@AuthorizedStaffId", model.AuthorizedStaffId);
                        cmd.Parameters.AddWithValue("@UserId", _UserSession.UserId);
                        cmd.Parameters.AddWithValue("@Active", model.Active == true ? "true" : "false");
                        cmd.Parameters.AddWithValue("@CompanyStaffId", model.CompanyStaffId);
                        // cmd.Parameters.AddWithValue("@pQRCode", image);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }

                }
                if (ds != null && ds.Tables[0] != null)
                {
                    foreach (DataRow row in ds.Tables[0].Rows)
                    {
                        UserLocationID = Convert.ToInt32(row[0]);
                        model.HiddenId = Convert.ToString(row["GuId"]);
                        model.UserLocationId = Convert.ToInt32(row["UserLocationId"]);
                        model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                        model.isStartDateFuture = isFutureDate;
                    }
                    //if (isAddMode)
                    //{
                    //    byte[] image = dbAccessDAL.GenerateQRCode(model.UserLocationCode + " + " + model.HiddenId.ToUpper());
                    //    UpdateQRCode(model, image);
                    //}
                }
                modelmas = model;
                ///-------------Get "Modules" FEMS OR BEMS OR CLS
                ///

                ds.Clear();

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
                ///----------------Get modules FEMS )R BEMS OR CLS IDS OF "LEVEL"
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
                dss.Clear();
                //
                ///----------------Get modules FEMS oR BEMS OR CLS IDS OF "Area"
                ///
                // var MasterdbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(MasterdbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Get_MasterServices_byAreaId";
                        cmd.Parameters.AddWithValue("MasterAreaID", model.UserAreaId);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(dss);
                    }
                }
                if (dss.Tables.Count != 0)
                {

                    FEMS_Area_ID = Convert.ToInt32(dss.Tables[0].Rows[0]["FEMS"]);
                    BEMS_Area_ID = Convert.ToInt32(dss.Tables[0].Rows[0]["BEMS"]);
                }
                dss.Clear();
                //----------insert into mapping table
                if (ups == 0)
                {
                    using (SqlConnection con = new SqlConnection(MasterdbAccessDAL.ConnectionString))
                    {
                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.Connection = con;
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.CommandText = "Master_UserLocationMst_Save";

                            SqlParameter parameter = new SqlParameter();
                            cmd.Parameters.Add("@UserLocationId", SqlDbType.Int).Value = UserLocationID;

                            // cmd.Parameters.Add(parameter);
                            var da = new SqlDataAdapter();
                            da.SelectCommand = cmd;
                            da.Fill(ds);
                        }
                    }
                    ds.Clear();
                    User_A_L_IDS.FEMS_UL_ID = 0;
                    User_A_L_IDS.BEMS_UL_ID = 0;
                }
                else
                {
                    User_A_L_IDS = Get_UserLocation(ups);
                }
               
                ///----------------Insert into FEMS DB
                ///
                if (FEMS != 0)
                {
                    var FEMSdbAccessDAL = new MASTERFEMSDBAccessDAL();
                    using (SqlConnection con = new SqlConnection(FEMSdbAccessDAL.ConnectionString))
                    {
                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.Connection = con;
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.CommandText = "UspFM_MstLocationUserLocation_Save";

                            SqlParameter parameter = new SqlParameter();
                            cmd.Parameters.AddWithValue("@pUserLocationId", User_A_L_IDS.FEMS_UL_ID);
                            //cmd.Parameters.AddWithValue("@CustomerId", Customar_Mapping_IDS.FEMS_B_ID);
                            //cmd.Parameters.AddWithValue("@FacilityId", Facility_Mapping_IDS.FEMS_B_ID);
                            cmd.Parameters.AddWithValue("@CustomerId", _UserSession.CustomerId);
                            cmd.Parameters.AddWithValue("@FacilityId", _UserSession.FacilityId);
                            cmd.Parameters.AddWithValue("@BlockId", FEMS);
                            cmd.Parameters.AddWithValue("@LevelId", FEMS_Level);
                            cmd.Parameters.AddWithValue("@UserAreaId", FEMS_Area_ID);
                            cmd.Parameters.AddWithValue("@UserLocationCode", model.UserLocationCode);
                            cmd.Parameters.AddWithValue("@UserLocationName", model.UserLocationName);
                            cmd.Parameters.AddWithValue("@ActiveFromDate", model.ActiveFromDate != null ? model.ActiveFromDate.ToString("yyyy-MM-dd") : null);
                            cmd.Parameters.AddWithValue("@ActiveFromDateUTC", model.ActiveFromDate != null ? model.ActiveFromDate.ToString("yyyy-MM-dd") : null);
                            cmd.Parameters.AddWithValue("@ActiveToDate", model.ActiveToDate != null ? model.ActiveToDate.Value.ToString("yyyy-MM-dd") : null);
                            cmd.Parameters.AddWithValue("@ActiveToDateUTC", model.ActiveToDate != null ? model.ActiveToDate.Value.ToString("yyyy-MM-dd") : null);
                            cmd.Parameters.AddWithValue("@AuthorizedStaffId", model.AuthorizedStaffId);
                            cmd.Parameters.AddWithValue("@UserId", _UserSession.UserId);
                            cmd.Parameters.AddWithValue("@Active", model.Active == true ? "true" : "false");
                            cmd.Parameters.AddWithValue("@CompanyStaffId", model.CompanyStaffId);
                            // cmd.Parameters.AddWithValue("@pQRCode", image);

                            var da = new SqlDataAdapter();
                            da.SelectCommand = cmd;
                            da.Fill(ds);
                        }
                        if (ds.Tables.Count != 0)
                        {                      
                                foreach (DataRow row in ds.Tables[0].Rows)
                                {
                                    FEMS_UserLocationID = Convert.ToInt32(row[0]);
                                model.HiddenId = Convert.ToString(row["GuId"]);
                                model.UserLocationId = Convert.ToInt32(row["UserLocationId"]);
                                model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                                model.isStartDateFuture = isFutureDate;
                            }
                            //if (isAddMode)
                            //{
                            //    byte[] image = FEMSdbAccessDAL.GenerateQRCode(model.UserLocationCode + " + " + model.HiddenId.ToUpper());
                            //    FEMSUpdateQRCode(model, image);
                            //}



                        }
                        ds.Clear();

                    }
                    if (ups == 0)
                    {
                        Update_FEMS(UserLocationID, FEMS_UserLocationID, 1);
                    }
                    else
                    {
                    }
                }
                if (BEMS != 0)
                {
                    var DBAccessDAL = new MASTERBEMSDBAccessDAL();
                    using (SqlConnection con = new SqlConnection(DBAccessDAL.ConnectionString))
                    {
                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.Connection = con;
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.CommandText = "UspFM_MstLocationUserLocation_Save";

                            SqlParameter parameter = new SqlParameter();
                            cmd.Parameters.AddWithValue("@pUserLocationId", User_A_L_IDS.BEMS_UL_ID);
                            //cmd.Parameters.AddWithValue("@CustomerId", Customar_Mapping_IDS.BEMS_B_ID);
                            //cmd.Parameters.AddWithValue("@FacilityId", Facility_Mapping_IDS.BEMS_B_ID);

                            cmd.Parameters.AddWithValue("@CustomerId", _UserSession.CustomerId);
                            cmd.Parameters.AddWithValue("@FacilityId", _UserSession.FacilityId);
                            cmd.Parameters.AddWithValue("@BlockId", BEMS);
                            cmd.Parameters.AddWithValue("@LevelId", BEMS_Level);
                            cmd.Parameters.AddWithValue("@UserAreaId", BEMS_Area_ID);
                            cmd.Parameters.AddWithValue("@UserLocationCode", model.UserLocationCode);
                            cmd.Parameters.AddWithValue("@UserLocationName", model.UserLocationName);
                            cmd.Parameters.AddWithValue("@ActiveFromDate", model.ActiveFromDate != null ? model.ActiveFromDate.ToString("yyyy-MM-dd") : null);
                            cmd.Parameters.AddWithValue("@ActiveFromDateUTC", model.ActiveFromDate != null ? model.ActiveFromDate.ToString("yyyy-MM-dd") : null);
                            cmd.Parameters.AddWithValue("@ActiveToDate", model.ActiveToDate != null ? model.ActiveToDate.Value.ToString("yyyy-MM-dd") : null);
                            cmd.Parameters.AddWithValue("@ActiveToDateUTC", model.ActiveToDate != null ? model.ActiveToDate.Value.ToString("yyyy-MM-dd") : null);
                            cmd.Parameters.AddWithValue("@AuthorizedStaffId", model.AuthorizedStaffId);
                            cmd.Parameters.AddWithValue("@UserId", _UserSession.UserId);
                            cmd.Parameters.AddWithValue("@Active", model.Active == true ? "true" : "false");
                            cmd.Parameters.AddWithValue("@CompanyStaffId", model.CompanyStaffId);
                            // cmd.Parameters.AddWithValue("@pQRCode", image);

                            var da = new SqlDataAdapter();
                            da.SelectCommand = cmd;
                            da.Fill(ds);
                        }
                        if (ds.Tables.Count != 0)
                        {
                            foreach (DataRow row in ds.Tables[0].Rows)
                            {
                                BEMS_UserLocationID = Convert.ToInt32(row[0]);
                                model.HiddenId = Convert.ToString(row["GuId"]);
                                model.UserLocationId = Convert.ToInt32(row["UserLocationId"]);
                                model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                                model.isStartDateFuture = isFutureDate;
                            }
                            //if (isAddMode)
                            //{
                            //    byte[] image = DBAccessDAL.GenerateQRCode(model.UserLocationCode + " + " + model.HiddenId.ToUpper());
                            //    BEMSUpdateQRCode(model, image);
                            //}



                        }
                        ds.Clear();

                    }
                    if (ups == 0)
                    {
                        Update_FEMS(UserLocationID, BEMS_UserLocationID, 2);
                    }
                    else
                    {
                    }
                }

                    Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return modelmas;
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
        public void Update_FEMS(int Master_LocationID, int Module_ID, int Module_Type)
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
                        cmd.CommandText = "Master_Update_Location_All";

                        SqlParameter parameter = new SqlParameter();
                        cmd.Parameters.Add("@Master_LocationID", SqlDbType.Int).Value = Master_LocationID;
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
        public void UpdateQRCode(MstLocationUserLocation model, byte[] QRCodeImage)
        {
            var ds = new DataSet();
            var dbAccessDAL = new MASTERDBAccessDAL();

            using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = con;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "uspFM_MstLocationUserLocationQR_Update";
                    cmd.Parameters.AddWithValue("@pUserLocationId", model.UserLocationId);
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
        public void FEMSUpdateQRCode(MstLocationUserLocation model, byte[] QRCodeImage)
        {
            var ds = new DataSet();
            var dbAccessDAL = new MASTERFEMSDBAccessDAL();

            using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = con;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "uspFM_MstLocationUserLocationQR_Update";
                    cmd.Parameters.AddWithValue("@pUserLocationId", model.UserLocationId);
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
        public void BEMSUpdateQRCode(MstLocationUserLocation model, byte[] QRCodeImage)
        {
            var ds = new DataSet();
            var dbAccessDAL = new MASTERFEMSDBAccessDAL();

            using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = con;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "uspFM_MstLocationUserLocationQR_Update";
                    cmd.Parameters.AddWithValue("@pUserLocationId", model.UserLocationId);
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
                parameters.Add("@pUserLocationId", Id.ToString());
                DataTable dt = dbAccessDAL.GetMASTERDataTable("uspFM_MstLocationUserLocation_Delete", parameters, DataSetparameters);
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
                var QueryCondition = pageFilter.QueryWhereCondition;
                var strCondition = string.Empty;
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
                DataTable dt = dbAccessDAL.GetMASTERDataTable("UspFM_MstLocationUserLocation_GetAll", parameters, DataSetparameters);

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
            catch (Exception)
            {
                throw;
            }
        }
        public bool IsUserLocationCodeDuplicate(MstLocationUserLocation model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsUserLocationCodeDuplicate), Level.Info.ToString());
                var IsDuplicate = true;
                var dbAccessDAL = new MASTERDBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@Id", model.UserLocationId.ToString());
                parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@UserLocationCode", model.UserLocationCode.ToString());
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("UspFM_MstLocationUserLocation_ValCode", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    IsDuplicate = Convert.ToBoolean(dt.Rows[0]["IsDuplicate"]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(IsUserLocationCodeDuplicate), Level.Info.ToString());
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
        public bool IsRecordModified(MstLocationUserLocation model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsRecordModified), Level.Info.ToString());
                var dbAccessDAL = new MASTERDBAccessDAL();
                var recordModifed = false;

                if (model.UserLocationId != 0)
                {
                    var DataSetparameters = new Dictionary<string, DataTable>();
                    var parameters = new Dictionary<string, string>();
                    parameters.Add("@Id", model.UserLocationId.ToString());
                    DataTable dt = dbAccessDAL.GetMASTERDataTable("UspFM_MstLocationUserLocation_GetTimestamp", parameters, DataSetparameters);

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
        public User_Location Get_UserLocation(int Master_User_Location_IDS)
        {
            User_Location ULersids = new User_Location();
            var dss = new DataSet();
            var MasterdbAccessDAL = new MASTERDBAccessDAL();
            using (SqlConnection con = new SqlConnection(MasterdbAccessDAL.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = con;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "Get_MasterServices_byUserLocationId";
                    cmd.Parameters.AddWithValue("@UserLocationID", Master_User_Location_IDS);
                    var da = new SqlDataAdapter();
                    da.SelectCommand = cmd;
                    da.Fill(dss);
                }
            }
            if (dss.Tables.Count != 0)
            {

                ULersids.FEMS_UL_ID = Convert.ToInt32(dss.Tables[0].Rows[0]["FEMS"]);
                ULersids.BEMS_UL_ID = Convert.ToInt32(dss.Tables[0].Rows[0]["BEMS"]);
            }
            // Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
            return ULersids;
        }
    }
}
