using CP.UETrack.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.UETrack.Models;
using CP.UETrack.Model.CLS;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using UETrack.DAL;
using System.Dynamic;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.DAL.DataAccess.Contracts.CLS;

namespace CP.UETrack.DAL.DataAccess.Implementations.CLS
{
    public class CLSReportsDAL : ICLSReportsDAL
    {
        private readonly string _FileName = nameof(CLSReportsDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public CLSReportsDAL()
        {
        }

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
                        cmd.CommandText = "Sp_CLS_Reports_Load";
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

        public JointInspectionSummaryReport JointInspectionSummaryReportFetch(JointInspectionSummaryReport model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(JointInspectionSummaryReportFetch), Level.Info.ToString());
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
                        cmd.CommandText = "SP_CLS_JISummaryReportFetch";

                        cmd.Parameters.AddWithValue("@Month", model.Month);
                        cmd.Parameters.AddWithValue("@Year", model.Year);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables[0] != null)
                        {
                            if (ds.Tables[0].Rows.Count > 0)
                            {
                                List<JointInspectionSummaryReport> JISummaryReportsList = new List<JointInspectionSummaryReport>();
                                foreach (DataRow dr in ds.Tables[0].Rows)
                                {
                                    JointInspectionSummaryReport Records = new JointInspectionSummaryReport();

                                    Records.No = Convert.ToInt32(dr["No"].ToString());
                                    Records.UserAreaCode = dr["UserAreaCode"].ToString();
                                    Records.UserAreaName = dr["UserAreaName"].ToString();
                                    Records.InspectionScheduled = Convert.ToInt32(dr["InspectionScheduled"].ToString());
                                    Records.Compliance = Convert.ToInt32(dr["Compliance"].ToString());
                                    Records.NonCompliance = Convert.ToInt32(dr["NonCompliance"].ToString());
                                    Records.TotalRatings = Convert.ToInt32(dr["TotalRatings"].ToString());
                                    Records.NoOfUserLocationsInspected = Convert.ToInt32(dr["NoOfUserLocationsInspected"].ToString());
                                    JISummaryReportsList.Add(Records);
                                }
                                model.JISummaryReportsList = JISummaryReportsList;
                            }
                        }
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(JointInspectionSummaryReportFetch), Level.Info.ToString());
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

        public DailyCleaningActivitySummaryReport DailyCleaningActivitySummaryReportFetch(DailyCleaningActivitySummaryReport model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(DailyCleaningActivitySummaryReportFetch), Level.Info.ToString());
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
                        cmd.CommandText = "Sp_CLS_DailyCleaningActivitySummaryReportFetch";

