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
    public class CentralCleanLinenStoreDAL : ICentralCleanLinenStoreDAL
    {
        private readonly string _FileName = nameof(CentralCleanLinenStoreDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public CentralCleanLinenStoreDAL()
        {

        }

        public CentralCleanLinenStoreModelLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                CentralCleanLinenStoreModelLovs UserCentralCleanLinenStoreModelLovs = new CentralCleanLinenStoreModelLovs();
                string lovs = "HousekeepingStoreTypeValue";
                var dbAccessDAL = new MASTERDBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pLovKey", lovs);
                DataSet ds = dbAccessDAL.MasterGetDataSet("uspFM_Dropdown", parameters, DataSetparameters);
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    UserCentralCleanLinenStoreModelLovs.StoreType = dbAccessDAL.GetLovRecords(ds.Tables[0], "HousekeepingStoreTypeValue");


                }

                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());

                return UserCentralCleanLinenStoreModelLovs;
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

        public CentralCleanLinenStoreModel Save(CentralCleanLinenStoreModel model, out string ErrorMessage)
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
                // List<LLinenAdjustmentLinenItemList> LinenAdjustdetailList = new List<LLinenAdjustmentLinenItemList>();
                // LinenAdjustdetailList = model.LLinenAdjustmentLinenItemListGrid;
                DataTable dataTable = new DataTable("CentralCleanLinenMst");
                DataTable dataTable1 = new DataTable("LinenAdjustmentMstDet");

                if (model.CCLSId != 0)
                {
                    // parameters.Add("@AuthorisedBy", Convert.ToString(model.AuthorisedBy));
                    // parameters.Add("@Remarks", Convert.ToString(model.Remarks));
                    parameters.Add("@LinenAdjustmentId", Convert.ToString(model.CCLSId));
                    DataTable dss = dbAccessDAL.GetMASTERDataTable("LLSLinenAdjustmentTxn_Update", parameters, DataSetparameters);
                    // foreach (var row in LinenAdjustdetailList)
                    //{
                    //    rowparameters.Add("@Justification", Convert.ToString(row.Justification));
                    //    rowparameters.Add("@LinenAdjustmentId", Convert.ToString(model.LinenInventoryId));
                    //}

                    //DataTable dsss = dbAccessDAL.GetMASTERDataTable("LLSLinenAdjustmentTxnDet_Update", rowparameters, DataSetparameters);
                    return model;
                }
                else
                {
                    spName = "LLSCentralCleanLinenStoreMst_Save";
                }

                dataTable.Columns.Add("CustomerId", typeof(int));
                dataTable.Columns.Add("FacilityId", typeof(int));
                dataTable.Columns.Add("StoreType", typeof(string));
                
                dataTable.Rows.Add(
                    _UserSession.CustomerId,
                    _UserSession.FacilityId,
                    model.StoreType                            
                );
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = spName;
                        SqlParameter parameter = new SqlParameter();
                        parameter.ParameterName = "@LLSCentralCleanLinenStoreMst";
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
                    var CCLSId = Convert.ToInt32(ds.Tables[0].Rows[0]["CCLSId"]);
                    if (CCLSId != 0)
                        model.CCLSId = CCLSId;
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



                if (model.CCLSId != 0)
                {

                }
                else
                {
                    spNames = "LLSCentralCleanLinenStoreMstDet_Save";
       
                    dataTable1.Columns.Add("CustomerId", typeof(int));
                    dataTable1.Columns.Add("FacilityID", typeof(int));
                    dataTable1.Columns.Add("CCLSId", typeof(int));
                    dataTable1.Columns.Add("LinenItemId", typeof(int));
                    dataTable1.Columns.Add("StoreBalance", typeof(decimal));
                    dataTable1.Columns.Add("StockLevel", typeof(decimal));
                    dataTable1.Columns.Add("ReorderQuantity", typeof(decimal));
                    dataTable1.Columns.Add("Par1", typeof(decimal));
                    dataTable1.Columns.Add("Par2", typeof(decimal));
                    //foreach (var row in LinenAdjustdetailList)
                    //{
                    //    dataTable1.Rows.Add(
                    //    model.LinenInventoryId,
                    //    _UserSession.CustomerId,
                    //    _UserSession.FacilityId,
                    //    row.LinenItemId,
                    //    row.ActualQuantity,
                    //    row.StoreBalance,
                    //    row.AdjustQuantity,
                    //    row.Justification
                    //    );
                    //}
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


        public CentralCleanLinenStoreModel Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                //CentralCleanLinenStoreModel model = null;
                CentralCleanLinenStoreModel model = new CentralCleanLinenStoreModel();
                var entity = new CentralCleanLinenStoreModelList();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                var ds = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "LLSCentralCleanLinenStoreMst_GetById";
                        cmd.Parameters.AddWithValue("Id", Id);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0)
                {
                    model = (from n in ds.Tables[0].AsEnumerable()
                             select new CentralCleanLinenStoreModel
                             {
                                 CCLSId=Id,
                                 StoreType = Convert.ToString(n["StoreType"]),

                             }).FirstOrDefault();
                }
                DataSet dt1 = dbAccessDAL.MasterGetDataSet("LLSCentralCleanLinenStoreMstDet_GetById", parameters, DataSetparameters);
                if (dt1 != null && dt1.Tables.Count > 0)
                {

                    model.CentralCleanLinenStoreModelListData = (from n in dt1.Tables[0].AsEnumerable()
                                                                 select new CentralCleanLinenStoreModelList
                                                                 {
                                                                     // Year = Convert.ToInt32(n["Year"]),
                                                                     // Month = Convert.ToInt32(n["Month"]),
                                                                     LinenCode = Convert.ToString(n["LinenCode"]),
                                                                     LinenDescription = Convert.ToString(n["LinenDescription"]),
                                                                     StockLevel = Convert.ToInt32(n["StockLevel"]),
                                                                     Par2 = Convert.ToInt32(n["Par2"]),
                                                                     Par1 = Convert.ToInt32(n["Par1"]),
                                                                     StoreBalance = Convert.ToInt32(n["StoreBalance"]),
                                                                     ReorderQuantity = Convert.ToInt32(n["ReorderQuantity"]),
                                                                     //TotalRequirement = Convert.ToInt32(n["TotalRequirement"]),
                                                                     //RepairQuantity = Convert.ToInt32(n["RepairQuantity"]),


                                                                     //TotalRecords = Convert.ToInt32(n["TotalRecords"]),
                                                                     //TotalPages = Convert.ToInt32(n["TotalPageCalc"]),
                                                                 }).ToList();

                    model.CentralCleanLinenStoreModelListData.ForEach((x) =>
                    {
                        x.PageSize = model.PageSize;
                        x.PageIndex = model.PageIndex;
                        x.FirstRecord = ((model.PageIndex - 1) * model.PageSize) + 1;
                        x.LastRecord = ((model.PageIndex - 1) * model.PageSize) + model.PageSize;
                        //x.LastPageIndex = x.TotalRecords % model.PageSize == 0 ? x.TotalRecords / model.PageSize : (x.TotalRecords / model.PageSize) + 1;

                    });
                }
                    Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                    return model;
                
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex );
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
                var dss = new DataSet();
                var ds = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                //using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                //{
                //    using (SqlCommand cmd = new SqlCommand())
                //    {
                //        cmd.Connection = con;
                //        cmd.CommandType = CommandType.StoredProcedure;
                //        cmd.CommandText = "LLSCentralCleanLinenStoreMstDet_Calc";
                //        var daa = new SqlDataAdapter();
                //        daa.SelectCommand = cmd;
                //        daa.Fill(dss);
                //    }
                //}
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "LLSCentralCleanLinenStoreMst_GetAll";
                        cmd.Parameters.AddWithValue("@PageIndex", pageFilter.PageIndex);
                        cmd.Parameters.AddWithValue("@PageSize", pageFilter.PageSize);
                        cmd.Parameters.AddWithValue("@StrCondition", strCondition);
                        cmd.Parameters.AddWithValue("@StrSorting", null);
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
                var dbAccessDAL = new MASTERDBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@Id", Id.ToString());
                DataTable dt = dbAccessDAL.GetMASTERDataTable("BlockMst_Delete", parameters, DataSetparameters);
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
        public bool IsCentralCleanLinenStoreDuplicate(CentralCleanLinenStoreModel model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsCentralCleanLinenStoreDuplicate), Level.Info.ToString());
                var IsDuplicate = true;
                var dbAccessDAL = new BEMSDBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@Id", model.CCLSId.ToString());
                parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@StoreType", Convert.ToString(model.StoreType));
                DataTable dt = dbAccessDAL.GetDataTable("LLSCentralCleanLinenStoreMst_ValCode", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    IsDuplicate = Convert.ToBoolean(dt.Rows[0]["IsDuplicate"]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(IsCentralCleanLinenStoreDuplicate), Level.Info.ToString());
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
        public bool IsRecordModified(CentralCleanLinenStoreModel model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsRecordModified), Level.Info.ToString());
                var recordModifed = false;
                if (model.CCLSId != 0)
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
                            cmd.Parameters.AddWithValue("Id", model.CCLSId);
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
