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
    public class LinenInventoryDAL:ILinenInventoryDAL
    {

        private readonly string _FileName = nameof(LinenInventoryDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public LinenInventoryDAL()
        {

        }


        public LinenInventoryModelClassLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                LinenInventoryModelClassLovs LinenInventoryModelLovs = new LinenInventoryModelClassLovs();
                string lovs = "StoreTypeValue";
                var dbAccessDAL = new BEMSDBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pLovKey", lovs);
                DataSet ds = dbAccessDAL.GetDataSet("uspFM_Dropdown", parameters, DataSetparameters);
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {

                    LinenInventoryModelLovs.StoreType = dbAccessDAL.GetLovRecords(ds.Tables[0], "StoreTypeValue");

                }


                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return LinenInventoryModelLovs;
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

        public TestModel Save(TestModel model, out string ErrorMessage)
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
                var EffectiveDate = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                var DataSetparameters = new Dictionary<string, DataTable>();
                List<LLinenInventoryclassLinenItemList> LinenInventoryLinen = new List<LLinenInventoryclassLinenItemList>();
               if(model.StoreType=="10171")
                    LinenInventoryLinen = model.LLinenInventoryCCLSListGrid;
               else
                    LinenInventoryLinen = model.LLinenInventoryLinenItemListGrid;

                DataTable dataTable = new DataTable("LinenInventoryMst");
                
                DataTable varDt2 = new DataTable();
                //// Delete grid
                var deletedId = model.LLinenInventoryLinenItemListGrid.Where(y => y.IsDeleted).Select(x => x.LlsLinenInventoryTxnDetId).ToList();
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
                //// Delete grid2
                var deleteId = model.LLinenInventoryCCLSListGrid.Where(y => y.IsDelete).Select(x => x.LlsLinenInventoryTxnDetId).ToList();
                var idstring1 = string.Empty;
                if (deleteId.Count() > 0)
                {
                    foreach (var item in deleteId.Select((value, var) => new { var, value }))
                    {
                        idstring1 += item.value;
                        if (item.var != deleteId.Count() - 1)
                        { idstring1 += ","; }
                    }
                    deleteChildrecords(idstring1);
                }
                if (model.LinenInventoryId != 0)
                {
                    parameters.Add("@VerifiedBy", Convert.ToString(model.VerifiedById));
                    if (string.IsNullOrEmpty(model.Remarks))
                        model.Remarks = "";
                    parameters.Add("@Remarks", Convert.ToString(model.Remarks));
                    parameters.Add("@LinenInventoryId", Convert.ToString(model.LinenInventoryId));
                    parameters.Add("@ModifiedBy", _UserSession.UserId.ToString());
                    DataTable dss = dbAccessDAL.GetMASTERDataTable("LLSLinenInventoryTxn_Update", parameters, DataSetparameters);
                    varDt2.Columns.Add("@LinenInventoryId", typeof(int));
                    varDt2.Columns.Add("@LlsLinenInventoryTxnDetId", typeof(int));
                    varDt2.Columns.Add("@LinenItemId", typeof(int));
                    varDt2.Columns.Add("@InUse", typeof(decimal));
                    varDt2.Columns.Add("@Shelf", typeof(decimal));
                    varDt2.Columns.Add("@CCLSInUse", typeof(int));
                    varDt2.Columns.Add("@CCLSShelf", typeof(int));
                    //varDt2.Columns.Add("@CustomerId", typeof(decimal));
                    //varDt2.Columns.Add("@FacilityId", typeof(decimal));
                    varDt2.Columns.Add("@LLSUserAreaLocationId", typeof(int));
                    varDt2.Columns.Add("Modifiedby", typeof(int));
                    if (model.StoreType == "10172")
                    {
                        foreach (var var in model.LLinenInventoryLinenItemListGrid)
                        {
                            if (var.LlsLinenInventoryTxnDetId != 0)
                                varDt2.Rows.Add(model.LinenInventoryId, var.LlsLinenInventoryTxnDetId, var.LinenItemId,
                            var.InUse, var.Shelf, var.CCLSInUse, var.CCLSShelf/*, _UserSession.CustomerId,*/
                                /*_UserSession.FacilityId*/,var.LLSUserAreaLocationId, _UserSession.UserId.ToString());
                        }
                    }
                    else
                    {
                        foreach (var var in model.LLinenInventoryCCLSListGrid)
                        {
                            if (var.LlsLinenInventoryTxnDetId != 0)
                                varDt2.Rows.Add(model.LinenInventoryId, var.LlsLinenInventoryTxnDetId, var.LinenItemId,
                                    var.InUse, var.Shelf, var.CCLSInUse, var.CCLSShelf/*, _UserSession.CustomerId,*/
                                       /* _UserSession.FacilityId*/, 1, _UserSession.UserId.ToString());

                        }
                    }

                    parameters.Clear();
                    DataSetparameters.Add("@LlsLinenInventoryTxnDetUpdate", varDt2);
                    DataTable dsss = dbAccessDAL.GetMASTERDataTable("LlsLinenInventoryTxnDet_Update", rowparameters, DataSetparameters);
                    if (model.StoreType == "10172")
                    {
                        foreach (var obj in model.LLinenInventoryLinenItemListGrid)
                        {
                            if (obj.LlsLinenInventoryTxnDetId == 0)
                            {
                                spNames = "LLSLinenInventoryTxnDet_Save";
                                DataTable dataTable1 = new DataTable("LinenInventoryMstDet");
                                dataTable1.Columns.Add("LinenInventoryId", typeof(int));
                                dataTable1.Columns.Add("LlsLinenInventoryTxnDetId", typeof(int));
                                dataTable1.Columns.Add("LinenItemId", typeof(int));
                                dataTable1.Columns.Add("InUse", typeof(decimal)); 
                                dataTable1.Columns.Add("Shelf", typeof(decimal));
                                dataTable1.Columns.Add("CCLSInUse", typeof(decimal));
                                dataTable1.Columns.Add("CCLSShelf", typeof(decimal));
                                dataTable1.Columns.Add("CustomerId", typeof(int));
                                dataTable1.Columns.Add("FacilityID", typeof(int));
                                dataTable1.Columns.Add("LLSUserAreaLocationId", typeof(int));
                                dataTable1.Columns.Add("CreatedBy", typeof(int));
                                dataTable1.Columns.Add("ModifiedBy", typeof(int));

                                dataTable1.Rows.Add(
                                model.LinenInventoryId,
                                obj.LlsLinenInventoryTxnDetId,
                                obj.LinenItemId,
                                obj.InUse,
                                obj.Shelf,
                                obj.CCLSInUse,
                                obj.CCLSShelf,
                                _UserSession.CustomerId,
                                _UserSession.FacilityId,
                                obj.LLSUserAreaLocationId,
                                 _UserSession.UserId.ToString(),
                    _UserSession.UserId.ToString()
                                );

                                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                                {
                                    using (SqlCommand cmd = new SqlCommand())
                                    {
                                        cmd.Connection = con;
                                        cmd.CommandType = CommandType.StoredProcedure;
                                        cmd.CommandText = spNames;
                                        SqlParameter parameter = new SqlParameter();
                                        parameter.ParameterName = "@LLSLinenInventoryTxnDet";
                                        parameter.SqlDbType = System.Data.SqlDbType.Structured;
                                        parameter.Value = dataTable1;
                                        cmd.Parameters.Add(parameter);
                                        var daa = new SqlDataAdapter();
                                        daa.SelectCommand = cmd;
                                        daa.Fill(ds2);
                                    }
                                }
                            }

                        }
                    }
                    else
                    {
                        foreach (var obj in model.LLinenInventoryCCLSListGrid)
                        {
                            if (obj.LlsLinenInventoryTxnDetId == 0)
                            {
                                spNames = "LLSLinenInventoryTxnDet_Save";
                                DataTable dataTable1 = new DataTable("LinenInventoryMstDet");
                                dataTable1.Columns.Add("LinenInventoryId", typeof(int));
                                dataTable1.Columns.Add("LlsLinenInventoryTxnDetId", typeof(int)); 
                                dataTable1.Columns.Add("LinenItemId", typeof(int));
                                dataTable1.Columns.Add("InUse", typeof(decimal));
                                dataTable1.Columns.Add("Shelf", typeof(decimal));
                                dataTable1.Columns.Add("CCLSInUse", typeof(decimal));
                                dataTable1.Columns.Add("CCLSShelf", typeof(decimal));
                                dataTable1.Columns.Add("CustomerId", typeof(int));
                                dataTable1.Columns.Add("FacilityID", typeof(int));
                                dataTable1.Columns.Add("LLSUserAreaLocationId", typeof(int));
                                dataTable1.Columns.Add("CreatedBy", typeof(int));
                                dataTable1.Columns.Add("ModifiedBy", typeof(int));

                                dataTable1.Rows.Add(
                                model.LinenInventoryId,
                                obj.LlsLinenInventoryTxnDetId,
                                obj.LinenItemId,
                                obj.InUse,
                                obj.Shelf,
                                obj.CCLSInUse,
                                obj.CCLSShelf,
                                _UserSession.CustomerId,
                                _UserSession.FacilityId,
                                obj.LLSUserAreaLocationId,
                                 _UserSession.UserId.ToString(),
                    _UserSession.UserId.ToString()
                                );

                                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                                {
                                    using (SqlCommand cmd = new SqlCommand())
                                    {
                                        cmd.Connection = con;
                                        cmd.CommandType = CommandType.StoredProcedure;
                                        cmd.CommandText = spNames;
                                        SqlParameter parameter = new SqlParameter();
                                        parameter.ParameterName = "@LLSLinenInventoryTxnDet";
                                        parameter.SqlDbType = System.Data.SqlDbType.Structured;
                                        parameter.Value = dataTable1;
                                        cmd.Parameters.Add(parameter);
                                        var daa = new SqlDataAdapter();
                                        daa.SelectCommand = cmd;
                                        daa.Fill(ds2);
                                    }
                                }
                            }

                        }
                    }
                   
                    return model;
                }


                ////save method///////
                else
                {
                    spName = "LLSLinenInventoryTxn_Save";
                }

                dataTable.Columns.Add("CustomerId", typeof(int));
                dataTable.Columns.Add("FacilityId", typeof(int));
                dataTable.Columns.Add("StoreType", typeof(string));
                dataTable.Columns.Add("DocumentNo", typeof(string));
                dataTable.Columns.Add("Date", typeof(DateTime));
                dataTable.Columns.Add("UserAreaId", typeof(int));
                dataTable.Columns.Add("VerifiedBy", typeof(int));
                dataTable.Columns.Add("Remarks", typeof(string));
                dataTable.Columns.Add("CreatedBy", typeof(int));
                dataTable.Columns.Add("ModifiedBy", typeof(int));
                dataTable.Rows.Add(
                    _UserSession.CustomerId,
                    _UserSession.FacilityId,
                    model.StoreType,
                    model.DocumentNo,
                    model.Date,
                    model.LLSUserAreaId,
                    model.VerifiedById,
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
                        parameter.ParameterName = "@LLSLinenInventoryTxn";
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
                    var LinenInventoryId = Convert.ToInt32(ds.Tables[0].Rows[0]["LinenInventoryId"]);
                    if (LinenInventoryId != 0)
                        model.LinenInventoryId = LinenInventoryId;
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
                if (model.LLSlinenInventoryTxnDetId != 0)
                {


                }
                else
                {

                    spNames = "LLSLinenInventoryTxnDet_Save";
                    DataTable dataTable1 = new DataTable("LinenInventoryMstDet");
                    dataTable1.Columns.Add("LinenInventoryId", typeof(int));
                    dataTable1.Columns.Add("LlsLinenInventoryTxnDetId", typeof(int));
                    dataTable1.Columns.Add("LinenItemId", typeof(int));
                    dataTable1.Columns.Add("InUse", typeof(decimal));
                    dataTable1.Columns.Add("Shelf", typeof(decimal));
                    dataTable1.Columns.Add("CCLSInUse", typeof(decimal));
                    dataTable1.Columns.Add("CCLSShelf", typeof(decimal));
                    dataTable1.Columns.Add("CustomerId", typeof(int));
                    dataTable1.Columns.Add("FacilityID", typeof(int));
                    dataTable1.Columns.Add("LLSUserAreaLocationId", typeof(int));
                    dataTable1.Columns.Add("CreatedBy", typeof(int));
                    dataTable1.Columns.Add("ModifiedBy", typeof(int));
                    if (model.StoreType == "10171")
                        LinenInventoryLinen = model.LLinenInventoryCCLSListGrid;
                    else
                        LinenInventoryLinen = model.LLinenInventoryLinenItemListGrid;

                    foreach (var row in LinenInventoryLinen)
                    {
                        dataTable1.Rows.Add(
                        model.LinenInventoryId,
                        row.LlsLinenInventoryTxnDetId,
                        row.LinenItemId,
                        row.InUse,
                        row.Shelf,
                        row.CCLSInUse,
                        row.CCLSShelf,
                        _UserSession.CustomerId,
                        _UserSession.FacilityId,
                        row.LLSUserAreaLocationId,
                        _UserSession.UserId.ToString(),
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
                            parameter.ParameterName = "@LLSLinenInventoryTxnDet";
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


        public TestModel Get(int Id)
        
        {

         
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                TestModel model = new TestModel();
                var ds = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                LLinenAdjustmentLinenItemList LLinenAdjustmentLinenItemList = new LLinenAdjustmentLinenItemList();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("Id", Convert.ToString(Id));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSLinenInventoryTxn_GetById", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    model.LinenInventoryId = Id;
                    model.StoreType = Convert.ToString(dt.Rows[0]["StoreType"]);
                    if (model.StoreType == "10172")
                    {
                        model.LLSUserAreaId = Convert.ToInt32(dt.Rows[0]["UserAreaId"] == System.DBNull.Value ? null : dt.Rows[0]["UserAreaId"]);
                        model.UserAreaCode = Convert.ToString(dt.Rows[0]["UserAreaCode"] == System.DBNull.Value ? null : dt.Rows[0]["UserAreaCode"]);
                        model.UserAreaName = Convert.ToString(dt.Rows[0]["UserAreaName"] == System.DBNull.Value ? null : dt.Rows[0]["UserAreaName"]);
                    }
                    model.DocumentNo = Convert.ToString(dt.Rows[0]["DocumentNo"]);
                    model.Date = Convert.ToDateTime(dt.Rows[0]["Date"]);
                    //model.UserAreaCode = Convert.ToString(dt.Rows[0]["UserAreaCode"] == System.DBNull.Value ? null : dt.Rows[0]["UserAreaCode"]);
                    //model.UserAreaName = Convert.ToString(dt.Rows[0]["UserAreaName"] == System.DBNull.Value ? null : dt.Rows[0]["UserAreaName"]);
                    model.VerifiedById = Convert.ToInt32(dt.Rows[0]["VerifiedById"] == System.DBNull.Value ? null : dt.Rows[0]["VerifiedById"]);
                    model.VerifiedBy = Convert.ToString(dt.Rows[0]["VerifiedBy"] == System.DBNull.Value ? null : dt.Rows[0]["VerifiedBy"]);
                    model.TotalPcs = Convert.ToDecimal(dt.Rows[0]["TotalPcs"] == System.DBNull.Value ? null : dt.Rows[0]["TotalPcs"]);
                    model.TotalInUse = Convert.ToDecimal(dt.Rows[0]["TotalInUse"] == System.DBNull.Value ? null : dt.Rows[0]["TotalInUse"]);
                    model.TotalShelf = Convert.ToDecimal(dt.Rows[0]["TotalShelf"] == System.DBNull.Value ? null : dt.Rows[0]["TotalShelf"]);
                    model.Remarks = Convert.ToString(dt.Rows[0]["Remarks"]);

                }
                if (model.StoreType == "10172")
                {
                    DataSet dt2 = dbAccessDAL.MasterGetDataSet("LLSLinenInventoryTxnDet_UserDeptArea_GetById", parameters, DataSetparameters);

                    if (dt != null && dt2.Tables.Count > 0)
                    {
                        model.LLinenInventoryLinenItemListGrid = (from n in dt2.Tables[0].AsEnumerable()
                                                                  select new LLinenInventoryclassLinenItemList
                                                                  {

                                                                      LinenInventoryId = Id,
                                                                      LinenItemId=Convert.ToInt32(n["LinenItemId"]),
                                                                      LlsLinenInventoryTxnDetId = Convert.ToInt32(n["LlsLinenInventoryTxnDetId"]),
                                                                      LinenCode = Convert.ToString(n["LinenCode"] == System.DBNull.Value ? null : n["LinenCode"]),
                                                                      LinenDescription = Convert.ToString(n["LinenDescription"] == System.DBNull.Value ? null : n["LinenDescription"]),
                                                                      LocationCode = Convert.ToString(n["UserLocationCode"] == System.DBNull.Value ? null : n["UserLocationCode"]),
                                                                      InUse = Convert.ToDecimal(n["InUse"] == System.DBNull.Value ? null : n["InUse"]),
                                                                      Shelf = Convert.ToDecimal(n["Shelf"] == System.DBNull.Value ? null : n["Shelf"]),
                                                                      UserAreaTotalPcs = Convert.ToDecimal(n["TotalPcs"] == System.DBNull.Value ? null : n["TotalPcs"]),
                                                                      LLSUserAreaLocationId = Convert.ToInt32(n["LLSUserAreaLocationId"]),
                                                                  }).ToList();
                        model.LLinenInventoryLinenItemListGrid.ForEach((x) =>
                        {

                        });


                    }
                }
                else
                {
                    DataSet dt3 = dbAccessDAL.MasterGetDataSet("LLSLinenInventoryTxnDet_CentralCleanLinenStore_GetById", parameters, DataSetparameters);
                    if (dt != null && dt3.Tables.Count > 0)
                    {
                        model.LLinenInventoryCCLSListGrid = (from n in dt3.Tables[0].AsEnumerable()
                                                             select new LLinenInventoryclassLinenItemList
                                                             {

                                                                 LinenInventoryId = Id,
                                                                 LlsLinenInventoryTxnDetId = Convert.ToInt32(n["LlsLinenInventoryTxnDetId"]),
                                                                 LinenItemId = Convert.ToInt32(n["LinenItemId"] == System.DBNull.Value ? null : n["LinenItemId"]),
                                                                 LinenCode = Convert.ToString(n["LinenCode"] == System.DBNull.Value ? null : n["LinenCode"]),
                                                                 LinenDescription = Convert.ToString(n["LinenDescription"] == System.DBNull.Value ? null : n["LinenDescription"]),
                                                                 CCLSInUse = Convert.ToDecimal(n["CCLSInUse"] == System.DBNull.Value ? null : n["CCLSInUse"]),
                                                                 CCLSShelf = Convert.ToDecimal(n["CCLSShelf"] == System.DBNull.Value ? null : n["CCLSShelf"]),
                                                                 //TotalPcs = Convert.ToDecimal(n["TotalPcs"]),
                                                                 // InUse = Convert.ToDecimal(n["InUse"]),
                                                                 CCLSTotalPcs = Convert.ToDecimal(n["TotalPcs(A)"] == System.DBNull.Value ? null : n["TotalPcs(A)"]),
                                                                 //TotalPcsB = Convert.ToDecimal(n["TotalPcs(B)"] == System.DBNull.Value ? null : n["TotalPcs(B)"]),
                                                                 //TotalPcsAB = Convert.ToDecimal(n["TotalPcs(A+B)"] == System.DBNull.Value ? null : n["TotalPcs(A+B)"]),
                                                                 //StoreBalance = Convert.ToDecimal(n["StoreBalance"] == System.DBNull.Value ? null : n["StoreBalance"]),
                                                                 //Variance = Convert.ToDecimal(n["Variance"] == System.DBNull.Value ? null : n["Variance"])

                                                             }).ToList();
                        model.LLinenInventoryCCLSListGrid.ForEach((x) =>
                        {

                        });


                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                    return model;
                //}
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
                        cmd.CommandText = "LLSLinenInventoryTxn_GetAll";

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
                DataTable dt = dbAccessDAL.GetDataTable("LLSLinenInventoryTxn_Delete", parameters, DataSetparameters);
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

        public bool IsLinenAdjustmentDuplicate(TestModel model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsLinenAdjustmentDuplicate), Level.Info.ToString());
                var IsDuplicate = true;
                var dbAccessDAL = new BEMSDBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@Id", model.LinenInventoryId.ToString());
                parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@DocumentNo", Convert.ToString(model.DocumentNo));
                DataTable dt = dbAccessDAL.GetDataTable("LLSLinenInventoryTxn_ValCode", parameters, DataSetparameters);
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
        public bool IsRecordModified(TestModel model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsRecordModified), Level.Info.ToString());
                var recordModifed = false;
                if (model.LinenInventoryId != 0)
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
                            cmd.Parameters.AddWithValue("Id", model.LinenInventoryId);
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
                        cmd.CommandText = "LLSLinenInventoryTxnDetSingle_Delete";
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
