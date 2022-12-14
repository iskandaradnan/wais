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
    public partial class OtherParameterAnalysis : System.Web.UI.Page
    {
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    var Parameterlevel = Request.QueryString["ParameterLevel"];
                    var AssetTypeCodeId = Request.QueryString["AssetTypeCode"];
                    var Fromdate = Request.QueryString["fromDate"];
                    var Todate = Request.QueryString["todate"];
                    reportViewer.Visible = true;
                    reportViewer.ProcessingMode = ProcessingMode.Local;
                    reportViewer.LocalReport.ReportPath = Server.MapPath(Request.ApplicationPath) + @"RdlReports\LatestReportsRDLC\ParameterAnalysisRpt_L1.rdlc";
                    var datasource = new ReportDataSource("DataSet1", GetSPResult("OtherEodParameterAnalysisRpt_L1", Parameterlevel, AssetTypeCodeId, Fromdate, Todate));
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
            var parameterName = DrillThroughValues[0].Values[0];
            var AssetNo = DrillThroughValues[1].Values[0];
            var Parameterlevel = Request.QueryString["ParameterLevel"];
            var AssetTypeCodeId = Request.QueryString["AssetTypeCode"];
            var Fromdate = Request.QueryString["fromDate"];
            var Todate = Request.QueryString["todate"];
            var reportname = e.ReportPath;
            var DatasetName = string.Empty;
            var localreport = (LocalReport)e.Report;
            var datasource = new ReportDataSource("OtherEodParameterAnalysisRpt_L2_Header", GetSPResult("OtherEodParameterAnalysisRpt_L2_Header", Parameterlevel, AssetTypeCodeId, Fromdate, Todate, parameterName, AssetNo));
            var datasource1 = new ReportDataSource("OtherEodParameterAnalysisRpt_L2_Body", GetSPResult("OtherEodParameterAnalysisRpt_L2_Body", Parameterlevel, AssetTypeCodeId, Fromdate, Todate, parameterName, AssetNo));
            localreport.DataSources.Clear();
            localreport.DataSources.Add(datasource);
            localreport.DataSources.Add(datasource1);
            localreport.Refresh();
        }

        // private DataTable GetSPResult(string Spname, string Parameterlevel, string Parameteroption,string Parameterservice,string Parameterfrequency,string Parameterfrequencykey,string Parameteryear, string Parameterfromdate, string ParameterTodate)
        private DataTable GetSPResult(string Spname, string Parameterlevel, string AssetTypeCodeId, string FromDate, string ToDate, string paramName = "", string AssetNo = "")
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
                                case "OtherEodParameterAnalysisRpt_L1":
                                    cmd.CommandText = "OtherEodParameterAnalysisRpt_L1";
                                    //cmd.Parameters.AddWithValue("@MenuName", "");
                                    cmd.Parameters.AddWithValue("@Level", Parameterlevel);
                                    cmd.Parameters.AddWithValue("@TypeCode", AssetTypeCodeId);
                                    cmd.Parameters.AddWithValue("@From_Date", FromDate);
                                    cmd.Parameters.AddWithValue("@To_Date", ToDate);
                                    cmd.Parameters.AddWithValue("@FacilityId", userDetails.FacilityId);                                   
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "OtherEodParameterAnalysisRpt_L2_Body":
                                    cmd.CommandText = "OtherEodParameterAnalysisRpt_L2_Body";
                                    //cmd.Parameters.AddWithValue("@MenuName", "");
                                    cmd.Parameters.AddWithValue("@Level", paramName);
                                    cmd.Parameters.AddWithValue("@TypeCodeId", AssetTypeCodeId);
                                    cmd.Parameters.AddWithValue("@From_Date", FromDate);
                                    cmd.Parameters.AddWithValue("@To_Date", ToDate);
                                    cmd.Parameters.AddWithValue("@FacilityId", userDetails.FacilityId);
                                    cmd.Parameters.AddWithValue("@AssetNo", AssetNo);
                             
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "OtherEodParameterAnalysisRpt_L2_Header":
                                    cmd.CommandText = "OtherEodParameterAnalysisRpt_L2_Header";
                                    cmd.Parameters.AddWithValue("@AssetNo", AssetNo);                                  
                                    cmd.Parameters.AddWithValue("@FacilityId", userDetails.FacilityId);
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