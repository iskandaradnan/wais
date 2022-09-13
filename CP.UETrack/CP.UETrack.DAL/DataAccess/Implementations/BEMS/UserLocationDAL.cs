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
using UETrack.DAL;

namespace CP.UETrack.DAL.DataAccess.Implementations.BEMS
{
    public class UserLocationDAL : IUserLocationDAL
    {
        private readonly string _FileName = nameof(UserLocationDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public UserLocationDAL()
        {
        }
        public MstLocationUserLocationLovs Load(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dal = new UserAreaDAL();
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
                var dbAccessDAL = new FEMSDBAccessDAL();
                var obj = new MstLocationUserLocation();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@Id", Id.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("UspFM_MstLocationUserLocation_GetById", parameters, DataSetparameters);
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
                var dbAccessDAL = new FEMSDBAccessDAL();
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
                        model.UserLocationId = Convert.ToInt32(row["UserLocationId"]);
                        model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                        model.HiddenId = Convert.ToString(row["GuId"]);
                        model.UserLocationCode = Convert.ToString(row["UserLocationCode"]);
                        model.isStartDateFuture = isFutureDate;

                    }
                    //if (isAddMode)
                    //{
                    //    byte[] image = commonDAL.GenerateQRCode(model.UserLocationCode + " + " + model.HiddenId.ToUpper());
                    //    UpdateQRCode(model, image);
                    //}
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

        public void UpdateQRCode(MstLocationUserLocation model, byte[] QRCodeImage)
        {
            var ds = new DataSet();
            var dbAccessDAL = new FEMSDBAccessDAL();

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
                var dbAccessDAL = new FEMSDBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pUserLocationId", Id.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_MstLocationUserLocation_Delete", parameters, DataSetparameters);
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
                var dbAccessDAL = new FEMSDBAccessDAL();

                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@PageIndex", pageFilter.PageIndex.ToString());
                parameters.Add("@PageSize", pageFilter.PageSize.ToString());
                parameters.Add("@strCondition", strCondition);
                parameters.Add("@strSorting", strOrderBy);
                DataTable dt = dbAccessDAL.GetDataTable("UspFM_MstLocationUserLocation_GetAll", parameters, DataSetparameters);

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
                var dbAccessDAL = new FEMSDBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@Id", model.UserLocationId.ToString());
                parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@UserLocationCode", model.UserLocationCode.ToString());
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                DataTable dt = dbAccessDAL.GetDataTable("UspFM_MstLocationUserLocation_ValCode", parameters, DataSetparameters);
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
                var dbAccessDAL = new FEMSDBAccessDAL();
                var recordModifed = false;

                if (model.UserLocationId != 0)
                {
                    var DataSetparameters = new Dictionary<string, DataTable>();
                    var parameters = new Dictionary<string, string>();
                    parameters.Add("@Id", model.UserLocationId.ToString());
                    DataTable dt = dbAccessDAL.GetDataTable("UspFM_MstLocationUserLocation_GetTimestamp", parameters, DataSetparameters);

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


        public MstLocationUserLocation Save(int i,MstLocationUserLocation model)
        {
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
                var dbAccessDAL = new FEMSDBAccessDAL();
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
                        model.UserLocationId = Convert.ToInt32(row["UserLocationId"]);
                        model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                        model.HiddenId = Convert.ToString(row["GuId"]);
                        model.UserLocationCode = Convert.ToString(row["UserLocationCode"]);
                        model.isStartDateFuture = isFutureDate;

                    }
                    //if (isAddMode)
                    //{
                    //    byte[] image = commonDAL.GenerateQRCode(model.UserLocationCode + " + " + model.HiddenId.ToUpper());
                    //    UpdateQRCode(model, image);
                    //}
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
    }
}
