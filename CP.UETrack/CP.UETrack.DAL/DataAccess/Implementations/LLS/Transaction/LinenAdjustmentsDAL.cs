using CP.UETrack.DAL.DataAccess.Contracts.LLS;
using CP.UETrack.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.UETrack.Models;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using UETrack.DAL;
using System.Dynamic;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model.LLS;
using CP.UETrack.DAL.DataAccess.Contracts.LLS.Transaction;

namespace CP.UETrack.DAL.DataAccess.Implementations.LLS.Transaction
{
    public class LinenAdjustmentsDAL: ILinenAdjustmentsDAL
    {
        private readonly string _FileName = nameof(LinenAdjustmentsDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public LinenAdjustmentsDAL()
        {

        }

       
        public LinenAdjustmentsModelLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                LinenAdjustmentsModelLovs UserFacilitiesEquipmentToolsModelLovs = new LinenAdjustmentsModelLovs();
                string lovs = "StatusValue";
                var dbAccessDAL = new BEMSDBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pLovKey", lovs);
                DataSet ds = dbAccessDAL.GetDataSet("uspFM_Dropdown", parameters, DataSetparameters);
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {

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

        public LinenAdjustmentsModel Save(LinenAdjustmentsModel model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                var spName = string.Empty;
                var spNames = string.Empty;
                var ds = new DataSet();
                var ds2 = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                var parameters = new Dictionary<string, string>();
                DataTable addRow = new DataTable();
                var rowparameters = new Dictionary<string, string>();
                var EffectiveDate = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                var DataSetparameters = new Dictionary<string, DataTable>();
                List<LLinenAdjustmentLinenItemList> LinenAdjustdetailList = new List<LLinenAdjustmentLinenItemList>();
                LinenAdjustdetailList = model.LLinenAdjustmentLinenItemListGrid;
                DataTable dataTable = new DataTable("LinenAdjustmentMst");
                DataTable dataTable1 = new DataTable("LinenAdjustmentMstDet");
                DataTable varDt2 = new DataTable();
                //// Delete grid
                var deletedId = model.LLinenAdjustmentLinenItemListGrid.Where(y => y.IsDeleted).Select(x => x.LinenAdjustmentDetId).ToList();
                var idstring = string.Empty;
                if (deletedId.Count() > 0)
                {
                    foreach (var item in deletedId.Select((value, var) => new { var, value }))
                    {
                        idstring += item.value;
                        if (item.var != deletedId.Count() - 1)
                        { idstring += ","; }
                    }
                    deleteChildrecords(idstring);
                }

                if (model.LinenAdjustmentId != 0)
                {
                    parameters.Add("@AuthorisedBy", Convert.ToString(model.AuthorisedById));
                    parameters.Add("@LinenAdjustmentId", Convert.ToString(model.LinenAdjustmentId));
                    parameters.Add("@Remarks", Convert.ToString(model.Remarks));
                    parameters.Add("@ModifiedBy", _UserSession.UserId.ToString());

                    DataTable dss = dbAccessDAL.GetMASTERDataTable("LLSLinenAdjustmentTxn_Update", parameters, DataSetparameters);
                    varDt2.Columns.Add("@Justification", typeof(string));
                    varDt2.Columns.Add("ModifiedBy", typeof(int));
                    varDt2.Columns.Add("@LinenAdjustmentDetId", typeof(int));
                    foreach (var row in model.LLinenAdjustmentLinenItemListGrid)
                    {
                        varDt2.Rows.Add(row.Justification, _UserSession.UserId.ToString(), row.LinenAdjustmentDetId);
                    }
                    parameters.Clear();
                    DataSetparameters.Add("@LLSLinenAdjustmentTxnDet_Update", varDt2);
                    DataTable dsss = dbAccessDAL.GetMASTERDataTable("LLSLinenAdjustmentTxnDet_Update", parameters, DataSetparameters);
                    foreach (var obj in model.LLinenAdjustmentLinenItemListGrid)
                    {
                        if (obj.LinenAdjustmentDetId == 0)
                        {
                            spNames = "LLSLinenAdjustmentTxnDet_Save";
                            dataTable1.Columns.Add("LinenAdjustmentId", typeof(int));
                            dataTable1.Columns.Add("CustomerId", typeof(int));
                            dataTable1.Columns.Add("FacilityID", typeof(int));
                            dataTable1.Columns.Add("LinenItemId", typeof(int));
                            dataTable1.Columns.Add("ActualQuantity", typeof(int));
                            dataTable1.Columns.Add("StoreBalance", typeof(int));
                            dataTable1.Columns.Add("AdjustQuantity", typeof(int));
                            dataTable1.Columns.Add("Justification", typeof(string));
                            dataTable1.Columns.Add("CreatedBy", typeof(int));
                            foreach (var row in LinenAdjustdetailList)
                            {
                                if (row.LinenAdjustmentDetId == 0)
                                {
                                    dataTable1.Rows.Add(
                                       model.LinenAdjustmentId,
                                       _UserSession.CustomerId,
                                       _UserSession.FacilityId,
                                       row.LinenItemId,
                                       row.ActualQuantity,
                                       row.StoreBalance,
                                       row.AdjustQuantity,
                                       row.Justification,
                                       _UserSession.UserId.ToString()
                                   );
                                }
                            }
                            using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                            {
                                using (SqlCommand cmd = new SqlCommand())
                                {
                                    cmd.Connection = con;
                                    cmd.CommandType = CommandType.StoredProcedure;
                                    cmd.CommandText = spNames;
                                    SqlParameter parameter = new SqlParameter();
                                    parameter.ParameterName = "@Block";
                                    parameter.SqlDbType = System.Data.SqlDbType.Structured;
                                    parameter.Value = dataTable1;
                                    cmd.Parameters.Add(parameter);
                                    var daa = new SqlDataAdapter();
                                    daa.SelectCommand = cmd;
                                    daa.Fill(ds2);
                                }
                            }
                        }
                        if (obj.LinenAdjustmentDetId == 0)
                        {
                            return model;
                        }
                        else
                        {
                        }
                    }
                        return model;
                    }

                else
                {
                    spName = "LLSLinenAdjustmentTxn_Save";
                }
                dataTable.Columns.Add("CustomerId", typeof(int));
                dataTable.Columns.Add("FacilityId", typeof(int));
                dataTable.Columns.Add("DocumentNo", typeof(string));
                dataTable.Columns.Add("DocumentDate", typeof(DateTime));
                dataTable.Columns.Add("AuthorisedBy", typeof(string));
                dataTable.Columns.Add("LinenInventoryId", typeof(int));
                dataTable.Columns.Add("Date", typeof(DateTime));
                dataTable.Columns.Add("Status", typeof(int));
                dataTable.Columns.Add("Remarks", typeof(string));
                dataTable.Columns.Add("CreatedBy", typeof(int));
                dataTable.Columns.Add("ModifiedBy", typeof(int));

                dataTable.Rows.Add(
                    _UserSession.CustomerId,
                    _UserSession.FacilityId,
                    model.DocumentNo,
                    model.DocumentDate,
                    model.AuthorisedBy,
                    model.LinenInventoryIds,
                    model.Date,
                    model.Status,
                    model.Remarks,
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
                        parameter.ParameterName = "@LLSLinenAdjustment";
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
                    var LinenAdjustmentId = Convert.ToInt32(ds.Tables[0].Rows[0]["LinenAdjustmentId"]);
                    if (LinenAdjustmentId != 0)
                        model.LinenAdjustmentId = LinenAdjustmentId;
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

               
                #region Add Row Save
                if (model.LinenAdjustmentDetId != 0)
                {

                }
                else
                {
                    spNames = "LLSLinenAdjustmentTxnDet_Save";
                    dataTable1.Columns.Add("LinenAdjustmentId", typeof(int));
                    dataTable1.Columns.Add("CustomerId", typeof(int));
                    dataTable1.Columns.Add("FacilityID", typeof(int));
                    dataTable1.Columns.Add("LinenItemId", typeof(int));
                    dataTable1.Columns.Add("ActualQuantity", typeof(int));
                    dataTable1.Columns.Add("StoreBalance", typeof(int));
                    dataTable1.Columns.Add("AdjustQuantity", typeof(int));
                    dataTable1.Columns.Add("Justification", typeof(string));
                    dataTable1.Columns.Add("CreatedBy", typeof(int));
                    foreach (var row in LinenAdjustdetailList)
                    {
                        dataTable1.Rows.Add(
                        model.LinenAdjustmentId,
                        _UserSession.CustomerId,
                        _UserSession.FacilityId,
                        row.LinenItemId,
                        row.ActualQuantity,
                        row.StoreBalance,
                        row.AdjustQuantity,
                        row.Justification,
                         _UserSession.UserId.ToString()
                        );
                    }
                    using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                    {
                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.Connection = con;
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.CommandText = spNames;
                            SqlParameter parameter = new SqlParameter();
                            parameter.ParameterName = "@Block";
                            parameter.SqlDbType = System.Data.SqlDbType.Structured;
                            parameter.Value = dataTable1;
                            cmd.Parameters.Add(parameter);
                            var daa = new SqlDataAdapter();
                            daa.SelectCommand = cmd;
                            daa.Fill(ds2);
                        }
                    }
                }
                #endregion

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


        public LinenAdjustmentsModel Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                LinenAdjustmentsModel model = new LinenAdjustmentsModel();
                var ds = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                LLinenAdjustmentLinenItemList LLinenAdjustmentLinenItemList = new LLinenAdjustmentLinenItemList();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("Id", Convert.ToString(Id));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSLinenAdjustmentTxn_GetById", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    model.LinenAdjustmentId = Id;
                    model.DocumentNo = Convert.ToString(dt.Rows[0]["DocumentNo"]);
                    model.DocumentDate = Convert.ToDateTime(dt.Rows[0]["DocumentDate"]);
                    model.AuthorisedBy = Convert.ToString(dt.Rows[0]["AuthorisedBy"]);
                    model.AuthorisedById = Convert.ToInt32(dt.Rows[0]["hdnTypeCodeId"]);
                    model.LinenInventoryId = Convert.ToString(dt.Rows[0]["LinenInventoryDocumentNo"]== System.DBNull.Value ? null : dt.Rows[0]["LinenInventoryDocumentNo"]);
                    if (dt.Rows[0]["Date"] != null )
                    {

                    }
                    else
                    {
                        model.Date = Convert.ToDateTime(dt.Rows[0]["Date"] == System.DBNull.Value ? null : dt.Rows[0]["Date"]);
                    }
                    model.Status = Convert.ToString(dt.Rows[0]["Status"]);
                    model.Remarks = Convert.ToString((dt.Rows[0]["Remarks"]) == System.DBNull.Value ? null : dt.Rows[0]["Remarks"]);


                }
                DataSet dt2 = dbAccessDAL.MasterGetDataSet("LLSLinenAdjustmentTxnDet_GetById", parameters, DataSetparameters);
                if (dt != null && dt2.Tables.Count > 0)
                {
                    model.LLinenAdjustmentLinenItemListGrid = (from n in dt2.Tables[0].AsEnumerable()
                                                             select new LLinenAdjustmentLinenItemList
                                                             {
                                                                 LinenAdjustmentDetId = Convert.ToInt32(n["LinenAdjustmentDetId"]),
                                                                 LinenCode = Convert.ToString(n["LinenCode"]),
                                                                 LinenDescription = Convert.ToString(n["LinenDescription"]),
                                                                 ActualQuantity = Convert.ToInt32(n["ActualQuantity"]) ,
                                                                 StoreBalance = Convert.ToDecimal((n["StoreBalance"]) != DBNull.Value ? (Convert.ToDecimal(n["StoreBalance"])) : (Decimal?)null),
                                                                 AdjustQuantity = Convert.ToInt32((n["AdjustQuantity"]) != DBNull.Value ? (Convert.ToInt32(n["AdjustQuantity"])) : (int?)null),
                                                                 Justification = Convert.ToString(n["Justification"]),
                                                                 
                                                             }).ToList();
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
                        cmd.CommandText = "LLSLinenAdjustmentTxn_GetAll";
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
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void Delete(int Id, out string ErrorMessage)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            try
            {
                ErrorMessage = string.Empty;
                var dbAccessDAL = new BEMSDBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@Id", Id.ToString());
                parameters.Add("@ModifiedBy", _UserSession.UserId.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("LLSLinenAdjustmentTxn_Delete", parameters, DataSetparameters);
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

        public bool IsLinenAdjustmentDuplicate(LinenAdjustmentsModel model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsLinenAdjustmentDuplicate), Level.Info.ToString());
                var IsDuplicate = true;
                var dbAccessDAL = new BEMSDBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@Id", model.LinenAdjustmentId.ToString());
                parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@DocumentNo", Convert.ToString(model.DocumentNo));
                DataTable dt = dbAccessDAL.GetDataTable("LLSLinenAdjustmentTxn_ValCode", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    IsDuplicate = Convert.ToBoolean(dt.Rows[0]["IsDuplicate"]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(IsLinenAdjustmentDuplicate), Level.Info.ToString());
                return IsDuplicate;

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
        public bool IsRecordModified(LinenAdjustmentsModel model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsRecordModified), Level.Info.ToString());
                var recordModifed = false;
                if (model.LinenAdjustmentId != 0)
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
                            cmd.Parameters.AddWithValue("Id", model.LinenAdjustmentId);
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
        public void deleteChildrecords(string id)
        {
            try
            {
                var ds = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "LLSLinenAdjustmentTxnDetSingle_Delete";
                        cmd.Parameters.AddWithValue("@ID", id);
                        cmd.Parameters.AddWithValue("@ModifiedBy", _UserSession.UserId.ToString());
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
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
    }
}
