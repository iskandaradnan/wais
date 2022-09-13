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
    public partial class PPMScheduleGenerationReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    var PPMWorkorderId = Request.QueryString["PPMScheduleWorkOrderId"];
                                      
                    reportViewer.Visible = true;
                    reportViewer.ProcessingMode = ProcessingMode.Local;
                    reportViewer.LocalReport.ReportPath = Server.MapPath(Request.ApplicationPath) + @"RdlReports\LatestReportsRDLC\PPM_Schedule_Generation_Print_Form.rdlc";
                    var datasource = new ReportDataSource("uspFM_PPMScheduleGeneration_Rpt", GetSPResult("uspFM_PPMScheduleGeneration_Rpt", PPMWorkorderId));
                    var datasource1 = new ReportDataSource("uspFMEmployeeDetails_PPMASIS", GetSPResult("uspFMEmployeeDetails_PPMASIS", PPMWorkorderId));
                    var datasource2 = new ReportDataSource("uspPartsDetails_PPMASIS", GetSPResult("uspPartsDetails_PPMASIS", PPMWorkorderId));
                    var datasource3 = new ReportDataSource("EquipmentAuditAssessmentChecklist_Rpt", GetSPResult("uspEquipmentAuditAssessmentChecklist_Rpt", PPMWorkorderId));

                    reportViewer.LocalReport.DataSources.Add(datasource); 
                    reportViewer.LocalReport.DataSources.Add(datasource1); 
                    reportViewer.LocalReport.DataSources.Add(datasource2);
                    reportViewer.LocalReport.DataSources.Add(datasource3);

                    reportViewer.LocalReport.Refresh();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }


        private DataTable GetSPResult(string Spname, string PPMWorkorderId)
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
                                case "uspFM_PPMScheduleGeneration_Rpt":
                                    cmd.CommandText = "uspFM_PPMScheduleGeneration_Rpt"; 
                                    cmd.Parameters.AddWithValue("@WorkOrderid", PPMWorkorderId);                                    
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "uspFMEmployeeDetails_PPMASIS":
                                    cmd.CommandText = "uspFMEmployeeDetails_PPMASIS"; 
                                    cmd.Parameters.Clear();
                                    cmd.Parameters.AddWithValue("@WorkOrderId", PPMWorkorderId);                                    
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "uspPartsDetails_PPMASIS":
                                    cmd.CommandText = "uspPartsDetails_PPMASIS";   
                                    cmd.Parameters.Clear();
                                    cmd.Parameters.AddWithValue("@WorkOrderId", PPMWorkorderId);
                                    
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "uspEquipmentAuditAssessmentChecklist_Rpt":
                                    cmd.CommandText = "uspEquipmentAuditAssessmentChecklist_Rpt";   
                                    cmd.Parameters.Clear();
                                    cmd.Parameters.AddWithValue("@WorkOrderid", PPMWorkorderId);                                    
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