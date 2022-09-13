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

    public partial class QAPPerformanceIndicatorSummary : System.Web.UI.Page
    {
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {

                    var FromMonth = Request.QueryString["FromMonth"];
                    var FromYear = Request.QueryString["FromYear"];
                    var ToYear = Request.QueryString["ToYear"];
                    var Tomonth = Request.QueryString["Tomonth"];
                    var IndicatorId = Request.QueryString["IndicatorId"];

                    if (FromYear == "null") FromYear = null;
                    if (FromMonth == "null") FromMonth = null;
                    if (ToYear == "null") ToYear = null;
                    if (Tomonth == "null") Tomonth = null;
                    if (IndicatorId == "null") IndicatorId = null;
                    // var dt = GetSPResult(Assetfromdate, AssetTodate);
                    reportViewer.Visible = true;
                    reportViewer.ProcessingMode = ProcessingMode.Local;
                    reportViewer.LocalReport.ReportPath = Server.MapPath(Request.ApplicationPath) + @"RdlReports\LatestReportsRDLC\QAPPerformanceIndicatorSummary.rdlc";
                    var datasource = new ReportDataSource("usp_QAPPerformanceIndicatorSummary", GetSPResult("usp_QAPPerformanceIndicatorSummary", FromYear, ToYear, FromMonth, Tomonth, IndicatorId));
                    var datasource1 = new ReportDataSource(nameof(FromYear), GetSPResult(nameof(FromYear), FromYear, ToYear, FromMonth, Tomonth, IndicatorId));
                    var datasource2 = new ReportDataSource(nameof(FromMonth), GetSPResult(nameof(FromMonth), FromYear, ToYear, FromMonth, Tomonth, IndicatorId));
                    var datasource3 = new ReportDataSource(nameof(ToYear), GetSPResult(nameof(ToYear), FromYear, ToYear, FromMonth, Tomonth, IndicatorId));
                    var datasource4 = new ReportDataSource("ToMonth", GetSPResult("ToMonth", FromYear, ToYear, FromMonth, Tomonth, IndicatorId));
                    var datasource5 = new ReportDataSource("Indicator", GetSPResult("IndicatorId", FromYear, ToYear, FromMonth, Tomonth, IndicatorId));
                    reportViewer.LocalReport.DataSources.Clear(); 
                    reportViewer.LocalReport.DataSources.Add(datasource);
                    reportViewer.LocalReport.DataSources.Add(datasource1);
                    reportViewer.LocalReport.DataSources.Add(datasource2);
                    reportViewer.LocalReport.DataSources.Add(datasource3);
                    reportViewer.LocalReport.DataSources.Add(datasource4);
                    reportViewer.LocalReport.DataSources.Add(datasource5);
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
            var ParameterName = DrillThroughValues[0].Values[0];
            var FromMonth = Request.QueryString["FromMonth"];
            var FromYear = Request.QueryString["FromYear"];
            var ToYear = Request.QueryString["ToYear"];
            var Tomonth = Request.QueryString["Tomonth"];
            var IndicatorId = Request.QueryString["IndicatorId"];
            if (FromYear == "null") FromYear = null;
            if (FromMonth == "null") FromMonth = null;
            if (ToYear == "null") ToYear = null;
            if (Tomonth == "null") Tomonth = null;
            if (IndicatorId == "null") IndicatorId = null;


            var reportname = e.ReportPath;
            var DatasetName = string.Empty;
            var localreport = (LocalReport)e.Report;
            var datasource = new ReportDataSource("usp_QAPPerformanceIndicatorSummary_L2", GetSPResult("usp_QAPPerformanceIndicatorSummary_L2", FromYear, ToYear, FromMonth, Tomonth, IndicatorId, ParameterName));
            localreport.DataSources.Clear();
            localreport.DataSources.Add(datasource);
            localreport.Refresh();


            var datasource1 = new ReportDataSource("usp_QAPPerformanceIndicatorSummary_L3", GetSPResult("usp_QAPPerformanceIndicatorSummary_L3", FromYear, ToYear, FromMonth, Tomonth, IndicatorId, ParameterName));
            localreport.DataSources.Add(datasource1);
            localreport.Refresh();

           
        }

        private DataTable GetSPResult(string Spname, string FromYear, string ToYear, string FromMonth, string Tomonth, string IndicatorId, string ParameterName= "")
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
                                case "usp_QAPPerformanceIndicatorSummary":
                                    cmd.CommandText = "usp_QAPPerformanceIndicatorSummary";
                                    cmd.Parameters.AddWithValue("@FacilityId", userDetails.FacilityId);
                                    cmd.Parameters.AddWithValue("@FromYear", FromYear);
                                    cmd.Parameters.AddWithValue("@ToYear", ToYear);
                                    cmd.Parameters.AddWithValue("@FromMonth", FromMonth);
                                    cmd.Parameters.AddWithValue("@Tomonth", Tomonth);
                                    cmd.Parameters.AddWithValue("@Indicator", IndicatorId);
                                    cmd.Parameters.AddWithValue("@Level", 1);

                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case nameof(FromYear):
                                    cmd.CommandText = "usp_ReportHeaderParamName";
                                    cmd.Parameters.Clear();
                                    cmd.Parameters.AddWithValue("@ParamName", "Year");
                                    cmd.Parameters.AddWithValue("@ParamValue", FromYear);
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case nameof(ToYear):
                                    cmd.CommandText = "usp_ReportHeaderParamName";
                                    cmd.Parameters.Clear();
                                    cmd.Parameters.AddWithValue("@ParamName", "Year");
                                    cmd.Parameters.AddWithValue("@ParamValue", ToYear);
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case nameof(FromMonth):
                                    cmd.CommandText = "usp_ReportHeaderParamName";
                                    cmd.Parameters.Clear();
                                    cmd.Parameters.AddWithValue("@ParamName", "Month");
                                    cmd.Parameters.AddWithValue("@ParamValue", FromMonth);
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "ToMonth":
                                    cmd.CommandText = "usp_ReportHeaderParamName";
                                    cmd.Parameters.Clear();
                                    cmd.Parameters.AddWithValue("@ParamName", "Month");
                                    cmd.Parameters.AddWithValue("@ParamValue", Tomonth);
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "IndicatorId":
                                    cmd.CommandText = "usp_ReportHeaderParamName";
                                    cmd.Parameters.Clear();
                                    cmd.Parameters.AddWithValue("@ParamName", "Indicator");
                                    cmd.Parameters.AddWithValue("@ParamValue", IndicatorId);
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;

                                case "usp_QAPPerformanceIndicatorSummary_L2":
                                    cmd.CommandText = "usp_QAPPerformanceIndicatorSummary_L2";
                                    cmd.Parameters.AddWithValue("@FacilityId", userDetails.FacilityId);
                                    cmd.Parameters.AddWithValue("@FromYear", FromYear);
                                    cmd.Parameters.AddWithValue("@ToYear", ToYear);
                                    cmd.Parameters.AddWithValue("@FromMonth", FromMonth);
                                    cmd.Parameters.AddWithValue("@Tomonth", Tomonth);
                                    cmd.Parameters.AddWithValue("@Indicator", IndicatorId);
                                    cmd.Parameters.AddWithValue("@Level", 1);
                                  
                                    
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "usp_QAPPerformanceIndicatorSummary_L3":
                                    cmd.CommandText = "usp_QAPPerformanceIndicatorSummary_L3";
                                    cmd.Parameters.AddWithValue("@FacilityId", userDetails.FacilityId);
                                    cmd.Parameters.AddWithValue("@FromYear", FromYear);
                                    cmd.Parameters.AddWithValue("@ToYear", ToYear);
                                    cmd.Parameters.AddWithValue("@FromMonth", FromMonth);
                                    cmd.Parameters.AddWithValue("@Tomonth", Tomonth);
                                    cmd.Parameters.AddWithValue("@Indicator", IndicatorId);
                                    cmd.Parameters.AddWithValue("@Level", 1);
                                    cmd.Parameters.AddWithValue("@CARNumber", ParameterName);
                                    
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
