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
    public partial class WorkOrderReport : System.Web.UI.Page
    {
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    var WOfromdate = Request.QueryString["WOFromDate"];
                    var WOTodate = Request.QueryString["WOToDate"];
                    var MaintainanceType = Request.QueryString["MaintainanceType"];
                    var ContractTypeId = Request.QueryString["ContractTypeId"];
                    reportViewer.Visible = true;
                    reportViewer.ProcessingMode = ProcessingMode.Local; 
                    reportViewer.LocalReport.ReportPath = Server.MapPath(Request.ApplicationPath) + @"RdlReports\LatestReportsRDLC\ScheduledWorkOrderReport.rdlc";                   
                    var datasource = new ReportDataSource("DataSet1", GetSPResult("usp_MaintenanceWorkReport", WOfromdate, WOTodate, MaintainanceType, ContractTypeId));
                    reportViewer.LocalReport.DataSources.Clear(); 
                    reportViewer.LocalReport.DataSources.Add(datasource); 
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
            var DrillThroughValues = e.Report.GetParameters();
            var WorkOrderNo = DrillThroughValues[0].Values[0];
            var WOfromdate = Request.QueryString["WOFromDate"];
            var WOTodate = Request.QueryString["WOToDate"];
            var MaintainanceType = Request.QueryString["MaintainanceType"];
            var ContractTypeId = Request.QueryString["ContractTypeId"];
            var reportname = e.ReportPath;        

            var localreport = (LocalReport)e.Report;
            var datasource = new ReportDataSource("usp_MaintenanceWorkReport_PPMCheckList", GetSPResult("usp_MaintenanceWorkReport_PPMCheckList", WOfromdate, WOTodate, MaintainanceType, ContractTypeId, WorkOrderNo));
            var datasource1 = new ReportDataSource("usp_MaintenanceWorkReport_WOReSchedule", GetSPResult("usp_MaintenanceWorkReport_WOReSchedule", WOfromdate, WOTodate, MaintainanceType, ContractTypeId, WorkOrderNo));
            var datasource2 = new ReportDataSource("usp_MaintenanceWorkReport_WOReassign", GetSPResult("usp_MaintenanceWorkReport_WOReassign", WOfromdate, WOTodate, MaintainanceType, ContractTypeId, WorkOrderNo));
            var datasource3 = new ReportDataSource("usp_MaintenanceWorkReport_PartReplacement", GetSPResult("usp_MaintenanceWorkReport_PartReplacement", WOfromdate, WOTodate, MaintainanceType, ContractTypeId, WorkOrderNo));
            var datasource4 = new ReportDataSource("usp_MaintenanceWorkReport_L2_D1", GetSPResult("usp_MaintenanceWorkReport_L2_D1", WOfromdate, WOTodate, MaintainanceType, ContractTypeId, WorkOrderNo));
            var datasource5 = new ReportDataSource("usp_MaintenanceWorkReport_Completion", GetSPResult("usp_MaintenanceWorkReport_Completion", WOfromdate, WOTodate, MaintainanceType, ContractTypeId, WorkOrderNo));
         
            localreport.DataSources.Clear();
            localreport.DataSources.Add(datasource);
            localreport.DataSources.Add(datasource1);
            localreport.DataSources.Add(datasource2);
            localreport.DataSources.Add(datasource3);
            localreport.DataSources.Add(datasource4);
            localreport.DataSources.Add(datasource5);
            localreport.Refresh();
        }

        private DataTable GetSPResult(string Spname,string WOfromdate, string WOTodate, string MaintainanceType, string ContractTypeId, string WoNo="")
        {
            var userDetails = (UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel));
            var ResultsTable = new DataTable();
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ConnectionString))
            {
                try
                {
                    var dbAccessDAL = new DBAccessDAL();
                    using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                    {
                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.Connection = con;
                            cmd.CommandType = CommandType.StoredProcedure;
                            switch (Spname)
                            {
                                case "usp_MaintenanceWorkReport":
                                    cmd.CommandText = "usp_MaintenanceWorkReport";
                                    cmd.Parameters.AddWithValue("@Facility_Id", userDetails.FacilityId);
                                    cmd.Parameters.AddWithValue("@MaintenanceType", MaintainanceType);
                                    cmd.Parameters.AddWithValue("@ContractType", ContractTypeId);
                                    cmd.Parameters.AddWithValue("@From_Date", WOfromdate);
                                    cmd.Parameters.AddWithValue("@To_Date", WOTodate);                                   
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "usp_MaintenanceWorkReport_L2_D1":
                                    cmd.CommandText = "usp_MaintenanceWorkReport_L2_D1";
                                    cmd.Parameters.AddWithValue("@Facility_Id", userDetails.FacilityId);
                                    cmd.Parameters.AddWithValue("@MaintenanceType", MaintainanceType);
                                    cmd.Parameters.AddWithValue("@ContractType", ContractTypeId);
                                    cmd.Parameters.AddWithValue("@From_Date", WOfromdate);
                                    cmd.Parameters.AddWithValue("@To_Date", WOTodate);
                                    cmd.Parameters.AddWithValue("@MaintenanceWorkNo", WoNo);
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "usp_MaintenanceWorkReport_PPMCheckList":
                                    cmd.CommandText = "usp_MaintenanceWorkReport_PPMCheckList";
                                    cmd.Parameters.AddWithValue("@Facility_Id", userDetails.FacilityId);
                                    cmd.Parameters.AddWithValue("@MaintenanceType", MaintainanceType);
                                    cmd.Parameters.AddWithValue("@ContractType", ContractTypeId);
                                    cmd.Parameters.AddWithValue("@From_Date", WOfromdate);
                                    cmd.Parameters.AddWithValue("@To_Date", WOTodate);
                                    cmd.Parameters.AddWithValue("@MaintenanceWorkNo", WoNo);
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "usp_MaintenanceWorkReport_WOReSchedule":
                                    cmd.CommandText = "usp_MaintenanceWorkReport_WOReSchedule";
                                    cmd.Parameters.AddWithValue("@Facility_Id", userDetails.FacilityId);
                                    cmd.Parameters.AddWithValue("@MaintenanceType", MaintainanceType);
                                    cmd.Parameters.AddWithValue("@ContractType", ContractTypeId);
                                    cmd.Parameters.AddWithValue("@From_Date", WOfromdate);
                                    cmd.Parameters.AddWithValue("@To_Date", WOTodate);
                                    cmd.Parameters.AddWithValue("@MaintenanceWorkNo", WoNo);
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "usp_MaintenanceWorkReport_WOReassign":
                                    cmd.CommandText = "usp_MaintenanceWorkReport_WOReassign";
                                    cmd.Parameters.AddWithValue("@Facility_Id", userDetails.FacilityId);
                                    cmd.Parameters.AddWithValue("@MaintenanceType", MaintainanceType);
                                    cmd.Parameters.AddWithValue("@ContractType", ContractTypeId);
                                    cmd.Parameters.AddWithValue("@From_Date", WOfromdate);
                                    cmd.Parameters.AddWithValue("@To_Date", WOTodate);
                                    cmd.Parameters.AddWithValue("@MaintenanceWorkNo", WoNo);
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "usp_MaintenanceWorkReport_PartReplacement":
                                    cmd.CommandText = "usp_MaintenanceWorkReport_PartReplacement";
                                    cmd.Parameters.AddWithValue("@Facility_Id", userDetails.FacilityId);
                                    cmd.Parameters.AddWithValue("@MaintenanceType", MaintainanceType);
                                    cmd.Parameters.AddWithValue("@ContractType", ContractTypeId);
                                    cmd.Parameters.AddWithValue("@From_Date", WOfromdate);
                                    cmd.Parameters.AddWithValue("@To_Date", WOTodate);
                                    cmd.Parameters.AddWithValue("@MaintenanceWorkNo", WoNo);
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "usp_MaintenanceWorkReport_Completion":
                                    cmd.CommandText = "usp_MaintenanceWorkReport_Completion";
                                    cmd.Parameters.AddWithValue("@Facility_Id", userDetails.FacilityId);
                                    cmd.Parameters.AddWithValue("@MaintenanceType", MaintainanceType);
                                    cmd.Parameters.AddWithValue("@ContractType", ContractTypeId);
                                    cmd.Parameters.AddWithValue("@From_Date", WOfromdate);
                                    cmd.Parameters.AddWithValue("@To_Date", WOTodate);
                                    cmd.Parameters.AddWithValue("@MaintenanceWorkNo", WoNo);
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