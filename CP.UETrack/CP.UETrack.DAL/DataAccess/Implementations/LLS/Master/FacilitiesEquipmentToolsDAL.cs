using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.LLS;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using CP.UETrack.Model.LLS;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UETrack.DAL;

namespace CP.UETrack.DAL.DataAccess.Implementations.LLS

{
    public class FacilitiesEquipmentToolsDAL : IFacilitiesEquipmentToolsDAL
    {
        private readonly string _FileName = nameof(FacilitiesEquipmentToolsDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public FacilitiesEquipmentToolsDAL()
        {

        }

        public FacilitiesEquipmentToolsModelLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                FacilitiesEquipmentToolsModelLovs UserFacilitiesEquipmentToolsModelLovs = new FacilitiesEquipmentToolsModelLovs();
                string lovs = "ItemTypeValues,StatusValue";
                var dbAccessDAL = new BEMSDBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pLovKey", lovs);
                DataSet ds = dbAccessDAL.GetDataSet("uspFM_Dropdown", parameters, DataSetparameters);
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    UserFacilitiesEquipmentToolsModelLovs.ItemType = dbAccessDAL.GetLovRecords(ds.Tables[0], "ItemTypeValues");
                    UserFacilitiesEquipmentToolsModelLovs.Status = dbAccessDAL.GetLovRecords(ds.Tables[0], "StatusValue");

                }


                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return UserFacilitiesEquipmentToolsModelLovs;
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

        public FacilitiesEquipmentToolsModel Save(FacilitiesEquipmentToolsModel model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                var spName = string.Empty;
                var ds = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                var parameters = new Dictionary<string, string>();
                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable dataTable = new DataTable("LLSFacilityEquipToolsConsumeMst");
                parameters.Add("@ItemDescription", Convert.ToString(model.ItemDescription));
                parameters.Add("@ItemType", Convert.ToString(model.ItemType));
                parameters.Add("@Status", Convert.ToString(model.Status));
                parameters.Add("@EffectiveFromDate", Convert.ToString(model.EffectiveFromDate == null || model.EffectiveFromDate == DateTime.MinValue ? null : model.EffectiveFromDate.ToString("MM-dd-yyy HH:mm")));
                parameters.Add("@EffectiveToDate", Convert.ToString(model.EffectiveToDate == null || model.EffectiveToDate == DateTime.MinValue ? null : model.EffectiveToDate.ToString("MM-dd-yyy HH:mm")));
                parameters.Add("@FETCId", Convert.ToString(model.FETCId));
                parameters.Add("@ModifiedBy", _UserSession.UserId.ToString());
                if (model.FETCId != 0)
                {
                    DataTable dss = dbAccessDAL.GetMASTERDataTable("LLSFacilityEquipToolsConsumeMst_Update", parameters, DataSetparameters);
                    return model;
                }
                else
                {
                    spName = "LLSFacilityEquipToolsConsumeMst_Save";
                }
                dataTable.Columns.Add("CustomerId", typeof(int));
                dataTable.Columns.Add("FacilityID", typeof(int));
                dataTable.Columns.Add("ItemCode", typeof(string));
                dataTable.Columns.Add("ItemDescription", typeof(string));
                dataTable.Columns.Add("ItemType", typeof(int));
                dataTable.Columns.Add("Status", typeof(int));
                dataTable.Columns.Add(new DataColumn("EffectiveFromDate", typeof(DateTime)));
                dataTable.Columns.Add(new DataColumn("EffectiveToDate", typeof(DateTime)));
                dataTable.Columns.Add("CreatedBy", typeof(int));
                dataTable.Columns.Add("ModifiedBy", typeof(int));
                dataTable.Rows.Add(
                    _UserSession.CustomerId,
                    _UserSession.FacilityId,
                    model.ItemCode,
                    model.ItemDescription,
                    model.ItemType,
                    model.Status,
                    Convert.ToDateTime(model.EffectiveFromDate),
                     Convert.ToDateTime(model.EffectiveToDate),
                        _UserSession.UserId.ToString(),
                        _UserSession.UserId.ToString()
                    );
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = spName;
                        SqlParameter parameter = new SqlParameter();
                        parameter.ParameterName = "@Block";
                        parameter.SqlDbType = System.Data.SqlDbType.Structured;
                        parameter.Value = dataTable;
                        cmd.Parameters.Add(parameter);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0)
                {
                    var FETCid = Convert.ToInt32(ds.Tables[0].Rows[0]["FETCId"]);
                    if (FETCid != 0)
                        model.FETCId = FETCid;
                    if (ds.Tables[0].Rows[0]["Timestamp"] == DBNull.Value)
                    {
                        model.Timestamp = "";
                    }
                    else
                    {
                        model.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                    }
                    ErrorMessage = Convert.ToString(ds.Tables[0].Rows[0]["ErrorMsg"]);
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
                throw ex;
            }

        }


        public FacilitiesEquipmentToolsModel Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                FacilitiesEquipmentToolsModel model = null;

                var ds = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "LLSFacilityEquipToolsConsumeMst_GetById";
                        cmd.Parameters.AddWithValue("Id", Id);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0)
                {

                    model = (from n in ds.Tables[0].AsEnumerable()
                             select new FacilitiesEquipmentToolsModel
                             {
                                 FETCId = Id,
                                 ItemCode = Convert.ToString(n["ItemCode"]),
                                 ItemDescription = Convert.ToString(n["ItemDescription"]),
                                 ItemType = Convert.ToString(n["ItemType"]),
                                 Statuss = Convert.ToInt32(n["Status"]),
                                 EffectiveFromDate = Convert.ToDateTime(n["EffectiveFromDate"]),
                                 EffectiveToDate = Convert.ToDateTime(n["EffectiveToDate"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["EffectiveToDate"]),
                             }).FirstOrDefault();


                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
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
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "LLSFacilityEquipToolsConsumeMst_GetAll";

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

        public void Delete(int Id, out string ErrorMessage)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            try
            {
                ErrorMessage = string.Empty;
                var dbAccessDAL = new MASTERDBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@ID", Id.ToString());
                parameters.Add("@ModifiedBy", _UserSession.UserId.ToString());
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSFacilityEquipToolsConsumeMst_Delete", parameters, DataSetparameters);
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


        public bool IsFacilityEquipmentDuplicate(FacilitiesEquipmentToolsModel model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsFacilityEquipmentDuplicate), Level.Info.ToString());

                var isDuplicate = true;
                var dbAccessDAL = new MASTERDBAccessDAL();


                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@Id", model.FETCId.ToString());
                parameters.Add("@ItemCode", model.ItemCode.ToString());
                parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSFacilityEquipToolsConsumeMst_ValCode", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    isDuplicate = Convert.ToBoolean(dt.Rows[0]["isDuplicate"]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(IsFacilityEquipmentDuplicate), Level.Info.ToString());
                return isDuplicate;
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


        public bool IsRecordModified(FacilitiesEquipmentToolsModel model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsRecordModified), Level.Info.ToString());

                var recordModifed = false;

                if (model.FETCId != 0)
                {
                    var ds = new DataSet();
                    string constring = ConfigurationManager.ConnectionStrings["BEMSUETrackConnectionString"].ConnectionString;
                    using (SqlConnection con = new SqlConnection(constring))
                    {
                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.Connection = con;
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.CommandText = "GetBlockTimestamp";
                            cmd.Parameters.AddWithValue("Id", model.FETCId);
                            var da = new SqlDataAdapter();
                            da.SelectCommand = cmd;
                            da.Fill(ds);
                        }
                    }
                    if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        var timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
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

