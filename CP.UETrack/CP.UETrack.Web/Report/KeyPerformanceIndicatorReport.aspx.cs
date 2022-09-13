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
    public partial class KeyPerformanceIndicatorReport : System.Web.UI.Page
    {
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    var FromYear = Request.QueryString["FromYear"];
                    var ToYear = Request.QueryString["ToYear"];
                    var TypecodeId = Request.QueryString["Typecode"];
                    reportViewer.Visible = true;
                    reportViewer.ProcessingMode = ProcessingMode.Local;
                    reportViewer.LocalReport.ReportPath = Server.MapPath(Request.ApplicationPath) + @"RdlReports\LatestReportsRDLC\KeyPerformanceIndicatorReport_L1.rdlc";
                    var datasource = new ReportDataSource("uspFM_KeyPerformanceIndicatorReport_L1_Rpt", GetSPResult("uspFM_KeyPerformanceIndicatorReport_L1_Rpt", FromYear, ToYear, TypecodeId));
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
                throw new Exception("some reason to rethrow", ex);
            }

        }
        protected void reportViewer_Drillthrough(object sender, DrillthroughEventArgs e)
        {
            ReportParameterInfoCollection DrillThroughValues = e.Report.GetParameters();
            var Typecode = DrillThroughValues[0].Values[0];
            var FromYear = Request.QueryString["FromYear"];
            var ToYear = Request.QueryString["ToYear"];
            var TypecodeId = Request.QueryString["Typecode"];
            var reportname = e.ReportPath;
            var DatasetName = string.Empty;
            var localreport = (LocalReport)e.Report;
            var datasource = new ReportDataSource("uspFM_KeyPerformanceIndicatorReport_L2_Rpt", GetSPResult("uspFM_KeyPerformanceIndicatorReport_L2_Rpt", FromYear, ToYear, TypecodeId));
            localreport.DataSources.Clear();
            localreport.DataSources.Add(datasource);
            localreport.Refresh();
        }

        private DataTable GetSPResult(string Spname, string FromYear, string ToYear, string TypecodeId)
        {
            var userDetails = (UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel));
            var _UserSession = new SessionHelper().UserSession();
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
                                case "uspFM_KeyPerformanceIndicatorReport_L1_Rpt":
                                    cmd.CommandText = "uspFM_KeyPerformanceIndicatorReport_L1_Rpt";
                                    cmd.Parameters.AddWithValue("@FacilityId", userDetails.FacilityId);
                                    cmd.Parameters.AddWithValue("@FromYear", FromYear);
                                    cmd.Parameters.AddWithValue("@ToYear", ToYear);
                                    cmd.Parameters.AddWithValue("@TypecodeId", TypecodeId);
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "uspFM_KeyPerformanceIndicatorReport_L2_Rpt":
                                    cmd.CommandText = "uspFM_KeyPerformanceIndicatorReport_L2_Rpt";
                                    cmd.Parameters.AddWithValue("@FacilityId", userDetails.FacilityId);
                                    cmd.Parameters.AddWithValue("@FromYear", FromYear);
                                    cmd.Parameters.AddWithValue("@ToYear", ToYear);
                                    cmd.Parameters.AddWithValue("@TypecodeId", TypecodeId);
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
                    throw new Exception("some reason to rethrow", ex);
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