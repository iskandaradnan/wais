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
    public  class AssetClassificationDAL: IAssetClassificationDAL
    {
        private readonly string _FileName = nameof(AssetClassificationDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public AssetClassificationDAL()
        {

        }
        public AssetClassificationLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                AssetClassificationLovs assetClassificationLovs = null;

                var ds = new DataSet();
                var srevicesDS = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "UspBEMS_EngAssetClassification_GetLovs";
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                        //Get services
                        var da2 = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_GetServices";
                        cmd.Parameters.Clear();
                        //  cmd.Parameters.AddWithValue("@UserRegistrationId", _UserSession.UserId);
                        da2.SelectCommand = cmd;
                        da2.Fill(srevicesDS);
                    }
                }
                if (ds.Tables.Count != 0)
                {
                    assetClassificationLovs = new AssetClassificationLovs();
                    //assetClassificationLovs.StatusList = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                    assetClassificationLovs.ServiceList = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                    
                }
                if (ds.Tables.Count != 0)
                {
                    assetClassificationLovs.Services = dbAccessDAL.GetLovRecords(srevicesDS.Tables[0]);
                }
                    Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return assetClassificationLovs;
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
        public EngAssetClassification Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var obj = new EngAssetClassification();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@Id", Id.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("UspBEMS_EngAssetClassification_Get", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    obj.AssetClassificationId  = Convert.ToInt16(dt.Rows[0]["AssetClassificationId"]);
                    obj.AssetClassification =Convert.ToString(dt.Rows[0]["AssetClassificationDescription"]);
                    obj.AssetClassificationCode = Convert.ToString(dt.Rows[0]["AssetClassificationCode"]);
                    obj.Active = Convert.ToBoolean(dt.Rows[0]["Active"]);
                    obj.ServiceId = Convert.ToInt32(dt.Rows[0]["ServiceId"]);
                    obj.Remarks = Convert.ToString(dt.Rows[0]["Remarks"]);
                    obj.Timestamp = Convert.ToBase64String((byte[])(dt.Rows[0]["Timestamp"]));
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
        public EngAssetClassification SaveUpdate(EngAssetClassification model)
        {
            int masterId=0, childId=0;
            string services="";
            Log4NetLogger.LogEntry(_FileName,nameof(SaveUpdate), Level.Info.ToString());
            try
            {

                if(model.ServiceId == 2)
                {
                    services = "BEMS";
                }
                else
                {
                    services = "FEMS";
                }
                var dbAccessDAL = new MASTERDBAccessDAL();
                var obj = new EngAssetClassification();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@AssetClassificationId", Convert.ToString(model.AssetClassificationId));
                parameters.Add("@AssetClassification", Convert.ToString(model.AssetClassification));
                parameters.Add("@AssetClassificationCode", Convert.ToString(model.AssetClassificationCode));
                parameters.Add("@ServiceId", Convert.ToString(model.ServiceId));
                parameters.Add("@Active", model.Active == true ? "true" : "false");
                parameters.Add("@Remarks", Convert.ToString(model.Remarks));
                parameters.Add("@UserId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@Servicename", Convert.ToString(services));

                DataTable ds = dbAccessDAL.GetMASTERDataTable("UspBEMS_EngAssetClassification_Save", parameters, DataSetparameters);
                if (ds != null)
                {
                    foreach (DataRow row in ds.Rows)
                    {
                        masterId = Convert.ToInt32(row["AssetClassificationId"]);
                        model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    }
                }
                if(model.ServiceId==2)
                {
                
                var dbAccessDALBEMS = new MASTERBEMSDBAccessDAL();
                var objBEMS = new EngAssetClassification();
                var DataSetparametersBEMS = new Dictionary<string, DataTable>();
                var parametersBEMS = new Dictionary<string, string>();
                parametersBEMS.Add("@AssetClassificationId", Convert.ToString(model.AssetClassificationId));
                parametersBEMS.Add("@AssetClassification", Convert.ToString(model.AssetClassification));
                parametersBEMS.Add("@AssetClassificationCode", Convert.ToString(model.AssetClassificationCode));
                parametersBEMS.Add("@ServiceId", Convert.ToString(model.ServiceId));
                parametersBEMS.Add("@Active", model.Active == true ? "true" : "false");
                parametersBEMS.Add("@Remarks", Convert.ToString(model.Remarks));
                parametersBEMS.Add("@UserId", Convert.ToString(_UserSession.UserId));
                DataTable dsBEMS = dbAccessDALBEMS.GetMasterDataTable("UspBEMS_EngAssetClassification_Save", parametersBEMS, DataSetparametersBEMS);
                if (dsBEMS != null)
                {
                    foreach (DataRow row in dsBEMS.Rows)
                    {
                            childId = Convert.ToInt32(row["AssetClassificationId"]);
                        model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    }
                }
                }
                else
                {
                    var dbAccessDALFEMS = new MASTERFEMSDBAccessDAL();
                    var objFEMS = new EngAssetClassification();
                    var DataSetparametersFEMS = new Dictionary<string, DataTable>();
                    var parametersFEMS = new Dictionary<string, string>();
                    parametersFEMS.Add("@AssetClassificationId", Convert.ToString(model.AssetClassificationId));
                    parametersFEMS.Add("@AssetClassification", Convert.ToString(model.AssetClassification));
                    parametersFEMS.Add("@AssetClassificationCode", Convert.ToString(model.AssetClassificationCode));
                    parametersFEMS.Add("@ServiceId", Convert.ToString(model.ServiceId));
                    parametersFEMS.Add("@Active", model.Active == true ? "true" : "false");
                    parametersFEMS.Add("@Remarks", Convert.ToString(model.Remarks));
                    parametersFEMS.Add("@UserId", Convert.ToString(_UserSession.UserId));
                    DataTable dsFEMS = dbAccessDALFEMS.GetMasterDataTable("UspBEMS_EngAssetClassification_Save", parametersFEMS, DataSetparametersFEMS);
                    if (dsFEMS != null)
                    {
                        foreach (DataRow row in dsFEMS.Rows)
                        {
                            childId = Convert.ToInt32(row["AssetClassificationId"]);
                            //model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                        }
                    }

                }
               
                parameters.Clear();
                parameters.Add("@EngAssetClass", Convert.ToString(childId));
                parameters.Add("@Master_AssetClassificationId", Convert.ToString(masterId));
                ds.Clear();
                ds = dbAccessDAL.GetMASTERDataTable("Master_Updae_EngAssetClassification_AssetClassification_mappingTo_SeviceDB", parameters, DataSetparameters);
              
                 model.AssetClassificationId = Convert.ToInt32(masterId);



                Log4NetLogger.LogExit(_FileName, nameof(SaveUpdate), Level.Info.ToString());
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
        public void Delete(int Id, out string ErrorMessage)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            try
            {
                ErrorMessage = string.Empty;
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pAssetClassificationId", Id.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EngAssetClassification_Delete", parameters, DataSetparameters);
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
                DataTable dt = dbAccessDAL.GetDataTable("UspBEMS_EngAssetClassification_GetAll", parameters, DataSetparameters);

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
        public GridFilterResult GetAll(SortPaginateFilter pageFilter, int Id)
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
                DataTable dt = dbAccessDAL.GetDataTable("UspBEMS_EngAssetClassification_GetAll", parameters, DataSetparameters);

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
        public GridFilterResult GetAllFEMS(SortPaginateFilter pageFilter)
        {
            try
            {
                
                  var dbAccessDAL = new MASTERFEMSDBAccessDAL();
                    
                
                Log4NetLogger.LogEntry(_FileName, nameof(GetAllFEMS), Level.Info.ToString());
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
               // var dbAccessDAL = new MASTERDBAccessDAL();

                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@PageIndex", pageFilter.PageIndex.ToString());
                parameters.Add("@PageSize", pageFilter.PageSize.ToString());
                parameters.Add("@strCondition", pageFilter.QueryWhereCondition);
                parameters.Add("@strSorting", strOrderBy);
                DataTable dt = dbAccessDAL.GetMasterDataTable("UspBEMS_EngAssetClassification_GetAll", parameters, DataSetparameters);

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
                Log4NetLogger.LogExit(_FileName, nameof(GetAllFEMS), Level.Info.ToString());
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
        public bool IsClassificationCodeDuplicate(EngAssetClassification model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsClassificationCodeDuplicate), Level.Info.ToString());

                var IsDuplicate = true;
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@Id", model.AssetClassificationId.ToString());
                parameters.Add("@AssetClassificationCode", model.AssetClassificationCode.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("UspFM_EngAssetClassification_ValCode", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    IsDuplicate = Convert.ToBoolean(dt.Rows[0]["IsDuplicate"]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(IsClassificationCodeDuplicate), Level.Info.ToString());
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
        public bool IsRecordModified(EngAssetClassification model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsRecordModified), Level.Info.ToString());
                var dbAccessDAL = new DBAccessDAL();
                var recordModifed = false;

                if (model.AssetClassificationId != 0)
                {
                    var DataSetparameters = new Dictionary<string, DataTable>();
                    var parameters = new Dictionary<string, string>();
                    parameters.Add("@Id", model.AssetClassificationId.ToString());
                    DataTable dt = dbAccessDAL.GetDataTable("UspFM_EngAssetClassification_GetTimestamp", parameters, DataSetparameters);

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
