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

namespace CP.UETrack.DAL.DataAccess.Implementations.LLS
{
    public class LinenInjectionDAL : ILinenInjectionDAL
    {
        private readonly string _FileName = nameof(LinenInjectionDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public LinenInjectionDAL()
        {

        }

        public LinenInjectionModel Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                LinenInjectionModel LinenInjectionModel = null;



                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                LinenInjectionModel = new LinenInjectionModel();
                return LinenInjectionModel;
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

        public LinenConemnationModel Save(LinenConemnationModel model, out string ErrorMessage)
            {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                var spName = string.Empty;
                var ds = new DataSet();
                var ds2 = new DataSet();
                var spNames = string.Empty;
                var dbAccessDAL = new MASTERDBAccessDAL();
                var parameters = new Dictionary<string, string>();
                var rowparameters = new Dictionary<string, string>();
                var DataSetparameters = new Dictionary<string, DataTable>();
                List<LLinenInjectionLinenItem> LineninjectdetailLists = new List<LLinenInjectionLinenItem>();
                LineninjectdetailLists = model.LLinenInjectionLinenItemListGrid;
                DataTable dataTable = new DataTable("LinenInjectiontMst");
                DataTable dataTable1 = new DataTable("LinenInjectiontMstDet");
                DataTable varDt2 = new DataTable();

                //// Delete grid
                var deletedId = model.LLinenInjectionLinenItemListGrid.Where(y => y.IsDeleted).Select(x => x.LinenInjectionDetId).ToList();
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
                if (model.LinenInjectionId != 0)
                {
                    parameters.Add("@Remarks", Convert.ToString(model.Remarks));
                    parameters.Add("@LinenInjectionId", Convert.ToString(model.LinenInjectionId));
                    parameters.Add("@ModifiedBy", _UserSession.UserId.ToString());
                    DataTable dss = dbAccessDAL.GetMASTERDataTable("LLSLinenInjectionTxn_Update", parameters, DataSetparameters);
                    varDt2.Columns.Add("@LinenPrice", typeof(Decimal));
                    varDt2.Columns.Add("@QuantityInjected", typeof(int));
                    varDt2.Columns.Add("@TestReport", typeof(string));
                    varDt2.Columns.Add("ModifiedBy", typeof(int));
                    varDt2.Columns.Add("@LinenInjectionDetId", typeof(int));
                    foreach (var var in model.LLinenInjectionLinenItemListGrid)
                    {
                        varDt2.Rows.Add(var.LinenPrice,var.QuantityInjected, var.TestReport,  var.LinenInjectionDetId, _UserSession.UserId.ToString() );
                    }
                    parameters.Clear();
                    DataSetparameters.Add("@LLSLinenInjectionTxnDet", varDt2);
                    DataTable dsss = dbAccessDAL.GetMASTERDataTable("LLSLinenInjectionTxnDet_Update", rowparameters, DataSetparameters);
                    foreach (var obj in model.LLinenInjectionLinenItemListGrid)
                    {
                        if (obj.LinenInjectionDetId == 0)
                        {
                            spNames = "LLSLinenInjectionTxnDet_Save";
                            dataTable1.Columns.Add("LinenInjectionId", typeof(int));
                            dataTable1.Columns.Add("CustomerId", typeof(int));
                            dataTable1.Columns.Add("FacilityID", typeof(int));
                            dataTable1.Columns.Add("LinenItemId", typeof(int));
                          
                            dataTable1.Columns.Add("QuantityInjected", typeof(int));
                            dataTable1.Columns.Add("TestReport", typeof(string));
                            dataTable1.Columns.Add("LifeSpanValidity", typeof(DateTime));
                            dataTable1.Columns.Add("CreatedBy", typeof(int));
                            dataTable1.Columns.Add("LinenPrice", typeof(Decimal));
                            foreach (var row in LineninjectdetailLists)
                            {
                                if (row.LinenInjectionDetId ==0)
                                {
                                    dataTable1.Rows.Add(
                                    model.LinenInjectionId,
                                    _UserSession.CustomerId,
                                    _UserSession.FacilityId,
                                    row.LinenItemId,
                                   
                                    row.QuantityInjected,
                                    row.TestReport,
                                    row.LifeSpanValidity,
                                    _UserSession.UserId.ToString(),
                                     row.LinenPrice
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
                        if (obj.LinenInjectionDetId == 0)
                        {
                            return model;
                        }
                        else { }
                    }
                    return model;
                }


                ////save method///////
                else
                {
                    spName = "LLSLinenInjectionTxn_Save";
                }
                dataTable.Columns.Add("CustomerId", typeof(int));
                dataTable.Columns.Add("FacilityId", typeof(int));
                dataTable.Columns.Add("DocumentNo", typeof(string));
                dataTable.Columns.Add("InjectionDate", typeof(DateTime));
                dataTable.Columns.Add("DONo", typeof(string));
                dataTable.Columns.Add("PONo", typeof(string));
                dataTable.Columns.Add("DODate", typeof(DateTime));
                dataTable.Columns.Add("Remarks", typeof(string));
                dataTable.Columns.Add("CreatedBy", typeof(int));
                dataTable.Columns.Add("ModifiedBy", typeof(int));


                dataTable.Rows.Add(
                   _UserSession.CustomerId,
                   _UserSession.FacilityId,
                   model.DocumentNo,
                   model.InjectionDate,
                   model.DONo,
                   model.PONo,
                   model.DODate,
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
                    var LinenInjectionId = Convert.ToInt32(ds.Tables[0].Rows[0]["LinenInjectionId"]);
                    if (LinenInjectionId != 0)
                        model.LinenInjectionId = LinenInjectionId;
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
                if (model.LinenInjectionDetId != 0)
                {


                }
                else
                {
                    spNames = "LLSLinenInjectionTxnDet_Save";
                    dataTable1.Columns.Add("LinenInjectionId", typeof(int));
                    dataTable1.Columns.Add("CustomerId", typeof(int));
                    dataTable1.Columns.Add("FacilityID", typeof(int));
                    dataTable1.Columns.Add("LinenItemId", typeof(int));
                   
                    dataTable1.Columns.Add("QuantityInjected", typeof(int));
                    dataTable1.Columns.Add("TestReport", typeof(string));
                    dataTable1.Columns.Add("LifeSpanValidity", typeof(DateTime));
                    dataTable1.Columns.Add("CreatedBy", typeof(int));
                    dataTable1.Columns.Add("LinenPrice", typeof(Decimal));
                    foreach (var row in LineninjectdetailLists)
                    {
                        dataTable1.Rows.Add(
                        model.LinenInjectionId,
                        _UserSession.CustomerId,
                        _UserSession.FacilityId,
                        row.LinenItemId,
                       
                        row.QuantityInjected,
                        row.TestReport,
                        row.LifeSpanValidity,
                        _UserSession.UserId.ToString(),
                         row.LinenPrice
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


        public LinenInjectionModel Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                LinenInjectionModel model = new LinenInjectionModel();
                var ds = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                LLinenInjectionLinenItemList LLinenInjectionLinenItemList = new LLinenInjectionLinenItemList();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("Id", Convert.ToString(Id));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSLinenInjectionTxn_GetById", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    model.LinenInjectionId = Id;
                    model.DocumentNo = Convert.ToString(dt.Rows[0]["DocumentNo"]);
                    model.InjectionDate = Convert.ToDateTime(dt.Rows[0]["InjectionDate"]);
                    model.DONo = Convert.ToString(dt.Rows[0]["DONo"]);
                    model.DODate = Convert.ToDateTime(dt.Rows[0]["DODate"]);
                    model.PONo = Convert.ToString(dt.Rows[0]["PONo"]);
                    model.Remarks = Convert.ToString(dt.Rows[0]["Remarks"]);
                    model.GuId = Convert.ToString(dt.Rows[0]["GuId"]);
                }
                    DataSet dt2 = dbAccessDAL.MasterGetDataSet("LLSLinenInjectionTxnDet_GetById", parameters, DataSetparameters);
                    if (dt != null && dt2.Tables.Count > 0)
                    {
                        model.LLinenInjectionLinenItemListGrid = (from n in dt2.Tables[0].AsEnumerable()
                                                                 select new LLinenInjectionLinenItemList
                                                                 {
                                                                     LinenInjectionDetId = Convert.ToInt32(n["LinenInjectionDetId"]),
                                                                     LinenCode = Convert.ToString(n["LinenCode"]),
                                                                     LinenDescription = Convert.ToString(n["LinenDescription"]),
                                                                     LinenPrice= Convert.ToDecimal(n["LinenPrice"]),
                                                                     QuantityInjected = Convert.ToInt32(n["QuantityInjected"]),
                                                                     TestReport = Convert.ToString(n["TestReport"]),
                                                                     LifeSpanValidity = Convert.ToDateTime(n["LifeSpanValidity"]),
                                                                    
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
                        cmd.CommandText = "LLSLinenInjectionTxn_GetAll";

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
                DataTable dt = dbAccessDAL.GetDataTable("LLSLinenInjectionTxn_Delete", parameters, DataSetparameters);
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
        public bool IsLinenInjectionDuplicate(LinenConemnationModel model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsLinenInjectionDuplicate), Level.Info.ToString());

                var IsDuplicate = true;
                var dbAccessDAL = new BEMSDBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@Id", model.LinenInjectionId.ToString());
                parameters.Add("@DocumentNo", model.LinenInjectionId.ToString());
                parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                DataTable dt = dbAccessDAL.GetDataTable("LLSLinenInjectionTxn_ValCode", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    IsDuplicate = Convert.ToBoolean(dt.Rows[0]["IsDuplicate"]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(IsLinenInjectionDuplicate), Level.Info.ToString());


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
        public bool IsRecordModified(LinenInjectionModel userRole)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsRecordModified), Level.Info.ToString());

                var recordModifed = false;

                if (userRole.LinenInjectionId != 0)
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
                            cmd.Parameters.AddWithValue("Id", userRole.LinenInjectionId);
                            var da = new SqlDataAdapter();
                            da.SelectCommand = cmd;
                            da.Fill(ds);
                        }
                    }
                    if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        var Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                        if (Timestamp != userRole.Timestamp)
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
            catch (Exception ex)
            {
                throw ex;
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
                        cmd.CommandText = "LLSLinenInjectionTxnDetSingle_Delete";
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
