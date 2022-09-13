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
    public partial class PerformanceMonitoringReport : System.Web.UI.Page
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
                    // var dt = GetSPResult(Assetfromdate, AssetTodate);
                    reportViewer.Visible = true;
                    reportViewer.ProcessingMode = ProcessingMode.Local;
                    reportViewer.LocalReport.ReportPath = Server.MapPath(Request.ApplicationPath) + @"RdlReports\LatestReportsRDLC\PerformanceMonitoringReport.rdlc";
                    var datasource = new ReportDataSource("DataSet1", GetSPResult("uspBEMS_PerformanceMonitoringReport", FromYear, ToYear, TypecodeId));
                    var datasource1 = new ReportDataSource("FromYear", GetSPResult("FromYear", FromYear, ToYear, TypecodeId));
                    var datasource2 = new ReportDataSource("ToYear", GetSPResult("ToYear", FromYear, ToYear, TypecodeId));
                    var datasource3 = new ReportDataSource("usp_ReportHeaderParamName_AssetTypeCodeCode", GetSPResult("usp_ReportHeaderParamName_AssetTypeCodeCode", FromYear, ToYear, TypecodeId));
                    reportViewer.LocalReport.DataSources.Add(datasource);
                    reportViewer.LocalReport.DataSources.Add(datasource1);
                    reportViewer.LocalReport.DataSources.Add(datasource2);
                    reportViewer.LocalReport.DataSources.Add(datasource3);
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
            var AssetsMeetingtype = DrillThroughValues[0].Values[0];
           // var AssetsMeetingtype = DrillThroughValues[1].Values[0];
            var FromYear = Request.QueryString["FromYear"];
            var ToYear = Request.QueryString["ToYear"];
            var TypecodeId = Request.QueryString["Typecode"];
            var reportname = e.ReportPath;
            var DatasetName = string.Empty;
            var localreport = (LocalReport)e.Report;
            var datasource = new ReportDataSource("uspBEMS_PerformanceMonitoringReport_L2", GetSPResult("uspBEMS_PerformanceMonitoringReport_L2", FromYear, ToYear, TypecodeId, AssetsMeetingtype));
            localreport.DataSources.Clear();
            localreport.DataSources.Add(datasource);
            localreport.Refresh();
        }

        private DataTable GetSPResult(string Spname, string FromYear, string ToYear, string TypecodeId, string AssetsMeetingtype="")
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
                                case "uspBEMS_PerformanceMonitoringReport":
                                    cmd.CommandText = "uspBEMS_PerformanceMonitoringReport";
                                    cmd.Parameters.AddWithValue("@FacilityId", userDetails.FacilityId);
                                    cmd.Parameters.AddWithValue("@FromYear", FromYear);
                                    cmd.Parameters.AddWithValue("@ToYear", ToYear);
                                    cmd.Parameters.AddWithValue("@ServiceId", 2);
                                    cmd.Parameters.AddWithValue("@AssetTypeCodeId", TypecodeId);
                                    cmd.Parameters.AddWithValue("@Level", 1);

                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "FromYear":
                                    cmd.CommandText = "usp_ReportHeaderParamName";
                                    cmd.Parameters.Clear();
                                    cmd.Parameters.AddWithValue("@ParamName", "Year");
                                    cmd.Parameters.AddWithValue("@ParamValue", FromYear);
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "ToYear":
                                    cmd.CommandText = "usp_ReportHeaderParamName";
                                    cmd.Parameters.Clear();
                                    cmd.Parameters.AddWithValue("@ParamName", "Year");
                                    cmd.Parameters.AddWithValue("@ParamValue", ToYear);
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "usp_ReportHeaderParamName_AssetTypeCodeCode":
                                    cmd.CommandText = "usp_ReportHeaderParamName";
                                    cmd.Parameters.Clear();
                                    cmd.Parameters.AddWithValue("@ParamName", "AssetTypeCodeId");
                                    cmd.Parameters.AddWithValue("@ParamValue", TypecodeId);
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "uspBEMS_PerformanceMonitoringReport_L2":
                                    cmd.CommandText = "uspBEMS_PerformanceMonitoringReport_L2";
                                    cmd.Parameters.AddWithValue("@FacilityId", userDetails.FacilityId);
                                    cmd.Parameters.AddWithValue("@FromYear", FromYear);
                                    cmd.Parameters.AddWithValue("@ToYear", ToYear);
                                    cmd.Parameters.AddWithValue("@ServiceId", 2);
                                    cmd.Parameters.AddWithValue("@AssetTypeCodeId", TypecodeId);                                    
                                    cmd.Parameters.AddWithValue("@AssetsMeetingtype", AssetsMeetingtype);
                                    cmd.Parameters.AddWithValue("@Level", 1);

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