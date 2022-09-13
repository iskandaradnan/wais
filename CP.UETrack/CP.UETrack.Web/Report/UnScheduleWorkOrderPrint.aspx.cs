using CP.Framework.Common.StateManagement;
using CP.UETrack.DAL.DataAccess;
using CP.UETrack.Model;
using Microsoft.Reporting.WebForms;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using UETrack.DAL;

namespace UETrack.Application.Web.Report
{
    public partial class UnScheduleWorkOrderPrint : System.Web.UI.Page
    {
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    var CurrentDate = DateTime.Today.ToString("dd_MMM_yyyy");
                    var userDetails = (UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel));
                    var Workorderid = Request.QueryString["UnScheduleWorkorderId"];

                    reportViewer.Visible = true;
                    reportViewer.ProcessingMode = ProcessingMode.Local;
                    reportViewer.LocalReport.ReportPath = Server.MapPath(Request.ApplicationPath) + @"RdlReports\LatestReportsRDLC\UnSchedule_Work_Order_Print.rdlc";
                    var datasource = new ReportDataSource("DataSet1", GetSPResult("UspFM_EngMaintenanceWorkOrderTxn_UnScheduled_Print", Workorderid));
                    var datasource1 = new ReportDataSource("DataSet2", GetSPResult("UspFM_EngMaintenanceWorkOrderTxn_UnScheduledPartDetails_Print", Workorderid));
                    var datasource2 = new ReportDataSource("DataSet3", GetSPResult("UspFM_EngMaintenanceWorkOrderTxn_UnScheduledEmployeeDetails_Print", Workorderid));
                    reportViewer.LocalReport.DataSources.Add(datasource);
                    reportViewer.LocalReport.DataSources.Add(datasource1);
                    reportViewer.LocalReport.DataSources.Add(datasource2);
                    reportViewer.LocalReport.Refresh();
                    reportViewer.LocalReport.DisplayName = "UnSchedule_Work_Order_" + CurrentDate;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }


        private DataTable GetSPResult(string Spname, string Workorderid)
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
                                case "UspFM_EngMaintenanceWorkOrderTxn_UnScheduled_Print":
                                    cmd.CommandText = "UspFM_EngMaintenanceWorkOrderTxn_UnScheduled_Print"; //
                                    cmd.Parameters.AddWithValue("@pWorkOrderId", Workorderid);
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "UspFM_EngMaintenanceWorkOrderTxn_UnScheduledPartDetails_Print":
                                    cmd.CommandText = "UspFM_EngMaintenanceWorkOrderTxn_UnScheduledPartDetails_Print"; //
                                    cmd.Parameters.AddWithValue("@pWorkOrderId", Workorderid);
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;

                                case "UspFM_EngMaintenanceWorkOrderTxn_UnScheduledEmployeeDetails_Print":
                                    cmd.CommandText = "UspFM_EngMaintenanceWorkOrderTxn_UnScheduledEmployeeDetails_Print"; //
                                    cmd.Parameters.AddWithValue("@pWorkOrderId", Workorderid);
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