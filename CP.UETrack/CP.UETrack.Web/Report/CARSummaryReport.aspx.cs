using CP.Framework.Common.StateManagement;
using CP.UETrack.DAL.DataAccess;
using CP.UETrack.Model;
using Microsoft.Reporting.WebForms;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using UETrack.DAL;


namespace UETrack.Application.Web.Report
{
    public partial class CARSummaryReport : System.Web.UI.Page
    {
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    var CARFromdate = Request.QueryString["CARFromdate"];
                    var CARTodate = Request.QueryString["CARTodate"];
                    var IndicatorId = Request.QueryString["IndicatorId"];
                    if (IndicatorId == "null")
                    {
                        IndicatorId = ""; 
                    }
                    var level = string.Empty;
                    reportViewer.Visible = true;
                    reportViewer.ProcessingMode = ProcessingMode.Local;
                    reportViewer.LocalReport.ReportPath = Server.MapPath(Request.ApplicationPath) + @"RdlReports\LatestReportsRDLC\CARSummaryReport_L1.rdlc";
                    var datasource = new ReportDataSource("uspFM_CARSummaryReport_L1", GetSPResult("uspFM_CARSummaryReport_L1", level, CARFromdate, CARTodate, IndicatorId));
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
            ReportParameterInfoCollection DrillThroughValues = e.Report.GetParameters();
            var ParameterName = DrillThroughValues[0].Values[0];
            var CARFromdate = Request.QueryString["CARFromdate"];
            var CARTodate = Request.QueryString["CARTodate"];
            var IndicatorId = Request.QueryString["IndicatorId"];
            if (IndicatorId == "null")
            {
                IndicatorId = "";
            }
            var reportname = e.ReportPath;
            var DatasetName = string.Empty;
            var localreport = (LocalReport)e.Report;
            var datasource = new ReportDataSource("uspFM_CARSummaryReport_L2", GetSPResult("uspFM_CARSummaryReport_L2", ParameterName, CARFromdate, CARTodate, IndicatorId));
            localreport.DataSources.Clear();
            localreport.DataSources.Add(datasource);
            localreport.Refresh();


            var datasource1 = new ReportDataSource("uspFM_CARSummaryReport_L3", GetSPResult("uspFM_CARSummaryReport_L3", ParameterName, CARFromdate, CARTodate, IndicatorId));
            localreport.DataSources.Add(datasource1);
            localreport.Refresh();
        }

        // private DataTable GetSPResult(string Spname, string Parameterlevel, string Parameteroption,string Parameterservice,string Parameterfrequency,string Parameterfrequencykey,string Parameteryear, string Parameterfromdate, string ParameterTodate)
        private DataTable GetSPResult(string Spname,string level, string CARFromdate, string CARTodate, string IndicatorId)
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
                                case "uspFM_CARSummaryReport_L1":
                                    cmd.CommandText = "uspFM_CARSummaryReport_L1";
                                    cmd.Parameters.AddWithValue("@Level", level);
                                    cmd.Parameters.AddWithValue("@CARFromdate", CARFromdate);
                                    cmd.Parameters.AddWithValue("@CARTodate", CARTodate);
                                    cmd.Parameters.AddWithValue("@IndicatorId", IndicatorId);
                                    cmd.Parameters.AddWithValue("@FacilityId", userDetails.FacilityId);
                                   
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "uspFM_CARSummaryReport_L2":
                                    cmd.CommandText = "uspFM_CARSummaryReport_L2";
                                   // cmd.Parameters.AddWithValue("@Level", level);
                                    cmd.Parameters.AddWithValue("@CARFromdate", CARFromdate);
                                    cmd.Parameters.AddWithValue("@CARTodate", CARTodate);
                                    cmd.Parameters.AddWithValue("@IndicatorId", IndicatorId);
                                    cmd.Parameters.AddWithValue("@FacilityId", userDetails.FacilityId);
                                    cmd.Parameters.AddWithValue("@StatusValue", level);
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "uspFM_CARSummaryReport_L3":
                                    cmd.CommandText = "uspFM_CARSummaryReport_L3";
                                    // cmd.Parameters.AddWithValue("@Level", level);
                                    cmd.Parameters.AddWithValue("@CARFromdate", CARFromdate);
                                    cmd.Parameters.AddWithValue("@CARTodate", CARTodate);
                                    cmd.Parameters.AddWithValue("@IndicatorId", IndicatorId);
                                    cmd.Parameters.AddWithValue("@FacilityId", userDetails.FacilityId);
                                    cmd.Parameters.AddWithValue("@CARNumber ", level);
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