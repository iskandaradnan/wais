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

namespace CP.UETrack.DAL.DataAccess.Implementations.LLS
{
    public class CleanLinenDespatchDAL : ICleanLinenDespatchDAL
    {
        private readonly string _FileName = nameof(CleanLinenDespatchDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
       

        public CleanLinenDespatchDAL()
        {

        }

        public CleanLinenDespatchModelLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                CleanLinenDespatchModelLovs CleanLinenDespatchDropdownvalues = null;

                var ds = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();

                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown_Others";
                        cmd.Parameters.AddWithValue("@pTablename", "LLSCleanLinenDespatch");
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                            CleanLinenDespatchDropdownvalues = new CleanLinenDespatchModelLovs();
                            CleanLinenDespatchDropdownvalues.DespatchedFrom = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                           
                        }
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return CleanLinenDespatchDropdownvalues;
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

        public CleanLinenDespatchModel Save(CleanLinenDespatchModel model, out string ErrorMessage)
            {
                try
                {
                    Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                var spName = string.Empty;
                var spNames = string.Empty;
                var ds = new DataSet();
                var ds2 = new DataSet();
                var ds3 = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                var parameters = new Dictionary<string, string>();
                var rowparameters = new Dictionary<string, string>();
                var DataSetparameters = new Dictionary<string, DataTable>();
                List<LUserCleanLinenItemList> DespatchdetailList = new List<LUserCleanLinenItemList>();
                DespatchdetailList = model.LUserCleanLinenItemGridList;
                DataTable dataTable = new DataTable("CleaLinenDespatch");
                DataTable dataTable1 = new DataTable("CleaLinenDespatchDet");
                DataTable varDt2 = new DataTable();
                //parameters.Add("@Remarks", Convert.ToString(model.Remarks));
                //parameters.Add("@ModifiedBy", _UserSession.UserId.ToString());
                //parameters.Add("@ModifiedDate", Convert.ToString(DateTime.Now));
                //parameters.Add("@ModifiedDateUTC", Convert.ToString(DateTime.UtcNow));
                //parameters.Add("@CleanLinenDespatchId", Convert.ToString(model.CleanLinenDespatchId));

                //// Delete grid
                var deletedId = model.LUserCleanLinenItemGridList.Where(y => y.IsDeleted).Select(x => x.CleanLinenDespatchDetId).ToList();
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
                if (model.CleanLinenDespatchId != 0)
                {
                    varDt2.Columns.Add("@CleanLinenDespatchDetId", typeof(int));
                    varDt2.Columns.Add("@ReceivedQuantity", typeof(string));
                    varDt2.Columns.Add("@DespatchedQuantity", typeof(string));
                    varDt2.Columns.Add("@Remarks", typeof(string));
                    varDt2.Columns.Add("@ModifiedBy", typeof(int));

                    foreach (var row in model.LUserCleanLinenItemGridList)
                    {
                        varDt2.Rows.Add(row.CleanLinenDespatchDetId, row.ReceivedQuantity,row.DespatchedQuantity,row.Remarks, _UserSession.UserId.ToString());
                    }
                    parameters.Clear();
                    DataSetparameters.Add("@LLSCleanLinenDespatchTxnDetUpdate", varDt2);
                    DataTable dsss = dbAccessDAL.GetMASTERDataTable("LLSCleanLinenDespatchTxnDetUpdate", parameters, DataSetparameters);
                    foreach (var obj in model.LUserCleanLinenItemGridList)
                    {
                        if (obj.CleanLinenDespatchDetId == 0)
                        {
                            spNames = "LLSCleanLinenDespatchTxnDetSave";
                            dataTable1.Columns.Add("CleanLinenDespatchId", typeof(int));
                            dataTable1.Columns.Add("LinenItemId", typeof(int));
                            dataTable1.Columns.Add("DespatchedQuantity", typeof(int));
                            dataTable1.Columns.Add("ReceivedQuantity", typeof(string));
                            dataTable1.Columns.Add("Variance", typeof(string));
                            dataTable1.Columns.Add("Remarks", typeof(string));
                            dataTable1.Columns.Add("LinenDescription", typeof(string));
                            dataTable1.Columns.Add("CreatedBy", typeof(int));
                            foreach (var rows in DespatchdetailList)
                            {
                                if (rows.CleanLinenDespatchDetId == 0)
                                {
                                    dataTable1.Rows.Add(
                                model.CleanLinenDespatchId,
                                rows.LinenItemId,
                                rows.DespatchedQuantity,
                                rows.ReceivedQuantity,
                                rows.Variance,
                                rows.Remarks,
                                rows.LinenDescription,
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
                                    daa.Fill(ds3);
                                }
                            }
                        }
                        if (obj.CleanLinenDespatchDetId == 0)
                        {
                            return model;
                        }
                        else
                        {
                        }
                    }
                    return model;
                }
                //
                else
                {
                    spName = "LLSCleanLinenDespatchTxnSave";
                }
                dataTable.Columns.Add("CustomerId", typeof(int));
                dataTable.Columns.Add("FacilityId", typeof(int));
                dataTable.Columns.Add("@pDocumentNo", typeof(string));
                dataTable.Columns.Add("DateReceived", typeof(DateTime));
                dataTable.Columns.Add("DespatchedFrom", typeof(int));
                dataTable.Columns.Add("ReceivedBy", typeof(int));
                dataTable.Columns.Add("NoOfPackages", typeof(decimal));
                dataTable.Columns.Add("TotalWeightKg", typeof(decimal));
                dataTable.Columns.Add("TotalReceivedPcs", typeof(int));
                dataTable.Columns.Add("CreatedBy", typeof(int));
                dataTable.Columns.Add("ModifiedBy", typeof(int));
                dataTable.Rows.Add(
                         _UserSession.CustomerId,
                        _UserSession.FacilityId,
                        model.DocumentNo,
                        model.DateReceived,
                        model.DespatchedFrom,
                        model.ReceivedBy,
                        model.NoOfPackages,
                        model.TotalWeightKg,
                        model.TotalReceivedPcs,
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
                    var CleanLinenDespatchId = Convert.ToInt32(ds.Tables[0].Rows[0]["CleanLinenDespatchId"]);
                    if (CleanLinenDespatchId != 0)
                        model.CleanLinenDespatchId = CleanLinenDespatchId;
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
                //----------------- Add Row Save
                if (model.CleanLinenDespatchDetId != 0)
                {


                }
                else
                {
                    spNames = "LLSCleanLinenDespatchTxnDetSave";
                    dataTable1.Columns.Add("CleanLinenDespatchId", typeof(int));
                    dataTable1.Columns.Add("LinenItemId", typeof(int));
                    dataTable1.Columns.Add("DespatchedQuantity", typeof(int));
                    dataTable1.Columns.Add("ReceivedQuantity", typeof(string));
                    dataTable1.Columns.Add("Variance", typeof(string));
                    dataTable1.Columns.Add("Remarks", typeof(string));
                    dataTable1.Columns.Add("LinenDescription", typeof(string));
                    dataTable1.Columns.Add("CreatedBy", typeof(int));
                    foreach (var row in DespatchdetailList)
                    {
                        dataTable1.Rows.Add(
                        model.CleanLinenDespatchId,
                        row.LinenItemId,
                        row.DespatchedQuantity,
                        row.ReceivedQuantity,
                        row.Variance,
                        row.Remarks,
                        row.LinenDescription,
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
                //--------------------End

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

        public bool IsCleanLinenDespatchDuplicate(CleanLinenDespatchModel model)
        {
            try
            {

                Log4NetLogger.LogEntry(_FileName, nameof(IsCleanLinenDespatchDuplicate), Level.Info.ToString());
                var IsDuplicate = true;
                var dbAccessDAL = new MASTERDBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@Id", model.CleanLinenDespatchId.ToString());
                parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@DocumentNo", model.DocumentNo.ToString());
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSCleanLinenDespatchTxn_ValCode", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    IsDuplicate = Convert.ToBoolean(dt.Rows[0]["IsDuplicate"]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(IsCleanLinenDespatchDuplicate), Level.Info.ToString());
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
        public bool IsRecordModified(CleanLinenDespatchModel model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsRecordModified), Level.Info.ToString());

                var recordModifed = false;

                if (model.CleanLinenDespatchId != 0)
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
                            cmd.Parameters.AddWithValue("Id", model.CleanLinenDespatchId);
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
        public CleanLinenDespatchModel Get(int Id)
        {
            
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                try
                {
                    CleanLinenDespatchModel model = new CleanLinenDespatchModel();
                    var ds = new DataSet();
                    var dbAccessDAL = new MASTERDBAccessDAL();
                    LUserCleanLinenItemList LUserCleanLinenItemList = new LUserCleanLinenItemList();
                    var DataSetparameters = new Dictionary<string, DataTable>();
                    var parameters = new Dictionary<string, string>();
                    parameters.Add("Id", Convert.ToString(Id));
                    DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSCleanLinenDespatchTxn_GetById", parameters, DataSetparameters);
                    if (dt != null && dt.Rows.Count > 0)
                    {
                        model.CleanLinenDespatchId = Id;
                        model.DocumentNo = Convert.ToString(dt.Rows[0]["DocumentNo"]);
                        model.DateReceived = Convert.ToDateTime(dt.Rows[0]["DateReceived"]);
                        model.LaundryPlantID = Convert.ToInt32(dt.Rows[0]["DespatchedFrom"]);
                        model.ReceivedBy = Convert.ToString(dt.Rows[0]["Received By"]);
                        model.NoOfPackages = Convert.ToInt32(dt.Rows[0]["NoOfPackages"]);
                        model.TotalWeightKg = Convert.ToDecimal(dt.Rows[0]["TotalWeightKg"]);
                        model.TotalReceivedPcs = Convert.ToInt32(dt.Rows[0]["TotalReceivedPcs"] == System.DBNull.Value ? null : dt.Rows[0]["TotalReceivedPcs"]);
                        model.GuId = Convert.ToString(dt.Rows[0]["GuId"]); 
                }
                    DataSet dt2 = dbAccessDAL.MasterGetDataSet("LLSCleanLinenDespatchTxnDet_GetById", parameters, DataSetparameters);
                    if (dt != null && dt2.Tables.Count > 0)
                    {
                        model.LUserCleanLinenItemGridList = (from n in dt2.Tables[0].AsEnumerable()
                                                                 select new LUserCleanLinenItemList
                                                                 {
                                                                     CleanLinenDespatchDetId = Convert.ToInt32(n["CleanLinenDespatchDetId"]),
                                                                     LinenCode = Convert.ToString(n["LinenCode"]),
                                                                     LinenDescription = Convert.ToString(n["LinenDescription"]),
                                                                     DespatchedQuantity = Convert.ToInt32(n["DespatchedQuantity"]),
                                                                     ReceivedQuantity = Convert.ToInt32(n["ReceivedQuantity"]),
                                                                     Variance = Convert.ToInt32(n["Variance"]),
                                                                     Remarks = Convert.ToString(n["Remarks"]),
                                                                     LinenItemId = Convert.ToInt32(n["LinenItemId"]),
                                                                 }).ToList();
                        model.LUserCleanLinenItemGridList.ForEach((x) =>
                        {
                            // entity.TotalCost = x.TotalCost;
                            //x.PageIndex = pageindex;
                            //x.FirstRecord = ((pageindex - 1) * pagesize) + 1;
                            //x.LastRecord = ((pageindex - 1) * pagesize) + pagesize;

                        });
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
                        cmd.CommandText = "LLSCleanLinenDespatchTxn_GetAll";

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
                DataTable dt = dbAccessDAL.GetDataTable("LLSCleanLinenDespatchTxn_Delete", parameters, DataSetparameters);
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
                        cmd.CommandText = "LLSCleanLinenDespatchTxnDetSingle_Delete";
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
