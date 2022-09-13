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
    public partial class BerAnalysisReport : System.Web.UI.Page
    {
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    var BerFromdate = Request.QueryString["BerFromdate"];
                    var BerTodate = Request.QueryString["BerTodate"];  
                    reportViewer.Visible = true;
                    reportViewer.ProcessingMode = ProcessingMode.Local;
                    reportViewer.LocalReport.ReportPath = Server.MapPath(Request.ApplicationPath) + @"RdlReports\LatestReportsRDLC\BerAnalysis_L1.rdlc";
                    var datasource = new ReportDataSource("DataSet1", GetSPResult("uspFM_BERApplicationTxn_BERAnalysis_Rpt_L1", BerFromdate, BerTodate));
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
            var BerFromdate = Request.QueryString["BerFromdate"];
            var BerTodate = Request.QueryString["BerTodate"];
            var reportname = e.ReportPath;
            var DatasetName = string.Empty;
            var localreport = (LocalReport)e.Report;
            var datasource = new ReportDataSource("DataSet1", GetSPResult("uspFM_BERApplicationTxn_BERSummary_Rpt_L2", BerFromdate, BerTodate, ParameterName));
            localreport.DataSources.Clear();
            localreport.DataSources.Add(datasource);
            localreport.Refresh();

            var datasource1 = new ReportDataSource("uspFM_BERApplicationTxn_BERAnalysis_Rpt_L3", GetSPResult("uspFM_BERApplicationTxn_BERAnalysis_Rpt_L3", BerFromdate, BerTodate, ParameterName));
            localreport.DataSources.Add(datasource1);
            localreport.Refresh();


        }
        private DataTable GetSPResult(string Spname, string BerFromdate, string BerTodate, string ParameterName="")
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
                               
                                case "uspFM_BERApplicationTxn_BERAnalysis_Rpt_L1":
                                    cmd.CommandText = "uspFM_BERApplicationTxn_BERAnalysis_Rpt_L1";
                                    cmd.Parameters.Clear();
                                    cmd.Parameters.AddWithValue("@FacilityId", userDetails.FacilityId);
                                    cmd.Parameters.AddWithValue("@From_Date", BerFromdate);
                                    cmd.Parameters.AddWithValue("@To_Date", BerTodate);                                    
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "uspFM_BERApplicationTxn_BERSummary_Rpt_L2":
                                    cmd.CommandText = "uspFM_BERApplicationTxn_BERSummary_Rpt_L2";
                                    cmd.Parameters.Clear();
                                    cmd.Parameters.AddWithValue("@FacilityId", userDetails.FacilityId);
                                    cmd.Parameters.AddWithValue("@From_Date", BerFromdate);
                                    cmd.Parameters.AddWithValue("@To_Date", BerTodate);
                                    cmd.Parameters.AddWithValue("@Level", ParameterName);
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "uspFM_BERApplicationTxn_BERAnalysis_Rpt_L3":
                                    cmd.CommandText = "uspFM_BERApplicationTxn_BERAnalysis_Rpt_L3";
                                    cmd.Parameters.Clear();
                                    cmd.Parameters.AddWithValue("@FacilityId", userDetails.FacilityId);
                                    cmd.Parameters.AddWithValue("@From_Date", BerFromdate);
                                    cmd.Parameters.AddWithValue("@To_Date", BerTodate);
                                    cmd.Parameters.AddWithValue("@BerNo", ParameterName);
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