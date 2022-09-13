using CP.Framework.Common.StateManagement;
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

namespace UETrack.Application.Web.Report
{
    public partial class UserLocationQRCodeReport : System.Web.UI.Page
    {
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    var CurrentDate = DateTime.Today.ToString("dd_MMM_yyyy");
                    var userDetails = (UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel));                    
                    var dt = GetSPResult();
                    reportViewer.Visible = true;
                    reportViewer.ProcessingMode = ProcessingMode.Local;                    
                    reportViewer.LocalReport.ReportPath = Server.MapPath(Request.ApplicationPath) + @"RDLCReports\QRCodeLocation.rdlc";
                    var datasource = new ReportDataSource("DataSet1", dt);    // UserLocationQRCode
                    reportViewer.LocalReport.DataSources.Add(datasource);
                    reportViewer.LocalReport.Refresh();
                    reportViewer.LocalReport.DisplayName = "Location_QR_Code_" + CurrentDate;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }


        private DataTable GetSPResult()
        {
            var userDetails = (UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel));
            var ResultsTable = new DataTable();
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ConnectionString))
            {
                try
                {
                    using (var cmd = new SqlCommand("uspFM_UserLocationQRCode_Report", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@pFacilityId", userDetails.FacilityId);
                        using (var adapter = new SqlDataAdapter(cmd))
                        {
                            adapter.Fill(ResultsTable);
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