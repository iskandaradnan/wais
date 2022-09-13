using CP.UETrack.DAL.DataAccess;
using CP.UETrack.Model;
using Microsoft.Reporting.WebForms;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using UETrack.DAL;
using CP.Framework.Common.StateManagement;

namespace UETrack.Application.Web.Report
{
    public partial class PreVcmMappingReport : System.Web.UI.Page
    {
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    var Year = Request.QueryString["VCMYear"];
                    var Month = Request.QueryString["VCMMonth"];
                   

                    reportViewer.Visible = true;
                    reportViewer.ProcessingMode = ProcessingMode.Local;
                    reportViewer.LocalReport.ReportPath = Server.MapPath(Request.ApplicationPath) + @"RdlReports\LatestReportsRDLC\KPI_Pre_VCM_Report.rdlc";
                    var datasource = new ReportDataSource("DataSet1", GetSPResult("usp_KPIPreVCMReport", Year, Month));
                    
                    reportViewer.LocalReport.DataSources.Add(datasource);
                    
                    reportViewer.LocalReport.Refresh();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }


        private DataTable GetSPResult(string Spname,string Year, string Month)
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
                                case "usp_KPIPreVCMReport":
                                    cmd.CommandText = "usp_KPIPreVCMReport";
                                    cmd.Parameters.AddWithValue("@pFacilityId", userDetails.FacilityId);
                                    cmd.Parameters.AddWithValue("@pCustomerId", userDetails.CustomerId);
                                    cmd.Parameters.AddWithValue("@pYear", Year);
                                    cmd.Parameters.AddWithValue("@pMonth", Month);
                                    cmd.Parameters.AddWithValue("@pServiceId", 2);
                                   
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