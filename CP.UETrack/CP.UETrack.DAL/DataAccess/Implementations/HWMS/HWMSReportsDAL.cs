using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.HWMS;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using CP.UETrack.Model.HWMS;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using UETrack.DAL;

namespace CP.UETrack.DAL.DataAccess.Implementations.HWMS
{
    public class HWMSReportsDAL : IHWMSReportsDAL
    {
        private readonly string _FileName = nameof(HWMSReportsDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public ReportsDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();

                ReportsDropdown _Dropdowns = new ReportsDropdown();

                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        var da = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "SP_CLS_Reports_Load";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pScreenName", "Reports");

                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables[0] != null)
                        {
                            _Dropdowns.YearLovs = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }
                        if (ds.Tables[1] != null)
                        {
                            _Dropdowns.MonthLovs = dbAccessDAL.GetLovRecords(ds.Tables[1]);
                        }
                        if (ds.Tables[2] != null)
                        {
                            _Dropdowns.RequestType = dbAccessDAL.GetLovRecords(ds.Tables[2]);
                        }
                        if (ds.Tables[3] != null)
                        {
                            _Dropdowns.WasteCategory = dbAccessDAL.GetLovRecords(ds.Tables[3]);
                        }

                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return _Dropdowns;
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
       
        public LicenseReport LicenseReportFetch(out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LicenseReportFetch), Level.Info.ToString());
                LicenseReport model = new LicenseReport();               
                ErrorMessage = string.Empty;
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "SP_HWMS_LicenseReportFetch";

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                        {

                            List<LicenseReport> LicenseReportList = new List<LicenseReport>();
                            foreach (DataRow dr in ds.Tables[0].Rows)
                            {
                                LicenseReport Records = new LicenseReport();

                                Records.LicenseNo = dr["LicenseNo"].ToString();
                                Records.LicenseDescription = dr["LicenseDescription"].ToString();
                                Records.LicenseType = dr["LicenseType"].ToString();

                                LicenseReportList.Add(Records);
                            }
                            model.LicenseReportList = LicenseReportList;
                        }
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(LicenseReportFetch), Level.Info.ToString());
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

        public WeighingSummaryReport WeighingSummaryReportFetch(WeighingSummaryReport model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(WeighingSummaryReportFetch), Level.Info.ToString());
                var spName = string.Empty;
                ErrorMessage = string.Empty;


                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "SP_HWMS_WeighingSummaryReportFetch";
                        cmd.Parameters.AddWithValue("@Month", model.Month);
                        cmd.Parameters.AddWithValue("@Year", model.Year);
                        cmd.Parameters.AddWithValue("@WasteCategory", model.WasteCategory);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                        {
                            List<WeighingSummaryReport> WeighingSummaryReportList = new List<WeighingSummaryReport>();
                            foreach (DataRow dr in ds.Tables[0].Rows)
                            {
                                WeighingSummaryReport Report = new WeighingSummaryReport();

                                Report.WasteCategory = dr["WasteCategory"].ToString();
                                Report.ConsignmentNo = dr["ConsignmentNo"].ToString();
                                Report.TotalWeight = dr["TotalWeight"].ToString();
                                Report.NoofBins = dr["NoofBins"].ToString();
                                Report.Date = dr["Date"].ToString();                               

                                WeighingSummaryReportList.Add(Report);

                            }
                            model.WeighingSummaryReportList = WeighingSummaryReportList;
                        }
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(WeighingSummaryReportFetch), Level.Info.ToString());
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

        public TransportationReport TransportationReportFetch(TransportationReport model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(TransportationReportFetch), Level.Info.ToString());
                var spName = string.Empty;
                ErrorMessage = string.Empty;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "SP_HWMS_TransportationReportFetch";
                        cmd.Parameters.AddWithValue("@Month", model.Month);
                        cmd.Parameters.AddWithValue("@Year", model.Year);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables[0] != null)
                        {
                            if (ds.Tables[0].Rows.Count > 0)
                            {
                                List<TransportationReport> TransportationReportList = new List<TransportationReport>();
                                foreach (DataRow dr in ds.Tables[0].Rows)
                                {
                                    TransportationReport Report = new TransportationReport();

                                    Report.ConsignmentNote = dr["ConsignmentNote"].ToString();
                                    Report.Date = dr["Date"].ToString();
                                    Report.QCValue = dr["QCValue"].ToString();
                                    Report.VehicleNumber = dr["VehicleNumber"].ToString();
                                    Report.DriverName = dr["DriverName"].ToString();
                                    Report.ONSchedule = dr["ONSchedule"].ToString();                                    

                                    TransportationReportList.Add(Report);

                                }
                                model.TransportationReportList = TransportationReportList;
                            }
                        }
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(TransportationReportFetch), Level.Info.ToString());
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

        public SafetyDataSheetReport SafetyDataSheetReportFetch(SafetyDataSheetReport model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(SafetyDataSheetReportFetch), Level.Info.ToString());
                var spName = string.Empty;
                ErrorMessage = string.Empty;


                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "SP_HWMS_SafetyDataSheetReportFetch";
                        cmd.Parameters.AddWithValue("@Month", model.Month);
                        cmd.Parameters.AddWithValue("@Year", model.Year);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables[0] != null)
                        {
                            if (ds.Tables[0].Rows.Count > 0)
                            {
                                List<SafetyDataSheetReport> SafetyDataSheetReportList = new List<SafetyDataSheetReport>();
                                foreach (DataRow dr in ds.Tables[0].Rows)
                                {
                                    SafetyDataSheetReport Report = new SafetyDataSheetReport();
                                   
                                    Report.ChemicalName = dr["ChemicalName"].ToString();
                                    Report.DocumentNo = dr["DocumentNo"].ToString();
                                    Report.DocumentDate = dr["DocumentDate"].ToString();
                                    Report.Category = dr["Category"].ToString();
                                    Report.AreaOfApplication = dr["AreaOfApplication"].ToString();

                                    SafetyDataSheetReportList.Add(Report);

                                }
                                model.SafetyDataSheetReportList = SafetyDataSheetReportList;
                            }
                        }
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(SafetyDataSheetReportFetch), Level.Info.ToString());
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

        public RecordSheetWithoutCN RecordSheetWithoutCNFetch(RecordSheetWithoutCN model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(RecordSheetWithoutCNFetch), Level.Info.ToString());
                var spName = string.Empty;
                ErrorMessage = string.Empty;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "SP_HWMS_RecordSheetWithoutCN";

                        cmd.Parameters.AddWithValue("@Month", model.Month);
                        cmd.Parameters.AddWithValue("@Year", model.Year);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables[0] != null)
                        {
                            if (ds.Tables[0].Rows.Count > 0)
                            {
                                List<RecordSheetWithoutCN> RecordSheetWithoutCNList = new List<RecordSheetWithoutCN>();
                                foreach (DataRow dr in ds.Tables[0].Rows)
                                {
                                    RecordSheetWithoutCN Report = new RecordSheetWithoutCN();
                                  
                                    Report.DateOfConsignmentNote = dr["DateOfConsignmentNote"].ToString();
                                    Report.ConsignmentNo = dr["ConsignmentNo"].ToString();
                                    Report.TotalWeight = dr["TotalWeight"].ToString();
                                    Report.RM = dr["RM"].ToString();

                                    RecordSheetWithoutCNList.Add(Report);

                                }
                                model.RecordSheetWithoutCNList = RecordSheetWithoutCNList;
                            }
                        }
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(RecordSheetWithoutCNFetch), Level.Info.ToString());
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

        public WasteGenerationMonthlyReport WasteGenerationMonthlyReportFetch(WasteGenerationMonthlyReport model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(WasteGenerationMonthlyReportFetch), Level.Info.ToString());
                var spName = string.Empty;
                ErrorMessage = string.Empty;


                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "SP_HWMS_WasteGenerationMonthlyReportFetch";

                        cmd.Parameters.AddWithValue("@Month", model.Month);
                        cmd.Parameters.AddWithValue("@Year", model.Year);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables[0] != null)
                        {
                            if (ds.Tables[0].Rows.Count > 0)
                            {
                                List<WasteGenerationMonthlyReport> WasteGenerationMonthlyReportList = new List<WasteGenerationMonthlyReport>();
                                foreach (DataRow dr in ds.Tables[0].Rows)
                                {
                                    WasteGenerationMonthlyReport Report = new WasteGenerationMonthlyReport();
                                    Report.DateOfConsignmentNote = dr["DateOfConsignmentNote"].ToString();
                                    Report.ConsignmentNo = dr["ConsignmentNo"].ToString();
                                    Report.TotalWeight = dr["TotalWeight"].ToString();
                                    Report.RM = dr["RM"].ToString();

                                    WasteGenerationMonthlyReportList.Add(Report);

                                }
                                model.WasteGenerationMonthlyReportList = WasteGenerationMonthlyReportList;
                            }
                        }
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(WasteGenerationMonthlyReportFetch), Level.Info.ToString());
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

        public CRMReport CRMReportFetch(CRMReport model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(CRMReportFetch), Level.Info.ToString());
                var spName = string.Empty;
                ErrorMessage = string.Empty;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_HWMS_CRMReportFetch";

                        cmd.Parameters.AddWithValue("@Month", model.Month);
                        cmd.Parameters.AddWithValue("@Year", model.Year);
                        cmd.Parameters.AddWithValue("@RequestType", model.RequestType);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables[0] != null)
                        {
                            if (ds.Tables[0].Rows.Count > 0)
                            {
                                List<CRMReport> CRMReportList = new List<CRMReport>();

                                foreach (DataRow dr in ds.Tables[0].Rows)
                                {
                                    CRMReport Report = new CRMReport();

                                    Report.RequestNo = dr["RequestNo"].ToString();
                                    Report.RequestDate = dr["RequestDate"].ToString();
                                    Report.RequestDetails = dr["RequestDetails"].ToString();
                                    Report.UserArea = dr["UserArea"].ToString();
                                    Report.Requester = dr["Requester"].ToString();
                                    Report.TypeOfRequest = dr["TypeOfRequest"].ToString();
                                    Report.Status = dr["Status"].ToString();
                                    Report.Completion = dr["Completion"].ToString();
                                    Report.Ageing = dr["Ageing"].ToString();


                                    CRMReportList.Add(Report);
                                }
                                model.CRMReportList = CRMReportList;
                            }
                        }
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(CRMReportFetch), Level.Info.ToString());
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
    }
}
