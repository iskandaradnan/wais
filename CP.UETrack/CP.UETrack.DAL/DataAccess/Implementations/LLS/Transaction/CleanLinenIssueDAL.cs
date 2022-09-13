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

    public class CleanLinenIssueDAL : ICleanLinenIssueDAL
    {
        private readonly string _FileName = nameof(CleanLinenIssueDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public CleanLinenIssueDAL()
        {

        }

        public CleanLinenIssueModelLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                CleanLinenIssueModelLovs CleanLinenIssueModelLovs = new CleanLinenIssueModelLovs();
                CleanLinenIssueModel clean = new CleanLinenIssueModel();
                string lovs = "PriorityValue,IssuedOnTimeValue,DeliveryScheduleValue,QCTimelinessValue,CLIOptionValue,LaundryBagValue";
                var dbAccessDAL = new MASTERDBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pLovKey", lovs);
                DataSet ds = dbAccessDAL.MasterGetDataSet("uspFM_Dropdown", parameters, DataSetparameters);
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    CleanLinenIssueModelLovs.Priority = dbAccessDAL.GetLovRecords(ds.Tables[0], "PriorityValue");
                    CleanLinenIssueModelLovs.IssuedOnTime = dbAccessDAL.GetLovRecords(ds.Tables[0], "IssuedOnTimeValue");
                    CleanLinenIssueModelLovs.DeliverySchedule = dbAccessDAL.GetLovRecords(ds.Tables[0], "DeliveryScheduleValue");
                    CleanLinenIssueModelLovs.QCTimeliness = dbAccessDAL.GetLovRecords(ds.Tables[0], "QCTimelinessValue");
                    CleanLinenIssueModelLovs.ShortfallQC = dbAccessDAL.GetLovRecords(ds.Tables[0], "QCTimelinessValue");
                    CleanLinenIssueModelLovs.CLIOption = dbAccessDAL.GetLovRecords(ds.Tables[0], "CLIOptionValue");
                    CleanLinenIssueModelLovs.LaundryBag = dbAccessDAL.GetLovRecords(ds.Tables[0], "LaundryBagValue");

                }
                var DataSetparameters1 = new Dictionary<string, DataTable>();
                var parameters1 = new Dictionary<string, string>();
                parameters1.Add("@pLovKey", null);
                parameters1.Add("@pTableName", "CleanLinenIssue");
                DataSet ds1 = dbAccessDAL.MasterGetDataSet("uspFM_Dropdown_Others", parameters1, DataSetparameters1);

                if (ds1.Tables.Count != 0 && ds1.Tables[0].Rows.Count > 0)
                {
                    CleanLinenIssueModelLovs.cleanLinenLaundryValues = (from n in ds1.Tables[0].AsEnumerable()

                                                                        select new cleanLinenLaundryValueLists
                                                                        {
                                                                            LovId = Convert.ToInt32(n["LovId"]),
                                                                            FieldValue = Convert.ToString(n["FieldValue"]),

                                                                        }).ToList();
                }


                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());

                return CleanLinenIssueModelLovs;
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

        public CleanLinenIssueModel Save(CleanLinenIssueModel model, out string ErrorMessage)
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
                var parameterss = new Dictionary<string, string>();
                var parametersf = new Dictionary<string, string>();
                var parametersL = new Dictionary<string, string>();
                var parametersLI = new Dictionary<string, string>();
                var parametersCS = new Dictionary<string, string>();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var DataSetparameterss = new Dictionary<string, DataTable>();
                var DataSetparametersss = new Dictionary<string, DataTable>();
                List<LLinenIssueItemList> LLinenIssueItemList = new List<LLinenIssueItemList>();
                LLinenIssueItemList = model.LLinenIssueItemGridList;
                DataTable dataTable = new DataTable("CleanLinenIssue");
                DataTable dataTable1 = new DataTable("CleanLinenDetails");
                parameters.Add("@Remarks", Convert.ToString(model.Remarks));
                parameters.Add("@ModifiedBy", _UserSession.UserId.ToString());
                parameters.Add("@DeliveryDate1st", Convert.ToString(model.DeliveryDate1st == null || model.DeliveryDate1st == DateTime.MinValue ? null : model.DeliveryDate1st.ToString("MM-dd-yyy ")));
                parameters.Add("@ReceivedBy1st", Convert.ToString(model.ReceivedBy1st));
                //parameters.Add("@DeliveryDate2nd", Convert.ToString(model.DeliveryDate2nd == null || model.DeliveryDate2nd == DateTime.MinValue ? null : model.DeliveryDate2nd.ToString("MM-dd-yyy ")));
                parameters.Add("@DeliveryWeight1st", Convert.ToString(model.DeliveryWeight1st));
                //parameters.Add("@ReceivedBy2nd", Convert.ToString(model.ReceivedBy2nd));
                //parameters.Add("@ReceivedBy2nd", Convert.ToString(0));
                //parameters.Add("@DeliveryWeight2nd", Convert.ToString(0));
                parameters.Add("@DeliverySchedule", Convert.ToString(model.DeliverySchedule));
                parameters.Add("@QCTimeliness", Convert.ToString(model.QCTimeliness));
                parameters.Add("@ShortfallQC", Convert.ToString(model.ShortfallQC));
                parameters.Add("@CleanLinenIssueId", Convert.ToString(model.CleanLinenIssueId));

                var cllValues = 0;
                var update = 0;
               
                foreach (var cllValueList in model.cleanLinenLaundryValues)
                {
                    cllValues = cllValueList.CLILinenBagId;
                }


                if (cllValues != 0)
                {
                    DataTable varDt2 = new DataTable();
                    varDt2.Columns.Add("CLILinenBagId", typeof(int));
                    varDt2.Columns.Add("CleanLinenIssueId", typeof(int));
                    varDt2.Columns.Add("LaundryBag", typeof(string));
                    varDt2.Columns.Add("IssuedQuantity", typeof(decimal));
                    varDt2.Columns.Add("Remarks", typeof(string));
                    varDt2.Columns.Add("ModifiedBy", typeof(int));
                    if (model.cleanLinenLaundryValues != null)
                    {

                        foreach (var var in model.cleanLinenLaundryValues)
                        {
                            varDt2.Rows.Add(var.CLILinenBagId, model.CleanLinenIssueId, var.LaundryBag, var.IssuedQuantity, var.Remarks, _UserSession.UserId.ToString());
                        }

                        DataSetparametersss.Add("@LLSIssue", varDt2);
                        DataTable dss2 = dbAccessDAL.GetMASTERDataTable("LLSCleanLinenIssueLinenBagTxnDet_Update", parameterss, DataSetparametersss);
                    }
                    DataSetparametersss.Clear();
                    DataTable varDt3 = new DataTable();
                    varDt3.Columns.Add("@CLILinenItemId", typeof(int));
                    varDt3.Columns.Add("@CleanLinenIssueId", typeof(int));
                    varDt3.Columns.Add("@DeliveryIssuedQty1st", typeof(decimal));
                    varDt3.Columns.Add("@DeliveryIssuedQty2nd", typeof(decimal));
                    varDt3.Columns.Add("@Remarks", typeof(string));
                    varDt3.Columns.Add("@ModifiedBy", typeof(int));
                    foreach (var row in model.LLinenIssueItemGridList)
                    {
                        //if (row.CLILinenItemId != 0)
                        //{
                        varDt3.Rows.Add(row.CLILinenItemId, model.CleanLinenIssueId, row.DeliveryIssuedQty1st, 
                            //row.DeliveryIssuedQty2nd,
                            0,
                            row.Remarks, _UserSession.UserId.ToString());

                    }
                    DataSetparameters.Add("@LLSCleanLinenIssueLinenItemTxnDet_Update", varDt3);
                    DataTable dss1 = dbAccessDAL.GetMASTERDataTable("LLSCleanLinenIssueLinenItemTxnDet_Update", rowparameters, DataSetparameters);
                    DataSetparameters.Clear();
                    DataSetparametersss.Clear();
                    DataTable dss4 = dbAccessDAL.GetMASTERDataTable("LLSCleanLinenIssueTxn_Update", parameters, DataSetparameters);
                    #region start
                    //else
                    //{
                    //    spNames = "LLSCleanLinenIssueLinenItemTxnDet_Save";
                    //    dataTable1.Columns.Add("CleanLinenIssueId", typeof(int));
                    //    dataTable1.Columns.Add("LinenitemId", typeof(int));
                    //    dataTable1.Columns.Add("RequestedQuantity", typeof(int));
                    //    dataTable1.Columns.Add("DeliveryIssuedQty1st", typeof(decimal));
                    //    dataTable1.Columns.Add("DeliveryIssuedQty2nd", typeof(decimal));
                    //    dataTable1.Columns.Add("Remarks", typeof(string));

                    //    foreach (var obj in LLinenIssueItemList)
                    //    {
                    //        if (obj.CLILinenItemId == 0)
                    //        {
                    //            dataTable1.Rows.Add(
                    //                model.CleanLinenIssueId,
                    //                obj.LinenitemId,
                    //                obj.RequestedQuantity,
                    //                obj.DeliveryIssuedQty1st,
                    //                obj.DeliveryIssuedQty2nd,
                    //                obj.Remarks

                    //             );
                    //        }
                    //    }
                    //    using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                    //    {
                    //        using (SqlCommand cmd = new SqlCommand())
                    //        {
                    //            cmd.Connection = con;
                    //            cmd.CommandType = CommandType.StoredProcedure;
                    //            cmd.CommandText = spNames;
                    //            SqlParameter parameter = new SqlParameter();
                    //            parameter.ParameterName = "@Block";
                    //            parameter.SqlDbType = System.Data.SqlDbType.Structured;
                    //            parameter.Value = dataTable1;
                    //            cmd.Parameters.Add(parameter);
                    //            var daa = new SqlDataAdapter();
                    //            daa.SelectCommand = cmd;
                    //            daa.Fill(ds2);
                    //        }
                    //    }
                    //}

                    //closing issued 
                    #endregion
                    parametersL.Add("@DocumentNo", Convert.ToString(model.DocumentNo));
                    if (model.CleanLinenIssueId != 0)
                    {

                        DataTable dsss = dbAccessDAL.GetMASTERDataTable("LLSCleanLinenRequestLinenItemTxnDeT_CLIDUpdate", parametersL, DataSetparameterss);
                    }
                    //closing issued end
                    //closing issued 
                    parametersLI.Add("@DocumentNo", Convert.ToString(model.DocumentNo));
                    if (model.CleanLinenIssueId != 0)
                    {
                        DataTable dsss = dbAccessDAL.GetMASTERDataTable("LLSCleanLinenRequestLinenBagTxnDet_CLIDUpdate", parametersLI, DataSetparameterss);
                    }
                    //closing issued end
                    //closing issued 
                    parametersf.Add("@DocumentNo", Convert.ToString(model.DocumentNo));
                    parametersf.Add("@CLINO", Convert.ToString(model.CLINo));
                    if (model.CleanLinenIssueId != 0)
                    {
                        DataTable dsss = dbAccessDAL.GetMASTERDataTable("LLSCleanLinenRequestTxn_StatusUpdate", parametersf, DataSetparameterss);
                    }
                    //closing issued end
                    return model;
                }


                else
                {
                    spName = "LLSCleanLinenIssueTxn_Save";
                }
                dataTable.Columns.Add("CustomerId", typeof(int));
                dataTable.Columns.Add("FacilityId", typeof(int));
                dataTable.Columns.Add("CleanLinenRequestId", typeof(int));
                dataTable.Columns.Add("CLRNo", typeof(string));
                dataTable.Columns.Add("CLINo", typeof(string));
                dataTable.Columns.Add("ReceivedBy1st", typeof(int));
                dataTable.Columns.Add("ReceivedBy2nd", typeof(int));
                dataTable.Columns.Add("Verifier", typeof(int));
                dataTable.Columns.Add("DeliveredBy", typeof(int));
                dataTable.Columns.Add(new DataColumn("DeliveryDate1st", typeof(DateTime)));
                // dataTable.Columns.Add(new DataColumn("DeliveryDate2nd", typeof(DateTime)));
                dataTable.Columns.Add("DeliveryWeight1st", typeof(decimal));
                dataTable.Columns.Add("DeliveryWeight2nd", typeof(decimal));
                dataTable.Columns.Add("IssuedOnTime", typeof(string));
                dataTable.Columns.Add("DeliverySchedule", typeof(string));
                dataTable.Columns.Add("QCTimeliness", typeof(int));
                dataTable.Columns.Add("ShortfallQC", typeof(int));
                dataTable.Columns.Add("CLIOption", typeof(string));
                dataTable.Columns.Add("TotalItemIssued", typeof(int));
                dataTable.Columns.Add("TotalBagIssued", typeof(int));
                dataTable.Columns.Add("TotalItemShortfall", typeof(int));
                dataTable.Columns.Add("Remarks", typeof(string));
                dataTable.Columns.Add("CreatedBy", typeof(int));
                dataTable.Columns.Add("ModifiedBy", typeof(int));
                dataTable.Rows.Add(
                         _UserSession.CustomerId,
                        _UserSession.FacilityId,
                        model.CleanLinenRequestId,
                        model.DocumentNo,
                        model.CLINo,
                        model.ReceivedBy1st,
                        model.ReceivedBy2nd,
                        model.Verifier,
                        model.DeliveredBy,
                        Convert.ToDateTime(model.DeliveryDate1st),
                        //Convert.ToDateTime(model.DeliveryDate2nd),
                        model.DeliveryWeight1st,
                        model.DeliveryWeight2nd,
                        model.IssuedOnTime,
                        model.DeliverySchedule,
                        model.QCTimeliness,
                        model.ShortfallQC,
                        model.CLIOption,
                        model.TotalItemIssued,
                        model.TotalBagIssued,
                        model.TotalItemShortfall,
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
                        parameter.ParameterName = "@LLSCleanLinenIssueTxn";
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
                    var CleanLinenIssueId = Convert.ToInt32(ds.Tables[0].Rows[0]["CleanLinenIssueId"]);
                    if (CleanLinenIssueId != 0)
                        model.CleanLinenIssueId = CleanLinenIssueId;
                    if (ds.Tables[0].Rows[0]["Timestamp"] == DBNull.Value)
                    {
                        //model.Timestamp = "";
                    }
                    else
                    {
                        //model.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                    }
                    ErrorMessage = Convert.ToString(ds.Tables[0].Rows[0]["ErrorMsg"]);
                }
                var Issuseparameters = new Dictionary<string, string>();
                Issuseparameters.Add("@ID", Convert.ToString(model.CleanLinenRequestId));
                DataTable dst = dbAccessDAL.GetMASTERDataTable("LLSCleanLinenIssueTxnCLINO_Save", Issuseparameters, DataSetparameters);
                if (dst != null && dst.Rows.Count > 0)
                {
                    model.CLINo = Convert.ToString(dst.Rows[0]["CLINo"]);
                }
                //----------------- Add Row Save
                if (model.CLILinenBagId != 0)
                {
                }
                else
                {
                    DataTable varDt = new DataTable();
                    varDt.Columns.Add("CleanLinenIssueId", typeof(int));
                    varDt.Columns.Add("LaundryBag", typeof(string));
                    varDt.Columns.Add("IssuedQuantity", typeof(decimal));
                    varDt.Columns.Add("Remarks", typeof(string));
                    varDt.Columns.Add("CreatedBy", typeof(int));
                    if (model.cleanLinenLaundryValues != null)
                    {
                        foreach (var var in model.cleanLinenLaundryValues)
                        {
                            varDt.Rows.Add(model.CleanLinenIssueId, var.FieldValue, var.IssuedQuantity, var.Remarks, _UserSession.UserId.ToString());
                        }
                    }
                    DataSetparameters.Add("@Block", varDt);
                    DataTable dsss = dbAccessDAL.GetMASTERDataTable("LLSCleanLinenIssueLinenBagTxnDet_Save", parameterss, DataSetparameters);
                }
                if (model.CLILinenItemId != 0)
                {

                }
                else
                {
                    spNames = "LLSCleanLinenIssueLinenItemTxnDet_Save";
                    dataTable1.Columns.Add("CleanLinenIssueId", typeof(int));
                    dataTable1.Columns.Add("LinenitemId", typeof(int));                   
                    dataTable1.Columns.Add("RequestedQuantity", typeof(int));
                    dataTable1.Columns.Add("DeliveryIssuedQty1st", typeof(decimal));
                    dataTable1.Columns.Add("DeliveryIssuedQty2nd", typeof(decimal));
                    dataTable1.Columns.Add("Remarks", typeof(string));
                    dataTable1.Columns.Add("CreatedBy", typeof(int));

                    foreach (var row in LLinenIssueItemList)
                    {
                        dataTable1.Rows.Add(
                        model.CleanLinenIssueId,
                        row.LinenitemId,
                        row.RequestedQuantity,
                        row.DeliveryIssuedQty1st,
                        //row.DeliveryIssuedQty2nd,
                        0,
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
                //closing issued 
                DataSetparameters.Clear();
                parametersL.Add("@DocumentNo", Convert.ToString(model.DocumentNo));
                if (model.CleanLinenIssueId != 0)
                {
                    DataTable dsss = dbAccessDAL.GetMASTERDataTable("LLSCleanLinenRequestLinenItemTxnDeT_CLIDUpdate", parametersL, DataSetparameters);
                }
                else
                {
                }
                //closing issued end
                //closing issued 
                parametersLI.Add("@DocumentNo", Convert.ToString(model.DocumentNo));
                if (model.CleanLinenIssueId != 0)
                {
                    DataTable dsss = dbAccessDAL.GetMASTERDataTable("LLSCleanLinenRequestLinenBagTxnDet_CLIDUpdate", parametersLI, DataSetparameters);
                }
                else
                {
                }
                //closing issued end
                //closing issued 
                DataSetparameters.Clear();
                parametersf.Add("@DocumentNo", Convert.ToString(model.DocumentNo));
                parametersf.Add("@CLINO", Convert.ToString(model.CLINo));
                if (model.CleanLinenIssueId != 0)
                {
                    DataTable dsss = dbAccessDAL.GetMASTERDataTable("LLSCleanLinenRequestTxn_StatusUpdate", parametersf, DataSetparameters);
                }
                else
                {
                }
                //closing issued end
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

        public CleanLinenIssueModel Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                CleanLinenIssueModel model = new CleanLinenIssueModel();
                var ds = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                LLinenIssueItemList LLinenIssueItemList = new LLinenIssueItemList();
                var EffectiveDate = DateTime.Now.ToString("yyyy-MMdd HH:mm:ss");
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                var parameterss = new Dictionary<string, string>();
                parameters.Add("@Id", Convert.ToString(Id));

                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSCleanLinenIssueTxn_GetById", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    model.CleanLinenIssueId = Id;
                    model.CLINo = Convert.ToString(dt.Rows[0]["CLINo"]);
                    model.DocumentNo = Convert.ToString(dt.Rows[0]["DocumentNo"]);
                    model.RequestDateTime = Convert.ToDateTime((dt.Rows[0]["RequestDateTime"]) == System.DBNull.Value ? null : dt.Rows[0]["RequestDateTime"]);
                    model.DeliveryDate1st = Convert.ToDateTime((dt.Rows[0]["DeliveryDate1st"]) == System.DBNull.Value ? null : dt.Rows[0]["DeliveryDate1st"]);
                    model.UserAreaCode = Convert.ToString((dt.Rows[0]["UserAreaCode"]) == System.DBNull.Value ? null : dt.Rows[0]["UserAreaCode"]);
                    model.UserAreaName = Convert.ToString((dt.Rows[0]["UserAreaName"]) == System.DBNull.Value ? null : dt.Rows[0]["UserAreaName"]);
                    model.UserLocationCode = Convert.ToString((dt.Rows[0]["UserLocationCode"]) == System.DBNull.Value ? null : dt.Rows[0]["UserLocationCode"]);
                    model.UserLocationName = Convert.ToString((dt.Rows[0]["UserLocationName"]) == System.DBNull.Value ? null : dt.Rows[0]["UserLocationName"]);
                    model.RequestedBy = Convert.ToString((dt.Rows[0]["RequestedBy"]) == System.DBNull.Value ? null : dt.Rows[0]["RequestedBy"]);
                    model.RequestedByDesignation = Convert.ToString((dt.Rows[0]["RequestedByDesignation"]) == System.DBNull.Value ? null : dt.Rows[0]["RequestedByDesignation"]);
                    model.ReceivedBy1st = Convert.ToString((dt.Rows[0]["ReceivedBy1st"]) == System.DBNull.Value ? null : dt.Rows[0]["ReceivedBy1st"]);
                    model.ReceivedBy1stDesignation = Convert.ToString((dt.Rows[0]["ReceivedBy1stDesignation"]) == System.DBNull.Value ? null : dt.Rows[0]["ReceivedBy1stDesignation"]);
                    model.ReceivedBy2nd = Convert.ToString((dt.Rows[0]["ReceivedBy2nd"]) == System.DBNull.Value ? null : dt.Rows[0]["ReceivedBy2nd"]);
                    model.ReceivedBy2ndDesignation = Convert.ToString((dt.Rows[0]["ReceivedBy2ndDesignation"]) == System.DBNull.Value ? null : dt.Rows[0]["ReceivedBy2ndDesignation"]);
                    model.Verifier = Convert.ToString((dt.Rows[0]["Verifier(MOH)"]) == System.DBNull.Value ? null : dt.Rows[0]["Verifier(MOH)"]);
                    model.VerifierDesignation = Convert.ToString((dt.Rows[0]["Verifier(MOH)Designation"]) == System.DBNull.Value ? null : dt.Rows[0]["Verifier(MOH)Designation"]);
                    model.DeliveredBy = Convert.ToString((dt.Rows[0]["DeliveredBy"]) == System.DBNull.Value ? null : dt.Rows[0]["DeliveredBy"]);
                    model.DeliveredByDesignation = Convert.ToString((dt.Rows[0]["DeliveredByDesignation"]) == System.DBNull.Value ? null : dt.Rows[0]["DeliveredByDesignation"]);
                    model.DeliveryWeight1st = Convert.ToDecimal((dt.Rows[0]["DeliveryWeight1st"]) == System.DBNull.Value ? null : dt.Rows[0]["DeliveryWeight1st"]);
                    model.DeliveryWeight2nd = Convert.ToDecimal((dt.Rows[0]["DeliveryWeight2nd"]) == System.DBNull.Value ? null : dt.Rows[0]["DeliveryWeight2nd"]);
                    model.TotalWeight = Convert.ToDecimal((dt.Rows[0]["TotalWeight"]) == System.DBNull.Value ? null : dt.Rows[0]["TotalWeight"]);
                    model.IssuedOnTime = Convert.ToInt32((dt.Rows[0]["IssuedOnTimeID"]) == System.DBNull.Value ? null : dt.Rows[0]["IssuedOnTimeID"]);
                    model.DeliverySchedule = Convert.ToString((dt.Rows[0]["DeliverySchedule"]) == System.DBNull.Value ? null : dt.Rows[0]["DeliverySchedule"]);
                    model.Priority = Convert.ToInt32((dt.Rows[0]["Priority"]) == System.DBNull.Value ? null : dt.Rows[0]["Priority"]);
                    model.QCTimeliness = Convert.ToString((dt.Rows[0]["QCTimeliness"]) == System.DBNull.Value ? null : dt.Rows[0]["QCTimeliness"]);
                    model.TotalBagRequested = Convert.ToInt32((dt.Rows[0]["TotalBagRequested"]) == System.DBNull.Value ? null : dt.Rows[0]["TotalBagRequested"]);
                    model.TotalBagIssued = Convert.ToInt32((dt.Rows[0]["TotalBagIssued"]) == System.DBNull.Value ? null : dt.Rows[0]["TotalBagIssued"]);
                    model.TotalItemRequested = Convert.ToInt32(dt.Rows[0]["TotalItemRequested"] == System.DBNull.Value ? null : dt.Rows[0]["TotalItemRequested"]);
                    model.TotalItemIssued = Convert.ToInt32((dt.Rows[0]["TotalItemIssued"]) == System.DBNull.Value ? null : dt.Rows[0]["TotalItemIssued"]);
                    model.TotalItemShortfall = Convert.ToInt32((dt.Rows[0]["TotalItemShortfall"]) == System.DBNull.Value ? null : dt.Rows[0]["TotalItemShortfall"]);
                    model.ShortfallQC = Convert.ToString((dt.Rows[0]["ShortfallQC"]) == System.DBNull.Value ? null : dt.Rows[0]["ShortfallQC"]);
                    model.CLIOption = Convert.ToString((dt.Rows[0]["CLIOption"]) == System.DBNull.Value ? null : dt.Rows[0]["CLIOption"]);
                    model.Remarks = Convert.ToString((dt.Rows[0]["Remarks"]) == System.DBNull.Value ? null : dt.Rows[0]["Remarks"]);
                    model.FirstReceivedBy = Convert.ToInt32((dt.Rows[0]["FirstReceivedBy"]) == System.DBNull.Value ? null : dt.Rows[0]["FirstReceivedBy"]);
                    model.GuId = Convert.ToString(dt.Rows[0]["GuId"]);
                    model.TxnStatus = Convert.ToInt32((dt.Rows[0]["TxnStatus"]) == System.DBNull.Value ? null : dt.Rows[0]["TxnStatus"]);
                }
                DataSet dt1 = dbAccessDAL.MasterGetDataSet("LLSCleanLinenIssueLinenBagTxnDet_GetById ", parameters, DataSetparameters);
                if (dt != null && dt1.Tables.Count > 0)
                {
                    model.cleanLinenLaundryValues = (from n in dt1.Tables[0].AsEnumerable()
                                                     select new cleanLinenLaundryValueLists
                                                     {
                                                         FieldValue = Convert.ToString(n["LaundryBag"]),
                                                         RequestedQuantity = Convert.ToInt32(n["RequestedQuantity"]),
                                                         IssuedQuantity = Convert.ToDecimal(n["IssuedQuantity"]),
                                                         Shortfall = Convert.ToInt32(n["Shortfall"]),
                                                         Remarks = Convert.ToString((n["Remarks"]) != DBNull.Value ? (Convert.ToString(n["Remarks"])) : null),
                                                         LaundryBag = Convert.ToInt32(n["LovId"]),
                                                         CLILinenBagId = Convert.ToInt32(n["CLILinenBagId"])
                                                     }).ToList();
                }
                DataSet dt2 = dbAccessDAL.MasterGetDataSet("LLSCleanLinenIssueLinenItemTxnDet_GetById", parameters, DataSetparameters);
                if (dt != null && dt2.Tables.Count > 0)
                {
                    model.LLinenIssueItemGridList = (from n in dt2.Tables[0].AsEnumerable()
                                                     select new LLinenIssueItemList
                                                     {

                                                         LinenCode = Convert.ToString((n["LinenCode"]) != DBNull.Value ? (Convert.ToString(n["LinenCode"])) : (String)null),
                                                         LinenDescription = Convert.ToString((n["LinenDescription"]) != DBNull.Value ? (Convert.ToString(n["LinenDescription"])) : (String)null),
                                                         AgreedShelfLevel = Convert.ToDecimal((n["AgreedShelfLevel"]) != DBNull.Value ? (Convert.ToDecimal(n["AgreedShelfLevel"])) : (Decimal?)null),
                                                         RequestedQuantity = Convert.ToInt32((n["RequestedQuantity"]) != DBNull.Value ? (Convert.ToInt32(n["RequestedQuantity"])) : (int?)null),
                                                         DeliveryIssuedQty1st = Convert.ToDecimal((n["DeliveryIssuedQty1st"]) != DBNull.Value ? (Convert.ToDecimal(n["DeliveryIssuedQty1st"])) : (Decimal?)null),
                                                         //DeliveryIssuedQty2nd = Convert.ToDecimal((n["DeliveryIssuedQty2nd"]) != DBNull.Value ? (Convert.ToDecimal(n["DeliveryIssuedQty2nd"])) : (Decimal?)null),
                                                         DeliveryIssuedQty2nd = 0,
                                                         Shortfall = Convert.ToDecimal((n["Shortfall"]) != DBNull.Value ? (Convert.ToDecimal(n["Shortfall"])) : (Decimal?)null),
                                                         StoreBalance = Convert.ToDecimal((n["StoreBalance"]) != DBNull.Value ? (Convert.ToDecimal(n["StoreBalance"])) : (Decimal?)null),
                                                         Remarks = Convert.ToString((n["Remarks"]) != DBNull.Value ? (Convert.ToString(n["Remarks"])) : (String)null),
                                                         CLILinenItemId = Convert.ToInt32((n["CLILinenItemId"]) != DBNull.Value ? (Convert.ToInt32(n["CLILinenItemId"])) : (int?)null),
                                                         LinenitemId = Convert.ToInt32((n["LinenitemId"]) != DBNull.Value ? (Convert.ToInt32(n["LinenitemId"])) : (int?)null),
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
        public CleanLinenIssueModel GetBY(CleanLinenIssueModel model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetBY), Level.Info.ToString());
                var ds = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                LLinenIssueItemList LLinenIssueItemList = new LLinenIssueItemList();
                var EffectiveDate = DateTime.Now.ToString("yyyy-MMdd HH:mm:ss");
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                var parameterss = new Dictionary<string, string>();
                //parameters.Add("@Id", Convert.ToString(Id));
                parameters.Add("@DeliveryDate1st", Convert.ToString(model.Delievery1 == null || model.Delievery1 == DateTime.MinValue ? null : model.Delievery1.ToString("MM-dd-yyy HH:mm")));
                //parameters.Add("@DeliveryDate2nd", Convert.ToString(model.Delievery2 == null || model.Delievery2 == DateTime.MinValue ? null : model.Delievery2.ToString("MM-dd-yyy HH:mm")));
                parameters.Add("@RequestDateTime", Convert.ToString(model.RequestDT == null || model.RequestDT == DateTime.MinValue ? null : model.RequestDT.ToString("MM-dd-yyy HH:mm")));
                parameters.Add("@Priority", Convert.ToString(model.priority1));
                parameters.Add("@ScheduleStatus", Convert.ToString(model.delieveryST));
                //parameters.Add("@IssuedStatus", Convert.ToString(model.Delievery1));
                parameters.Add("@LocationId", Convert.ToString(model.Location1));


                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSIssuedOnTimeLovidDeliveryDate1st", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    //model.CleanLinenIssueId = Id;
                    model.IssuedOnTime = Convert.ToInt32(dt.Rows[0]["IssuedOnTimeLovid"]);
                    //model.DocumentNo = Convert.ToString(dt.Rows[0]["DocumentNo"]);
                    //model.RequestDateTime = Convert.ToDateTime((dt.Rows[0]["RequestDateTime"]) == System.DBNull.Value ? null : dt.Rows[0]["RequestDateTime"]);
                    //model.DeliveryDate1st = Convert.ToDateTime((dt.Rows[0]["DeliveryDate1st"]) == System.DBNull.Value ? null : dt.Rows[0]["DeliveryDate1st"]);
                    //model.DeliveryDate2nd = Convert.ToDateTime(dt.Rows[0]["DeliveryDate2nd"]);
                    //model.UserAreaCode = Convert.ToString((dt.Rows[0]["UserAreaCode"]) == System.DBNull.Value ? null : dt.Rows[0]["UserAreaCode"]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(GetBY), Level.Info.ToString());
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

        public CleanLinenIssueModel GetByLinenItemDetails(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetByLinenItemDetails), Level.Info.ToString());
                CleanLinenIssueModel model = new CleanLinenIssueModel();
                var ds = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                LLinenIssueItemList LLinenIssueItemList = new LLinenIssueItemList();
                var EffectiveDate = DateTime.Now.ToString("yyyy-MMdd HH:mm:ss");
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                var parameterss = new Dictionary<string, string>();
                parameters.Add("@Id", Convert.ToString(Id));

                DataSet dt2 = dbAccessDAL.MasterGetDataSet("LLSCleanLinenIssueLinenitemTxnDet_GridGetById", parameters, DataSetparameters);
                if (dt2 != null && dt2.Tables.Count > 0)
                {
                    model.LLinenIssueItemGridList = (from n in dt2.Tables[0].AsEnumerable()
                                                     select new LLinenIssueItemList
                                                     {
                                                         LinenitemId = Convert.ToInt32(n["LinenitemId"]),
                                                         LinenCode = Convert.ToString(n["LinenCode"]),
                                                         BalanceOnShelf = Convert.ToInt32(n["BalanceOnShelf"]),
                                                         LinenDescription = Convert.ToString(n["LinenDescription"]),
                                                         AgreedShelfLevel = Convert.ToDecimal(n["AgreedShelfLevel"]),
                                                         RequestedQuantity = Convert.ToInt32(n["RequestedQuantity"]),
                                                         CLILinenItemId = Convert.ToInt32(n["LinenItemId"]),
                                                     }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(GetByLinenItemDetails), Level.Info.ToString());
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

        public CleanLinenIssueModel GetByLinenBagDetails(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetByLinenBagDetails), Level.Info.ToString());
                CleanLinenIssueModel model = new CleanLinenIssueModel();
                List<LaundrybagItemlist> result = new List<LaundrybagItemlist>();

                List<cleanLinenLaundryValueList> Lresult = null;
                var ds = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                LaundrybagItemlist prioritys = new LaundrybagItemlist();
                LaundrybagItemlist LaundrybagItemlist = new LaundrybagItemlist();
                var EffectiveDate = DateTime.Now.ToString("yyyy-MMdd HH:mm:ss");
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                var parameterss = new Dictionary<string, string>();
                parameters.Add("@DocumentNo", Convert.ToString(Id));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSCleanLinenIssueTxn_FetchLinenBag", parameters, DataSetparameters);
                DataSet dt2 = dbAccessDAL.MasterGetDataSet("LLSCleanLinenIssueTxn_FetchLinenBag", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    model.Priorityid = Convert.ToInt32(dt.Rows[0]["Priorityid"]);
                    model.RequestDateTime = Convert.ToDateTime(dt.Rows[0]["RequestDateTime"]);

                }
                if (dt2 != null && dt2.Tables.Count > 0)
                {
                    model.LaundrybagItemGridList = (from n in dt2.Tables[1].AsEnumerable()
                                                    select new LaundrybagItemlist
                                                    {

                                                        CleanLinenRequestId = Convert.ToInt32(n["CleanLinenRequestId"]),
                                                        BL01 = Convert.ToInt32((dt2.Tables[1].Rows[0]["RequestedQuantity"])),
                                                        BL02 = Convert.ToInt32((dt2.Tables[1].Rows[1]["RequestedQuantity"])),
                                                        BL03 = Convert.ToInt32((dt2.Tables[1].Rows[2]["RequestedQuantity"])),
                                                        BL04 = Convert.ToInt32((dt2.Tables[1].Rows[3]["RequestedQuantity"])),
                                                        BL05 = Convert.ToInt32((dt2.Tables[1].Rows[4]["RequestedQuantity"])),

                                                    }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(GetByLinenBagDetails), Level.Info.ToString());
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


        public CleanLinenIssueModel GetByScheduledId(CleanLinenIssueModel model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetByScheduledId), Level.Info.ToString());
                ErrorMessage = string.Empty;
                var spName = string.Empty;
                var spNames = string.Empty;
                var ds = new DataSet();
                var ds2 = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                var rowparameters = new Dictionary<string, string>();
                var parameters = new Dictionary<string, string>();
                var DataSetparameters = new Dictionary<string, DataTable>();


                Log4NetLogger.LogExit(_FileName, nameof(GetByScheduledId), Level.Info.ToString());
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
                        cmd.CommandText = "LLSCleanLinenIssueTxn_GetAll";

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

        public bool IsCleanLinenIssueDuplicate(CleanLinenIssueModel model)
        {
            try
            {

                Log4NetLogger.LogEntry(_FileName, nameof(IsCleanLinenIssueDuplicate), Level.Info.ToString());
                var IsDuplicate = true;
                var dbAccessDAL = new BEMSDBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@Id", model.CleanLinenIssueId.ToString());
                parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@CLINo", Convert.ToString(model.CLINo));
                DataTable dt = dbAccessDAL.GetDataTable("LLSCleanLinenIssueTxn_ValCode", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    IsDuplicate = Convert.ToBoolean(dt.Rows[0]["IsDuplicate"]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(IsCleanLinenIssueDuplicate), Level.Info.ToString());
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
        public bool IsRecordModified(CleanLinenIssueModel model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsRecordModified), Level.Info.ToString());

                var recordModifed = false;

                if (model.CleanLinenIssueId != 0)
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
                            cmd.Parameters.AddWithValue("Id", model.CleanLinenIssueId);
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
                DataTable dt = dbAccessDAL.GetDataTable("LLSCleanLinenIssueTxn_Delete", parameters, DataSetparameters);
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
                        cmd.CommandText = "";
                        cmd.Parameters.AddWithValue("@ID", id);

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