using CP.Framework.Common.StateManagement;
using CP.UETrack.DAL.DataAccess;
using CP.UETrack.Model;
using Microsoft.Reporting.WebForms;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using UETrack.DAL;

namespace UETrack.Application.Web.Report
{
    public partial class PlannedPreventiveScheduleReport : System.Web.UI.Page
    {
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    var TypeCodeId = Request.QueryString["TypeCodeId"];
                    var Year = Request.QueryString["Year"];
                    var Schedule = Request.QueryString["Schedule"];
                    var TaskCodeOption = Request.QueryString["TaskCodeOption"];
                    var Status = Request.QueryString["Status"];
                    if (Year == "null")
                    {
                        Year = null; 
                    }
                    if (Schedule == "null")
                    {
                        Schedule = null;
                    }
                    if (TaskCodeOption == "null")
                    {
                        TaskCodeOption = null;
                    }
                    if (Status == "null")
                    {
                        Status = null;
                    }
                    reportViewer.Visible = true;
                    reportViewer.ProcessingMode = ProcessingMode.Local;
                    reportViewer.LocalReport.ReportPath = Server.MapPath(Request.ApplicationPath) + @"RdlReports\LatestReportsRDLC\PlannedPreventiveScheduleReport_L1.rdlc";
                    var datasource = new ReportDataSource("UET_PPMchedule_Rpt_L1", GetSPResult("UET_PPMchedule_Rpt_L1", TypeCodeId, Year, Schedule, TaskCodeOption, Status));
                    var datasource1 = new ReportDataSource("Facility_Ds", GetSPResult("Facility_Ds", TypeCodeId, Year, Schedule, TaskCodeOption, Status));
                    var datasource2 = new ReportDataSource("TypeCode_Ds", GetSPResult("TypeCode_Ds", TypeCodeId, Year, Schedule, TaskCodeOption, Status));
                    var datasource3 = new ReportDataSource("Year_Ds", GetSPResult("Year_Ds", TypeCodeId, Year, Schedule, TaskCodeOption, Status));
                    var datasource4 = new ReportDataSource("ScheduleType_Ds", GetSPResult("ScheduleType_Ds", TypeCodeId, Year, Schedule, TaskCodeOption, Status));
                    var datasource5 = new ReportDataSource("TaskCodeOption_Ds", GetSPResult("TaskCodeOption_Ds", TypeCodeId, Year, Schedule, TaskCodeOption, Status));
                    var datasource6 = new ReportDataSource("Status_Ds", GetSPResult("Status_Ds", TypeCodeId, Year, Schedule, TaskCodeOption, Status));
                    //var datasource2 = new ReportDataSource("uspFM_From_To_Rpt", GetSPResult("uspFM_From_To_Rpt", Taskcode, Plannerclassification, Typeplanner, Groupby, Preventfromdate, Preventtodate));
                    //var datasource3 = new ReportDataSource("UET_DS_GetAssetGrouping_PPM", GetSPResult("UET_DS_GetAssetGrouping_PPM", Taskcode, Plannerclassification, Typeplanner, Groupby, Preventfromdate, Preventtodate));
                    //var datasource4 = new ReportDataSource("uspFM_GetCustomer_Rpt", GetSPResult("uspFM_GetCustomer_Rpt", Taskcode, Plannerclassification, Typeplanner, Groupby, Preventfromdate, Preventtodate));
                    reportViewer.LocalReport.DataSources.Clear(); 
                   reportViewer.LocalReport.DataSources.Add(datasource);
                    reportViewer.LocalReport.DataSources.Add(datasource1);
                    reportViewer.LocalReport.DataSources.Add(datasource2);
                    reportViewer.LocalReport.DataSources.Add(datasource3);
                    reportViewer.LocalReport.DataSources.Add(datasource4);
                    reportViewer.LocalReport.DataSources.Add(datasource5);
                    reportViewer.LocalReport.DataSources.Add(datasource6);
                    reportViewer.LocalReport.Refresh();
                }
                else
                {
                    reportViewer.Drillthrough += new DrillthroughEventHandler(reportViewer_Drillthrough);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }
        protected void reportViewer_Drillthrough(object sender, DrillthroughEventArgs e)
        {
            ReportParameterInfoCollection DrillThroughValues = e.Report.GetParameters();
            var IP_AssetNo = DrillThroughValues[0].Values[0];
            var IP_TaskCodeOption = DrillThroughValues[1].Values[0];
           

            var TypeCodeId = Request.QueryString["TypeCodeId"];
            var Year = Request.QueryString["Year"];
            var Schedule = Request.QueryString["Schedule"];
            var TaskCodeOption = Request.QueryString["TaskCodeOption"];
            var Status = Request.QueryString["Status"];
            if (Year == "null")
            {
                Year = null;
            }
            if (Schedule == "null")
            {
                Schedule = null;
            }
            if (TaskCodeOption == "null")
            {
                TaskCodeOption = null;
            }
            if (Status == "null")
            {
                Status = null;
            }
            var reportname = e.ReportPath;
            var DatasetName = string.Empty;
            var localreport = (LocalReport)e.Report;

            if (IP_TaskCodeOption == "Manual")
            {
                var datasource1 = new ReportDataSource("UET_PPMchedule_Rpt_Manual_L2", GetSPResult("UET_PPMchedule_Rpt_Manual_L2", TypeCodeId, Year, Schedule, TaskCodeOption, Status, IP_AssetNo, IP_TaskCodeOption));
                localreport.DataSources.Clear();
                localreport.DataSources.Add(datasource1);
            }
            if (IP_TaskCodeOption == "Frequency")
            {
                var datasource = new ReportDataSource("UET_PPMchedule_Rpt_Frequency_L2", GetSPResult("UET_PPMchedule_Rpt_Frequency_L2", TypeCodeId, Year, Schedule, TaskCodeOption, Status, IP_AssetNo, IP_TaskCodeOption));
                localreport.DataSources.Clear();
                localreport.DataSources.Add(datasource);
            }




            // localreport.DataSources.Add(datasource1);
            localreport.Refresh();


            var datasource2 = new ReportDataSource("usp_BEMSAssetRegistration_Rpt_L2", GetSPResult("usp_BEMSAssetRegistration_Rpt_L2", TypeCodeId, Year, Schedule, TaskCodeOption, Status, IP_AssetNo, IP_TaskCodeOption));
            localreport.DataSources.Add(datasource2);
            localreport.Refresh();
        }

