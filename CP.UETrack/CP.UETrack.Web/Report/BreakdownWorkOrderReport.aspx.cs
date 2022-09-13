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
    public partial class BreakdownWorkOrderReport : System.Web.UI.Page
    {
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
      

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    var userDetails = (UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel));
                    var WorkOrderCategoryId = Request.QueryString["WorkOrderCategoryId"];
                    var WorkOrderPriorityId = Request.QueryString["WorkOrderPriorityId"];
                    var WOFromDate = Request.QueryString["WOFromDate"];
                    var WOToDate = Request.QueryString["WOToDate"];
                  
                    reportViewer.Visible = true;
                    reportViewer.ProcessingMode = ProcessingMode.Local;
                    reportViewer.LocalReport.ReportPath = Server.MapPath(Request.ApplicationPath) + @"RdlReports\LatestReportsRDLC\UnscheduledWorkOderReport.rdlc";
                    var datasource = new ReportDataSource("DataSet1", GetSPResult("usp_UnscheduledWorkOderReport", WorkOrderCategoryId, WorkOrderPriorityId, WOFromDate,WOToDate));
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
            var WorkOrderCategoryId = Request.QueryString["WorkOrderCategoryId"];
            var WorkOrderPriorityId = Request.QueryString["WorkOrderPriorityId"];
            var WOFromDate = Request.QueryString["WOFromDate"];
            var WOToDate = Request.QueryString["WOToDate"];
            var reportname = e.ReportPath;

            var localreport = (LocalReport)e.Report;
            var datasource = new ReportDataSource("usp_UnscheduledWorkOderReport_L2_Header", GetSPResult("usp_UnscheduledWorkOderReport_L2_Header", WorkOrderCategoryId, WorkOrderPriorityId, WOFromDate, WOToDate, WorkOrderNo));
            var datasource1 = new ReportDataSource("usp_UnscheduledWorkOderReport_AssessMent", GetSPResult("usp_UnscheduledWorkOderReport_AssessMent", WorkOrderCategoryId, WorkOrderPriorityId, WOFromDate, WOToDate, WorkOrderNo));
            var datasource2 = new ReportDataSource("usp_UnscheduledWorkOderReport_WOReassign", GetSPResult("usp_UnscheduledWorkOderReport_WOReassign", WorkOrderCategoryId, WorkOrderPriorityId, WOFromDate, WOToDate, WorkOrderNo));
            var datasource3 = new ReportDataSource("usp_UnscheduledWorkOderReport_SparePart", GetSPResult("usp_UnscheduledWorkOderReport_SparePart", WorkOrderCategoryId, WorkOrderPriorityId, WOFromDate, WOToDate, WorkOrderNo));
            var datasource4 = new ReportDataSource("usp_MaintenanceWorkReport_Completion", GetSPResult("usp_MaintenanceWorkReport_Completion", WorkOrderCategoryId, WorkOrderPriorityId, WOFromDate, WOToDate, WorkOrderNo));
           

            localreport.DataSources.Clear();
            localreport.DataSources.Add(datasource);
            localreport.DataSources.Add(datasource1);
            localreport.DataSources.Add(datasource2);
            localreport.DataSources.Add(datasource3);
            localreport.DataSources.Add(datasource4);
          
            localreport.Refresh();
        }


        private DataTable GetSPResult(string Spname, string WorkOrderCategoryId, string WorkOrderPriorityId, string WOFromDate, string WOtodate, string WoNo="")
        {
            var userDetails = (UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel));
            var ResultsTable = new DataTable();
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ConnectionString))
            {
                try
                {
                    if (string.IsNullOrEmpty(WorkOrderPriorityId) || WorkOrderPriorityId == "null")
                    {
                        WorkOrderPriorityId = ""; 
                    }
                    if (string.IsNullOrEmpty(WorkOrderCategoryId) || WorkOrderCategoryId == "null")
                    {
                        WorkOrderCategoryId = "";
                    }
                    var dbAccessDAL = new DBAccessDAL();
                    using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                    {
                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.Connection = con;
                            cmd.CommandType = CommandType.StoredProcedure;
                            switch (Spname)
                            {
                                case "usp_UnscheduledWorkOderReport":
                                    cmd.CommandText = "usp_UnscheduledWorkOderReport"; //
                                    cmd.Parameters.AddWithValue("@Level", 1);
                                    cmd.Parameters.AddWithValue("@Facility_Id", userDetails.FacilityId);
                                    cmd.Parameters.AddWithValue("@From_Date", WOFromDate);
                                    cmd.Parameters.AddWithValue("@To_Date", WOtodate);
                                    cmd.Parameters.AddWithValue("@WorkOrderPriority", WorkOrderPriorityId);
                                    cmd.Parameters.AddWithValue("@WorkOrderCategory", WorkOrderCategoryId);
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "usp_UnscheduledWorkOderReport_L2_Header":
                                    cmd.CommandText = "usp_UnscheduledWorkOderReport_L2_Header";
                                    cmd.Parameters.AddWithValue("@Facility_Id", userDetails.FacilityId);
                                    cmd.Parameters.AddWithValue("@From_Date", WOFromDate);
                                    cmd.Parameters.AddWithValue("@To_Date", WOtodate);
                                    cmd.Parameters.AddWithValue("@WorkOrderPriority", WorkOrderPriorityId);
                                    cmd.Parameters.AddWithValue("@WorkOrderCategory", WorkOrderCategoryId);
                                    cmd.Parameters.AddWithValue("@MaintenanceWorkNo", WoNo);
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "usp_UnscheduledWorkOderReport_AssessMent":
                                    cmd.CommandText = "usp_UnscheduledWorkOderReport_AssessMent";
                                    cmd.Parameters.AddWithValue("@Facility_Id", userDetails.FacilityId);
                                    cmd.Parameters.AddWithValue("@From_Date", WOFromDate);
                                    cmd.Parameters.AddWithValue("@To_Date", WOtodate);
                                    cmd.Parameters.AddWithValue("@WorkOrderPriority", WorkOrderPriorityId);
                                    cmd.Parameters.AddWithValue("@WorkOrderCategory", WorkOrderCategoryId);
                                    cmd.Parameters.AddWithValue("@MaintenanceWorkNo", WoNo);
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "usp_UnscheduledWorkOderReport_WOReassign":
                                    cmd.CommandText = "usp_UnscheduledWorkOderReport_WOReassign";
                                    cmd.Parameters.AddWithValue("@Facility_Id", userDetails.FacilityId);
                                    cmd.Parameters.AddWithValue("@From_Date", WOFromDate);
                                    cmd.Parameters.AddWithValue("@To_Date", WOtodate);
                                    cmd.Parameters.AddWithValue("@WorkOrderPriority", WorkOrderPriorityId);
                                    cmd.Parameters.AddWithValue("@WorkOrderCategory", WorkOrderCategoryId);
                                    cmd.Parameters.AddWithValue("@MaintenanceWorkNo", WoNo);
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "usp_UnscheduledWorkOderReport_SparePart":
                                    cmd.CommandText = "usp_UnscheduledWorkOderReport_SparePart";
                                    cmd.Parameters.AddWithValue("@Facility_Id", userDetails.FacilityId);
                                    cmd.Parameters.AddWithValue("@From_Date", WOFromDate);
                                    cmd.Parameters.AddWithValue("@To_Date", WOtodate);
                                    cmd.Parameters.AddWithValue("@WorkOrderPriority", WorkOrderPriorityId);
                                    cmd.Parameters.AddWithValue("@WorkOrderCategory", WorkOrderCategoryId);
                                    cmd.Parameters.AddWithValue("@MaintenanceWorkNo", WoNo);
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "usp_MaintenanceWorkReport_Completion":
                                    cmd.CommandText = "usp_MaintenanceWorkReport_Completion";
                                    cmd.Parameters.AddWithValue("@Facility_Id", userDetails.FacilityId);
                                    //cmd.Parameters.AddWithValue("@MaintenanceType", MaintainanceType);
                                    //cmd.Parameters.AddWithValue("@ContractType", ContractTypeId);
                                    //cmd.Parameters.AddWithValue("@From_Date", WOfromdate);
                                    //cmd.Parameters.AddWithValue("@To_Date", WOTodate);
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
    