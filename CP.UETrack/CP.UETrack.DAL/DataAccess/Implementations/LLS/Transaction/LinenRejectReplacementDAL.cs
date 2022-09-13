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
    public class LinenRejectReplacementDAL : ILinenRejectReplacementDAL
    {
        private readonly string _FileName = nameof(LinenRejectReplacementDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public LinenRejectReplacementDAL()
        {

        }

        public LinenRejectReplacementModel Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                LinenRejectReplacementModel LinenRejectReplacementModel = null;



                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                LinenRejectReplacementModel = new LinenRejectReplacementModel();
                return LinenRejectReplacementModel;
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

        public LinenRejectReplacementModel Save(LinenRejectReplacementModel model, out string ErrorMessage)
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
                var EffectiveDate = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                List<LLinenRejectGridListItem> RejectdetailList = new List<LLinenRejectGridListItem>();
                RejectdetailList = model.LLinenRejectGridList;
                DataTable dataTable = new DataTable("LinenRejectReplacementMst");
                DataTable dataTable1 = new DataTable("LinenRejectReplacementMstDet");
                DataTable dt1 = new DataTable();
                // Delete grid
                var deletedId = model.LLinenRejectGridList.Where(y => y.IsDeleted).Select(x => x.LinenRejectReplacementDetId).ToList();
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
                if (model.LinenRejectReplacementId != 0)
                {
                    parameters.Add("@Remarks", Convert.ToString(model.Remarks));
                    parameters.Add("@LinenRejectReplacementId", Convert.ToString(model.LinenRejectReplacementId));
                    parameters.Add("@ModifiedBy", _UserSession.UserId.ToString());
                    DataTable dss = dbAccessDAL.GetMASTERDataTable("LLSLinenRejectReplacementTxn_Update", parameters, DataSetparameters);
                    if (dss != null)
                    {

                        dt1.Columns.Add("Ql01aTapeGlue", typeof(int));
                        dt1.Columns.Add("Ql01bChemical", typeof(int));
                        dt1.Columns.Add("Ql01cBlood", typeof(int));
                        dt1.Columns.Add("Ql01dPermanentStain", typeof(int));
                        dt1.Columns.Add("Ql02TornPatches", typeof(int));
                        dt1.Columns.Add("Ql03Button", typeof(int));
                        dt1.Columns.Add("Ql04String", typeof(int));
                        dt1.Columns.Add("Ql05Odor", typeof(int));
                        dt1.Columns.Add("Ql06aFaded", typeof(int));
                        dt1.Columns.Add("Ql06bThinMaterial", typeof(int));
                        dt1.Columns.Add("Ql06cWornOut", typeof(int));
                        dt1.Columns.Add("Ql06d3YrsOld", typeof(int));
                        dt1.Columns.Add("Ql07Shrink", typeof(int));
                        dt1.Columns.Add("Ql08Crumple", typeof(int));
                        dt1.Columns.Add("Ql09Lint", typeof(int));
                        dt1.Columns.Add("TotalRejectedQuantity", typeof(int));
                        dt1.Columns.Add("ReplacedQuantity", typeof(int));
                        dt1.Columns.Add("ReplacedDateTime", typeof(DateTime));
                        dt1.Columns.Add("Remarks", typeof(string));
                        dt1.Columns.Add("LinenRejectReplacementDetId", typeof(int));
                        dt1.Columns.Add("ModifiedBy", typeof(int));
                        foreach (var var in model.LLinenRejectGridList)
                        {
                            dt1.Rows.Add(var.Ql01aTapeGlue, var.Ql01bChemical,var.Ql01cBlood, var.Ql01dPermanentStain, var.Ql02TornPatches, var.Ql03Button,
                                 var.Ql04String, var.Ql05Odor, var.Ql06aFaded, var.Ql06bThinMaterial, var.Ql06cWornOut, var.Ql06d3YrsOld, var.Ql07Shrink,
                                 var.Ql08Crumple, var.Ql09Lint, var.TotalRejectedQuantity, var.ReplacedQuantity, Convert.ToString(var.ReplacedDateTime == null || var.ReplacedDateTime == DateTime.MinValue ? null : var.ReplacedDateTime.ToString("yyy-MM-dd HH:mm")), 
                                 var.Remarks, var.LinenRejectReplacementDetId, _UserSession.UserId.ToString());
                        }
                        parameters.Clear();
                        DataSetparameters.Add("@LLSLinenRejectReplacementTxnDet_Udpate", dt1);
                        DataTable dss2 = dbAccessDAL.GetMASTERDataTable("LLSLinenRejectReplacementTxnDet_Udpate", parameters, DataSetparameters);
                        foreach (var jjj in model.LLinenRejectGridList)
                        {
                            if (jjj.LinenRejectReplacementDetId == 0)
                            {
                                spNames = "LLSLinenRejectReplacementTxnDet_Save";
                                dataTable1.Columns.Add("LinenRejectReplacementId", typeof(int));
                                dataTable1.Columns.Add("CustomerId", typeof(int));
                                dataTable1.Columns.Add("FacilityId", typeof(int));
                                dataTable1.Columns.Add("LinenItemId", typeof(int));
                                dataTable1.Columns.Add("Ql01aTapeGlue", typeof(int));
                                dataTable1.Columns.Add("Ql01bChemical", typeof(int));
                                dataTable1.Columns.Add("Ql01cBlood", typeof(int));
                                dataTable1.Columns.Add("Ql01dPermanentStain", typeof(int));
                                dataTable1.Columns.Add("Ql02TornPatches", typeof(int));
                                dataTable1.Columns.Add("Ql03Button", typeof(int));
                                dataTable1.Columns.Add("Ql04String", typeof(int));
                                dataTable1.Columns.Add("Ql05Odor", typeof(int));
                                dataTable1.Columns.Add("Ql06aFaded", typeof(int));
                                dataTable1.Columns.Add("Ql06bThinMaterial", typeof(int));
                                dataTable1.Columns.Add("Ql06cWornOut", typeof(int));
                                dataTable1.Columns.Add("Ql06d3YrsOld", typeof(int));
                                dataTable1.Columns.Add("Ql07Shrink", typeof(int));
                                dataTable1.Columns.Add("Ql08Crumple", typeof(int));
                                dataTable1.Columns.Add("Ql09Lint", typeof(int));
                                dataTable1.Columns.Add("TotalRejectedQuantity", typeof(int));
                                dataTable1.Columns.Add("ReplacedQuantity", typeof(int));
                                dataTable1.Columns.Add("ReplacedDateTime", typeof(DateTime));
                                dataTable1.Columns.Add("Remarks", typeof(string));
                                dataTable1.Columns.Add("CreatedBy", typeof(int));

                                foreach (var row in RejectdetailList)
                                {
                                    if (row.LinenRejectReplacementDetId == 0)
                                    {
                                        dataTable1.Rows.Add(
                                         model.LinenRejectReplacementId,
                                          _UserSession.CustomerId,
                                          _UserSession.FacilityId,
                                    row.LinenItemId,
                                    row.Ql01aTapeGlue,
                                    row.Ql01bChemical,
                                    row.Ql01cBlood,
                                    row.Ql01dPermanentStain,
                                    row.Ql02TornPatches,
                                    row.Ql03Button,
                                    row.Ql04String,
                                    row.Ql05Odor,
                                    row.Ql06aFaded,
                                    row.Ql06bThinMaterial,
                                    row.Ql06cWornOut,
                                    row.Ql06d3YrsOld,
                                    row.Ql07Shrink,
                                    row.Ql08Crumple,
                                    row.Ql09Lint,
                                    row.TotalRejectedQuantity,
                                    row.ReplacedQuantity,
                                    row.ReplacedDateTime,
                                    row.Remarks,
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
                                if (jjj.LinenRejectReplacementDetId == 0)
                            {
                                return model;
                            }
                            else { }
                        }
                        return model;
                    }
                }
                ///////////save method///////
                else
                {
                    spName = "LLSLinenRejectReplacementTxn_Save";
                }
                dataTable.Columns.Add("CustomerId", typeof(int));
                dataTable.Columns.Add("FacilityId", typeof(int));
                dataTable.Columns.Add("DocumentNo", typeof(string));
                dataTable.Columns.Add("DateTime", typeof(DateTime));
                dataTable.Columns.Add("CleanLinenIssueId", typeof(int));
                dataTable.Columns.Add("LLSUserAreaId", typeof(int));
                dataTable.Columns.Add("LLSUserLocationId", typeof(int));
                dataTable.Columns.Add("RejectedBy", typeof(int));
                dataTable.Columns.Add("ReplacementReceivedBy", typeof(int));
                dataTable.Columns.Add("ReceivedDateTime", typeof(DateTime));
                dataTable.Columns.Add("TotalQuantityRejected", typeof(decimal));
                dataTable.Columns.Add("TotalQuantityReplaced", typeof(decimal));
                dataTable.Columns.Add("Remarks", typeof(string));
                dataTable.Columns.Add("CreatedBy", typeof(int));
                dataTable.Columns.Add("ModifiedBy", typeof(int));
                dataTable.Rows.Add(
                     _UserSession.CustomerId,
                    _UserSession.FacilityId,
                    model.DocumentNo,
                    model.DateTime,
                    model.CleanLinenIssueId,
                    model.LLSUserAreaId,
                    model.LLSUserLocationId,
                    model.RejectedBy,
                    model.ReplacementReceivedBy,
                    model.EffectiveDate,
                    model.TotalQuantityRejected,
                    model.TotalQuantityReplaced,
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
                    var LinenRejectReplacementId = Convert.ToInt32(ds.Tables[0].Rows[0]["LinenRejectReplacementId"]);
                    if (LinenRejectReplacementId != 0)
                        model.LinenRejectReplacementId = LinenRejectReplacementId;
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
                if (model.LinenRejectReplacementDetId != 0)
                {


                }
                else
                {
                    spNames = "LLSLinenRejectReplacementTxnDet_Save";
                    dataTable1.Columns.Add("LinenRejectReplacementId", typeof(int));
                    dataTable1.Columns.Add("CustomerId", typeof(int));
                    dataTable1.Columns.Add("FacilityId", typeof(int));
                    dataTable1.Columns.Add("LinenItemId", typeof(int));
                    dataTable1.Columns.Add("Ql01aTapeGlue", typeof(int));
                    dataTable1.Columns.Add("Ql01bChemical", typeof(int));
                    dataTable1.Columns.Add("Ql01cBlood", typeof(int));
                    dataTable1.Columns.Add("Ql01dPermanentStain", typeof(int));
                    dataTable1.Columns.Add("Ql02TornPatches", typeof(int));
                    dataTable1.Columns.Add("Ql03Button", typeof(int));
                    dataTable1.Columns.Add("Ql04String", typeof(int));
                    dataTable1.Columns.Add("Ql05Odor", typeof(int));
                    dataTable1.Columns.Add("Ql06aFaded", typeof(int));
                    dataTable1.Columns.Add("Ql06bThinMaterial", typeof(int));
                    dataTable1.Columns.Add("Ql06cWornOut", typeof(int));
                    dataTable1.Columns.Add("Ql06d3YrsOld", typeof(int));
                    dataTable1.Columns.Add("Ql07Shrink", typeof(int));
                    dataTable1.Columns.Add("Ql08Crumple", typeof(int));
                    dataTable1.Columns.Add("Ql09Lint", typeof(int));
                    dataTable1.Columns.Add("TotalRejectedQuantity", typeof(int));
                    dataTable1.Columns.Add("ReplacedQuantity", typeof(int));
                    dataTable1.Columns.Add("ReplacedDateTime", typeof(DateTime));
                    dataTable1.Columns.Add("Remarks", typeof(string));
                    dataTable1.Columns.Add("CreatedBy", typeof(int));

                    foreach (var row in RejectdetailList)
                    {
                        dataTable1.Rows.Add(
                             model.LinenRejectReplacementId,
                              _UserSession.CustomerId,
                              _UserSession.FacilityId,
                        row.LinenItemId,
                        row.Ql01aTapeGlue,
                        row.Ql01bChemical,
                        row.Ql01cBlood,
                        row.Ql01dPermanentStain,
                        row.Ql02TornPatches,
                        row.Ql03Button,
                        row.Ql04String,
                        row.Ql05Odor,
                        row.Ql06aFaded,
                        row.Ql06bThinMaterial,
                        row.Ql06cWornOut,
                        row.Ql06d3YrsOld,
                        row.Ql07Shrink,
                        row.Ql08Crumple,
                        row.Ql09Lint,
                        row.TotalRejectedQuantity,
                        row.ReplacedQuantity,
                        row.ReplacedDateTime,
                        row.Remarks,
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


        public LinenRejectReplacementModel Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                LinenRejectReplacementModel model = new LinenRejectReplacementModel();
                var ds = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                LLinenRejectGridListItem LLinenRejectGridListItem = new LLinenRejectGridListItem();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("Id", Convert.ToString(Id));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSLinenRejectReplacementTxn_GetById", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    model.LinenRejectReplacementId = Id;
                    model.DocumentNo = Convert.ToString(dt.Rows[0]["DocumentNo"]);
                    model.DateTime = Convert.ToDateTime(dt.Rows[0]["DateTime"]);
                    model.CLINo = Convert.ToString(dt.Rows[0]["CLINo"]);
                    model.CLIDescription = Convert.ToString((dt.Rows[0]["CLIDescription"]) == System.DBNull.Value ? null : dt.Rows[0]["CLIDescription"]);
                    model.UserAreaCode = Convert.ToString(dt.Rows[0]["UserAreaCode"]);
                    model.UserAreaName = Convert.ToString(dt.Rows[0]["UserAreaName"]);
                    model.UserLocationCode = Convert.ToString(dt.Rows[0]["UserLocationCode"]);
                    model.UserLocationName = Convert.ToString(dt.Rows[0]["UserLocationName"]);
                    model.RejectedBy = Convert.ToString(dt.Rows[0]["RejectedBy"]);
                    model.RejectedByDesignation = Convert.ToString(dt.Rows[0]["RejectedByDesignation"]);
                    model.ReplacementReceivedBy = Convert.ToString(dt.Rows[0]["ReplacementReceivedBy"]);
                    model.ReplacementReceivedByDesignation = Convert.ToString(dt.Rows[0]["ReplacementReceivedByDesignation"]);
                    model.ReceivedDateTime = Convert.ToDateTime(dt.Rows[0]["ReceivedDateTime"]);
                    model.TotalRejectedQuantity = Convert.ToInt32(dt.Rows[0]["TotalQuantityRejected"]);
                    model.ReplacedQuantity = Convert.ToInt32(dt.Rows[0]["TotalQuantityReplaced"]);
                    model.Remarks = Convert.ToString((dt.Rows[0]["Remarks"]) == System.DBNull.Value ? null : dt.Rows[0]["Remarks"]);
                       
                }
                DataSet dt2 = dbAccessDAL.MasterGetDataSet("LLSLinenRejectReplacementTxnDet_GetById", parameters, DataSetparameters);
                if (dt != null && dt2.Tables.Count > 0)
                {
                    model.LLinenRejectGridList = (from n in dt2.Tables[0].AsEnumerable()
                                                             select new LLinenRejectGridListItem
                                                             {
                                                                 
                                                                 LinenRejectReplacementDetId = Convert.ToInt32(n["LinenRejectReplacementDetId"]),
                                                                 LinenCode = Convert.ToString(n["LinenCode"]),
                                                                 LinenDescription = Convert.ToString(n["LinenDescription"]),
                                                                 Ql01aTapeGlue = Convert.ToInt32(n["Ql01aTapeGlue"]),
                                                                 Ql01bChemical = Convert.ToInt32(n["Ql01bChemical"]),
                                                                 Ql01cBlood = Convert.ToInt32(n["Ql01cBlood"]),
                                                                 Ql01dPermanentStain = Convert.ToInt32(n["Ql01dPermanentStain"]),
                                                                 Ql02TornPatches = Convert.ToInt32(n["Ql02TornPatches"]),
                                                                 Ql03Button = Convert.ToInt32(n["Ql03Button"]),
                                                                 Ql04String = Convert.ToInt32(n["Ql04String"]),
                                                                 Ql05Odor = Convert.ToInt32(n["Ql05Odor"]),
                                                                 Ql06aFaded = Convert.ToInt32(n["Ql06aFaded"] ),
                                                                 Ql06bThinMaterial = Convert.ToInt32(n["Ql06bThinMaterial"]),
                                                                 Ql06cWornOut = Convert.ToInt32(n["Ql06cWornOut"]),
                                                                 Ql06d3YrsOld = Convert.ToInt32(n["Ql06d3YrsOld"]),
                                                                 Ql07Shrink = Convert.ToInt32(n["Ql07Shrink"]),
                                                                 Ql08Crumple = Convert.ToInt32(n["Ql08Crumple"]),
                                                                 Ql09Lint = Convert.ToInt32(n["Ql09Lint"]),
                                                                 TotalRejectedQuantity = Convert.ToInt32(n["TotalRejectedQuantity"]),
                                                                 ReplacedQuantity = Convert.ToInt32(n["ReplacedQuantity"]),
                                                                 ReplacedDateTime = Convert.ToDateTime(n["ReplacedDateTime"]),
                                                                 Remarks = Convert.ToString(n["Remarks"]),
                                                             }).ToList();
                    model.LLinenRejectGridList.ForEach((x) =>
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
                        cmd.CommandText = "LLSLinenRejectReplacementTxn_GetAll";

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
                DataTable dt = dbAccessDAL.GetDataTable("LLSLinenRejectReplacementTxn_Delete", parameters, DataSetparameters);
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
        public bool IsLinenRejectReplacementDuplicate(LinenRejectReplacementModel model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsLinenRejectReplacementDuplicate), Level.Info.ToString());
                var IsDuplicate = true;
                var dbAccessDAL = new BEMSDBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@Id", model.LinenRejectReplacementId.ToString());
                parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@DocumentNo", Convert.ToString(model.DocumentNo));
                DataTable dt = dbAccessDAL.GetDataTable("LLSLinenRejectReplacementTxn_ValCode", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    IsDuplicate = Convert.ToBoolean(dt.Rows[0]["IsDuplicate"]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(IsLinenRejectReplacementDuplicate), Level.Info.ToString());
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
        public bool IsRecordModified(LinenRejectReplacementModel model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsRecordModified), Level.Info.ToString());

                var recordModifed = false;

                if (model.LinenRejectReplacementId != 0)
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
                            cmd.Parameters.AddWithValue("Id", model.LinenRejectReplacementId);
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
                        cmd.CommandText = "LLSLinenRejectReplacementTxnDetSingle_Delete";
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