        private DataTable GetSPResult(string Spname, string TypeCodeId, string Year, string Schedule, string TaskCodeOption, string Status, string IP_AssetNo = "", string IP_TaskCodeOption="")
        {
            var userDetails = (UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel));
            var ResultsTable = new DataTable();
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ConnectionString))
            {
                try
                {
                    //if (IP_TaskCodeOption == "Manual")
                    //{
                    //    TaskCodeOption = "364";
                    //}
                    //else {
                    //    TaskCodeOption = "365";
                    //}
                    var dbAccessDAL = new DBAccessDAL();
                    using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                    {
                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.Connection = con;
                            cmd.CommandType = CommandType.StoredProcedure;
                            switch (Spname)
                            {
                                case "UET_PPMchedule_Rpt_L1":
                                    //cmd.CommandText = "UET_BemsPlannedPreventiveSchedule_SchedCount_Rpt_L2";
                                    cmd.CommandText = "UET_PPMchedule_Rpt_L1";
                                    cmd.Parameters.AddWithValue("@TypeCodeId", TypeCodeId);
                                    cmd.Parameters.AddWithValue("@FacilityId", userDetails.FacilityId);
                                    cmd.Parameters.AddWithValue("@Year", Year);
                                    cmd.Parameters.AddWithValue("@Schedule", Schedule);
                                    cmd.Parameters.AddWithValue("@TaskCodeOption", TaskCodeOption);
                                    cmd.Parameters.AddWithValue("@Status", Status);
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "Facility_Ds":
                                    cmd.CommandText = "usp_ReportHeaderParamName";
                                    cmd.Parameters.Clear();
                                    cmd.Parameters.AddWithValue("@ParamName", "Facilityid");
                                    cmd.Parameters.AddWithValue("@ParamValue", userDetails.FacilityId);
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "TypeCode_Ds":
                                    cmd.CommandText = "usp_ReportHeaderParamName";
                                    cmd.Parameters.Clear();
                                    cmd.Parameters.AddWithValue("@ParamName", "AssetTypeCodeId");
                                    cmd.Parameters.AddWithValue("@ParamValue", TypeCodeId);
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "Year_Ds":
                                    cmd.CommandText = "usp_ReportHeaderParamName";
                                    cmd.Parameters.Clear();
                                    cmd.Parameters.AddWithValue("@ParamName", "Year");
                                    cmd.Parameters.AddWithValue("@ParamValue", Year);
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "ScheduleType_Ds":
                                    cmd.CommandText = "usp_ReportHeaderParamName";
                                    cmd.Parameters.Clear();
                                    cmd.Parameters.AddWithValue("@ParamName", "ScheduleType");
                                    cmd.Parameters.AddWithValue("@ParamValue", Schedule);
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "TaskCodeOption_Ds":
                                    cmd.CommandText = "usp_ReportHeaderParamName";
                                    cmd.Parameters.Clear();
                                    cmd.Parameters.AddWithValue("@ParamName", "TaskCodeOption");
                                    cmd.Parameters.AddWithValue("@ParamValue", TaskCodeOption);
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "Status_Ds":
                                    cmd.CommandText = "usp_ReportHeaderParamName";
                                    cmd.Parameters.Clear();
                                    cmd.Parameters.AddWithValue("@ParamName", "EngPlannerStatus");
                                    cmd.Parameters.AddWithValue("@ParamValue", Status);
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "UET_PPMchedule_Rpt_Frequency_L2":
                                    //cmd.CommandText = "UET_BemsPlannedPreventiveSchedule_SchedCount_Rpt_L2";
                                    cmd.CommandText = "UET_PPMchedule_Rpt_Frequency_L2";
                                    cmd.Parameters.AddWithValue("@TypeCodeId", TypeCodeId);
                                    cmd.Parameters.AddWithValue("@FacilityId", userDetails.FacilityId);
                                    cmd.Parameters.AddWithValue("@Year", Year);
                                    cmd.Parameters.AddWithValue("@Schedule", Schedule);
                                    cmd.Parameters.AddWithValue("@TaskCodeOption", "365");
                                    cmd.Parameters.AddWithValue("@Status", Status);
                                    cmd.Parameters.AddWithValue("@AssetNo", IP_AssetNo);
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "UET_PPMchedule_Rpt_Manual_L2":
                                    //cmd.CommandText = "UET_BemsPlannedPreventiveSchedule_SchedCount_Rpt_L2";
                                    cmd.CommandText = "UET_PPMchedule_Rpt_Manual_L2";
                                    cmd.Parameters.AddWithValue("@TypeCodeId", TypeCodeId);
                                    cmd.Parameters.AddWithValue("@FacilityId", userDetails.FacilityId);
                                    cmd.Parameters.AddWithValue("@Year", Year);
                                    cmd.Parameters.AddWithValue("@Schedule", Schedule);
                                    cmd.Parameters.AddWithValue("@TaskCodeOption", "364");
                                    cmd.Parameters.AddWithValue("@Status", Status);
                                    cmd.Parameters.AddWithValue("@AssetNo", IP_AssetNo);
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "usp_BEMSAssetRegistration_Rpt_L2":
                                    //cmd.CommandText = "UET_BemsPlannedPreventiveSchedule_SchedCount_Rpt_L2";
                                    cmd.CommandText = "usp_BEMSAssetRegistration_Rpt_L2";
                                    cmd.Parameters.AddWithValue("@Typecode", TypeCodeId);
                                    cmd.Parameters.AddWithValue("@Facility_Id", userDetails.FacilityId);
                                    //cmd.Parameters.AddWithValue("@Year", Year);
                                    //cmd.Parameters.AddWithValue("@Schedule", Schedule);
                                    //cmd.Parameters.AddWithValue("@TaskCodeOption", "364");
                                    //cmd.Parameters.AddWithValue("@Status", Status);
                                    cmd.Parameters.AddWithValue("@AssetNo", IP_AssetNo);
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                            }

                        }
                    }
                }
                catch (Exception ex)
                {
                    throw ex;
                }
                finally
                {
                    if (conn != null)
                    {
                        conn.Close();
                    }
                }
                return ResultsTable;
            }
        }
    }
}