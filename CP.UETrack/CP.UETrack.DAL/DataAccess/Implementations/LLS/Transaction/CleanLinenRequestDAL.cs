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

namespace CP.UETrack.DAL.DataAccess.Implementations.LLS.Transaction
{

    public class CleanLinenRequestDAL : ICleanLinenRequestDAL
    {
        private readonly string _FileName = nameof(CleanLinenRequestDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public CleanLinenRequestDAL()
        {

        }

        public CleanLinenRequestModelLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());

                CleanLinenRequestModelLovs CleanLinenRequestModelLovs = new CleanLinenRequestModelLovs();
                CleanLinenRequestModel clean = new CleanLinenRequestModel();

                string lovs = "PriorityValue,IssueStatusValue,IssuedOnTimeValue,DeliveryScheduleValue,QCTimelinessValue";
                var dbAccessDAL = new MASTERDBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pLovKey", lovs);
                DataSet ds = dbAccessDAL.MasterGetDataSet("uspFM_Dropdown", parameters, DataSetparameters);
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    CleanLinenRequestModelLovs.Priority = dbAccessDAL.GetLovRecords(ds.Tables[0], "PriorityValue");
                    CleanLinenRequestModelLovs.IssueStatus = dbAccessDAL.GetLovRecords(ds.Tables[0], "IssueStatusValue");
                    CleanLinenRequestModelLovs.IssuedonTime = dbAccessDAL.GetLovRecords(ds.Tables[0], "IssuedOnTimeValue");
                    CleanLinenRequestModelLovs.DeliveryWindow = dbAccessDAL.GetLovRecords(ds.Tables[0], "DeliveryScheduleValue");
                    CleanLinenRequestModelLovs.QCTimeliness = dbAccessDAL.GetLovRecords(ds.Tables[0], "QCTimelinessValue");
                    CleanLinenRequestModelLovs.ShortfallQC = dbAccessDAL.GetLovRecords(ds.Tables[0], "QCTimelinessValue");


                }
                var DataSetparameters1 = new Dictionary<string, DataTable>();
                var parameters1 = new Dictionary<string, string>();
                parameters1.Add("@pLovKey", null);
                parameters1.Add("@pTableName", "CleanLinenRequest");
                DataSet ds1 = dbAccessDAL.MasterGetDataSet("uspFM_Dropdown_Others", parameters1, DataSetparameters1);

