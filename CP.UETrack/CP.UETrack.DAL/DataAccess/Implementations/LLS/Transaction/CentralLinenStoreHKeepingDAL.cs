using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.LLS;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using CP.UETrack.Model.LLS;
using CP.UETrack.Models;
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
    public class CentralLinenStoreHKeepingDAL : ICentralLinenStoreHKeepingDAL
    {
        private readonly string _FileName = nameof(CentralLinenStoreHKeepingDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public CentralLinenStoreHKeepingDAL()
        {

        }

        public CentralLinenStoreHousekeepingModelLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                CentralLinenStoreHousekeepingModelLovs CentralLinenStoreHousekeepingModelLovs = new CentralLinenStoreHousekeepingModelLovs();

                var dbAccessDAL = new DBAccessDAL();
                var ds = new DataSet();
                var ds1 = new DataSet();
                var ds2 = new DataSet();
                var currentYear = DateTime.Now.Year;
                var prevoiusYear = currentYear - 1;
                CentralLinenStoreHousekeepingModelLovs.Year = new List<LovValue> { new LovValue { LovId = currentYear, FieldValue = currentYear.ToString() }, new LovValue { LovId = prevoiusYear, FieldValue = prevoiusYear.ToString() } };
                CentralLinenStoreHousekeepingModelLovs.CurrentYear = currentYear;
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown_Others";
                        cmd.Parameters.AddWithValue("@pTablename", "FinMonthlyFeeTxn");
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);



                        if (ds.Tables.Count != 0)
                        {
                            CentralLinenStoreHousekeepingModelLovs.MonthName = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }
                    }
                }
                string lovs = "HousekeepingStoreTypeValue,YesNoValue";
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pLovKey", lovs);
                DataSet ds4 = dbAccessDAL.GetDataSet("uspFM_Dropdown", parameters, DataSetparameters);
                if (ds4.Tables.Count != 0 && ds4.Tables[0].Rows.Count > 0)
                {
                    CentralLinenStoreHousekeepingModelLovs.StoreType = dbAccessDAL.GetLovRecords(ds4.Tables[0], "HousekeepingStoreTypeValue");
                    CentralLinenStoreHousekeepingModelLovs.HousekeepingDone = dbAccessDAL.GetLovRecords(ds4.Tables[0], "YesNoValue");
                }



                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return CentralLinenStoreHousekeepingModelLovs;
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

        public CentralLinenStoreHousekeepingModel Save(CentralLinenStoreHousekeepingModel model, out string ErrorMessage)
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
                var rowparameters = new Dictionary<string, string>();
                var parameters = new Dictionary<string, string>();

                //TimeSpan DateTimeStamp = new TimeSpan();
                // Convert String to timespan
                //DateTimeStamp = TimeSpan.Parse(DateTimeStamp.ToString());
                DateTime DateTimeStamp = DateTime.Now;
                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable varDt2 = new DataTable();
                List<LCentralHouseItemList> HKeepingList = new List<LCentralHouseItemList>();
                HKeepingList = model.LCentralHouseItemGridList;
                DataTable dataTable = new DataTable("HousekeepingMst");
                DataTable dataTable1 = new DataTable("HousekeepingDetails");
                parameters.Add("@StoreType", Convert.ToString(model.StoreType));
                parameters.Add("@Year", Convert.ToString(model.Year));
                parameters.Add("@Month", Convert.ToString(model.Month));
                parameters.Add("@HouseKeepingId", Convert.ToString(model.HouseKeepingId));
                parameters.Add("@HouseKeepingDetId", Convert.ToString(model.HouseKeepingDetId));
                parameters.Add("@HousekeepingDone", Convert.ToString(model.HousekeepingDone));
                parameters.Add("@Date", Convert.ToString(model.Date));
                parameters.Add("@DateTimeStamp", Convert.ToString(DateTimeStamp));
                parameters.Clear();
                // Delete grid

                var deletedId = model.LCentralHouseItemGridList.Where(y => y.IsDeleted).Select(x => x.HouseKeepingDetId).ToList();
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
                //if (model.HouseKeepingId != 0)
                //{
                //    // DataTable dss = dbAccessDAL.GetMASTERDataTable("LLSCentralLinenStoreHKeepingTxnDet_Update ", parameters, DataSetparameters);
                //    foreach (var row in HKeepingList)
                //    {
                //        rowparameters.Clear();
                //        rowparameters.Add("@HouseKeepingDetId", Convert.ToString(row.HouseKeepingDetId));
                //        rowparameters.Add("@HousekeepingDone", Convert.ToString(row.HousekeepingDone));
                //        rowparameters.Add("@Date", Convert.ToString(row.Date));
                //        //rowparameters.Add("@DateTimeStamp", Convert.ToString(row.DateTimeStamp));
                //        //rowparameters.Add("@HouseKeepingId", Convert.ToString(row.HouseKeepingId));
                //        DataTable dsss = dbAccessDAL.GetMASTERDataTable("LLSCentralLinenStoreHKeepingTxnDet_Update", rowparameters, DataSetparameters);

                //    }
                //    return model;
                //}
                if (model.HouseKeepingId != 0)
                {
                    // DataTable dss = dbAccessDAL.GetMASTERDataTable("LLSCentralLinenStoreHKeepingTxnDet_Update ", parameters, DataSetparameters);

                    varDt2.Columns.Add("@HouseKeepingDetId", typeof(int));
                    varDt2.Columns.Add("@HousekeepingDone", typeof(int));
                    varDt2.Columns.Add("@Date", typeof(DateTime));
                    varDt2.Columns.Add("@ModifiedBy", typeof(int));
                    foreach (var var in model.LCentralHouseItemGridList)
                    {
                        varDt2.Rows.Add(var.HouseKeepingDetId, var.HousekeepingDone, var.Date, _UserSession.UserId.ToString());
                    }
                    parameters.Clear();
                    DataSetparameters.Add("@LLSCentralLinenStoreHKeepingTxnDet_Update", varDt2);
                    DataTable dss = dbAccessDAL.GetMASTERDataTable("LLSCentralLinenStoreHKeepingTxnDet_Update", parameters, DataSetparameters);
                    foreach (var obj in model.LCentralHouseItemGridList)
                    {
                        if (obj.HouseKeepingDetId == 0)
                        {
                            spNames = "LLSCentralLinenStoreHKeepingTxnDet_Save";
                            dataTable1.Columns.Add("HouseKeepingId", typeof(int));
                            dataTable1.Columns.Add("CustomerId", typeof(int));
                            dataTable1.Columns.Add("FacilityID", typeof(int));
                            dataTable1.Columns.Add(new DataColumn("Date", typeof(DateTime)));
                            //dataTable1.Columns.Add("HouseKeepingDetId", typeof(string));
                            dataTable1.Columns.Add("HousekeepingDone", typeof(string));
                            dataTable1.Columns.Add(new DataColumn("DateTimeStamp", typeof(DateTime)));
                            dataTable1.Columns.Add("CreatedBy", typeof(int));
                            foreach (var row in HKeepingList)
                            {
                                if (row.HouseKeepingDetId == 0)
                                {
                                    dataTable1.Rows.Add(
                                        model.HouseKeepingId,
                                        _UserSession.CustomerId,
                                        _UserSession.FacilityId,
                                        row.Date,
                                        //row.HouseKeepingDetId,
                                        row.HousekeepingDone,
                                        DateTime.Now,
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
                        if (obj.HouseKeepingDetId == 0)
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
                    spName = "LLSCentralLinenStoreHKeepingTxn_Save";
                }
                dataTable.Columns.Add("CustomerId", typeof(int));
                dataTable.Columns.Add("FacilityId", typeof(int));
                dataTable.Columns.Add("Year", typeof(int));
                dataTable.Columns.Add("Month", typeof(string));
                dataTable.Columns.Add("StoreType", typeof(int));
                dataTable.Columns.Add("CreatedBy", typeof(int));
                dataTable.Columns.Add("ModifiedBy", typeof(int));
                dataTable.Rows.Add(_UserSession.CustomerId, _UserSession.FacilityId,
                   model.Year, model.Month, model.StoreType, _UserSession.UserId.ToString(), _UserSession.UserId.ToString());

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
                    var HouseKeepingId = Convert.ToInt32(ds.Tables[0].Rows[0]["HouseKeepingId"]);
                    if (HouseKeepingId != 0)
                        model.HouseKeepingId = HouseKeepingId;
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
                if (model.HouseKeepingDetId != 0)
                {

                }
                else
                {

                    spNames = "LLSCentralLinenStoreHKeepingTxnDet_Save";
                    dataTable1.Columns.Add("HouseKeepingId", typeof(int));
                    dataTable1.Columns.Add("CustomerId", typeof(int));
                    dataTable1.Columns.Add("FacilityID", typeof(int));
                    dataTable1.Columns.Add(new DataColumn("Date", typeof(DateTime)));
                    //dataTable1.Columns.Add("HouseKeepingDetId", typeof(string));
                    dataTable1.Columns.Add("HousekeepingDone", typeof(string));
                    dataTable1.Columns.Add(new DataColumn("DateTimeStamp", typeof(DateTime)));
                    dataTable1.Columns.Add("CreatedBy", typeof(int));
                    foreach (var row in HKeepingList)
                    {
                        dataTable1.Rows.Add(
                        model.HouseKeepingId,
                        _UserSession.CustomerId,
                        _UserSession.FacilityId,
                        row.Date,
                        //row.HouseKeepingDetId,
                        row.HousekeepingDone,
                        DateTime.Now,
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
                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());

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


        public CentralLinenStoreHousekeepingModel Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                CentralLinenStoreHousekeepingModel model = new CentralLinenStoreHousekeepingModel();
                var ds = new DataSet();
                var parameters = new Dictionary<string, string>();
                var dbAccessDAL = new MASTERDBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameter = new Dictionary<string, string>();
                parameters.Add("Id", Convert.ToString(Id));
                #region
                //using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                //{
                //    using (SqlCommand cmd = new SqlCommand())
                //    {
                //        cmd.Connection = con;
                //        cmd.CommandType = CommandType.StoredProcedure;
                //        cmd.CommandText = "LLSCentralLinenStoreHKeepingTxn_GetById";
                //        cmd.Parameters.AddWithValue("Id", Id);
                //        var da = new SqlDataAdapter();
                //        da.SelectCommand = cmd;
                //        da.Fill(ds);


                //    }
                //}
                //if (ds.Tables.Count != 0)
                //{
                //    model = (from n in ds.Tables[0].AsEnumerable()
                //             select new CentralLinenStoreHousekeepingModel
                //             {
                //                 ///CCLSId = Id,
                //                 StoreTypes = Convert.ToString(n["StoreType"]),
                //                 Years = Convert.ToInt32(n["Year"]),
                //                 Month = Convert.ToString(n["Month"]),

                //             }).FirstOrDefault();
                //}
                //parameters.Add("@Id", Id.ToString());
                //DataSet dt1 = dbAccessDAL.MasterGetDataSet("LLSCentralLinenStoreHKeepingTxnDet_GetById", parameters, DataSetparameters);

                //if (dt1 != null && dt1.Tables.Count > 0)
                //{

                //    model.LCentralHouseItemGridList = (from n in dt1.Tables[0].AsEnumerable()
                //                                                 select new LCentralHouseItemList
                //                                                 {
                //                                                     //HouseKeepingDetId = Id,

                //                                                     Date = Convert.ToDateTime(n["Date"] ==System.DBNull.Value ? null : dt1.Tables[0].Rows[0]["Date"]),
                //                                                     HousekeepingDone = Convert.ToInt32(n["HousekeepingDone"] == System.DBNull.Value ? null : dt1.Tables[0].Rows[0]["HousekeepingDone"]),
                //                                                     DateTimeStamp = Convert.ToDateTime(n["DateTimeStamp"] == System.DBNull.Value ? null : dt1.Tables[0].Rows[0]["DateTimeStamp"]),

                //                                                 }).ToList();

                //    model.LCentralHouseItemGridList.ForEach((x) =>
                //    {
                //        x.PageSize = model.PageSize;
                //        x.PageIndex = model.PageIndex;
                //        x.FirstRecord = ((model.PageIndex - 1) * model.PageSize) + 1;
                //        x.LastRecord = ((model.PageIndex - 1) * model.PageSize) + model.PageSize;
                //        //x.LastPageIndex = x.TotalRecords % model.PageSize == 0 ? x.TotalRecords / model.PageSize : (x.TotalRecords / model.PageSize) + 1;

                //    });
                #endregion
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSCentralLinenStoreHKeepingTxn_GetById", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {

                    model.StoreType = Convert.ToString(dt.Rows[0]["StoreType"]);
                    model.Year = Convert.ToString(dt.Rows[0]["Year"]);
                    model.Month = Convert.ToString(dt.Rows[0]["Month"]);
                    model.HouseKeepingId = Id;
                }
                DataSet dt1 = dbAccessDAL.MasterGetDataSet("LLSCentralLinenStoreHKeepingTxnDet_GetById", parameters, DataSetparameters);
                if (dt1 != null && dt1.Tables.Count > 0)
                {
                    model.LCentralHouseItemGridList = (from n in dt1.Tables[0].AsEnumerable()
                                                       select new LCentralHouseItemList
                                                       {
                                                           HouseKeepingDetId = Convert.ToInt32(n["HouseKeepingDetId"]),
                                                           Date = Convert.ToDateTime(n["Date"]),
                                                           HousekeepingDone = Convert.ToInt32(n["HousekeepingDone"]),
                                                           DateTimeStamp = Convert.ToDateTime(n["DateTimeStamp"]),
                                                           HouseKeepingId = Id
                                                       }).ToList();
                    model.LCentralHouseItemGridList.ForEach((x) =>
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
                throw new DALException(dalex);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public CentralLinenStoreHousekeepingModel HKeeping(int StoreType, int Year, int Month, int pagesize, int pageindex)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                CentralLinenStoreHousekeepingModel model = new CentralLinenStoreHousekeepingModel();
                var entity = new LCentralHouseItemList();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                var ds = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                //using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                //{
                //    using (SqlCommand cmd = new SqlCommand())
                //    {
                //        cmd.Connection = con;
                //        cmd.CommandType = CommandType.StoredProcedure;
                //        cmd.CommandText = "LLSCentralLinenStoreHKeepingTxn_GetById";
                //        cmd.Parameters.AddWithValue("Id", Id);
                //        var da = new SqlDataAdapter();
                //        da.SelectCommand = cmd;
                //        da.Fill(ds);
                //    }
                //}
                //if (ds.Tables.Count != 0)
                //{
                //    model = (from n in ds.Tables[0].AsEnumerable()
                //             select new CentralLinenStoreHousekeepingModel
                //             {

                //                 StoreType = Convert.ToInt32(n["StoreType"]),
                //                 Year = Convert.ToString(n["Year"]),
                //                 Month = Convert.ToString(n["Month"]),

                //             }).FirstOrDefault();
                //}
                //DataSet dt1 = dbAccessDAL.MasterGetDataSet("LLSCentralCleanLinenStoreMstDet_GetById", parameters, DataSetparameters);
                //if (dt1 != null && dt1.Tables.Count > 0)
                //{

                //    model.LCentralHouseItemList = (from n in dt1.Tables[0].AsEnumerable()
                //                                                 select new CentralCleanLinenStoreModelList
                //                                                 {
                //                                                     // Year = Convert.ToInt32(n["Year"]),
                //                                                     // Month = Convert.ToInt32(n["Month"]),
                //                                                     LinenCode = Convert.ToString(n["LinenCode"]),
                //                                                     LinenDescription = Convert.ToString(n["LinenDescription"]),
                //                                                     StoreBalance = Convert.ToInt32(n["StoreBalance"]),
                //                                                     StockLevel = Convert.ToInt32(n["StockLevel"]),
                //                                                     ReorderQuantity = Convert.ToInt32(n["ReorderQuantity"]),
                //                                                     Par1 = Convert.ToInt32(n["Par1"]),
                //                                                     Par2 = Convert.ToInt32(n["Par2"]),
                //                                                     //TotalRequirement = Convert.ToInt32(n["TotalRequirement"]),
                //                                                     //RepairQuantity = Convert.ToInt32(n["RepairQuantity"]),


                //                                                     //TotalRecords = Convert.ToInt32(n["TotalRecords"]),
                //                                                     //TotalPages = Convert.ToInt32(n["TotalPageCalc"]),
                //                                                 }).ToList();

                //    model.CentralCleanLinenStoreModelListData.ForEach((x) =>
                //    {
                //        x.PageSize = model.PageSize;
                //        x.PageIndex = model.PageIndex;
                //        x.FirstRecord = ((model.PageIndex - 1) * model.PageSize) + 1;
                //        x.LastRecord = ((model.PageIndex - 1) * model.PageSize) + model.PageSize;
                //        //x.LastPageIndex = x.TotalRecords % model.PageSize == 0 ? x.TotalRecords / model.PageSize : (x.TotalRecords / model.PageSize) + 1;

                //    });
                //}
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return model;
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
                var dbAccessDAL = new BEMSDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "LLSCentralLinenStoreHKeepingTxn_GetAll";

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
        public bool IsCentralLinenStoreHKeepingDuplicate(CentralLinenStoreHousekeepingModel model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsCentralLinenStoreHKeepingDuplicate), Level.Info.ToString());

                var IsDuplicate = true;
                var dbAccessDAL = new BEMSDBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@Id", model.HouseKeepingId.ToString());
                //parameters.Add("@UserAreaCode", model.CleanLinenRequestId.ToString());
                parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@Year", Convert.ToString(model.Year));
                parameters.Add("@Month", Convert.ToString(model.Month));
                parameters.Add("@StoreType", Convert.ToString(model.StoreType));
                DataTable dt = dbAccessDAL.GetDataTable("LLSCentralLinenStoreHKeepingTxn_ValCode", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    IsDuplicate = Convert.ToBoolean(dt.Rows[0]["IsDuplicate"]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(IsCentralLinenStoreHKeepingDuplicate), Level.Info.ToString());
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
        public bool IsRecordModified(CentralLinenStoreHousekeepingModel model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsRecordModified), Level.Info.ToString());

                var recordModifed = false;

                if (model.HouseKeepingId != 0)
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
                            cmd.Parameters.AddWithValue("Id", model.HouseKeepingId);
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
                DataTable dt = dbAccessDAL.GetDataTable("LLSCentralLinenStoreHKeepingTxn_Delete", parameters, DataSetparameters);
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
                        cmd.CommandText = "LLSCentralLinenStoreHKeepingTxnDetSingle_Delete";
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
