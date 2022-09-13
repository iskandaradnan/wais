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
    public partial class ServiceWorkReport : System.Web.UI.Page
    {
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    var Servicefromdate = Request.QueryString["ServiceFromDate"];
                    var ServiceTodate = Request.QueryString["ServiceToDate"];
                    var Status= Request.QueryString["ServiceStatus"];

                    reportViewer.Visible = true;
                    reportViewer.ProcessingMode = ProcessingMode.Local;
                    reportViewer.LocalReport.ReportPath = Server.MapPath(Request.ApplicationPath) + @"RdlReports\LatestReportsRDLC\BEMS_Service_WO_Rpt.rdlc";
                    var datasource = new ReportDataSource("uspFM_EngMaintenanceWorkOrderTxn_ServiceWork_Rpt", GetSPResult("uspFM_EngMaintenanceWorkOrderTxn_ServiceWork_Rpt", Servicefromdate, ServiceTodate, Status));
                    var datasource1 = new ReportDataSource("uspFM_From_To_Rpt", GetSPResult("uspFM_From_To_Rpt", Servicefromdate, ServiceTodate, Status));
                    var datasource2 = new ReportDataSource("uspFM_GetCustomer_Rpt", GetSPResult("uspFM_GetCustomer_Rpt", Servicefromdate, ServiceTodate, Status));
                    
                    reportViewer.LocalReport.DataSources.Add(datasource);
                    reportViewer.LocalReport.DataSources.Add(datasource1);
                    reportViewer.LocalReport.DataSources.Add(datasource2);                    
                    reportViewer.LocalReport.Refresh();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }


        private DataTable GetSPResult(string Spname, string Servicefromdate, string ServiceTodate,string Status)
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
                                case "uspFM_EngMaintenanceWorkOrderTxn_ServiceWork_Rpt":
                                    cmd.CommandText = "uspFM_EngMaintenanceWorkOrderTxn_ServiceWork_Rpt";                                  
                                    cmd.Parameters.AddWithValue("@Facility_Id", userDetails.FacilityId);
                                    cmd.Parameters.AddWithValue("@From_Date", Servicefromdate);
                                    cmd.Parameters.AddWithValue("@To_Date", ServiceTodate);
                                    cmd.Parameters.AddWithValue("@Status", Status);
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "uspFM_From_To_Rpt":
                                    cmd.CommandText = "uspFM_From_To_Rpt";
                                    cmd.Parameters.Clear();
                                    cmd.Parameters.AddWithValue("@From_Date", Servicefromdate);
                                    cmd.Parameters.AddWithValue("@To_Date", ServiceTodate);
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "uspFM_GetCustomer_Rpt":
                                    cmd.CommandText = "uspFM_GetCustomer_Rpt";
                                    cmd.Parameters.Clear();
                                    cmd.Parameters.AddWithValue("@Facility_Id", userDetails.FacilityId);
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