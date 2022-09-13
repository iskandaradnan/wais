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
    public partial class OthersPlannerReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    var WorkGroupId = Request.QueryString["OtherWorkGroupId"];
                    var year = Request.QueryString["OtherYear"];
                    var plannerType= Request.QueryString["OtherTypePlanner"];

                    reportViewer.Visible = true;
                    reportViewer.ProcessingMode = ProcessingMode.Local;
                    reportViewer.LocalReport.ReportPath = Server.MapPath(Request.ApplicationPath) + @"RdlReports\LatestReportsRDLC\Planner_Others_Advisory.rdlc";
                    var datasource = new ReportDataSource("uspFM_EngPlanner_Other_Summary_Rpt", GetSPResult("uspFM_EngPlanner_Other_Summary_Rpt", WorkGroupId, year, plannerType));
                    reportViewer.LocalReport.DataSources.Add(datasource); 
                    reportViewer.LocalReport.Refresh();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }


        private DataTable GetSPResult(string Spname, string WorkGroupId, string year,string plannerType)
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
                            cmd.CommandText = Spname;
                            cmd.Parameters.AddWithValue("@pServiceId", 2);
                            cmd.Parameters.AddWithValue("@pFacilityId", 2);
                            cmd.Parameters.AddWithValue("@pWorkGroupid", WorkGroupId);
                            cmd.Parameters.AddWithValue("@pYear", year); 
                            cmd.Parameters.AddWithValue("@pTypeOfPlanner", plannerType);                         

                            using (var adapter = new SqlDataAdapter(cmd))
                            {
                                adapter.Fill(ResultsTable);
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