                        cmd.Parameters.AddWithValue("@Month", model.Month);
                        cmd.Parameters.AddWithValue("@Year", model.Year);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables[0] != null)
                        {
                            if (ds.Tables[0].Rows.Count > 0)
                            {
                                List<DailyCleaningActivitySummaryReport> DailyCleaningActivitySummaryReport = new List<DailyCleaningActivitySummaryReport>();
                                foreach (DataRow dr in ds.Tables[0].Rows)
                                {
                                    DailyCleaningActivitySummaryReport Report = new DailyCleaningActivitySummaryReport();

                                    Report.No = Convert.ToInt32(dr["No"].ToString());
                                    Report.UserAreaCode = dr["UserAreaCode"].ToString();
                                    Report.UserArea = dr["UserAreaName"].ToString();
                                    Report.A1 = Convert.ToInt32( dr["A1"].ToString());                                  
                                    Report.A2 = Convert.ToInt32(dr["A2"].ToString());
                                    Report.A3 = Convert.ToInt32(dr["A3"].ToString());
                                    Report.A4 = Convert.ToInt32(dr["A4"].ToString());
                                    Report.B1 = Convert.ToInt32(dr["B1"].ToString());
                                    Report.C1 = Convert.ToInt32(dr["C1"].ToString());
                                    Report.D1 = Convert.ToInt32(dr["D1"].ToString());
                                    Report.D2 = Convert.ToInt32(dr["D2"].ToString());
                                    Report.D3 = Convert.ToInt32(dr["D3"].ToString());
                                    Report.E1 = Convert.ToInt32(dr["E1"].ToString());
                                 
                                    DailyCleaningActivitySummaryReport.Add(Report);

                                }
                                model.DailyCleaningActivitySummaryReportFetchList = DailyCleaningActivitySummaryReport;
                            }
                        }
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(DailyCleaningActivitySummaryReportFetch), Level.Info.ToString());
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

        public PeriodicWorkRecordSummaryReport PeriodicWorkRecordSummaryReportFetch(PeriodicWorkRecordSummaryReport model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(PeriodicWorkRecordSummaryReportFetch), Level.Info.ToString());
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
                        cmd.CommandText = "Sp_CLS_PeriodicWorkRecordSummaryReportFetch";

                        cmd.Parameters.AddWithValue("@Month", model.Month);
                        cmd.Parameters.AddWithValue("@Year", model.Year);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables[0] != null)
                        {
                            if (ds.Tables[0].Rows.Count > 0)
                            {
                                List<PeriodicWorkRecordSummaryReport> PeriodicWorkRecordSummaryReport = new List<PeriodicWorkRecordSummaryReport>();
                                foreach (DataRow dr in ds.Tables[0].Rows)
                                {
                                    PeriodicWorkRecordSummaryReport Report = new PeriodicWorkRecordSummaryReport();
                                   
                                    Report.UserAreaCode = dr["UserAreaCode"].ToString();
                                    Report.UserArea = dr["UserAreaName"].ToString();
                                    Report.Done = dr["Done"].ToString();
                                    Report.NotDone = dr["NotDone"].ToString();

                                    PeriodicWorkRecordSummaryReport.Add(Report);
                                }
                                model.PeriodicWorkRecordSummaryReportsList = PeriodicWorkRecordSummaryReport;
                            }
                        }
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(PeriodicWorkRecordSummaryReportFetch), Level.Info.ToString());
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

        public ToiletInspectionSummaryReport ToiletInspectionSummaryReportFetch(ToiletInspectionSummaryReport model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ToiletInspectionSummaryReportFetch), Level.Info.ToString());
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
                        cmd.CommandText = "SP_CLS_ToiletInspectionSummaryReportFetch";

                        cmd.Parameters.AddWithValue("@Month", model.Month);
                        cmd.Parameters.AddWithValue("@Year", model.Year);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count > 0)
                        {
                            if (ds.Tables[0].Rows.Count > 0)
                            {
                                List<ToiletInspectionSummaryReport> JISummaryReportsList = new List<ToiletInspectionSummaryReport>();
                                foreach (DataRow dr in ds.Tables[0].Rows)
                                {
                                    ToiletInspectionSummaryReport Records = new ToiletInspectionSummaryReport();

                                    Records.TotalToiletLocations = Convert.ToInt32(dr["TotalToiletLocations"].ToString());
                                    Records.TotalDone = Convert.ToInt32(dr["TotalDone"].ToString());
                                    Records.TotalNotDone = Convert.ToInt32(dr["TotalNotDone"].ToString());
                                    JISummaryReportsList.Add(Records);
                                }
                                model.ToiletInspReportList = JISummaryReportsList;
                            }
                        }
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(ToiletInspectionSummaryReportFetch), Level.Info.ToString());
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

        public EquipmentReport EquipmentReportFetch(EquipmentReport model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(EquipmentReportFetch), Level.Info.ToString());
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
                        cmd.CommandText = "Sp_CLS_EquipmentReportFetch";

                        cmd.Parameters.AddWithValue("@Month", model.Month);
                        cmd.Parameters.AddWithValue("@Year", model.Year);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables[0] != null)
                        {
                            if (ds.Tables[0].Rows.Count > 0)
                            {
                                List<EquipmentReport> EquipmentReportList = new List<EquipmentReport>();
                                foreach (DataRow dr in ds.Tables[0].Rows)
                                {
                                    EquipmentReport Records = new EquipmentReport();
                                    Records.EquipmentCode = dr["EquipmentCode"].ToString();
                                    Records.EquipmentDescription = dr["EquipmentDescription"].ToString();
                                    Records.Quantity = dr["Quantity"].ToString();
                                    EquipmentReportList.Add(Records);
                                }
                                model.EquipmentReportList = EquipmentReportList;
                            }
                        }
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(EquipmentReportFetch), Level.Info.ToString());
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

        public ChemicalUsedReport ChemicalUsedReportFetch(ChemicalUsedReport model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ChemicalUsedReportFetch), Level.Info.ToString());
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
                        cmd.CommandText = "Sp_CLS_ChemicalUsedReportFetch";

                        cmd.Parameters.AddWithValue("@Month", model.Month);
                        cmd.Parameters.AddWithValue("@Year", model.Year);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                        {

                            List<ChemicalUsedReport> ChemicalUsedReportList = new List<ChemicalUsedReport>();
                            foreach (DataRow dr in ds.Tables[0].Rows)
                            {
                                ChemicalUsedReport Records = new ChemicalUsedReport();

                                Records.ChemicalName = dr["ChemicalName"].ToString();
                                Records.KMMNO = dr["KMMNO"].ToString();
                                Records.Category = dr["Category"].ToString();
                                Records.AreaofApplication = dr["AreaofApplication"].ToString();
                                Records.Properties = dr["Properties"].ToString();
                                Records.Status = dr["Status"].ToString();
                                Records.EffectiveDate = dr["EffectiveDate"].ToString();

                                ChemicalUsedReportList.Add(Records);
                            }
                            model.ChemicalReportList = ChemicalUsedReportList;

                        }
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(ChemicalUsedReportFetch), Level.Info.ToString());
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
                        cmd.CommandText = "Sp_CLS_CRMReportFetch";

                        cmd.Parameters.AddWithValue("@Month", model.Month);
                        cmd.Parameters.AddWithValue("@Year", model.Year);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                        {
                            List<CRMReport> CRMReportList = new List<CRMReport>();
                            foreach (DataRow dr in ds.Tables[0].Rows)
                            {
                                CRMReport Records = new CRMReport();

                                Records.RequestNo = dr["RequestNo"].ToString();
                                Records.RequestDate = dr["RequestDate"].ToString();
                                Records.RequestDetails = dr["RequestDetails"].ToString();
                                Records.UserArea = dr["UserArea"].ToString();
                                Records.Requester = dr["Requester"].ToString();
                                Records.TypeOfRequest = dr["TypeOfRequest"].ToString();
                                Records.Status = dr["Status"].ToString();
                                Records.Completion = dr["Completion"].ToString();
                                Records.Ageing = dr["Ageing"].ToString();

                                CRMReportList.Add(Records);
                            }
                            model.CRMReportList = CRMReportList;
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
            catch (Exception ex)
            {
                throw ex;
            }
        }




    }
}
