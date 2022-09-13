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
    public partial class WorkOrderPrintReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    var Workorderid = Request.QueryString["PrintWorkOrderId"];                    
                   
                    reportViewer.Visible = true;
                    reportViewer.ProcessingMode = ProcessingMode.Local;
                    reportViewer.LocalReport.ReportPath = Server.MapPath(Request.ApplicationPath) + @"RdlReports\LatestReportsRDLC\WorkOrderScheduled_Rpt.rdlc";
                    var datasource = new ReportDataSource("WorkOrderScheduled_Rpt", GetSPResult("WorkOrderScheduled_Rpt", Workorderid));
                    var datasource1 = new ReportDataSource("EmployeeDetails", GetSPResult("uspFMEmployeeDetails_PPMASIS", Workorderid));
                    var datasource2 = new ReportDataSource("PartsDetails", GetSPResult("uspPartsDetails_PPMASIS", Workorderid));
                    
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


        private DataTable GetSPResult(string Spname,string Workorderid)
        {
            UserDetailsModel _UserSession = new SessionHelper().UserSession();
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
                                case "WorkOrderScheduled_Rpt":
                                    cmd.CommandText = "WorkOrderScheduled_Rpt";
                                    cmd.Parameters.AddWithValue("@WorkOrderId", Workorderid);                                    
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "uspFMEmployeeDetails_PPMASIS":
                                    cmd.CommandText = "uspFMEmployeeDetails_PPMASIS";
                                    cmd.Parameters.Clear();
                                    cmd.Parameters.AddWithValue("@WorkOrderId", Workorderid);                                    
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "uspPartsDetails_PPMASIS":
                                    cmd.CommandText = "uspPartsDetails_PPMASIS";
                                    cmd.Parameters.Clear();
                                    cmd.Parameters.AddWithValue("@WorkOrderId", Workorderid);                                    
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