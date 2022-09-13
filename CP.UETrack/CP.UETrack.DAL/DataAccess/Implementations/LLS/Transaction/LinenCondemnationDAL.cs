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
    public class LinenCondemnationDAL : ILinenCondemnationDAL
    {
        private readonly string _FileName = nameof(LinenCondemnationDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public LinenCondemnationDAL()
        {

        }

        public LinenConemnationModelLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                LinenConemnationModelLovs LinenConemnationModelLovs = new LinenConemnationModelLovs();
                string lovs = "LocationOfCondemnationValue";
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pLovKey", lovs);
                DataSet ds = dbAccessDAL.GetDataSet("uspFM_Dropdown", parameters, DataSetparameters);
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    LinenConemnationModelLovs.LocationofCondemnation = dbAccessDAL.GetLovRecords(ds.Tables[0], "LocationOfCondemnationValue");
                   

                }

                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
               
                return LinenConemnationModelLovs;
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
                var DataSetparameters = new Dictionary<string, DataTable>();
                List<LLinenCondemnationList> LinenConddetailList = new List<LLinenCondemnationList>();
                LinenConddetailList = model.LLinenCondemnationGridList;
                DataTable dataTable1 = new DataTable("LinenConemnationtMstDet");
                DataTable dataTable = new DataTable("LinenConemnationtMst");
                //parameters.Add("@LinenCondemnationDetId", Convert.ToString(model.LinenCondemnationDetId));
                //// Delete grid
                var deletedId = model.LLinenCondemnationGridList.Where(y => y.IsDeleted).Select(x => x.LinenCondemnationDetId).ToList();
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

                if (model.LinenCondemnationId != 0)
                {
                    parameters.Add("@Remarks", Convert.ToString(model.Remarks));
                    parameters.Add("@LinenCondemnationId", Convert.ToString(model.LinenCondemnationId));
                    parameters.Add("@ModifiedBy", _UserSession.UserId.ToString());
                    DataTable dss = dbAccessDAL.GetMASTERDataTable("LLSLinenCondemnationTxn_Update", parameters, DataSetparameters);
                    parameters.Clear();
                    if (dss != null)
                    {
                        foreach (var jjj in model.LLinenCondemnationGridList)
                        {
                            if (jjj.LinenCondemnationDetId == 0)
                            {
                                spNames = "LLSLinenCondemnationTxnDet_Save";
                                dataTable1.Columns.Add("LinenCondemnationId", typeof(int));
                                dataTable1.Columns.Add("CustomerId", typeof(int));
                                dataTable1.Columns.Add("FacilityId", typeof(int));
                                dataTable1.Columns.Add("LinenItemId", typeof(int));
                                dataTable1.Columns.Add("BatchNo", typeof(string));
                                dataTable1.Columns.Add("Total", typeof(int));
                                dataTable1.Columns.Add("Torn", typeof(int));
                                dataTable1.Columns.Add("Stained", typeof(int));
                                dataTable1.Columns.Add("Faded", typeof(int));
                                dataTable1.Columns.Add("Vandalism", typeof(int));
                                dataTable1.Columns.Add("WearTear", typeof(int));
                                dataTable1.Columns.Add("StainedByChemical", typeof(int));
                                dataTable1.Columns.Add("CreatedBy", typeof(int));
                                foreach (var row in LinenConddetailList)
                                {
                                    if (row.LinenCondemnationDetId == 0)
                                    {
                                        dataTable1.Rows.Add(
                                        model.LinenCondemnationId,
                                        _UserSession.CustomerId,
                                        _UserSession.FacilityId,
                                        row.LinenItemId,
                                        row.BatchNo,
                                        row.Total,
                                        row.Torn,
                                        row.Stained,
                                        row.Faded,
                                        row.Vandalism,
                                        row.WearTear,
                                        row.StainedByChemical,
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
                            if (jjj.LinenCondemnationDetId == 0)
                            {
                                return model;
                            }
                            else { }
                        }
                        return model;
                    }
                }


                ////////save method///
                else
                {
                    spName = "LLSLinenCondemnationTxn_Save";
                }
                dataTable.Columns.Add("CustomerId", typeof(int));
                dataTable.Columns.Add("FacilityId", typeof(int));
                dataTable.Columns.Add("DocumentNo", typeof(string));
                dataTable.Columns.Add("DocumentDate", typeof(DateTime));
                dataTable.Columns.Add("InspectedBy", typeof(int));
                dataTable.Columns.Add("VerifiedBy", typeof(int));
                dataTable.Columns.Add("TotalCondemns", typeof(int));
                dataTable.Columns.Add("Value", typeof(string));
                dataTable.Columns.Add("LocationOfCondemnation", typeof(string));
                dataTable.Columns.Add("Remarks", typeof(string));
                dataTable.Columns.Add("CreatedBy", typeof(int));
                dataTable.Columns.Add("ModifiedBy", typeof(int));
                dataTable.Rows.Add(
                     _UserSession.CustomerId,
                    _UserSession.FacilityId,
                    model.DocumentNo,
                    model.DocumentDate,
                    model.InspectedBy,
                    model.VerifiedBy,
                    model.TotalCondemns,
                    model.Value,
                    model.LocationOfCondemnation,                    
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
                        parameter.ParameterName = "@LLSLinenCondemnationTxn";
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
                    var LinenCondemnationId = Convert.ToInt32(ds.Tables[0].Rows[0]["LinenCondemnationId"]);
                    if (LinenCondemnationId != 0)
                        model.LinenCondemnationId = LinenCondemnationId;
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
                if (model.LinenCondemnationDetId!= 0)
                {


                }
                else
                {
                    spNames = "LLSLinenCondemnationTxnDet_Save";
                    dataTable1.Columns.Add("LinenCondemnationId", typeof(int));
                    dataTable1.Columns.Add("CustomerId", typeof(int));
                    dataTable1.Columns.Add("FacilityId", typeof(int));
                    dataTable1.Columns.Add("LinenItemId", typeof(int));
                    dataTable1.Columns.Add("BatchNo", typeof(string));
                    dataTable1.Columns.Add("Total", typeof(int));
                    dataTable1.Columns.Add("Torn", typeof(int));
                    dataTable1.Columns.Add("Stained", typeof(int));
                    dataTable1.Columns.Add("Faded", typeof(int));
                    dataTable1.Columns.Add("Vandalism", typeof(int));
                    dataTable1.Columns.Add("WearTear", typeof(int));
                    dataTable1.Columns.Add("StainedByChemical", typeof(int));
                    dataTable1.Columns.Add("CreatedBy", typeof(int));
                    foreach (var row in LinenConddetailList)
                    {
                        dataTable1.Rows.Add(
                        model.LinenCondemnationId,
                        _UserSession.CustomerId,
                        _UserSession.FacilityId,
                        row.LinenItemId,
                        row.BatchNo,
                        row.Total,
                        row.Torn,
                        row.Stained,
                        row.Faded,
                        row.Vandalism,
                        row.WearTear,
                        row.StainedByChemical,
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


        public LinenConemnationModel Get(int Id)
        {
                 Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                try
                {
                    LinenConemnationModel model = new LinenConemnationModel();
                    var ds = new DataSet();
                    var dbAccessDAL = new MASTERDBAccessDAL();
                    LLinenCondemnationList LLinenCondemnationList = new LLinenCondemnationList();
                    var DataSetparameters = new Dictionary<string, DataTable>();
                    var parameters = new Dictionary<string, string>();
                    parameters.Add("Id", Convert.ToString(Id));
                    DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSLinenCondemnationTxn_GetById", parameters, DataSetparameters);
                    if (dt != null && dt.Rows.Count > 0)
                    {

                                 model.LinenCondemnationId = Id;
                                 model.DocumentNo = Convert.ToString(dt.Rows[0]["DocumentNo"]);
                                 model.DocumentDate = Convert.ToDateTime(dt.Rows[0]["DocumentDate"]);
                                 model.InspectedBy = Convert.ToString(dt.Rows[0]["InspectedBy"]);
                                 model.VerifiedBy = Convert.ToString(dt.Rows[0]["VerifiedBy"]);
                                 model.TotalCondemns = Convert.ToInt32(dt.Rows[0]["TotalCondemns"]);
                                 model.Value = Convert.ToDecimal(dt.Rows[0]["Value"]);
                                 model.LocationOfCondemnation = Convert.ToString(dt.Rows[0]["LocationOfCondemns"]);
                                 model.Remarks = Convert.ToString(dt.Rows[0]["Remarks"]);

                    }
                DataSet dt2 = dbAccessDAL.MasterGetDataSet("LLSLinenCondemnationTxnDet_GetById", parameters, DataSetparameters);
                if (dt != null && dt2.Tables.Count > 0)
                {
                    model.LLinenCondemnationGridList = (from n in dt2.Tables[0].AsEnumerable()
                                                             select new LLinenCondemnationList
                                                             {
                                                                 LinenCondemnationDetId = Convert.ToInt32(n["LinenCondemnationDetId"]),
                                                                 LinenCode = Convert.ToString(n["LinenCode"]),
                                                                 LinenDescription = Convert.ToString(n["LinenDescription"]),
                                                                 BatchNo = Convert.ToString(n["BatchNo"]),
                                                                 Total = Convert.ToInt32(n["Total"]),
                                                                 Torn = Convert.ToInt32(n["Torn"]),
                                                                 Faded = Convert.ToInt32(n["Faded"]),
                                                                 Stained = Convert.ToInt32(n["Stained"]),
                                                                 Vandalism = Convert.ToInt32(n["Vandalism"]),
                                                                 WearTear = Convert.ToInt32(n["WearTear"]),
                                                                 StainedByChemical = Convert.ToInt32(n["StainedByChemical"]),

                                                             }).ToList();
                    model.LLinenCondemnationGridList.ForEach((x) =>
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
                        cmd.CommandText = "LLSLinenCondemnationTxn_GetAll";

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
                DataTable dt = dbAccessDAL.GetDataTable("LLSLinenCondemnationTxn_Delete", parameters, DataSetparameters);
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

        public bool IsLinenCondemnationCodeDuplicate(LinenConemnationModel model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsLinenCondemnationCodeDuplicate), Level.Info.ToString());

                var IsDuplicate = true;
                var dbAccessDAL = new BEMSDBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@Id", model.LinenCondemnationId.ToString());
                parameters.Add("@DocumentNo", model.LinenCondemnationId.ToString());
                parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                DataTable dt = dbAccessDAL.GetDataTable("LLSLinenCondemnationTxn_ValCode", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    IsDuplicate = Convert.ToBoolean(dt.Rows[0]["IsDuplicate"]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(IsLinenCondemnationCodeDuplicate), Level.Info.ToString());
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
        public bool IsRecordModified(LinenConemnationModel model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsRecordModified), Level.Info.ToString());

                var recordModifed = false;

                if (model.LinenCondemnationId != 0)
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
                            cmd.Parameters.AddWithValue("Id", model.LinenCondemnationId);
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
                        cmd.CommandText = "LLSLinenCondemnationTxnDetSingle_Delete";
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
