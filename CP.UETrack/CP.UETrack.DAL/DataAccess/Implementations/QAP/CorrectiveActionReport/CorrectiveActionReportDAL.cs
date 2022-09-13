using CP.UETrack.Model;
using System;
using System.Linq;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using System.Data;
using System.Data.SqlClient;
using UETrack.DAL;
using CP.UETrack.DAL.DataAccess.Implementation;
using System.Collections.Generic;
using CP.UETrack.DAL.Helper;
using CP.UETrack.DAL.DataAccess.Contracts;
using CP.UETrack.Models;

namespace CP.UETrack.DAL.DataAccess
{
    public class CorrectiveActionReportDAL : ICorrectiveActionReportDAL
    {
        private readonly string _FileName = nameof(CorrectiveActionReportDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        private IEmailDAL _EmailDAL;
        public CorrectiveActionReportDAL()
        {
            _EmailDAL = new EmailDAL();
        }
        public CorrectiveActionReportLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                CorrectiveActionReportLovs correctiveActionReportLovs = null;

                var ds = new DataSet();
                var ds1 = new DataSet();
                var ds2 = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown_Others";
                        cmd.Parameters.AddWithValue("@pTableName", "QAPCarTxn");

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        var da1 = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pLovKey", "QAPPriorityValue,QAPStatusValue,QAPResponsibilityValue");
                        da1.SelectCommand = cmd;
                        da1.Fill(ds1);

                        var da2 = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown_Others";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pTableName", "ServiceAll");
                        da2.SelectCommand = cmd;
                        da2.Fill(ds2);
                    }
                }
                correctiveActionReportLovs = new CorrectiveActionReportLovs();
                if (ds.Tables.Count != 0)
                {
                    correctiveActionReportLovs.Indicators = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                    correctiveActionReportLovs.FailureSymptomCodes = dbAccessDAL.GetLovRecords(ds.Tables[1]);
                }
                if (ds1.Tables.Count != 0)
                {

                    correctiveActionReportLovs.QAPPriorityValue = dbAccessDAL.GetLovRecords(ds1.Tables[0], "QAPPriorityValue");
                    correctiveActionReportLovs.QAPStatusValue = dbAccessDAL.GetLovRecords(ds1.Tables[0], "QAPStatusValue");
                    correctiveActionReportLovs.Responsibilities = dbAccessDAL.GetLovRecords(ds1.Tables[0], "QAPResponsibilityValue");
                }
                if (ds2.Tables.Count != 0)
                {
                    correctiveActionReportLovs.ServiceData = dbAccessDAL.GetLovRecords(ds2.Tables[0]);
                    
                }
                //Below line added & next line commented by bala on 8/12/2021 to bind default indicator based on service id
                correctiveActionReportLovs.SelectedIndicators = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                //correctiveActionReportLovs.SelectedIndicators = GetIndicators();

                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return correctiveActionReportLovs;
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
        private List<LovValue> GetIndicators()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                var Indicators = new List<LovValue>();
                
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Get_Indicatros";

                        SqlParameter parameter = new SqlParameter();
                        cmd.Parameters.AddWithValue("@pCustomerId", _UserSession.CustomerId);
                        
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var ConfigKeyId = 0;
                    var ConfigKeyLovId = 0;
                    for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                    {
                        ConfigKeyId = Convert.ToInt32(ds.Tables[0].Rows[i]["ConfigKeyId"].ToString());
                        ConfigKeyLovId = Convert.ToInt32(ds.Tables[0].Rows[i]["ConfigKeyLovId"].ToString());
                        switch (ConfigKeyId)
                        {
                            case 3:
                                if (ConfigKeyLovId == 99) Indicators.Add(new LovValue { LovId= 1, FieldValue= "B1" });
                                break;
                            case 4:
                                if (ConfigKeyLovId == 99) Indicators.Add(new LovValue { LovId = 2, FieldValue = "B2" });
                                break;
                        }
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return Indicators;
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
        public CorrectiveActionReport Save(CorrectiveActionReport correctiveActionReport, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                var TempCarId = correctiveActionReport.CarId;
                ErrorMessage = string.Empty;
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_QAPCarTxn_Save";

                        SqlParameter parameter = new SqlParameter();
                        cmd.Parameters.AddWithValue("@pCarId", correctiveActionReport.CarId);
                        cmd.Parameters.AddWithValue("@pCustomerId", _UserSession.CustomerId);
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);
                        cmd.Parameters.AddWithValue("@pServiceId", 2);
                        cmd.Parameters.AddWithValue("@pQAPIndicatorId", correctiveActionReport.QAPIndicatorId);
                        cmd.Parameters.AddWithValue("@pCARDate", correctiveActionReport.CARDate);
                        cmd.Parameters.AddWithValue("@pFromDate", correctiveActionReport.FromDate);
                        cmd.Parameters.AddWithValue("@pToDate", correctiveActionReport.ToDate);
                        cmd.Parameters.AddWithValue("@pFollowupCARId", correctiveActionReport.FollowupCARId);
                        cmd.Parameters.AddWithValue("@pAssignedUserId", correctiveActionReport.AssignedUserId);
                        cmd.Parameters.AddWithValue("@pProblemStatement", correctiveActionReport.ProblemStatement);
                        cmd.Parameters.AddWithValue("@pRootCause", correctiveActionReport.RootCause);
                        cmd.Parameters.AddWithValue("@pSolution", correctiveActionReport.Solution);
                        cmd.Parameters.AddWithValue("@pPriorityLovId", correctiveActionReport.PriorityLovId);
                        cmd.Parameters.AddWithValue("@pStatus", correctiveActionReport.Status);
                        cmd.Parameters.AddWithValue("@pIssuerUserId", correctiveActionReport.IssuerUserId);
                        cmd.Parameters.AddWithValue("@pCARTargetDate", correctiveActionReport.CARTargetDate);
                        cmd.Parameters.AddWithValue("@pVerifiedDate", correctiveActionReport.VerifiedDate);
                        cmd.Parameters.AddWithValue("@pVerifiedBy", correctiveActionReport.VerifiedBy);
                        cmd.Parameters.AddWithValue("@pRemarks", correctiveActionReport.Remarks);
                        cmd.Parameters.AddWithValue("@pCarStatus", correctiveActionReport.CARStatus);
                        cmd.Parameters.AddWithValue("@pUserId", _UserSession.UserId);
                        cmd.Parameters.AddWithValue("@pTimestamp", Convert.FromBase64String(correctiveActionReport.Timestamp));

                        var dataTable = new DataTable("udt_QAPCarTxnDet");
                        dataTable.Columns.Add("CarDetId", typeof(int));
                        dataTable.Columns.Add("CustomerId", typeof(int));
                        dataTable.Columns.Add("FacilityId", typeof(int));
                        dataTable.Columns.Add("ServiceId", typeof(int));
                        dataTable.Columns.Add("CarId", typeof(int));
                        dataTable.Columns.Add("Activity", typeof(string));
                        dataTable.Columns.Add("StartDate", typeof(DateTime));
                        dataTable.Columns.Add("TargetDate", typeof(DateTime));
                        dataTable.Columns.Add("CompletedDate", typeof(DateTime));
                        dataTable.Columns.Add("ResponsiblePersonUserId", typeof(int));
                        dataTable.Columns.Add("ResponsibilityId", typeof(int));
                        dataTable.Columns.Add("IsDeleted", typeof(bool));

                        foreach (var item in correctiveActionReport.activities)
                        {
                            dataTable.Rows.Add(item.CarDetId, _UserSession.CustomerId, _UserSession.FacilityId, 2, correctiveActionReport.CarId, 
                                item.Activity, item.StartDate, item.TargetDate, item.CompletedDate, item.ResponsiblePersonUserId, 
                                item.ResponsibilityId,  item.IsDeleted);
                        }
                        parameter.ParameterName = "@pQAPCarTxnDet";
                        parameter.SqlDbType = SqlDbType.Structured;
                        parameter.Value = dataTable;
                        cmd.Parameters.Add(parameter);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    ErrorMessage = Convert.ToString(ds.Tables[0].Rows[0]["ErrorMessage"]);
                    if (ErrorMessage == string.Empty)
                    {
                        correctiveActionReport.CarId = Convert.ToInt32(ds.Tables[0].Rows[0]["CarId"]);
                        correctiveActionReport = Get(correctiveActionReport.CarId, 1, 5);

                        _EmailDAL.SendCAREmail(correctiveActionReport);
                        UpdateNotification(correctiveActionReport);                                                
                    }
                }
                
                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return correctiveActionReport;
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

        private void UpdateNotification(CorrectiveActionReport correctiveActionReport)
        {
            var dbAccessDAL = new DBAccessDAL();
            var parameters = new Dictionary<string, string>();
            var DataSetparameters = new Dictionary<string, DataTable>();

            var action = string.Empty;
            var emailTemplateId = 0;
            
            switch (correctiveActionReport.CARStatus)
            {
                case (int)CARStatus.Submitted:
                    action = "submitted";
                    emailTemplateId = (int)NotificationTemplateIds.QAPCARSubmission;
                    break;
                case (int)CARStatus.Approved:
                    action = "approved";
                    emailTemplateId = (int)NotificationTemplateIds.QAPCARApproved;
                    break;
                case (int)CARStatus.Rejected:
                    action = "rejected";
                    emailTemplateId = (int)NotificationTemplateIds.QAPCARRejected;
                    break;
            }

            var notalert = "CAR " + correctiveActionReport.CARNumber + " has been " + action;
            var hyplink = "/qap/correctiveactionreport?id=" + correctiveActionReport.CarId;

            parameters.Add("@pNotificationId", Convert.ToString(0));
            parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
            parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
            parameters.Add("@pUserId", Convert.ToString(correctiveActionReport.AssignedUserId));
            parameters.Add("@pNotificationAlerts", Convert.ToString(notalert));
            parameters.Add("@pRemarks", Convert.ToString(""));
            parameters.Add("@pHyperLink", Convert.ToString(hyplink));
            parameters.Add("@pIsNew", Convert.ToString(1));
            parameters.Add("@pNotificationDateTime", Convert.ToString(null));
            parameters.Add("@pEmailTempId", Convert.ToString(emailTemplateId));

            DataTable ds = dbAccessDAL.GetDataTable("uspFM_WebNotificationSingle_Save", parameters, DataSetparameters);
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
                var QueryCondition = pageFilter.QueryWhereCondition;
                var strCondition = string.Empty;
                if (string.IsNullOrEmpty(QueryCondition))
                {
                    strCondition = "FacilityId = " + _UserSession.FacilityId.ToString();
                }
                else
                {
                    strCondition = QueryCondition + "AND FacilityId = " + _UserSession.FacilityId.ToString();
                }
                strOrderBy = string.IsNullOrEmpty(strOrderBy) ? pageFilter.SortColumn + " " + pageFilter.SortOrder : strOrderBy;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_QAPCarTxn_GetAll ";

                        cmd.Parameters.AddWithValue("@PageIndex", pageFilter.PageIndex);
                        cmd.Parameters.AddWithValue("@PageSize", pageFilter.PageSize);
                        cmd.Parameters.AddWithValue("@strCondition", strCondition);
                        cmd.Parameters.AddWithValue("@strSorting", strOrderBy);

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
                return filterResult;
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
        public CorrectiveActionReport Get(int Id, int PageIndex, int PageSize)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                CorrectiveActionReport correctiveActionReport = null;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_QAPCarTxn_GetById";
                        cmd.Parameters.AddWithValue("@pCarId", Id);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    correctiveActionReport = (from n in ds.Tables[0].AsEnumerable()
                                              select new CorrectiveActionReport
                                              {

                                                  CarId = n.Field<int>("CarId"),
                                                  CARNumber = n.Field<string>("CARNumber"),
                                                  QAPIndicatorId = n.Field<int>("QAPIndicatorId"),
                                                  IndicatorCode = n.Field<string>("IndicatorCode"),
                                                  CARDate = n.Field<DateTime>("CARDate"),
                                                  FromDate = n.Field<DateTime?>("FromDate"),
                                                  ToDate = n.Field<DateTime?>("ToDate"),
                                                  //FailureSymptomId = n.Field<int?>("FailureSymptomId"),
                                                  //FailureSymptomCode = n.Field<string>("FailureSymptomCode"),
                                                  FollowupCARId = n.Field<int?>("FollowupCARId"),
                                                  FollowUpCARNumber = n.Field<string>("FollowUpCARNumber"),
                                                  AssignedUserId = n.Field<int?>("AssignedUserId"),
                                                  AssignedUserName = n.Field<string>("AssignedUserName"),
                                                  ProblemStatement = n.Field<string>("ProblemStatement"),
                                                  RootCause = n.Field<string>("RootCause"),
                                                  Solution = n.Field<string>("Solution"),
                                                  PriorityLovId = n.Field<int?>("PriorityLovId"),
                                                  Status = n.Field<int>("Status"),
                                                  IssuerUserId = n.Field<int?>("IssuerUserId"),
                                                  IssuerUserName = n.Field<string>("IssuerUserName"),
                                                  CARTargetDate = n.Field<DateTime?>("CARTargetDate"),
                                                  VerifiedDate = n.Field<DateTime?>("VerifiedDate"),
                                                  VerifiedBy = n.Field<int?>("VerifiedBy"),
                                                  VerifiedByName = n.Field<string>("VerifiedByName"),
                                                  Remarks = n.Field<string>("Remarks"),
                                                  CARGeneration = n.Field<string>("CARGeneration"),
                                                  CARStatus = n.Field<int?>("CARStatus"),
                                                  CARStatusValue = n.Field<string>("CARStatusValue"),
                                                  Timestamp = Convert.ToBase64String((byte[])(n["Timestamp"])),
                                                  HiddenId=Convert.ToString(n["GuId"]),

                                              }).FirstOrDefault();
                }
                if (ds.Tables.Count != 0 && ds.Tables[1].Rows.Count > 0)
                {
                    correctiveActionReport.activities = (from n in ds.Tables[1].AsEnumerable()
                                                         select new CARAcitvity
                                                         {
                                                             CarDetId = n.Field<int>("CarDetId"),
                                                             Activity = n.Field<string>("Activity"),
                                                             StartDate = n.Field<DateTime>("StartDate"),
                                                             TargetDate = n.Field<DateTime>("TargetDate"),
                                                             CompletedDate = n.Field<DateTime?>("CompletedDate"),
                                                             ResponsibilityId = n.Field<int?>("ResponsibilityId"),
                                                             ResponsiblePersonUserId = n.Field<int?>("ResponsiblePersonUserId"),
                                                             ResponsiblePerson = n.Field<string>("ResponsiblePerson"),
                                                         }).ToList();

                    correctiveActionReport.IsAutoCarEdit = false;
                }
                else
                {
                    correctiveActionReport.IsAutoCarEdit = true;
                }
                 Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return correctiveActionReport;
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
        public CARWorkOrderList GetWorkOrderDetails(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var carWorkOrderList = new CARWorkOrderList();

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_QAPWorkOrderDetails_GetByCarId";
                        cmd.Parameters.AddWithValue("@pCarId", Id);
                        
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {

                    carWorkOrderList.workOrderDetails = (from n in ds.Tables[0].AsEnumerable()
                                              select new CARWorkOrderDetails
                                              {
                                                  AdditionalInfoId = n.Field<int>("AdditionalInfoId"),
                                                  WorkOrderId = n.Field<int>("WorkOrderId"),
                                                  MaintenanceWorkNo = n.Field<string>("MaintenanceWorkNo"),
                                                  CategoryId = n.Field<int>("MaintenanceWorkCategory"),
                                                  MaintenanceWorkDateTime = n.Field<DateTime>("MaintenanceWorkDateTime"),
                                                  AssetNo = n.Field<string>("AssetNo"),
                                                  //FailureSymptomId = n.Field<int?>("CauseCodeId"),
                                                  //RootCauseId = n.Field<int?>("QCCodeId")
                                                  FailureSymptomId = n.Field<int?>("QCCodeId"),
                                                  RootCauseId = n.Field<int?>("CauseCodeId")
                                              }).ToList();
                    foreach (var item in carWorkOrderList.workOrderDetails)
                    {
                        if (item.FailureSymptomId != null)
                        {
                            item.rootCausesList = GetRootCauses((int)item.FailureSymptomId);
                        } else if (item.RootCauseId != null)
                        {
                            item.rootCausesList = GetRootCauseList((int)item.RootCauseId);
                        }
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return carWorkOrderList;
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
        public CARHistoryList GetCARHistoryDetails(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var carHistoryList = new CARHistoryList();

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_QAPCarHistory_GetByCarId";
                        cmd.Parameters.AddWithValue("@pCarId", Id);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {

                    carHistoryList.historyDetails = (from n in ds.Tables[0].AsEnumerable()
                                                         select new CARHistoryDetails
                                                         {
                                                             StatusValue = n.Field<string>("StatusValue"),
                                                             RootCause = n.Field<string>("RootCause"),
                                                             Solution = n.Field<string>("Solution"),
                                                             Remarks = n.Field<string>("Remarks"),
                                                             LastModifiedBy = n.Field<string>("ModifiedBy"),
                                                             LastModifiedDate = n.Field<DateTime>("ModifiedDate"),
                                                         }).ToList();
                }

                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return carHistoryList;
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
        public CARWorkOrderList SaveWorkOrderDetails(CARWorkOrderList carWorkOrderList)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_QAPWorkOrderDetails_Save";

                        var dataTable = new DataTable("udt_QapB1AdditionalInformationTxn");
                        dataTable.Columns.Add("AdditionalInfoId", typeof(int));
                        dataTable.Columns.Add("CustomerId", typeof(int));
                        dataTable.Columns.Add("FacilityId", typeof(int));
                        dataTable.Columns.Add("ServiceId", typeof(int));
                        dataTable.Columns.Add("CarId", typeof(int));
                        dataTable.Columns.Add("AssetId", typeof(int));
                        dataTable.Columns.Add("WorkOrderId", typeof(int));
                        dataTable.Columns.Add("TargetDateTime", typeof(DateTime));
                        dataTable.Columns.Add("EndDateTime", typeof(DateTime));
                        dataTable.Columns.Add("CauseCodeId", typeof(int));
                        dataTable.Columns.Add("QcCodeId", typeof(int));
                        dataTable.Columns.Add("UserId", typeof(int));
                        
                        foreach (var item in carWorkOrderList.workOrderDetails)
                        {
                            dataTable.Rows.Add(item.AdditionalInfoId, _UserSession.CustomerId, _UserSession.FacilityId, 2, DBNull.Value,
                                DBNull.Value, item.WorkOrderId, DBNull.Value, DBNull.Value, item.RootCauseId, item.FailureSymptomId,
                                _UserSession.UserId);
                        }
                        SqlParameter parameter = new SqlParameter();
                        parameter.ParameterName = "@WorkOrderDetails";
                        parameter.SqlDbType = SqlDbType.Structured;
                        parameter.Value = dataTable;
                        cmd.Parameters.Add(parameter);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
               
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return carWorkOrderList;
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
        public void Delete(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());

                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_QAPCarTxn_Delete";
                        cmd.Parameters.AddWithValue("@pCarId", Id);

                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();
                    }
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
        public RootCauseList GetRootCauses(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetRootCauses), Level.Info.ToString());
                var rootCauseList = new RootCauseList();

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "UspFM_QCCode_GetbyId";
                        cmd.Parameters.AddWithValue("@pQualityCauseId", Id);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {

                    rootCauseList.rootCauses = (from n in ds.Tables[0].AsEnumerable()
                                                select new RootCauses
                                                {
                                                    RootCauseId = n.Field<int>("RootCauseId"),
                                                    RootCauseDescription = n.Field<string>("RootCauseDescription")
                                                }).ToList();
                }

                Log4NetLogger.LogExit(_FileName, nameof(GetRootCauses), Level.Info.ToString());
                return rootCauseList;
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
        public RootCauseList GetRootCauseList(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetRootCauseList), Level.Info.ToString());
                var rootCauseList = new RootCauseList();

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "UspFM_QCCodeUsingId_GetbyId";
                        cmd.Parameters.AddWithValue("@pQualityCauseDetId", Id);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {

                    rootCauseList.rootCauses = (from n in ds.Tables[0].AsEnumerable()
                                                select new RootCauses
                                                {
                                                    RootCauseId = n.Field<int>("RootCauseId"),
                                                    RootCauseDescription = n.Field<string>("RootCauseDescription")
                                                }).ToList();
                }

                Log4NetLogger.LogExit(_FileName, nameof(GetRootCauseList), Level.Info.ToString());
                return rootCauseList;
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