                if (ds1.Tables.Count != 0 && ds1.Tables[0].Rows.Count > 0)
                {
                    CleanLinenRequestModelLovs.cleanLinenLaundryValue = (from n in ds1.Tables[0].AsEnumerable()

                                                                         select new cleanLinenLaundryValueList
                                                                         {
                                                                             LovId = Convert.ToInt32(n["LovId"]),
                                                                             FieldValue = Convert.ToString(n["FieldValue"]),

                                                                         }).ToList();
                }


                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());

                return CleanLinenRequestModelLovs;
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

        public CleanLinenRequestModel Save(CleanLinenRequestModel model, out string ErrorMessage)
        {
            try
            {


                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                var spName = string.Empty;
                var spNames = string.Empty;
                var spNamess = string.Empty;
                DateTime now = DateTime.Now;
                String s = now.ToString("MM/dd/yyyy HH:mm:ss");
                var ds = new DataSet();
                var ds1 = new DataSet();
                var ds2 = new DataSet();
                var rowparameters = new Dictionary<string, string>();
                var dbAccessDAL = new MASTERDBAccessDAL();
                var parameters = new Dictionary<string, string>();
                var parameterss = new Dictionary<string, string>();
                var parametersL = new Dictionary<string, string>();
                var parametersLI = new Dictionary<string, string>();
                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable dataTable = new DataTable("CleanLinenRequestMst");
                DataTable dataTable1 = new DataTable("CleanLinenRequestMstDet");
                DataTable dataTable2 = new DataTable("CleanLinenRequestMstsec");
                List<LLinenRequestItemList> LinenRequestItemList = new List<LLinenRequestItemList>();
                LinenRequestItemList = model.LLinenRequestItemGridList;
                parameters.Add("@Remarks", Convert.ToString(model.Remarks));
                parameters.Add("@CleanLinenRequestId", Convert.ToString(model.CleanLinenRequestId));
                parameters.Add("@ModifiedBy", _UserSession.UserId.ToString());
                //// Delete grid
                var deletedId = model.LLinenRequestItemGridList.Where(y => y.IsDeleted).Select(x => x.LinenItemId).ToList();
                var idstring = string.Empty;
                if (deletedId.Count() > 0)
                {
                    foreach (var item in deletedId.Select((value, var) => new { var, value }))
                    {
                        idstring += item.value;
                        if (item.var != deletedId.Count() - 1)
                        { idstring += ","; }
                    }
                    deleteChildrecords(model, idstring);
                }
                if (model.CleanLinenRequestId != 0)
                {

                    //if (dss != null)
                    //{
                    DataTable varDt1 = new DataTable();
                    varDt1.Columns.Add("CLRLinenBagId", typeof(int));
                    varDt1.Columns.Add("RequestedQuantity", typeof(int));
                    varDt1.Columns.Add("Remarks", typeof(string));
                    varDt1.Columns.Add("CleanLinenRequestId", typeof(int));
                    varDt1.Columns.Add("ModifiedBy", typeof(int));
                    if (model.cleanLinenLaundryValue != null)
                    {
                        foreach (var var in model.cleanLinenLaundryValue)
                        {

                            varDt1.Rows.Add(var.CLRLinenBagId, var.RequestedQuantity, var.Remarks, model.CleanLinenRequestId, _UserSession.UserId.ToString());
                        }
                    }

                    DataSetparameters.Add("@LLSCleanLinenRequestLinenBagTxnDet_Update", varDt1);
                    DataTable dsss = dbAccessDAL.GetMASTERDataTable("LLSCleanLinenRequestLinenBagTxnDet_Update", parameterss, DataSetparameters);
                    //}

                    DataTable varDt2 = new DataTable();
                    varDt2.Columns.Add("CLRLinenItemId", typeof(int));
                    varDt2.Columns.Add("RequestedQuantity", typeof(int));
                    varDt2.Columns.Add("CleanLinenRequestId", typeof(int));
                    varDt2.Columns.Add("ModifiedBy", typeof(int));

                    foreach (var var in model.LLinenRequestItemGridList)
                    {
                        varDt2.Rows.Add(var.CLRLinenItemId, var.RequestedQuantity, model.CleanLinenRequestId, _UserSession.UserId.ToString());
                    }
                    DataSetparameters.Clear();
                    DataSetparameters.Add("@LLSCleanLinenRequestLinenItemTxnDet_Update", varDt2);
                    DataTable dssss = dbAccessDAL.GetMASTERDataTable("LLSCleanLinenRequestLinenItemTxnDet_Update", parameterss, DataSetparameters);

                    //Commented on 18-11-2020 for more than 3 LinenCodes  Save 
                    //foreach (var jjj in model.LLinenRequestItemGridList)
                    //{

                    //if (jjj.CLRLinenItemId == 0)
                    //{
                    spNames = "LLSCleanLinenRequestLinenItemTxnDet_Save";
                    dataTable1.Columns.Add("CustomerId", typeof(int));
                    dataTable1.Columns.Add("FacilityId", typeof(int));
                    dataTable1.Columns.Add("CleanLinenRequestId", typeof(int));
                    dataTable1.Columns.Add("CleanLinenIssueId", typeof(int));
                    dataTable1.Columns.Add("LinenItemId", typeof(int));
                    dataTable1.Columns.Add("BalanceOnShelf", typeof(decimal));
                    dataTable1.Columns.Add("RequestedQuantity", typeof(decimal));
                    dataTable1.Columns.Add("CreatedBy", typeof(int));
                  
                    foreach (var row in LinenRequestItemList)
                    {
                        if (row.CLRLinenItemId == 0)
                        {
                            dataTable1.Rows.Add(
                            _UserSession.CustomerId,
                            _UserSession.FacilityId,
                            model.CleanLinenRequestId,
                            null,
                            row.LinenItemId,
                            row.BalanceOnShelf,
                            row.RequestedQuantity,
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
                    DataSetparameters.Clear();
                    DataTable dss = dbAccessDAL.GetMASTERDataTable("LLSCleanLinenRequestTxn_Update", parameters, DataSetparameters);

                    return model;
                }
                //if (jjj.CLRLinenItemId == 0)
                //{
                //    // return model;
                //}
                //else { }
            //}

            //}
                else
            {
                spName = "LLSCleanLinenRequestTxn_Save";
            }
            dataTable.Columns.Add("CustomerId", typeof(int));
            dataTable.Columns.Add("FacilityId", typeof(int));
            dataTable.Columns.Add("DocumentNo", typeof(string));
            dataTable.Columns.Add("RequestDateTime", typeof(DateTime));
            dataTable.Columns.Add("LLSUserAreaId", typeof(int));
            dataTable.Columns.Add("LLSUserAreaLocationId", typeof(int));
            dataTable.Columns.Add("RequestedBy", typeof(int));
            dataTable.Columns.Add("Priority", typeof(int));
            dataTable.Columns.Add("TotalItemRequested", typeof(int));
            dataTable.Columns.Add("TotalBagRequested", typeof(int));
            dataTable.Columns.Add("IssueStatus", typeof(int));
            dataTable.Columns.Add("Remarks", typeof(string));
            dataTable.Columns.Add("CreatedBy", typeof(int));
            dataTable.Columns.Add("ModifiedBy", typeof(int));

            dataTable.Rows.Add(
                 _UserSession.CustomerId,
                _UserSession.FacilityId,
                model.DocumentNo,
                model.RequestDateTime,
                model.LLSUserAreaId,
                model.LLSUserAreaLocationId,
                model.RequestedBy,
                model.Priority,
                model.TotalItemRequested,
                model.TotalBagRequested,
                model.IssueStatus,
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
                var CleanLinenRequestId = Convert.ToInt32(ds.Tables[0].Rows[0]["CleanLinenRequestId"]);
                if (CleanLinenRequestId != 0)
                    model.CleanLinenRequestId = CleanLinenRequestId;
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
            if (model.CLRLinenBagID != 0)
            {

            }
            else
            {
                DataTable varDt = new DataTable();
                varDt.Columns.Add("CustomerId", typeof(int));
                varDt.Columns.Add("FacilityId", typeof(int));
                varDt.Columns.Add("CleanLinenRequestId", typeof(int));
                varDt.Columns.Add("CleanLinenIssueId", typeof(int));
                varDt.Columns.Add("LaundryBag", typeof(int));
                varDt.Columns.Add("RequestedQuantity", typeof(int));
                varDt.Columns.Add("Remarks", typeof(string));
                varDt.Columns.Add("CreatedBy", typeof(int));

                if (model.cleanLinenLaundryValue != null)
                {
                    foreach (var var in model.cleanLinenLaundryValue)
                    {

                        varDt.Rows.Add(_UserSession.CustomerId, _UserSession.FacilityId, model.CleanLinenRequestId, null, var.FieldValue, var.RequestedQuantity, var.Remarks, _UserSession.UserId.ToString());
                    }
                }

                DataSetparameters.Add("@Block", varDt);

                DataTable dsss = dbAccessDAL.GetMASTERDataTable("LLSCleanLinenRequestLinenBagTxnDet_Save", parameterss, DataSetparameters);
            }
            if (model.CLRLinenItemId != 0)
            {

            }
            else
            {
                spNames = "LLSCleanLinenRequestLinenItemTxnDet_Save";
                dataTable1.Columns.Add("CustomerId", typeof(int));
                dataTable1.Columns.Add("FacilityId", typeof(int));
                dataTable1.Columns.Add("CleanLinenRequestId", typeof(int));
                dataTable1.Columns.Add("CleanLinenIssueId", typeof(int));
                dataTable1.Columns.Add("LinenItemId", typeof(int));
                dataTable1.Columns.Add("BalanceOnShelf", typeof(decimal));
                dataTable1.Columns.Add("RequestedQuantity", typeof(decimal));
                dataTable1.Columns.Add("CreatedBy", typeof(int));
                foreach (var row in LinenRequestItemList)
                {
                    if (row.LinenCode != null)
                    {
                        dataTable1.Rows.Add(
                        _UserSession.CustomerId,
                        _UserSession.FacilityId,
                        model.CleanLinenRequestId,
                        null,
                        row.LinenItemId,
                        row.BalanceOnShelf,
                        row.RequestedQuantity,
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


        public CleanLinenRequestModel Get(int Id)
{
    Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
    try
    {
        CleanLinenRequestModel model = new CleanLinenRequestModel();
        var ds = new DataSet();
        var dbAccessDAL = new MASTERDBAccessDAL();
        LLinenRequestItemList LLinenRequestItemList = new LLinenRequestItemList();
        var DataSetparameters = new Dictionary<string, DataTable>();
        var parameters = new Dictionary<string, string>();
        parameters.Add("Id", Convert.ToString(Id));
        DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSCleanLinenRequestTxn_GetById", parameters, DataSetparameters);
        if (dt != null && dt.Rows.Count > 0)
        {
            model.CleanLinenRequestId = Id;
            model.DocumentNo = Convert.ToString(dt.Rows[0]["DocumentNo"]);
            model.RequestDateTime = Convert.ToDateTime(dt.Rows[0]["RequestDateTime"]);
            model.UserAreaCode = Convert.ToString(dt.Rows[0]["UserAreaCode"]);
            model.UserAreaName = Convert.ToString(dt.Rows[0]["UserAreaName"]);
            model.UserLocationCode = Convert.ToString(dt.Rows[0]["UserLocationCode"]);
            model.UserLocationName = Convert.ToString(dt.Rows[0]["UserLocationName"]);
            model.RequestedBy = Convert.ToString(dt.Rows[0]["RequestedBy"]);
            model.Designation = Convert.ToString(dt.Rows[0]["Designation"]);
            model.IssuedonTime = Convert.ToString(dt.Rows[0]["IssuedOnTime"]);
            model.DeliverySchedule = Convert.ToString(dt.Rows[0]["DeliverySchedule"]);
            model.Priority = Convert.ToString(dt.Rows[0]["Priority"]);
            model.QCTimeliness = Convert.ToString(dt.Rows[0]["QCTimeliness"]);
            model.TotalItemRequested = Convert.ToInt32(dt.Rows[0]["TotalItemRequested"] == System.DBNull.Value ? null : dt.Rows[0]["TotalItemRequested"]);
            model.TotalItemIssued = Convert.ToInt32((dt.Rows[0]["TotalItemIssued"]) == System.DBNull.Value ? null : dt.Rows[0]["TotalItemIssued"]);
            model.TotalLinenItemShortfall = Convert.ToInt32((dt.Rows[0]["TotalLinenItemShortfall"]) == System.DBNull.Value ? null : dt.Rows[0]["TotalLinenItemShortfall"]);
            model.ShortfallQC = Convert.ToString((dt.Rows[0]["ShortfallQC"]) == System.DBNull.Value ? null : dt.Rows[0]["ShortfallQC"]);
            model.IssueStatus = Convert.ToString((dt.Rows[0]["IssueStatus"]) == System.DBNull.Value ? null : dt.Rows[0]["IssueStatus"]);
            model.Remarks = Convert.ToString((dt.Rows[0]["Remarks"]) == System.DBNull.Value ? null : dt.Rows[0]["Remarks"]);
            model.GuId = Convert.ToString(dt.Rows[0]["GuId"]);
            model.TxnStatus = Convert.ToInt32((dt.Rows[0]["TxnStatus"]) == System.DBNull.Value ? null : dt.Rows[0]["TxnStatus"]);
        }
        DataSet dt1 = dbAccessDAL.MasterGetDataSet("LLSCleanLinenRequestLinenBagTxnDet_GetById ", parameters, DataSetparameters);
        if (dt != null && dt1.Tables.Count > 0)
        {
            model.cleanLinenLaundryValue = (from n in dt1.Tables[0].AsEnumerable()
                                            select new cleanLinenLaundryValueList
                                            {
                                                CLRLinenBagId = Convert.ToInt32(n["CLRLinenBagId"]),
                                                FieldValue = Convert.ToString(n["LaundryBag"]),
                                                RequestedQuantity = Convert.ToInt32(n["RequestedQuantity"]),
                                                IssuedQuantity = Convert.ToInt32(n["IssuedQuantity"]),
                                                Shortfall = Convert.ToInt32(n["Shortfall"]),
                                                Remarks = Convert.ToString(n["Remarks"])
                                            }).ToList();
        }
        DataSet dt2 = dbAccessDAL.MasterGetDataSet("LLSCleanLinenRequestLinenItemTxnDet_GetById", parameters, DataSetparameters);
        if (dt != null && dt2.Tables.Count > 0)
        {
            model.LLinenRequestItemGridList = (from n in dt2.Tables[0].AsEnumerable()
                                               select new LLinenRequestItemList
                                               {
                                                   CLRLinenItemId = Convert.ToInt32((n["CLRLinenItemId"]) != DBNull.Value ? (Convert.ToInt32(n["CLRLinenItemId"])) : (int?)null),
                                                   LinenCode = Convert.ToString((n["LinenCode"]) != DBNull.Value ? (Convert.ToString(n["LinenCode"])) : (string)null),
                                                   LinenDescription = Convert.ToString((n["LinenDescription"]) != DBNull.Value ? (Convert.ToString(n["LinenDescription"])) : (string)null),
                                                   AgreedShelfLevel = Convert.ToDecimal((n["AgreedShelfLevel"]) != DBNull.Value ? (Convert.ToInt32(n["AgreedShelfLevel"])) : (int?)null),
                                                   BalanceOnShelf = Convert.ToInt32((n["BalanceOnShelf"]) != DBNull.Value ? (Convert.ToInt32(n["BalanceOnShelf"])) : (int?)null),
                                                   RequestedQuantity = Convert.ToInt32((n["RequestedQuantity"]) != DBNull.Value ? (Convert.ToInt32(n["RequestedQuantity"])) : (int?)null),
                                                   DeliveryIssuedQty1st = Convert.ToDecimal((n["DeliveryIssuedQty1st"]) != DBNull.Value ? (Convert.ToDecimal(n["DeliveryIssuedQty1st"])) : (Decimal?)null),
                                                   DeliveryIssuedQty2nd = Convert.ToDecimal((n["DeliveryIssuedQty2nd"]) != DBNull.Value ? (Convert.ToDecimal(n["DeliveryIssuedQty2nd"])) : (Decimal?)null),
                                                   Shortfall = Convert.ToDecimal((n["Shortfall"]) != DBNull.Value ? (Convert.ToDecimal(n["Shortfall"])) : (Decimal?)null),
                                                   StoreBalance = Convert.ToDecimal((n["StoreBalance"]) != DBNull.Value ? (Convert.ToDecimal(n["StoreBalance"])) : (Decimal?)null),
                                                   LinenItemId = Convert.ToInt32((n["LinenItemId"]) != DBNull.Value ? (Convert.ToInt32(n["LinenItemId"])) : (int?)null),
                                               }).ToList();
            model.LLinenRequestItemGridList.ForEach((x) =>
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
                cmd.CommandText = "LLSCleanLinenRequestTxn_GetAll";

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

public bool IsUserAreaCodeDuplicate(CleanLinenRequestModel model)
{
    try
    {
        Log4NetLogger.LogEntry(_FileName, nameof(IsUserAreaCodeDuplicate), Level.Info.ToString());

        var IsDuplicate = true;
        var dbAccessDAL = new BEMSDBAccessDAL();
        var DataSetparameters = new Dictionary<string, DataTable>();
        var parameters = new Dictionary<string, string>();
        parameters.Add("@Id", model.CleanLinenRequestId.ToString());
        if (model.DocumentNo == " " || model.DocumentNo == null)
        {
            var guid = Guid.NewGuid().ToString();
            model.DocumentNo = guid;
        }

        //parameters.Add("@UserAreaCode", model.CleanLinenRequestId.ToString());
        parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
        parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
        parameters.Add("@DocumentNo", Convert.ToString(model.DocumentNo));

        DataTable dt = dbAccessDAL.GetDataTable("LLSCleanLinenRequestTxn_ValCode", parameters, DataSetparameters);
        if (dt != null && dt.Rows.Count > 0)
        {
            IsDuplicate = Convert.ToBoolean(dt.Rows[0]["IsDuplicate"]);
        }
        Log4NetLogger.LogExit(_FileName, nameof(IsUserAreaCodeDuplicate), Level.Info.ToString());
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
public bool IsRecordModified(CleanLinenRequestModel model)
{
    try
    {
        Log4NetLogger.LogEntry(_FileName, nameof(IsRecordModified), Level.Info.ToString());

        var recordModifed = false;

        if (model.CleanLinenRequestId != 0)
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
                    cmd.Parameters.AddWithValue("Id", model.CleanLinenRequestId);
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
        DataTable dt = dbAccessDAL.GetDataTable("LLSCleanLinenRequestTxn_Delete", parameters, DataSetparameters);
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

public void deleteChildrecords(CleanLinenRequestModel model, string id)
{
    try
    {
        var parameters = new Dictionary<string, string>();
        var ds = new DataSet();
        var dbAccessDAL = new MASTERDBAccessDAL();
        using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
        {
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.Connection = con;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "LLSCleanLinenRequestLinenItemTxnDetSingle_Delete";
                cmd.Parameters.AddWithValue("@ID", id);
                cmd.Parameters.AddWithValue("@CleanLinenRequestId", model.CleanLinenRequestId);
                //parameters.Add("@CleanLinenRequestId", Convert.ToString(model.CleanLinenRequestId));
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
