using CP.UETrack.DAL.DataAccess;
using CP.UETrack.Model;
using Microsoft.Reporting.WebForms;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using CP.Framework.Common.StateManagement;
using UETrack.DAL;

namespace UETrack.Application.Web.Report
{
    public partial class ContractOutRegisterReport : System.Web.UI.Page
    {
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    reportViewer.Visible = true;
                    var Fromdate = Request.QueryString["Fromdate"];
                    var Todate = Request.QueryString["Todate"];
                    var ContractorId = Request.QueryString["contractorId"];
                    var dt = GetSPResult("usp_BEMS_OutSourcedServiceRegisterRpt", Fromdate, Todate, ContractorId);
                    reportViewer.ProcessingMode = ProcessingMode.Local;
                    reportViewer.LocalReport.ReportPath = Server.MapPath(Request.ApplicationPath) + @"RdlReports\LatestReportsRDLC\BEMS_OutSourcedServiceRegisterRpt.rdlc";
                    var datasource = new ReportDataSource("usp_BEMS_OutSourcedServiceRegisterRpt", dt);
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
            var parameterName = DrillThroughValues[0].Values[0];
            var Fromdate = Request.QueryString["Fromdate"];
            var Todate = Request.QueryString["Todate"];
            var ContractorId = Request.QueryString["contractorId"];
            var reportname = e.ReportPath;
            var DatasetName = string.Empty;
            var localreport = (LocalReport)e.Report;
            var datasource = new ReportDataSource("DataSet1", GetSPResult("usp_BEMS_OutSourcedServiceRegisterRpt_L2", Fromdate, Todate, ContractorId, parameterName));
            localreport.DataSources.Clear();
            localreport.DataSources.Add(datasource);
            localreport.Refresh();
        }

        private DataTable GetSPResult(string Spname, string Fromdate, string Todate, string ContractorId, string contractorCode = "")
        {
            var userDetails = (UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel));
            var ResultsTable = new DataTable();
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ConnectionString))
            {
                var Get_userDetails = new SessionHelper().UserSession();
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
                                case "usp_BEMS_OutSourcedServiceRegisterRpt":                                   
                                    cmd.Connection = con;
                                    cmd.CommandType = CommandType.StoredProcedure;
                                    cmd.CommandText = "usp_BEMS_OutSourcedServiceRegisterRpt";
                                    cmd.Parameters.AddWithValue("@Level", "1");
                                    cmd.Parameters.AddWithValue("@Facility_Id", userDetails.FacilityId);
                                    cmd.Parameters.AddWithValue("@From_Date", Fromdate);
                                    cmd.Parameters.AddWithValue("@To_Date", Todate);
                                    cmd.Parameters.AddWithValue("@ContractorCode", ContractorId);
                                    using (var adapter = new SqlDataAdapter(cmd))
                                    {
                                        adapter.Fill(ResultsTable);
                                    }
                                    break;
                                case "usp_BEMS_OutSourcedServiceRegisterRpt_L2":
                                    cmd.CommandText = "usp_BEMS_OutSourcedServiceRegisterRpt_L2";
                                    cmd.Parameters.Clear();
                                    cmd.Parameters.AddWithValue("@ContractorCode", contractorCode);
                                    cmd.Parameters.AddWithValue("@Facility_Id", userDetails.FacilityId);
                                    cmd.Parameters.AddWithValue("@From_Date", Fromdate);
                                    cmd.Parameters.AddWithValue("@To_Date", Todate);
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