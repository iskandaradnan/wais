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
    public class LinenRepairDAL : ILinenRepairDAL
    {
        private readonly string _FileName = nameof(LinenRepairDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public LinenRepairDAL()
        {

        }

        public LinenRepairModel Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                LinenRepairModel LinenRepairModel = null;



                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
              
                return LinenRepairModel;
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

        public LinenRepairModel Save(LinenRepairModel model, out string ErrorMessage)
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
                var rowparameters = new Dictionary<string, string>();
                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable dataTable = new DataTable("LinenRepairMst");
                DataTable dataTable1 = new DataTable("LinenRepairMstDet");
                DataTable varDt2 = new DataTable();
                List<LLinenRepairItemList> RepairdetailList = new List<LLinenRepairItemList>();
                RepairdetailList = model.LLinenRepairItemGridList;

                //// Delete grid
                var deletedId = model.LLinenRepairItemGridList.Where(y => y.IsDeleted).Select(x => x.LinenRepairDetId).ToList();
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
                if (model.LinenRepairId != 0)
                {
                    parameters.Add("@Remarks", Convert.ToString(model.Remarks));
                    parameters.Add("@LinenRepairId", Convert.ToString(model.LinenRepairId));
                    parameters.Add("@ModifiedBy", _UserSession.UserId.ToString());
                    DataTable dss = dbAccessDAL.GetMASTERDataTable("LLSLinenRepairTxn_Update", parameters, DataSetparameters);
                    varDt2.Columns.Add("@LinenRepairDetId", typeof(int));
                    varDt2.Columns.Add("@RepairCompletedQuantity", typeof(decimal));
                    varDt2.Columns.Add("@RepairQuantity", typeof(decimal));
                    varDt2.Columns.Add("@DescriptionOfProblem", typeof(string));
                    varDt2.Columns.Add("@LinenRepairId", typeof(int));
                    varDt2.Columns.Add("@ModifiedBy", typeof(int));
                    foreach (var var in model.LLinenRepairItemGridList)
                    {
                        varDt2.Rows.Add(var.LinenRepairDetId, var.RepairCompletedQuantity, var.RepairQuantity, var.DescriptionOfProblem,model.LinenRepairId, _UserSession.UserId.ToString());
                    }
                    parameters.Clear();
                    DataSetparameters.Add("@LLSLinenRepairTxnDet_Update", varDt2);
                    DataTable dsss = dbAccessDAL.GetMASTERDataTable("LLSLinenRepairTxnDet_Update", rowparameters, DataSetparameters);
                    foreach (var jjj in model.LLinenRepairItemGridList)
                    {
                        if (jjj.LinenRepairDetId == 0)
                        {
                            spNames = "LLSLinenRepairTxnDet_Save";
                            dataTable1.Columns.Add("LinenRepairId", typeof(int));
                            dataTable1.Columns.Add("CustomerId", typeof(int));
                            dataTable1.Columns.Add("FacilityID", typeof(int));
                            dataTable1.Columns.Add("LinenItemId", typeof(int));
                            dataTable1.Columns.Add("RepairQuantity", typeof(decimal));
                            dataTable1.Columns.Add("RepairCompletedQuantity", typeof(decimal));
                            dataTable1.Columns.Add("BalanceRepairQuantity", typeof(int));
                            dataTable1.Columns.Add("DescriptionOfProblem", typeof(string));
                            dataTable1.Columns.Add("CreatedBy", typeof(int));
                            foreach (var row in RepairdetailList)
                            {
                                if (row.LinenRepairDetId == 0)
                                {
                                    dataTable1.Rows.Add(
                                model.LinenRepairId,
                                _UserSession.CustomerId,
                                _UserSession.FacilityId,
                                row.LinenItemId,
                                row.RepairQuantity,
                                row.RepairCompletedQuantity,
                                row.BalanceRepairQuantity,
                                row.DescriptionOfProblem,
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
                        if (jjj.LinenRepairDetId == 0)
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
                    spName = "LLSLinenRepairTxn_Save";
                }
                dataTable.Columns.Add("CustomerId", typeof(int));
                dataTable.Columns.Add("FacilityId", typeof(int));
                dataTable.Columns.Add("DocumentNo", typeof(string));
                dataTable.Columns.Add("DocumentDate", typeof(DateTime));
                dataTable.Columns.Add("RepairedBy", typeof(int));
                dataTable.Columns.Add("CheckedBy", typeof(int));
                dataTable.Columns.Add("Remarks", typeof(string));
                dataTable.Columns.Add("CreatedBy", typeof(int));
                dataTable.Columns.Add("ModifiedBy", typeof(int));
                dataTable.Rows.Add(
                    _UserSession.CustomerId,
                    _UserSession.FacilityId,
                    model.DocumentNo,
                    model.DocumentDate,
                    model.RepairedBy,
                    model.CheckedBy,
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
                    var LinenRepairId = Convert.ToInt32(ds.Tables[0].Rows[0]["LinenRepairId"]);
                    if (LinenRepairId != 0)
                        model.LinenRepairId = LinenRepairId;
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
                if (model.LinenRepairDetId != 0)
                {


                }
                else
                {
                    spNames = "LLSLinenRepairTxnDet_Save";
                    dataTable1.Columns.Add("LinenRepairId", typeof(int));
                    dataTable1.Columns.Add("CustomerId", typeof(int));
                    dataTable1.Columns.Add("FacilityID", typeof(int));
                    dataTable1.Columns.Add("LinenItemId", typeof(int));
                    dataTable1.Columns.Add("RepairQuantity", typeof(decimal));
                    dataTable1.Columns.Add("RepairCompletedQuantity", typeof(decimal));
                    dataTable1.Columns.Add("BalanceRepairQuantity", typeof(int));
                    dataTable1.Columns.Add("DescriptionOfProblem", typeof(string));
                    dataTable1.Columns.Add("CreatedBy", typeof(int));
                    foreach (var row in RepairdetailList)
                    {
                        dataTable1.Rows.Add(
                        model.LinenRepairId,
                        _UserSession.CustomerId,
                        _UserSession.FacilityId,
                        row.LinenItemId,
                        row.RepairQuantity,
                        row.RepairCompletedQuantity,
                        row.BalanceRepairQuantity,
                        row.DescriptionOfProblem,
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


        public LinenRepairModel Get(int Id)
        {
         Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                LinenRepairModel model = new LinenRepairModel();
                var ds = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                LLinenRepairItemList LLinenRepairItemList = new LLinenRepairItemList();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("Id", Convert.ToString(Id));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSLinenRepairTxn_GetById", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    model.LinenRepairId = Id;
                    model.DocumentNo = Convert.ToString(dt.Rows[0]["DocumentNo"]);
                    model.DocumentDate = Convert.ToDateTime(dt.Rows[0]["DocumentDate"]);
                    model.RepairedBy = Convert.ToString(dt.Rows[0]["RepairedBy"]);
                    model.CheckedBy = Convert.ToString(dt.Rows[0]["CheckBy"]);
                    model.Remarks = Convert.ToString((dt.Rows[0]["Remarks"]) == System.DBNull.Value ? null : dt.Rows[0]["Remarks"]);
                }
                    DataSet dt2 = dbAccessDAL.MasterGetDataSet("LLSLinenRepairTxnDet_GetById", parameters, DataSetparameters);
                    if (dt != null && dt2.Tables.Count > 0)
                    {
                        model.LLinenRepairItemGridList = (from n in dt2.Tables[0].AsEnumerable()
                                                          select new LLinenRepairItemList
                                                          {
                                                              LinenRepairDetId = Convert.ToInt32(n["LinenRepairDetId"]),
                                                              LinenCode = Convert.ToString(n["LinenCode"]),
                                                              LinenDescription = Convert.ToString(n["LinenDescription"]),
                                                              RepairQuantity = Convert.ToDecimal(n["RepairQuantity"]),
                                                              RepairCompletedQuantity = Convert.ToDecimal(n["RepairCompletedQuantity"]),
                                                              BalanceRepairQuantity = Convert.ToDecimal(n["BalanceRepairQuantity"]),
                                                              DescriptionOfProblem = Convert.ToString(n["DescriptionOfProblem"]),


                                                          }).ToList();
                        model.LLinenRepairItemGridList.ForEach((x) =>
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
                        cmd.CommandText = "LLSLinenRepairTxn_GetAll";

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
                DataTable dt = dbAccessDAL.GetDataTable("LLSLinenRepairTxn_Delete", parameters, DataSetparameters);
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

        public bool IsLinenRepairDuplicate(LinenRepairModel model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsLinenRepairDuplicate), Level.Info.ToString());

                var IsDuplicate = true;
                var dbAccessDAL = new BEMSDBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@Id", model.LinenRepairId.ToString());
                
                parameters.Add("@DocumentNo", Convert.ToString(model.DocumentNo));
                parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                DataTable dt = dbAccessDAL.GetDataTable("LLSLinenRepairTxn_ValCode", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    IsDuplicate = Convert.ToBoolean(dt.Rows[0]["IsDuplicate"]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(IsLinenRepairDuplicate), Level.Info.ToString());

              
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
        public bool IsRecordModified(LinenRepairModel userRole)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsRecordModified), Level.Info.ToString());

                var recordModifed = false;

                if (userRole.LinenRepairId != 0)
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
                            cmd.Parameters.AddWithValue("Id", userRole.LinenRepairId);
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
                        cmd.CommandText = "LLSLinenRepairTxnDetSingle_Delete";
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
