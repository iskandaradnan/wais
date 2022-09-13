
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
using CP.UETrack.Models;

namespace CP.UETrack.DAL.DataAccess
{
    public class ReportsAndRecordsDAL : IReportsAndRecordsDAL
    {
        private readonly string _FileName = nameof(ReportsAndRecordsDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public ReportsAndRecordsLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var reportAndRecordsLovs = new ReportsAndRecordsLovs();

                var currentYear = DateTime.Now.Year;
                var previousYear = currentYear - 1;
                reportAndRecordsLovs.Years = new List<LovValue> { new LovValue { LovId = previousYear, FieldValue = previousYear.ToString() }, new LovValue { LovId = currentYear, FieldValue = currentYear.ToString() } };
                reportAndRecordsLovs.CurrentYear = currentYear;
                var currentMonth = DateTime.Now.Month;
                reportAndRecordsLovs.CurrentMonth = currentMonth;

                var ds = new DataSet();
                var ds1 = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown_Others";
                        cmd.Parameters.AddWithValue("@pLovKey", "");
                        cmd.Parameters.AddWithValue("@pTableName", "FMTimeMonth");

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0)
                {
                    reportAndRecordsLovs.Months = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                }
                return reportAndRecordsLovs;
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
        public ReportsAndRecordsLst FetchRecords(int Year, int Month)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var reportAndRecordsList = new ReportsAndRecordsLst();

               
                var ds = new DataSet();
                var ds1 = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "UspFM_KPIReportsandRecordTxn_Fetch";
                        cmd.Parameters.AddWithValue("@pCustomerId", _UserSession.CustomerId);
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);
                        cmd.Parameters.AddWithValue("@pYear", Year);
                        cmd.Parameters.AddWithValue("@pMonth", Month);
                        
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0)
                {
                    reportAndRecordsList.ReportsAndRecords = (from n in ds.Tables[0].AsEnumerable()
                                                              select new ReportsAndRecords
                                                              {
                                                                  ReportsandRecordTxnDetId = n.Field<int>("ReportsandRecordTxnDetId"),
                                                                  ReportsandRecordTxnId = n.Field<int>("ReportsandRecordTxnId"),
                                                                  CustomerReportId = n.Field<int?>("CustomerReportId"),
                                                                  ReportName = n.Field<string>("ReportName"),
                                                                  Submitted = n.Field<bool>("Submitted"),
                                                                  Verified = n.Field<bool>("Verified"),
                                                                  RecordSubmitted = n.Field<bool?>("RecordSubmitted"),
                                                                  RecordVerified = n.Field<bool?>("RecordVerified"),
                                                                  Remarks = n.Field<string>("Remarks"),
                                                                  Status = n.Field<string>("Status")
                                                              }).ToList();
                }
                return reportAndRecordsList;
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
        public ReportsAndRecordsLst Save(ReportsAndRecordsLst repotsAndRecordsList, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                
                ErrorMessage = string.Empty;
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_KPIReportsandRecordTxn_Save";

                        SqlParameter parameter = new SqlParameter();
                        cmd.Parameters.AddWithValue("@pReportsandRecordTxnId", repotsAndRecordsList.ReportsandRecordTxnId);
                        cmd.Parameters.AddWithValue("@pYear", repotsAndRecordsList.Year);
                        cmd.Parameters.AddWithValue("@pMonth", repotsAndRecordsList.Month);
                        cmd.Parameters.AddWithValue("@pSubmitted", repotsAndRecordsList.Submitted);
                        cmd.Parameters.AddWithValue("@PVerified", repotsAndRecordsList.Verified);
                        cmd.Parameters.AddWithValue("@pCustomerId", _UserSession.CustomerId);
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);
                        cmd.Parameters.AddWithValue("@pUserId", _UserSession.UserId);
                        cmd.Parameters.Add("@pErrorMessage", SqlDbType.NVarChar);
                        cmd.Parameters["@pErrorMessage"].Size = 1000;
                        cmd.Parameters["@pErrorMessage"].Direction = ParameterDirection.Output;

                        var dataTable = new DataTable("udt_KPIReportsandRecordTxnDet");
                        dataTable.Columns.Add("ReportsandRecordTxnDetId", typeof(int));
                        dataTable.Columns.Add("CustomerReportId", typeof(int));
                        dataTable.Columns.Add("Submitted", typeof(bool));
                        dataTable.Columns.Add("Verified", typeof(bool));
                        dataTable.Columns.Add("ReportName", typeof(string));
                        dataTable.Columns.Add("Remarks", typeof(string));
                        dataTable.Columns.Add("UserId", typeof(int));
                        dataTable.Columns.Add("IsDeleted", typeof(bool));

                        foreach (var item in repotsAndRecordsList.ReportsAndRecords)
                        {
                            dataTable.Rows.Add(item.ReportsandRecordTxnDetId, item.CustomerReportId, item.Submitted, item.Verified, item.ReportName, 
                                item.Remarks, _UserSession.UserId,item.IsDeleted);
                        }
                        parameter.ParameterName = "@pKPIReportsandRecordTxn";
                        parameter.SqlDbType = SqlDbType.Structured;
                        parameter.Value = dataTable;
                        cmd.Parameters.Add(parameter);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        ErrorMessage = cmd.Parameters["@pErrorMessage"].Value.ToString();
                    }
                }
                if (ErrorMessage == string.Empty && ds.Tables[0].Rows.Count > 0)
                {
                    //ErrorMessage = Convert.ToString(ds.Tables[0].Rows[0]["ErrorMessage"]);
                    //if (ErrorMessage == string.Empty)
                    //{
                        repotsAndRecordsList.ReportsAndRecords = (from n in ds.Tables[0].AsEnumerable()
                                                                  select new ReportsAndRecords
                                                                  {
                                                                      ReportsandRecordTxnDetId = n.Field<int>("ReportsandRecordTxnDetId"),
                                                                      ReportsandRecordTxnId = n.Field<int>("ReportsandRecordTxnId"),
                                                                      CustomerReportId = n.Field<int?>("CustomerReportId"),
                                                                      ReportName = n.Field<string>("ReportName"),
                                                                      Submitted = n.Field<bool>("Submitted"),
                                                                      Verified = n.Field<bool>("Verified"),
                                                                      RecordSubmitted = n.Field<bool?>("RecordSubmitted"),
                                                                      RecordVerified = n.Field<bool?>("RecordVerified"),
                                                                      Remarks = n.Field<string>("Remarks"),
                                                                      Status = n.Field<string>("Status")
                                                                  }).ToList();
                    //}
                }
                
                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return repotsAndRecordsList;
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
        public ReportsAndRecordsLst Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var reportsAndRecords = new ReportsAndRecordsLst();

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "UspFM_KPIReportsandRecordTxn_GetById";
                        cmd.Parameters.AddWithValue("@pReportsandRecordTxnId", Id);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    reportsAndRecords.ReportsAndRecords = (from n in ds.Tables[0].AsEnumerable()
                                                           select new ReportsAndRecords
                                                           {
                                                               ReportsandRecordTxnDetId = n.Field<int>("ReportsandRecordTxnDetId"),
                                                               ReportsandRecordTxnId = n.Field<int>("ReportsandRecordTxnId"),
                                                               CustomerReportId = n.Field<int?>("CustomerReportId"),
                                                               ReportName = n.Field<string>("ReportName"),
                                                               Submitted = n.Field<bool>("Submitted"),
                                                               Verified = n.Field<bool>("Verified"),
                                                               RecordSubmitted = n.Field<bool?>("RecordSubmitted"),
                                                               RecordVerified = n.Field<bool?>("RecordVerified"),
                                                               Remarks = n.Field<string>("Remarks"),
                                                               Status = n.Field<string>("Status"),
                                                               Year = n.Field<int>("Year"),
                                                               Month = n.Field<int>("Month")
                                                           }).ToList();
                }
               
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return reportsAndRecords;
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
        public CorrectiveActionReport updateNotificationSingle(CorrectiveActionReport ent)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            CorrectiveActionReport griddata = new CorrectiveActionReport();
            var dbAccessDAL = new DBAccessDAL();
            var parameters = new Dictionary <string, string>();
            var DataSetparameters = new Dictionary <string, DataTable>();

            var notalert = ent.CARNumber + " " + "CAR has been generated";
            var hyplink = "/qap/correctiveactionreport?id=" + ent.CarId;
            parameters.Add("@pNotificationId", Convert.ToString(ent.NotificationId));
            parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
            parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
            parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
            parameters.Add("@pNotificationAlerts", Convert.ToString(notalert));
            parameters.Add("@pRemarks", Convert.ToString(""));
            parameters.Add("@pHyperLink", Convert.ToString(hyplink));
            parameters.Add("@pIsNew", Convert.ToString(1));
            parameters.Add("@pNotificationDateTime", Convert.ToString(null));

            DataTable ds = dbAccessDAL.GetDataTable("uspFM_WebNotificationSingle_Save", parameters, DataSetparameters);
            if (ds != null)
            {
                foreach (DataRow row in ds.Rows)
                {
                    //model.CRMRequestId = Convert.ToInt32(row["CRMRequestId"]);
                    //model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    //// model.err = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    //model.HiddenId = Convert.ToString(row["GuId"]);
                }
            }

            return ent;
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
                        cmd.CommandText = "uspFM_KPIReportsandRecordTxn_GetAll";

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
                                                  FailureSymptomId = n.Field<int?>("CauseCodeId"),
                                                  RootCauseId = n.Field<int?>("QCCodeId")
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
                                DBNull.Value, item.WorkOrderId, DBNull.Value, DBNull.Value, item.FailureSymptomId, item.RootCauseId,
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