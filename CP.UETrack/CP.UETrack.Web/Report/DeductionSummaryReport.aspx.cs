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
    public partial class DeductionSummaryReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    var FromMonth = Request.QueryString["DedSummaryFromMonth"];
                    var ToMonth = Request.QueryString["DedSummaryToMonth"];
                    var Year = Request.QueryString["DedSummaryYear"];

                    reportViewer.Visible = true;
                    reportViewer.ProcessingMode = ProcessingMode.Local;
                    reportViewer.LocalReport.ReportPath = Server.MapPath(Request.ApplicationPath) + @"RdlReports\LatestReportsRDLC\AssetRegistrationHistoryRpt_Condition.rdlc";
                    var datasource = new ReportDataSource("uspFM_Deduction_SummaryReport", GetSPResult("uspFM_Deduction_SummaryReport", FromMonth, ToMonth, Year));                    
                    reportViewer.LocalReport.DataSources.Add(datasource);                    
                    reportViewer.LocalReport.Refresh();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }


        private DataTable GetSPResult(string Spname, string FromMonth,string ToMonth,string Year)
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
                                case "uspFM_Deduction_SummaryReport":
                                    cmd.CommandText = "uspFM_Deduction_SummaryReport";
                                    cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);
                                    cmd.Parameters.AddWithValue("@pFrommonth", FromMonth);
                                    cmd.Parameters.AddWithValue("@pTomonth", ToMonth);
                                    cmd.Parameters.AddWithValue("@pYear", Year);                                    
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